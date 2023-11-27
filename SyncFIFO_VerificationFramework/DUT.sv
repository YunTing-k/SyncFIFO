//+FHDR//////////////////////////////////////////////////////////////////////////////
// Company: Shanghai Jiao Tong University
// Original Source: EST8703-039-M01 LAB2 DUT.sv
// Engineer: Yu Huang
// Copyright: (c) This file is originally from the course "SystemVerilog Circuit Design
// and Verfication (EST8703-039-M01)" by Shanghai Jiao Tong University Prof. Jiang Jianfei.
// The author partly modify the original source and resubmit it.
//
// Create Date: 2023.11.27
// DUT Name: SyncFIFO
// DUT Top: top_wrapper
// Testbench Name: SyncFIFO Verification Framework
// Testbench Design: DUT
// Tool versions: QuestaSim 10.6c
// Description: 
// Connect the DUT([$DUT Top].v) to testbench in interface.
// Dependencies:
// .sv
//
// Revision:
// ---------------------------------------------------------------------------------
// [Date]         [By]         [Version]         [Change Log]
// ---------------------------------------------------------------------------------
// 2023/11/27     Yu Huang     1.0               First implmentation
// ---------------------------------------------------------------------------------
//
//-FHDR//////////////////////////////////////////////////////////////////////////////
module dut (
    input clk  ,
    input rst_n,

    // source channel modport
    duttb_intf_srcchannel.DUTconnect sch_0
);

top_wrapper top_wrapper (
    // Critical system signal
    .clk          (clk                   ),
    .reset_n      (rst_n                 ),
    // APB modport (source)
    .pwrite       (sch_0.channel_pwrite  ),
    .psel         (sch_0.channel_psel    ),
    .paddr        (sch_0.channel_paddr   ),
    .pwdata       (sch_0.channel_pwdata  ),
    .penable      (sch_0.channel_penable ),
    .prdata       (sch_0.channel_prdata  ),
    .pready       (sch_0.channel_pready  ),
    // Arbiter channel1 modport (dst)
    .addr_dst0    (0),
    .priority_dst0(0),
    .valid_dst0   (0),
    .data_dst0    (),
    .ready_dst0   (),
    // Arbiter channel2 modport (dst)
    .addr_dst1    (0),
    .priority_dst1(0),
    .valid_dst1   (0),
    .data_dst1    (),
    .ready_dst1   (),
    // Arbiter channel3 modport (dst)
    .addr_dst2    (0),
    .priority_dst2(0),
    .valid_dst2   (0),
    .data_dst2    (),
    .ready_dst2   (),
    // Arbiter channel4 modport (dst)
    .addr_dst3    (0),
    .priority_dst3(0),
    .valid_dst3   (0),
    .data_dst3    (),
    .ready_dst3   (),
    // Arbiter channel5 modport (dst)
    .addr_dst4    (0),
    .priority_dst4(0),
    .valid_dst4   (0),
    .data_dst4    (),
    .ready_dst4   (),
    // Arbiter channel6 modport (dst)
    .addr_dst5    (0),
    .priority_dst5(0),
    .valid_dst5   (0),
    .data_dst5    (),
    .ready_dst5   (),
    // Arbiter channel7 modport (dst)
    .addr_dst6    (0),
    .priority_dst6(0),
    .valid_dst6   (0),
    .data_dst6    (),
    .ready_dst6   (),
    // Arbiter channel8 modport (dst)
    .addr_dst7    (0),
    .priority_dst7(0),
    .valid_dst7   (0),
    .data_dst7    (),
    .ready_dst7   ()
);
endmodule
