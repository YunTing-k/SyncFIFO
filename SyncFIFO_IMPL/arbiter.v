//+FHDR//////////////////////////////////////////////////////////////////////////////
// Company: Shanghai Jiao Tong University
// Engineer: Yu Huang
//
// Create Date: 2023.11.03
// Design Name: SyncFIFO
// Module Name: arbiter
// Target Device: N/A
// Tool versions: QuestaSim 10.6c
// Description: 
// Arbiter of the 8-channle fifo read out, arbitrate and selcet channel with the
// maximum priority, output the data according to the addr of this channel
// Dependencies:
// find_max.v read_channel.v fifo_read.v
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
module arbiter
#(parameter  ADDR = 10,    // address length
  parameter  ERRPTR = 4,   // error ptr index length
  parameter  WIDTH = 32,   // data length
  parameter  ERRDATA = 6)  // error data index length
(
    input  clk,                            // clock
    input  rst_n,                          // reset signal active low
    input  [7 :0] addr_dst0,               // channel0 address
    input  [7 :0] priority_dst0,           // channel0 priority
    input  valid_dst0,                     // channel0 valid
    input  [7 :0] addr_dst1,               // channel1 address
    input  [7 :0] priority_dst1,           // channel1 priority
    input  valid_dst1,                     // channel1 valid
    input  [7 :0] addr_dst2,               // channel2 address
    input  [7 :0] priority_dst2,           // channel2 priority
    input  valid_dst2,                     // channel2 valid
    input  [7 :0] addr_dst3,               // channel3 address
    input  [7 :0] priority_dst3,           // channel3 priority
    input  valid_dst3,                     // channel3 valid
    input  [7 :0] addr_dst4,               // channel4 address
    input  [7 :0] priority_dst4,           // channel4 priority
    input  valid_dst4,                     // channel4 valid
    input  [7 :0] addr_dst5,               // channel5 address
    input  [7 :0] priority_dst5,           // channel5 priority
    input  valid_dst5,                     // channel5 valid
    input  [7 :0] addr_dst6,               // channel6 address
    input  [7 :0] priority_dst6,           // channel6 priority
    input  valid_dst6,                     // channel6 valid
    input  [7 :0] addr_dst7,               // channel7 address
    input  [7 :0] priority_dst7,           // channel7 priority
    input  valid_dst7,                     // channel7 valid
    input  [WIDTH - 1:0] fifo_out,         // fifo readout data,         [addr = 0]
    input  [ERRDATA - 1:0] data_err_idx,   // fifo data error index,     [addr = 1]
    input  [ADDR - 1:0] wr_ptr,            // write pointer,             [addr = 2]
    input  [ERRPTR - 1:0] wr_ptr_err_idx,  // write pointer error index, [addr = 3]
    input  [ADDR - 1:0] rd_ptr,            // read pointer,              [addr = 4]
    input  [ERRPTR - 1:0] rd_ptr_err_idx,  // read pointer error index,  [addr = 5]
    output rd_en,                          // read enable signal for FIFO
    output rd_only,                        // read only signal for FIFO
    output [31:0] data_dst0,               // channel0 data output
    output ready_dst0,                     // channel0 ready signal
    output [31:0] data_dst1,               // channel1 data output
    output ready_dst1,                     // channel1 ready signal
    output [31:0] data_dst2,               // channel2 data output
    output ready_dst2,                     // channel2 ready signal
    output [31:0] data_dst3,               // channel3 data output
    output ready_dst3,                     // channel3 ready signal
    output [31:0] data_dst4,               // channel4 data output
    output ready_dst4,                     // channel4 ready signal
    output [31:0] data_dst5,               // channel5 data output
    output ready_dst5,                     // channel5 ready signal
    output [31:0] data_dst6,               // channel6 data output
    output ready_dst6,                     // channel6 ready signal
    output [31:0] data_dst7,               // channel7 data output
    output ready_dst7                      // channel7 ready signal
);

wire [7:0] sel;
wire [7:0] priority0, priority1, priority2, priority3, priority4, priority5, priority6, priority7;
wire rd_en0, rd_en1, rd_en2, rd_en3, rd_en4, rd_en5, rd_en6, rd_en7;
wire rd_only0, rd_only1, rd_only2, rd_only3, rd_only4, rd_only5, rd_only6, rd_only7;

