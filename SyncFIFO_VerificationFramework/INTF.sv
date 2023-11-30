//+FHDR//////////////////////////////////////////////////////////////////////////////
// Company: Shanghai Jiao Tong University
// Original Source: EST8703-039-M01 LAB2 INTF.sv
// Engineer: Yu Huang
// Copyright: (c) This file is originally from the course "SystemVerilog Circuit Design
// and Verfication (EST8703-039-M01)" by Shanghai Jiao Tong University Prof. Jiang Jianfei.
// The author partly modify the original source and resubmit it.
//
// Create Date: 2023.11.28
// DUT Name: SyncFIFO
// DUT Top: top_wrapper
// Testbench Name: SyncFIFO Verification Framework
// Testbench Design: INTF
// Tool versions: QuestaSim 10.6c
// Description: 
// DUT TB interface of source and dst agent
// Dependencies:
// N/A
//
// Revision:
// ---------------------------------------------------------------------------------
// [Date]         [By]         [Version]         [Change Log]
// ---------------------------------------------------------------------------------
// 2023/11/28     Yu Huang     1.0               First implmentation
// ---------------------------------------------------------------------------------
//
//-FHDR//////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

interface duttb_intf_srcchannel(
    input clk,
    input rst_n
);
// ---------------------------------------------------------------------------------
// parameters
// ---------------------------------------------------------------------------------
    localparam SADDR_W = 32;
    localparam SDATA_W = 32;
// ---------------------------------------------------------------------------------
// APB IOs
// ---------------------------------------------------------------------------------
    logic                  channel_pwrite   ;
    logic                  channel_psel     ;
    logic [SADDR_W - 1:0]  channel_paddr    ;
    logic [SDATA_W - 1:0]  channel_pwdata   ;
    logic                  channel_penable  ;
    logic [SDATA_W - 1:0]  channel_prdata   ;
    logic                  channel_pready   ;
// ---------------------------------------------------------------------------------
// clocking block
// ---------------------------------------------------------------------------------
    clocking cb_src @(posedge clk);
        default input #0ns output #0ns;
        output channel_pwrite, channel_psel, channel_paddr, channel_pwdata, channel_penable;
        input  channel_prdata, channel_pready;
    endclocking
// ---------------------------------------------------------------------------------
// modports
// ---------------------------------------------------------------------------------
    modport DUTconnect( // Interface => DUT
        input  channel_pwrite, channel_psel, channel_paddr, channel_pwdata, channel_penable,
        output channel_prdata, channel_pready
    );

    modport TBconnect(  // Interface => TB
        input  clk,
        // output channel_pwrite, channel_psel, channel_paddr, channel_pwdata, channel_penable,
        // input  channel_prdata, channel_pready
        clocking cb_src
    );
endinterface

interface duttb_intf_dstchannel(
    input clk,
    input rst_n
);
// ---------------------------------------------------------------------------------
// parameters
// ---------------------------------------------------------------------------------
    localparam DPRIO_W = 8;
    localparam DADDR_W = 8;
    localparam DDATA_W = 32;
// ---------------------------------------------------------------------------------
// APB IOs
// ---------------------------------------------------------------------------------
    logic [DADDR_W - 1:0]   addr_dst     ;
    logic [DPRIO_W - 1:0]   priority_dst ;
    logic                   valid_dst    ;
    logic [DDATA_W - 1:0]   data_dst     ;
    logic                   ready_dst    ;
// ---------------------------------------------------------------------------------
// clocking block
// ---------------------------------------------------------------------------------
    clocking cb_dst @(posedge clk);
        default input #0ns output #0ns;
        output addr_dst, priority_dst, valid_dst;
        input  data_dst, ready_dst;
    endclocking
// ---------------------------------------------------------------------------------
// modports
// ---------------------------------------------------------------------------------
    modport DUTconnect( // Interface => DUT
        input  addr_dst, priority_dst, valid_dst,
        output data_dst, ready_dst
    );

    modport TBconnect(  // Interface => TB
        input  clk,
        // output addr_dst, priority_dst, valid_dst,
        // input  data_dst, ready_dst
        clocking cb_dst
    );
endinterface
