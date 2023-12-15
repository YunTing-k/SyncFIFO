//+FHDR//////////////////////////////////////////////////////////////////////////////
// Company: Shanghai Jiao Tong University
// Engineer: Yu Huang
//
// Create Date: 2023.11.02
// Design Name: SyncFIFO
// Module Name: top_wrapper
// Target Device: N/A
// Tool versions: QuestaSim 10.6c
// Description: 
// Top module for a sync FIFO with hanming code error dectecion and correction,
// 8-channel dynamic priority readout arbiter, APB3 control.
// Dependencies:
// apb_slave.v fifo_wrapper.v arbiter.v
//
// Revision:
// ---------------------------------------------------------------------------------
// [Date]         [By]         [Version]         [Change Log]
// ---------------------------------------------------------------------------------
// 2023/11/02     Yu Huang     1.0               First implmentation
// ---------------------------------------------------------------------------------
//
//-FHDR//////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module top_wrapper(
    input clk,
    input rst_n,

//apb slave port
    input pwrite,          // 1-write, 0-read
    input psel,            // scletion signal
    input [31:0] paddr,    // address bus
    input [31:0] pwdata,   // the data to be written
    input penable,         // enable signal
    output [31:0] prdata,  // the data to be read
    output pready,         // slave ready signal
//channel 0
    input  [7 :0]   addr_dst0,
    input  [7 :0]   priority_dst0,
    input           valid_dst0,
    output [31:0]   data_dst0,
    output          ready_dst0,
//channel 1
    input  [7 :0]   addr_dst1,
    input  [7 :0]   priority_dst1,
    input           valid_dst1,
    output [31:0]   data_dst1,
    output          ready_dst1,
//channel 2
    input  [7 :0]   addr_dst2,
    input  [7 :0]   priority_dst2,
    input           valid_dst2,
    output [31:0]   data_dst2,
    output          ready_dst2,
//channel 3
    input  [7 :0]   addr_dst3,
    input  [7 :0]   priority_dst3,
    input           valid_dst3,
    output [31:0]   data_dst3,
    output          ready_dst3,
//channel 4
    input  [7 :0]   addr_dst4,
    input  [7 :0]   priority_dst4,
    input           valid_dst4,
    output [31:0]   data_dst4,
    output          ready_dst4,
//channel 5
    input  [7 :0]   addr_dst5,
    input  [7 :0]   priority_dst5,
    input           valid_dst5,
    output [31:0]   data_dst5,
    output          ready_dst5,
//channel 6
    input  [7 :0]   addr_dst6,
    input  [7 :0]   priority_dst6,
    input           valid_dst6,
    output [31:0]   data_dst6,
    output          ready_dst6,
//channel 7
    input  [7 :0]   addr_dst7,
    input  [7 :0]   priority_dst7,
    input           valid_dst7,
    output [31:0]   data_dst7,
    output          ready_dst7
);

wire [2:0] fifo_status;
wire [31:0] apb_write_data;
wire apb_wr_en;
wire arbiter_rd_en, arbiter_rd_only;
wire [32 -1:0] fifo_out_reg;                           // WIDTH - 1:0
wire [6 - 1:0] data_err_idx_reg;                       // ERRDATA - 1:0
wire [10 - 1:0] wr_ptr_reg, rd_ptr_reg;                // ADDR - 1:0
wire [4 - 1:0] wr_ptr_err_idx_reg, rd_ptr_err_idx_reg; // ERRPTR - 1:0

apb_slave apb_slave_inst(
    .clk(clk),                                // clock
    .rst_n(rst_n),                            // reset signal active low
    .pwrite(pwrite),                          // [from APB] 1-write, 0-read
    .psel(psel),                              // [from APB] scletion signal
    .paddr(paddr),                            // [from APB] address bus
    .pwdata(pwdata),                          // [from APB] the data to be written
    .penable(penable),                        // [from APB] enable signal
    .fifo_status(fifo_status),                // [from FIFO] fifo status (comb logic)
                                              // 0:empty, 1:(3/4)empty, 2:(2/4)empty, 3-(1/4)empty, 4-(0/4)empty, 5-full
    .prdata(prdata),                          // [to APB] the data to be read
    .write_data(apb_write_data),              // [to FIFO] data write to fifo
    .wr_en(apb_wr_en),                        // [to FIFO] write enable signal
    .pready(pready)                           // [to APB] slave ready signal
);