find_max find_max_inst(
    .priority_0(priority0),               // input priority of channel-0
    .priority_1(priority1),               // input priority of channel-1
    .priority_2(priority2),               // input priority of channel-2
    .priority_3(priority3),               // input priority of channel-3
    .priority_4(priority4),               // input priority of channel-4
    .priority_5(priority5),               // input priority of channel-5
    .priority_6(priority6),               // input priority of channel-6
    .priority_7(priority7),               // input priority of channel-7
    .select(sel)                          // output select signal, one hot
);

read_channel #(.ADDR(ADDR), .ERRPTR(ERRPTR), .WIDTH(WIDTH), .ERRDATA(ERRDATA))
channel0(
    .clk             (clk),               // clock
    .rst_n           (rst_n),             // reset signal active low
    .sel             (sel[0]),            // select signal derived by the priority
    .valid_cfg       (valid_dst0),        // [config] valid signal of channel handshake
    .priority_cfg    (priority_dst0),     // [config] priority of channel handshake
    .addr_cfg        (addr_dst0),         // [config] address of the readout data of channel handshake
    .fifo_out        (fifo_out),          // fifo readout data,         [addr = 0]
    .data_err_idx    (data_err_idx),      // fifo data error index,     [addr = 1]
    .wr_ptr          (wr_ptr),            // write pointer,             [addr = 2]
    .wr_ptr_err_idx  (wr_ptr_err_idx),    // write pointer error index, [addr = 3]
    .rd_ptr          (rd_ptr),            // read pointer,              [addr = 4]
    .rd_ptr_err_idx  (rd_ptr_err_idx),    // read pointer error index,  [addr = 5]
    .priority        (priority0),         // [configured priority in reg]
    .data            (data_dst0),         // [readout data]
    .rd_en           (rd_en0),            // [read enable signal]
    .rd_only         (rd_only0),          // [read only signal]
    .ready           (ready_dst0)         // [ready signal for valid-ready handshake]
);

read_channel #(.ADDR(ADDR), .ERRPTR(ERRPTR), .WIDTH(WIDTH), .ERRDATA(ERRDATA))
channel1(
    .clk             (clk),               // clock
    .rst_n           (rst_n),             // reset signal active low
    .sel             (sel[1]),               // select signal derived by the priority
    .valid_cfg       (valid_dst1),        // [config] valid signal of channel handshake
    .priority_cfg    (priority_dst1),     // [config] priority of channel handshake
    .addr_cfg        (addr_dst1),         // [config] address of the readout data of channel handshake
    .fifo_out        (fifo_out),          // fifo readout data,         [addr = 0]
    .data_err_idx    (data_err_idx),      // fifo data error index,     [addr = 1]
    .wr_ptr          (wr_ptr),            // write pointer,             [addr = 2]
    .wr_ptr_err_idx  (wr_ptr_err_idx),    // write pointer error index, [addr = 3]
    .rd_ptr          (rd_ptr),            // read pointer,              [addr = 4]
    .rd_ptr_err_idx  (rd_ptr_err_idx),    // read pointer error index,  [addr = 5]
    .priority        (priority1),         // [configured priority in reg]
    .data            (data_dst1),         // [readout data]
    .rd_en           (rd_en1),            // [read enable signal]
    .rd_only         (rd_only1),          // [read only signal]
    .ready           (ready_dst1)         // [ready signal for valid-ready handshake]
);

read_channel #(.ADDR(ADDR), .ERRPTR(ERRPTR), .WIDTH(WIDTH), .ERRDATA(ERRDATA))
channel2(
    .clk             (clk),               // clock
    .rst_n           (rst_n),             // reset signal active low
    .sel             (sel[2]),               // select signal derived by the priority
    .valid_cfg       (valid_dst2),        // [config] valid signal of channel handshake
    .priority_cfg    (priority_dst2),     // [config] priority of channel handshake
    .addr_cfg        (addr_dst2),         // [config] address of the readout data of channel handshake
    .fifo_out        (fifo_out),          // fifo readout data,         [addr = 0]
    .data_err_idx    (data_err_idx),      // fifo data error index,     [addr = 1]
    .wr_ptr          (wr_ptr),            // write pointer,             [addr = 2]
    .wr_ptr_err_idx  (wr_ptr_err_idx),    // write pointer error index, [addr = 3]
    .rd_ptr          (rd_ptr),            // read pointer,              [addr = 4]
    .rd_ptr_err_idx  (rd_ptr_err_idx),    // read pointer error index,  [addr = 5]
    .priority        (priority2),         // [configured priority in reg]
    .data            (data_dst2),         // [readout data]
    .rd_en           (rd_en2),            // [read enable signal]
    .rd_only         (rd_only2),          // [read only signal]
    .ready           (ready_dst2)         // [ready signal for valid-ready handshake]
);

