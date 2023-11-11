//+FHDR//////////////////////////////////////////////////////////////////////////////
// Company: Shanghai Jiao Tong University
// Engineer: Yu Huang
//
// Create Date: 2023.11.06
// Design Name: SyncFIFO
// Module Name: find_max
// Target Device: N/A
// Tool versions: QuestaSim 10.6c
// Description: 
// Based on the input channel's priority, find and output the index of the channel
// that has the largest priority
// Dependencies:
// N/A
//
// Revision:
// ---------------------------------------------------------------------------------
// [Date]         [By]         [Version]         [Change Log]
// ---------------------------------------------------------------------------------
// 2023/11/06     Yu Huang     1.0               First implmentation
// ---------------------------------------------------------------------------------
//
//-FHDR//////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module find_max
(
    input  [7:0] priority_0,        // input priority of channel-0
    input  [7:0] priority_1,        // input priority of channel-1
    input  [7:0] priority_2,        // input priority of channel-2
    input  [7:0] priority_3,        // input priority of channel-3
    input  [7:0] priority_4,        // input priority of channel-4
    input  [7:0] priority_5,        // input priority of channel-5
    input  [7:0] priority_6,        // input priority of channel-6
    input  [7:0] priority_7,        // input priority of channel-7
    output [7:0] select             // output select signal, one hot
);
wire [7:0] pri_l1_0, pri_l1_1, pri_l1_2, pri_l1_3; // first layer priority compare result
wire [7:0] pri_l2_0, pri_l2_1;                     // second layer priority compare result
wire [2:0] idx_l1_0, idx_l1_1, idx_l1_2, idx_l1_3; // first layer index result
wire [2:0] idx_l2_0, idx_l2_1;                     // second layer index result
wire [2:0] idx_l3;                                 // third layer index result

// parallel compare [first layer priority and index gen]
assign pri_l1_0 = (priority_0 >= priority_1) ? priority_0:priority_1;
assign pri_l1_1 = (priority_2 >= priority_3) ? priority_2:priority_3;
assign pri_l1_2 = (priority_4 >= priority_5) ? priority_4:priority_5;
assign pri_l1_3 = (priority_6 >= priority_7) ? priority_6:priority_7;

assign idx_l1_0 = (priority_0 >= priority_1) ? 3'd0:3'd1;
assign idx_l1_1 = (priority_2 >= priority_3) ? 3'd2:3'd3;
assign idx_l1_2 = (priority_4 >= priority_5) ? 3'd4:3'd5;
assign idx_l1_3 = (priority_6 >= priority_7) ? 3'd6:3'd7;

// parallel compare [second layer priority and index gen]
assign pri_l2_0 = (pri_l1_0 >= pri_l1_1) ? pri_l1_0:pri_l1_1;
assign pri_l2_1 = (pri_l1_2 >= pri_l1_3) ? pri_l1_2:pri_l1_3;

assign idx_l2_0 = (pri_l1_0 >= pri_l1_1) ? idx_l1_0:idx_l1_1;
assign idx_l2_1 = (pri_l1_2 >= pri_l1_3) ? idx_l1_2:idx_l1_3;

// third layer index gen
assign idx_l3 =  (pri_l2_0 >= pri_l2_1) ? idx_l2_0:idx_l2_1;

// one-hot output selction signal gen
assign select = (8'b0000_0001 << idx_l3);

endmodule