fifo_wrapper #(.ADDR(10), .DEPTH(1024), .ERRPTR(4), .WIDTH(32), .ERRDATA(6))
fifo_wrapper_inst(
    .clk(clk),                                // clock
    .rst_n(rst_n),                            // reset signal active low
    .apb_write_data(apb_write_data),          // write data from apb slave reg
    .apb_wr_en(apb_wr_en),                    // write enable from apb slave
    .arbiter_rd_en(arbiter_rd_en),            // read enable from arbiter
    .arbiter_rd_only(arbiter_rd_only),        // read only from arbiter
    .fifo_status(fifo_status),                // fifo status to apb slave reg
    .fifo_out_reg(fifo_out_reg),              // fifo output to arbiter
    .data_err_idx_reg(data_err_idx_reg),      // data error index to arbiter
    .wr_ptr_reg(wr_ptr_reg),                  // write pointer to arbiter
    .wr_ptr_err_idx_reg(wr_ptr_err_idx_reg),  // write pointer error index arbiter
    .rd_ptr_reg(rd_ptr_reg),                  // read pointer to arbiter
    .rd_ptr_err_idx_reg(rd_ptr_err_idx_reg)   // read pointer error index arbiter
);


arbiter #(.ADDR(10), .ERRPTR(4), .WIDTH(32), .ERRDATA(6))
arbiter_inst(
    .clk(clk),                                // clock
    .rst_n(rst_n),                            // reset signal active low
    .addr_dst0(addr_dst0),                    // channel0 address
    .priority_dst0(priority_dst0),            // channel0 priority
    .valid_dst0(valid_dst0),                  // channel0 valid
    .addr_dst1(addr_dst1),                    // channel1 address
    .priority_dst1(priority_dst1),            // channel1 priority
    .valid_dst1(valid_dst1),                  // channel1 valid
    .addr_dst2(addr_dst2),                    // channel2 address
    .priority_dst2(priority_dst2),            // channel2 priority
    .valid_dst2(valid_dst2),                  // channel2 valid
    .addr_dst3(addr_dst3),                    // channel3 address
    .priority_dst3(priority_dst3),            // channel3 priority
    .valid_dst3(valid_dst3),                  // channel3 valid
    .addr_dst4(addr_dst4),                    // channel4 address
    .priority_dst4(priority_dst4),            // channel4 priority
    .valid_dst4(valid_dst4),                  // channel4 valid
    .addr_dst5(addr_dst5),                    // channel5 address
    .priority_dst5(priority_dst5),            // channel5 priority
    .valid_dst5(valid_dst5),                  // channel5 valid
    .addr_dst6(addr_dst6),                    // channel6 address
    .priority_dst6(priority_dst6),            // channel6 priority
    .valid_dst6(valid_dst6),                  // channel6 valid
    .addr_dst7(addr_dst7),                    // channel7 address
    .priority_dst7(priority_dst7),            // channel7 priority
    .valid_dst7(valid_dst7),                  // channel7 valid
    .fifo_out(fifo_out_reg),                  // fifo readout data,         [addr = 0]
    .data_err_idx(data_err_idx_reg),          // fifo data error index,     [addr = 1]
    .wr_ptr(wr_ptr_reg),                      // write pointer,             [addr = 2]
    .wr_ptr_err_idx(wr_ptr_err_idx_reg),      // write pointer error index, [addr = 3]
    .rd_ptr(rd_ptr_reg),                      // read pointer,              [addr = 4]
    .rd_ptr_err_idx(rd_ptr_err_idx_reg),      // read pointer error index,  [addr = 5]
    .rd_en(arbiter_rd_en),                    // read enable signal for FIFO
    .rd_only(arbiter_rd_only),                // read only signal for FIFO
    .data_dst0(data_dst0),                    // channel0 data output
    .ready_dst0(ready_dst0),                  // channel0 ready signal
    .data_dst1(data_dst1),                    // channel1 data output
    .ready_dst1(ready_dst1),                  // channel1 ready signal
    .data_dst2(data_dst2),                    // channel2 data output
    .ready_dst2(ready_dst2),                  // channel2 ready signal
    .data_dst3(data_dst3),                    // channel3 data output
    .ready_dst3(ready_dst3),                  // channel3 ready signal
    .data_dst4(data_dst4),                    // channel4 data output
    .ready_dst4(ready_dst4),                  // channel4 ready signal
    .data_dst5(data_dst5),                    // channel5 data output
    .ready_dst5(ready_dst5),                  // channel5 ready signal
    .data_dst6(data_dst6),                    // channel6 data output
    .ready_dst6(ready_dst6),                  // channel6 ready signal
    .data_dst7(data_dst7),                    // channel7 data output
    .ready_dst7(ready_dst7)                   // channel7 ready signal
);
endmodule
