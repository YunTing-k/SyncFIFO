//+FHDR//////////////////////////////////////////////////////////////////////////////
// Company: Shanghai Jiao Tong University
// Engineer: Yu Huang
//
// Create Date: 2023.11.03
// Design Name: SyncFIFO
// Module Name: fifo_mem
// Target Device: N/A
// Tool versions: QuestaSim 10.6c
// Description: 
// Fifo memory, dual port sync ram with parameters design
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
module fifo_mem
#(parameter  WIDTH = 32,   // data bit width
  parameter  DEPTH = 1024, // depth of mem
  parameter  ADDR = 10)    // address length
(
    input  wr_clk,                      // write clock
    input  wr_en,                       // write enable
    input  rd_clk,                      // read clock
    input  rd_en,                       // read enable
    input  [ADDR - 1:0] wr_addr,        // write address
    input  [ADDR - 1:0] rd_addr,        // read address
    input  [WIDTH - 1:0] wr_data,       // write data
    input  rst_n,                       // reset signal active low
    output reg [WIDTH - 1:0] rd_data    // readout data
);
reg [WIDTH - 1:0] memory [DEPTH - 1:0]; // a memory with 'WIDTH' width and 'DEPTH' depth

// memory write in
always @(posedge wr_clk) begin
    if (wr_en == 1'b1) begin
        memory[wr_addr] <= wr_data;
    end
end

// memory read out
always @(posedge rd_clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        rd_data <= {WIDTH{1'b0}};
    end
    else if (rd_en == 1'b1) begin
        rd_data <= memory[rd_addr];
    end
    else begin
        rd_data <= rd_data;
    end
end

endmodule
