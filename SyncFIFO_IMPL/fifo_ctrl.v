//+FHDR//////////////////////////////////////////////////////////////////////////////
// Company: Shanghai Jiao Tong University
// Engineer: Yu Huang
//
// Create Date: 2023.11.03
// Design Name: SyncFIFO
// Module Name: fifo_ctrl
// Target Device: N/A
// Tool versions: QuestaSim 10.6c
// Description: 
// Control module of FIFO
// Dependencies:
// N/A
//
// Revision:
// ---------------------------------------------------------------------------------
// [Date]         [By]         [Version]         [Change Log]
// ---------------------------------------------------------------------------------
// 2023/11/03     Yu Huang     1.0               First implmentation
// ---------------------------------------------------------------------------------
//
//-FHDR//////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module fifo_ctrl
#(parameter  WIDTH = 32,   // data bit width
  parameter  DEPTH = 1024, // depth of mem
  parameter  ADDR = 10)    // address length
(
    input  clk,                        // clock
    input  rst_n,                      // reset signal active low
    input  wr_en,                      // write enable (from APB slave)
    input  rd_en,                      // read enable (from Arbiter)
    input  rd_only,                    // read only signel (from Arbiter), ture: only read fifo but don't pop
    output reg [ADDR - 1:0] wr_addr,   // write address
    output reg [ADDR - 1:0] rd_addr,   // read address
    output wr_clk,                     // write clock
    output rd_clk,                     // read clock
    output [2:0] fifo_status           // fifo status (to APB slave and Arbiter, in decimal)
                                       // 0:empty, 1:(3/4)empty, 2:(2/4)empty, 3-(1/4)empty, 4-(0/4)empty, 5-full
);
reg [ADDR:0] fifo_counter;  // counter of the data amount in fifo

wire fifo_pop;              // fifo pop flag
wire empty_flag;            // fifo empty flag
wire one_quarter_flag;      // fifo >= 1/4 volume flag
wire two_quarter_flag;      // fifo >= 2/4 volume flag
wire three_quarter_flag;    // fifo >= 3/4 volume flag
wire full_flag;             // fifo full flag

// generate read address
always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        rd_addr <= {ADDR{1'b0}};
    end
    else if ((!empty_flag) && fifo_pop) begin // this moment, addr is the current pointer
        rd_addr <= rd_addr + 1'b1;
    end
    else begin
        rd_addr <= rd_addr;
    end
end

// generate write address
always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        wr_addr <= {ADDR{1'b0}};
    end
    else if ((!full_flag) && wr_en) begin // this moment, addr is the current pointer
        wr_addr <= wr_addr + 1'b1;
    end
    else begin
        wr_addr <= wr_addr;
    end
end

// update fifo data amount
always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        fifo_counter <= {(ADDR+1){1'b0}};
    end
    else if ((!full_flag) && wr_en && (!fifo_pop)) begin // not full, enable write, no read >> data increase
        fifo_counter <= fifo_counter + 1'b1;
    end
    else if (!empty_flag && (!wr_en) && fifo_pop) begin // not empty, no write, enbale read >> data decrease
        fifo_counter <= fifo_counter - 1'b1;
    end
    else begin // other case: amount keep the same
        fifo_counter <= fifo_counter;
    end
end

// combinational logic of flag signals
assign fifo_pop = (rd_en && (!rd_only)) ? 1'b1:1'b0;
assign empty_flag = (fifo_counter == {(ADDR+1){1'b0}}) ? 1'b1:1'b0;
assign one_quarter_flag = (fifo_counter >= (DEPTH / 4)) ? 1'b1:1'b0;
assign two_quarter_flag = (fifo_counter >= (DEPTH / 2)) ? 1'b1:1'b0;
assign three_quarter_flag = (fifo_counter >= (3 * DEPTH / 4)) ? 1'b1:1'b0;
assign full_flag = (fifo_counter == DEPTH) ? 1'b1:1'b0;

// combinational logic of fifo status
assign fifo_status = (!empty_flag + one_quarter_flag) + ((two_quarter_flag + three_quarter_flag) + full_flag);

endmodule
