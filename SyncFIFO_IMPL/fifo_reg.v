//+FHDR//////////////////////////////////////////////////////////////////////////////
// Company: Shanghai Jiao Tong University
// Engineer: Yu Huang
//
// Create Date: 2023.11.10
// Design Name: SyncFIFO
// Module Name: fifo_reg
// Target Device: N/A
// Tool versions: QuestaSim 10.6c
// Description: 
// Regfile of fifo's (corrected) data, error data index, (corrected) write pointer,
// write pointer index, (corrected) read pointer, read pointer index.
// Dependencies:
// N/A
//
// Revision:
// ---------------------------------------------------------------------------------
// [Date]         [By]         [Version]         [Change Log]
// ---------------------------------------------------------------------------------
// 2023/11/10     Yu Huang     1.0               First implmentation
// ---------------------------------------------------------------------------------
//
//-FHDR//////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module fifo_reg
#(parameter  ADDR = 10,    // address length
  parameter  ERRPTR = 4,   // error ptr index length
  parameter  WIDTH = 32,   // data length
  parameter  ERRDATA = 6)  // error data index length
(
    input  clk,                                    // clock
    input  rst_n,                                  // reset signal active low
    input  [WIDTH - 1:0] fifo_out,                 // fifo readout data
    input  [ERRDATA - 1:0] data_err_idx,           // fifo data error index
    input  [ADDR - 1:0] wr_ptr,                    // write pointer
    input  [ERRPTR - 1:0] wr_ptr_err_idx,          // write pointer error index
    input  [ADDR - 1:0] rd_ptr,                    // read pointer
    input  [ERRPTR - 1:0] rd_ptr_err_idx,          // read pointer error index
    output reg [WIDTH - 1:0] fifo_out_reg,         // [reg] of fifo readout data,         [addr = 0]
    output reg [ERRDATA - 1:0] data_err_idx_reg,   // [reg] of fifo data error index,     [addr = 1]
    output reg [ADDR - 1:0] wr_ptr_reg,            // [reg] of write pointer,             [addr = 2]
    output reg [ERRPTR - 1:0] wr_ptr_err_idx_reg,  // [reg] of write pointer error index, [addr = 3]
    output reg [ADDR - 1:0] rd_ptr_reg,            // [reg] of read pointer,              [addr = 4]
    output reg [ERRPTR - 1:0] rd_ptr_err_idx_reg   // [reg] of read pointer error index,  [addr = 5]
);

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        fifo_out_reg <= {WIDTH{1'b0}};
        data_err_idx_reg <= {ERRDATA{1'b0}};
        wr_ptr_reg <= {ADDR{1'b0}};
        wr_ptr_err_idx_reg <= {ERRPTR{1'b0}};
        rd_ptr_reg <= {ADDR{1'b0}};
        rd_ptr_err_idx_reg <= {ERRPTR{1'b0}};
    end
    else begin
        fifo_out_reg <= fifo_out;
        data_err_idx_reg <= data_err_idx;
        wr_ptr_reg <= wr_ptr;
        wr_ptr_err_idx_reg <= wr_ptr_err_idx;
        rd_ptr_reg <= rd_ptr;
        rd_ptr_err_idx_reg <= rd_ptr_err_idx;
    end
end

endmodule
