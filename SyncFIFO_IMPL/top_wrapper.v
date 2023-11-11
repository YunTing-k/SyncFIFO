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
// Top module for a Sync FIFO with APB, Arbiter and Data Correction
// Dependencies:
// .v .v .v .v
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
    input reset_n,

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

endmodule
