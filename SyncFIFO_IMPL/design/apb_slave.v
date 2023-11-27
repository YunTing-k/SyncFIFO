//+FHDR//////////////////////////////////////////////////////////////////////////////
// Company: Shanghai Jiao Tong University
// Engineer: Yu Huang
//
// Create Date: 2023.11.11
// Design Name: SyncFIFO
// Module Name: apb_slave
// Target Device: N/A
// Tool versions: QuestaSim 10.6c
// Description: 
// An APB3.0 slave to handle the write request of the Sync FIFO, reg read request of
// reg file.
// Dependencies:
// N/A
//
// Revision:
// ---------------------------------------------------------------------------------
// [Date]         [By]         [Version]         [Change Log]
// ---------------------------------------------------------------------------------
// 2023/11/11     Yu Huang     1.0               First implmentation
// ---------------------------------------------------------------------------------
//
//-FHDR//////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`define FIFO_BASE_ADDR    32'h2000_0000                // base addr of FIFO device
`define FIFO_WRITE_DATA   (`FIFO_BASE_ADDR + 32'h00)   // FIFO write data (read/write)
`define FIFO_STATUS       (`FIFO_BASE_ADDR + 32'h04)   // FIFO status (read)

module apb_slave
(
    input  clk,                   // clock
    input  rst_n,                 // reset signal active low
    input  pwrite,                // [from APB] 1-write, 0-read
    input  psel,                  // [from APB] scletion signal
    input  [31:0] paddr,          // [from APB] address bus
    input  [31:0] pwdata,         // [from APB] the data to be written
    input  penable,               // [from APB] enable signal
    input  [2:0] fifo_status,     // [from FIFO] fifo status (comb logic)
                                  // 0:empty, 1:(3/4)empty, 2:(2/4)empty, 3-(1/4)empty, 4-(0/4)empty, 5-full
    output reg [31:0] prdata,     // [to APB] the data to be read
    output reg [31:0] write_data, // [to FIFO] data write to fifo
    output reg wr_en,             // [to FIFO] write enable signal
    output reg pready             // [to APB] slave ready signal
);
// FSM param definition
localparam
    IDLE    = 3'b001,  // wait for apb master/bridge request
    SETUP   = 3'b010,  // setup stage, check addr
    ACCESS  = 3'b100;  // access stage
reg [2:0]current_state;
reg [2:0]next_state;

// FSM flag signal
reg access_valid;
reg access_done;

// other inner reg
//reg [31:0] write_data;
//reg [31:0] fifo_status;

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
            next_state = (psel && !penable) ? SETUP:IDLE;
        end
        SETUP:
        begin
             // valid access
            if (access_valid == 1'b1 && (pready == 1'b1)) begin
                next_state = (psel && penable) ? ACCESS:SETUP; // wait for enable
            end
            // valid access, but fifo full with write request
            else if (access_valid == 1'b1 && (pready == 1'b0)) begin
                next_state = SETUP; // wait for fifo not empty
            end
             // invlaid access
            else begin
                next_state = IDLE; // go to IDLE
            end
        end
        ACCESS:
        begin
            if ((access_done == 1'b1) && (psel == 1'b1)) begin
                next_state = SETUP;
            end
            else if ((access_done == 1'b1) && (psel == 1'b0)) begin
                next_state = IDLE;
            end
            else begin
                next_state = ACCESS;
            end
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
        prdata <= 32'd0;
        write_data <= 32'd0;
        wr_en <= 1'b0;
        pready <= 1'b0;
        // inner reg reset
        access_valid <= 1'b0;
        access_done <= 1'b0;
    end
    else begin
        case(next_state) //next_state oriented output
        //case(current_state) //current_state oriented output
        IDLE:
        begin
            // output reg reset
            wr_en <= 1'b0;
            pready <= 1'b0;
            // inner reg reset
            access_valid <= 1'b0;
            access_done <= 1'b0;
        end
        SETUP:
        begin
            access_done <= 1'b0;
            if ((paddr <= `FIFO_STATUS) && (paddr >= `FIFO_BASE_ADDR)) begin
                access_valid <= 1'b1;
                if (pwrite == 1'b1) begin // write request
                    case(paddr)
                    `FIFO_WRITE_DATA:  begin
                         // fifo full with write
                        if (fifo_status == 3'd5) begin
                            wr_en <= 1'b0;
                            pready <= 1'b0;
                        end
                         // fifo not full with write
                        else begin
                            write_data <= pwdata;
                            wr_en <= 1'b1;
                            pready <= 1'b1;
                        end
                    end
                    `FIFO_STATUS:  begin
                        // fifo status is read only
                        wr_en <= 1'b0;
                        pready <= 1'b1;
                    end
                endcase
                end
                else begin // read request
                    wr_en <= 1'b0;
                    pready <= 1'b1;
                    case(paddr)
                    `FIFO_WRITE_DATA:  prdata <= write_data;
                    `FIFO_STATUS    :  prdata <= {{(32 - 3){1'b0}},fifo_status};
                    endcase
                end
            end
            else begin // invalid access
                access_valid <= 1'b0;
                wr_en <= 1'b0;
                pready <= 1'b0;
            end
        end
        ACCESS:
        begin
            access_valid <= 1'b0;
            wr_en <= 1'b0;
            pready <= 1'b0;
            access_done <= 1'b1;
        end
        default:
        begin
            // output reg reset
            wr_en <= 1'b0;
            pready <= 1'b0;
            // inner reg reset
            access_valid <= 1'b0;
            access_done <= 1'b0;
        end
        endcase
    end
end
endmodule