read_channel #(.ADDR(ADDR), .ERRPTR(ERRPTR), .WIDTH(WIDTH), .ERRDATA(ERRDATA))
channel3(
    .clk             (clk),               // clock
    .rst_n           (rst_n),             // reset signal active low
    .sel             (sel[3]),               // select signal derived by the priority
    .valid_cfg       (valid_dst3),        // [config] valid signal of channel handshake
    .priority_cfg    (priority_dst3),     // [config] priority of channel handshake
    .addr_cfg        (addr_dst3),         // [config] address of the readout data of channel handshake
    .fifo_out        (fifo_out),          // fifo readout data,         [addr = 0]
    .data_err_idx    (data_err_idx),      // fifo data error index,     [addr = 1]
    .wr_ptr          (wr_ptr),            // write pointer,             [addr = 2]
    .wr_ptr_err_idx  (wr_ptr_err_idx),    // write pointer error index, [addr = 3]
    .rd_ptr          (rd_ptr),            // read pointer,              [addr = 4]
    .rd_ptr_err_idx  (rd_ptr_err_idx),    // read pointer error index,  [addr = 5]
    .priority        (priority3),         // [configured priority in reg]
    .data            (data_dst3),         // [readout data]
    .rd_en           (rd_en3),            // [read enable signal]
    .rd_only         (rd_only3),          // [read only signal]
    .ready           (ready_dst3)         // [ready signal for valid-ready handshake]
);

read_channel #(.ADDR(ADDR), .ERRPTR(ERRPTR), .WIDTH(WIDTH), .ERRDATA(ERRDATA))
channel4(
    .clk             (clk),               // clock
    .rst_n           (rst_n),             // reset signal active low
    .sel             (sel[4]),               // select signal derived by the priority
    .valid_cfg       (valid_dst4),        // [config] valid signal of channel handshake
    .priority_cfg    (priority_dst4),     // [config] priority of channel handshake
    .addr_cfg        (addr_dst4),         // [config] address of the readout data of channel handshake
    .fifo_out        (fifo_out),          // fifo readout data,         [addr = 0]
    .data_err_idx    (data_err_idx),      // fifo data error index,     [addr = 1]
    .wr_ptr          (wr_ptr),            // write pointer,             [addr = 2]
    .wr_ptr_err_idx  (wr_ptr_err_idx),    // write pointer error index, [addr = 3]
    .rd_ptr          (rd_ptr),            // read pointer,              [addr = 4]
    .rd_ptr_err_idx  (rd_ptr_err_idx),    // read pointer error index,  [addr = 5]
    .priority        (priority4),         // [configured priority in reg]
    .data            (data_dst4),         // [readout data]
    .rd_en           (rd_en4),            // [read enable signal]
    .rd_only         (rd_only4),          // [read only signal]
    .ready           (ready_dst4)         // [ready signal for valid-ready handshake]
);

read_channel #(.ADDR(ADDR), .ERRPTR(ERRPTR), .WIDTH(WIDTH), .ERRDATA(ERRDATA))
channel5(
    .clk             (clk),               // clock
    .rst_n           (rst_n),             // reset signal active low
    .sel             (sel[5]),               // select signal derived by the priority
    .valid_cfg       (valid_dst5),        // [config] valid signal of channel handshake
    .priority_cfg    (priority_dst5),     // [config] priority of channel handshake
    .addr_cfg        (addr_dst5),         // [config] address of the readout data of channel handshake
    .fifo_out        (fifo_out),          // fifo readout data,         [addr = 0]
    .data_err_idx    (data_err_idx),      // fifo data error index,     [addr = 1]
    .wr_ptr          (wr_ptr),            // write pointer,             [addr = 2]
    .wr_ptr_err_idx  (wr_ptr_err_idx),    // write pointer error index, [addr = 3]
    .rd_ptr          (rd_ptr),            // read pointer,              [addr = 4]
    .rd_ptr_err_idx  (rd_ptr_err_idx),    // read pointer error index,  [addr = 5]
    .priority        (priority5),         // [configured priority in reg]
    .data            (data_dst5),         // [readout data]
    .rd_en           (rd_en5),            // [read enable signal]
    .rd_only         (rd_only5),          // [read only signal]
    .ready           (ready_dst5)         // [ready signal for valid-ready handshake]
);

