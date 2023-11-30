//+FHDR//////////////////////////////////////////////////////////////////////////////
// Company: Shanghai Jiao Tong University
// Engineer: Yu Huang
//
// Create Date: 2023.11.10
// Design Name: SyncFIFO
// Module Name: read_channel
// Target Device: N/A
// Tool versions: QuestaSim 10.6c
// Description: 
// Readout channel implementation, with valid-ready handshake. We set the configured
// priority as [input prioirty+1]. To prevent the race between channels, channel priority
// will be cleared after the control signal is outputted, if the select signal changes
// to 0 before the control signal is outputted, means the control is taken by another
// channel which is just one cycle after this channel request read data. We need to
// wait until the sel change back to 1, this means we can finally control the fifo.
// Then we send the control signal, in this cycle, sel = 1, and the fifo_read moudule
// make sure that the fifo get the exact config of this channel. Since the channel's
// output has no thing to do with sel, once the correct config is send to fifo, we can
// always get the correct data from it. Meanwhile, any attempt to read an empty fifo
// will turn to read out the last data poped out of fifo.
// Dependencies:
// N/A
//
// Revision:
// ---------------------------------------------------------------------------------
// [Date]         [By]         [Version]         [Change Log]
// ---------------------------------------------------------------------------------
// 2023/11/10     Yu Huang     1.0               First implmentation
// 2023/11/15     Yu Huang     1.1               Support of 0-priority arbitration
// 2023/11/29     Yu Huang     1.2               Add busy signal to avoid race
// ---------------------------------------------------------------------------------
//
//-FHDR//////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`define FIFO_OUT_DATA       8'd0   // FIFO output data (read)
`define DATA_ERR_IDX        8'd1   // FIFO data error index (read)
`define WRITE_PTR           8'd2   // FIFO write pointer (read)
`define WRITE_PTR_ERR_IDX   8'd3   // FIFO write pointer error index (read)
`define READ_PTR            8'd4   // FIFO read pointer (read)
`define READ_PTR_ERR_IDX    8'd5   // FIFO read pointer error index (read)

module read_channel
#(parameter  ADDR = 10,    // address length
  parameter  ERRPTR = 4,   // error ptr index length
  parameter  WIDTH = 32,   // data length
  parameter  ERRDATA = 6)  // error data index length
(
    input  clk,                            // clock
    input  rst_n,                          // reset signal active low
    input  busy,                           // busy signal of arbiter
    input  sel,                            // select signal derived by the priority
    input  valid_cfg,                      // config valid signal of channel handshake
    input  [7:0] priority_cfg,             // config priority of channel handshake
    input  [7:0] addr_cfg,                 // config address of the readout data of channel handshake
    input  [WIDTH - 1:0] fifo_out,         // fifo readout data,         [addr = 0]
    input  [ERRDATA - 1:0] data_err_idx,   // fifo data error index,     [addr = 1]
    input  [ADDR - 1:0] wr_ptr,            // write pointer,             [addr = 2]
    input  [ERRPTR - 1:0] wr_ptr_err_idx,  // write pointer error index, [addr = 3]
    input  [ADDR - 1:0] rd_ptr,            // read pointer,              [addr = 4]
    input  [ERRPTR - 1:0] rd_ptr_err_idx,  // read pointer error index,  [addr = 5]
    output reg [8:0] priority,             // configured priority in reg
    output reg [31:0] data,                // readout data
    output reg block,                      // block signal for arbiter
    output reg rd_en,                      // read enable signal
    output reg rd_only,                    // read only signal
    output reg ready                       // ready signal for valid-ready handshake
);
// FSM param definition
localparam
    IDLE     = 5'b00001,  // wait for config event
    CONFIG   = 5'b00010,  // configure channel addr, priority
    CONTROL  = 5'b00100,  // if selected, output fifo read signal control
    WAITDATA = 5'b01000,  // wait for data from ctr -> FIFO -> REG
    OUTPUT   = 5'b10000;  // output data
reg [4:0]current_state;
reg [4:0]next_state;

// FSM flag signal
reg cfg_done;
reg ctrl_done;
reg wait_done;
reg output_done;

// other inner reg
reg [7:0] addr;
reg [2:0] wait_counter;

// FSM state transfer
always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        current_state <= IDLE;
    end
    else begin
        current_state <= next_state;
    end
end

// FSM next state logic
always @(*) begin
    if (rst_n == 1'b0) begin
        next_state = IDLE;
    end
    else begin
        case(current_state)
        IDLE:
        begin
            next_state = (valid_cfg) ? CONFIG:IDLE;
        end
        CONFIG:
        begin
            next_state = (cfg_done) ? CONTROL:CONFIG;
        end
        CONTROL:
        begin
            next_state = (ctrl_done) ? WAITDATA:CONTROL;
        end
        WAITDATA:
        begin
            next_state = (wait_done) ? OUTPUT:WAITDATA;
        end
        OUTPUT:
        begin
            next_state = (output_done) ? IDLE:OUTPUT;
        end
        default:
        begin
            next_state = IDLE;
        end
        endcase
    end
end

// FSM output logic
always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        // output reg reset
        priority <= 9'd0;
        data <= 32'd0;
        block <= 1'b0;
        rd_en <= 1'b0;
        rd_only <= 1'b0;
        ready <= 1'b0;
        // inner reg reset
        cfg_done <= 1'b0;
        ctrl_done <= 1'b0;
        wait_done <= 1'b0;
        output_done <= 1'b0;
        addr <= 8'd0;
        wait_counter <= 3'd0;
    end
    else begin
        case(next_state) //next_state oriented output
        //case(current_state) //current_state oriented output
        IDLE:
        begin
            // output reg reset
            priority <= 9'd0;
            block <= 1'b0;
            rd_en <= 1'b0;
            rd_only <= 1'b0;
            ready <= 1'b0;
            // inner reg reset
            cfg_done <= 1'b0;
            ctrl_done <= 1'b0;
            wait_done <= 1'b0;
            output_done <= 1'b0;
            wait_counter <= 3'd0;
        end
        CONFIG: //config priority and addr
        begin
            if (busy == 1'b0) begin // if not busy, we can config priority and take control
                // configured pri = input pri + 1
                priority <= {1'b0, priority_cfg} + 1'b1;
                addr <= addr_cfg;
                cfg_done <= 1'b1;
                block <= 1'b1; // since priority is configured, the arbiter is blocked by this channel
            end
            else begin // if busy, we can not config priority, since this race may occur
                priority <= 9'd0;
                addr <= 8'd0;
                cfg_done <= 1'b0;
                block <= 1'b0; // the arbiter is blocked by another channel
            end
        end
        CONTROL: // control fifo
        begin
            cfg_done <= 1'b0;
            if (addr == `FIFO_OUT_DATA && sel == 1'b1) begin // fifo pop
                rd_en <= 1'b1;
                rd_only <= 1'b0;
                ctrl_done <= 1'b1;
            end
            else if (addr != `FIFO_OUT_DATA && sel == 1'b1) begin // fifo not pop
                rd_en <= 1'b1;
                rd_only <= 1'b1;
                ctrl_done <= 1'b1;
            end // is sel != 0, means control is taken by other channels, wait untill ready
            else begin
                rd_en <= 1'b0;
                rd_only <= 1'b0;
                ctrl_done <= 1'b0;
            end
        end
        WAITDATA: // wait for data ready from ctr -> fifo -> reg
        begin
            ctrl_done <= 1'b0;
            block <= 1'b0;    // clear block signal to give back the control
                              // only the control signal is outputted, can we unblock the arbiter
            priority <= 9'd0; // clear priority to give back the control
            rd_en <= 1'b0;    // avoid redundant request
            rd_only <= 1'b0;  // avoid redundant request
            if (wait_counter < (3'd2 - 3'd1)) begin
                wait_done <= 1'b0;
                wait_counter <= wait_counter + 1'b1;
            end
            else begin
                wait_done <= 1'b1;
                wait_counter <= 3'd0;
            end
        end
        OUTPUT: // output data
        begin
            wait_done <= 1'b0;
            wait_counter <= 3'd0;
            ready <= 1'b1;
            case(addr)
            `FIFO_OUT_DATA    : data <= fifo_out;
            `DATA_ERR_IDX     : data <= {{(32-ERRDATA){1'b0}},data_err_idx};
            `WRITE_PTR        : data <= {{(32-ADDR){1'b0}},wr_ptr};
            `WRITE_PTR_ERR_IDX: data <= {{(32-ERRPTR){1'b0}},wr_ptr_err_idx};
            `READ_PTR         : data <= {{(32-ADDR){1'b0}},rd_ptr};
            `READ_PTR_ERR_IDX : data <= {{(32-ERRPTR){1'b0}},rd_ptr_err_idx};
            default: data <= fifo_out;
            endcase
            output_done <= 1'b1;
        end
        default:
        begin
            // output reg reset
            priority <= 9'd0;
            block <= 1'b0;
            rd_en <= 1'b0;
            rd_only <= 1'b0;
            ready <= 1'b0;
            // inner reg reset
            cfg_done <= 1'b0;
            ctrl_done <= 1'b0;
            wait_done <= 1'b0;
            output_done <= 1'b0;
            wait_counter <= 3'd0;
        end
        endcase
    end
end
endmodule
