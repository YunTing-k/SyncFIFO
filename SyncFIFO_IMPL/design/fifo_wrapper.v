//+FHDR//////////////////////////////////////////////////////////////////////////////
// Company: Shanghai Jiao Tong University
// Engineer: Yu Huang
//
// Create Date: 2023.11.10
// Design Name: SyncFIFO
// Module Name: fifo_wrapper
// Target Device: N/A
// Tool versions: QuestaSim 10.6c
// Description: 
// FIFO with hanming code error detection and correction. controlled by arbiter and
// apb slave. Meanwhile, a register file which stores the (corrected) data, error 
// data index, (corrected) write pointer, write pointer index, (corrected) read pointer,
// read pointer index.
// Dependencies:
// fifo_ctrl.v ptr_encode.v ptr_decode.v data_encode.v data_decode.v fifo_mem.v fifo_reg.v
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
module fifo_wrapper
#(parameter  ADDR = 10,    // address length
  parameter  DEPTH = 1024, // depth of mem
  parameter  ERRPTR = 4,   // error ptr index length
  parameter  WIDTH = 32,   // data length
  parameter  ERRDATA = 6)  // error data index length
(
    input  clk,                                    // clock
    input  rst_n,                                  // reset signal active low
    input  [WIDTH -1:0] apb_write_data,            // write data from apb slave reg
    input  apb_wr_en,                              // write enable from apb slave
    input  arbiter_rd_en,                          // read enable from arbiter
    input  arbiter_rd_only,                        // read only from arbiter
    output [2:0] fifo_status,                      // fifo status to apb slave reg
    output [WIDTH - 1:0] fifo_out_reg,             // fifo output to arbiter
    output [ERRDATA - 1:0] data_err_idx_reg,       // data error index to arbiter
    output [ADDR - 1:0] wr_ptr_reg,                // write pointer to arbiter
    output [ERRPTR - 1:0] wr_ptr_err_idx_reg,      // write pointer error index arbiter
    output [ADDR - 1:0] rd_ptr_reg,                // read pointer to arbiter
    output [ERRPTR - 1:0] rd_ptr_err_idx_reg       // read pointer error index arbiter
);

wire wr_clk, rd_clk;
wire [ADDR - 1:0] rd_ptr, wr_ptr;
wire [ADDR + ERRPTR - 1:0] rd_ptr_encoded, wr_ptr_encoded;
wire [ADDR - 1:0] rd_ptr_decoded, wr_ptr_decoded;
wire [ERRPTR - 1:0] rd_ptr_err_idx, wr_ptr_err_idx;
wire [WIDTH + ERRDATA - 1:0] data_encoded, fifo_raw;
wire [WIDTH - 1:0] data_decoded;
wire [ERRDATA - 1:0] data_err_idx;

fifo_ctrl #(.WIDTH(WIDTH), .DEPTH(DEPTH), .ADDR(ADDR))
fifo_ctrl_inst(
    .clk(clk),                             // clock
    .rst_n(rst_n),                         // reset signal active low
    .wr_en(apb_wr_en),                     // write enable (from APB slave)
    .rd_en(arbiter_rd_en),                 // read enable (from Arbiter)
    .rd_only(arbiter_rd_only),             // read only signel (from Arbiter), ture: only read fifo but don't pop
    .wr_addr(wr_ptr),                      // write address
    .rd_addr(rd_ptr),                      // read address
    .wr_clk(wr_clk),                       // write clock
    .rd_clk(rd_clk),                       // read clock
    .fifo_status(fifo_status)              // fifo status (to APB slave and Arbiter, in decimal)
                                           // 0:empty, 1:(3/4)empty, 2:(2/4)empty, 3-(1/4)empty, 4-(0/4)empty, 5-full
);

ptr_encode ptr_encode_instA
(
    .raw_data(rd_ptr),                     // input raw data to be encoded
    .enc_data(rd_ptr_encoded)              // output data after encoding
);

ptr_encode ptr_encode_instB
(
    .raw_data(wr_ptr),                     // input raw data to be encoded
    .enc_data(wr_ptr_encoded)              // output data after encoding
);

ptr_decode ptr_decode_instA
(
    .enc_data(rd_ptr_encoded),             // input encoded data
    .out_data(rd_ptr_decoded),             // output decoded data
    .err_index(rd_ptr_err_idx)             // error index, 0:no error detected, else:error detected
                                           // error take place in index = err_index - 1
);

data_encode data_encode_inst
(
    .raw_data(apb_write_data),             // input raw data to be encoded
    .enc_data(data_encoded)                // output data after encoding
);

ptr_decode ptr_decode_instB
(
    .enc_data(wr_ptr_encoded),             // input encoded data
    .out_data(wr_ptr_decoded),             // output decoded data
    .err_index(wr_ptr_err_idx)             // error index, 0:no error detected, else:error detected
                                           // error take place in index = err_index - 1
);

fifo_mem #(.WIDTH(WIDTH + ERRDATA), .DEPTH(DEPTH), .ADDR(ADDR))
fifo_mem_inst(
    .wr_clk(wr_clk),                       // write clock
    .wr_en(apb_wr_en),                     // write enable
    .rd_clk(rd_clk),                       // read clock
    .rd_en(arbiter_rd_en),                 // read enable
    .wr_addr(wr_ptr_decoded),              // (decoded) write address
    .rd_addr(rd_ptr_decoded),              // (decoded) read address
    .wr_data(data_encoded),                // (encoded) write data
    .rst_n(rst_n),                         // reset signal active low
    .rd_data(fifo_raw)                     // (encoded) readout data
);

data_decode data_decode_inst
(
    .enc_data(fifo_raw),                   // input encoded data
    .out_data(data_decoded),               // output decoded data
    .err_index(data_err_idx)               // error index, 0:no error detected, else:error detected
                                           // error take place in index = err_index - 1
);

fifo_reg #(.ADDR(ADDR), .ERRPTR(ERRPTR), .WIDTH(WIDTH), .ERRDATA(ERRDATA))
fifo_reg_inst(
    .clk(clk),                                // clock
    .rst_n(rst_n),                            // reset signal active low
    .fifo_out(data_decoded),                  // fifo readout data
    .data_err_idx(data_err_idx),              // fifo data error index
    .wr_ptr(wr_ptr_decoded),                  // write pointer
    .wr_ptr_err_idx(wr_ptr_err_idx),          // write pointer error index
    .rd_ptr(rd_ptr_decoded),                  // read pointer
    .rd_ptr_err_idx(rd_ptr_err_idx),          // read pointer error index
    .fifo_out_reg(fifo_out_reg),              // [reg] of fifo readout data,         [addr = 0]
    .data_err_idx_reg(data_err_idx_reg),      // [reg] of fifo data error index,     [addr = 1]
    .wr_ptr_reg(wr_ptr_reg),                  // [reg] of write pointer,             [addr = 2]
    .wr_ptr_err_idx_reg(wr_ptr_err_idx_reg),  // [reg] of write pointer error index, [addr = 3]
    .rd_ptr_reg(rd_ptr_reg),                  // [reg] of read pointer,              [addr = 4]
    .rd_ptr_err_idx_reg(rd_ptr_err_idx_reg)   // [reg] of read pointer error index,  [addr = 5]
);

endmodule