read_channel #(.ADDR(ADDR), .ERRPTR(ERRPTR), .WIDTH(WIDTH), .ERRDATA(ERRDATA))
channel6(
    .clk             (clk),               // clock
    .rst_n           (rst_n),             // reset signal active low
    .sel             (sel[6]),               // select signal derived by the priority
    .valid_cfg       (valid_dst6),        // [config] valid signal of channel handshake
    .priority_cfg    (priority_dst6),     // [config] priority of channel handshake
    .addr_cfg        (addr_dst6),         // [config] address of the readout data of channel handshake
    .fifo_out        (fifo_out),          // fifo readout data,         [addr = 0]
    .data_err_idx    (data_err_idx),      // fifo data error index,     [addr = 1]
    .wr_ptr          (wr_ptr),            // write pointer,             [addr = 2]
    .wr_ptr_err_idx  (wr_ptr_err_idx),    // write pointer error index, [addr = 3]
    .rd_ptr          (rd_ptr),            // read pointer,              [addr = 4]
    .rd_ptr_err_idx  (rd_ptr_err_idx),    // read pointer error index,  [addr = 5]
    .priority        (priority6),         // [configured priority in reg]
    .data            (data_dst6),         // [readout data]
    .rd_en           (rd_en6),            // [read enable signal]
    .rd_only         (rd_only6),          // [read only signal]
    .ready           (ready_dst6)         // [ready signal for valid-ready handshake]
);

read_channel #(.ADDR(ADDR), .ERRPTR(ERRPTR), .WIDTH(WIDTH), .ERRDATA(ERRDATA))
channel7(
    .clk             (clk),               // clock
    .rst_n           (rst_n),             // reset signal active low
    .sel             (sel[7]),               // select signal derived by the priority
    .valid_cfg       (valid_dst7),        // [config] valid signal of channel handshake
    .priority_cfg    (priority_dst7),     // [config] priority of channel handshake
    .addr_cfg        (addr_dst7),         // [config] address of the readout data of channel handshake
    .fifo_out        (fifo_out),          // fifo readout data,         [addr = 0]
    .data_err_idx    (data_err_idx),      // fifo data error index,     [addr = 1]
    .wr_ptr          (wr_ptr),            // write pointer,             [addr = 2]
    .wr_ptr_err_idx  (wr_ptr_err_idx),    // write pointer error index, [addr = 3]
    .rd_ptr          (rd_ptr),            // read pointer,              [addr = 4]
    .rd_ptr_err_idx  (rd_ptr_err_idx),    // read pointer error index,  [addr = 5]
    .priority        (priority7),         // [configured priority in reg]
    .data            (data_dst7),         // [readout data]
    .rd_en           (rd_en7),            // [read enable signal]
    .rd_only         (rd_only7),          // [read only signal]
    .ready           (ready_dst7)         // [ready signal for valid-ready handshake]
);

fifo_read fifo_read_inst(
    .rd_en0     (rd_en0),                  // read enable channel0
    .rd_only0   (rd_only0),                // read only channel0
    .rd_en1     (rd_en1),                  // read enable channel1
    .rd_only1   (rd_only1),                // read only channel1
    .rd_en2     (rd_en2),                  // read enable channel2
    .rd_only2   (rd_only2),                // read only channel2
    .rd_en3     (rd_en3),                  // read enable channel3
    .rd_only3   (rd_only3),                // read only channel3
    .rd_en4     (rd_en4),                  // read enable channel4
    .rd_only4   (rd_only4),                // read only channel4
    .rd_en5     (rd_en5),                  // read enable channel5
    .rd_only5   (rd_only5),                // read only channel5
    .rd_en6     (rd_en6),                  // read enable channel6
    .rd_only6   (rd_only6),                // read only channel6
    .rd_en7     (rd_en7),                  // read enable channel7
    .rd_only7   (rd_only7),                // read only channel7
    .select     (sel),                     // select signal
    .rd_en      (rd_en),                   // read enable signal
    .rd_only    (rd_only)                  // read only signal
);
endmodule
