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
// Testbench Name: SyncFIFO Assertion
// Testbench Design: DUT
// Tool versions: QuestaSim 10.6c
// Description: 
// Connect the DUT([$(DUT Top)].v) to testbench in interface and the assertion instance
// of DUT(APB, Arbiter, FIFO).
// Dependencies:
// top_wrapper.v, INTF.sv, DUT_ASSERTION.sv
//
// Revision:
// ---------------------------------------------------------------------------------
// [Date]         [By]         [Version]         [Change Log]
// ---------------------------------------------------------------------------------
// 2023/11/27     Yu Huang     1.0               First implmentation
// 2023/12/07     Yu Huang     1.1               Add instance of assertion
// 2023/12/15     Yu Huang     1.2               reset_n -> rst_n
// ---------------------------------------------------------------------------------
//
//-FHDR//////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module dut(
// Critical system signal
    input clk,
    input rst_n,
// source channel modport
    duttb_intf_srcchannel.DUTconnect sch_0,
// dst channel modport
    duttb_intf_dstchannel.DUTconnect dst_0,
    duttb_intf_dstchannel.DUTconnect dst_1,
    duttb_intf_dstchannel.DUTconnect dst_2,
    duttb_intf_dstchannel.DUTconnect dst_3,
    duttb_intf_dstchannel.DUTconnect dst_4,
    duttb_intf_dstchannel.DUTconnect dst_5,
    duttb_intf_dstchannel.DUTconnect dst_6,
    duttb_intf_dstchannel.DUTconnect dst_7
);

top_wrapper top_wrapper(
// Critical system signal
    .clk          (clk                   ),
    .rst_n        (rst_n                 ),
// APB modport (source)
    .pwrite       (sch_0.channel_pwrite  ),
    .psel         (sch_0.channel_psel    ),
    .paddr        (sch_0.channel_paddr   ),
    .pwdata       (sch_0.channel_pwdata  ),
    .penable      (sch_0.channel_penable ),
    .prdata       (sch_0.channel_prdata  ),
    .pready       (sch_0.channel_pready  ),
// Arbiter channel0 modport (dst)
    .addr_dst0    (dst_0.addr_dst        ),
    .priority_dst0(dst_0.priority_dst    ),
    .valid_dst0   (dst_0.valid_dst       ),
    .data_dst0    (dst_0.data_dst        ),
    .ready_dst0   (dst_0.ready_dst       ),
// Arbiter channel1 modport (dst)
    .addr_dst1    (dst_1.addr_dst        ),
    .priority_dst1(dst_1.priority_dst    ),
    .valid_dst1   (dst_1.valid_dst       ),
    .data_dst1    (dst_1.data_dst        ),
    .ready_dst1   (dst_1.ready_dst       ),
// Arbiter channel2 modport (dst)
    .addr_dst2    (dst_2.addr_dst        ),
    .priority_dst2(dst_2.priority_dst    ),
    .valid_dst2   (dst_2.valid_dst       ),
    .data_dst2    (dst_2.data_dst        ),
    .ready_dst2   (dst_2.ready_dst       ),
// Arbiter channel3 modport (dst)
    .addr_dst3    (dst_3.addr_dst        ),
    .priority_dst3(dst_3.priority_dst    ),
    .valid_dst3   (dst_3.valid_dst       ),
    .data_dst3    (dst_3.data_dst        ),
    .ready_dst3   (dst_3.ready_dst       ),
// Arbiter channel4 modport (dst)
    .addr_dst4    (dst_4.addr_dst        ),
    .priority_dst4(dst_4.priority_dst    ),
    .valid_dst4   (dst_4.valid_dst       ),
    .data_dst4    (dst_4.data_dst        ),
    .ready_dst4   (dst_4.ready_dst       ),
// Arbiter channel5 modport (dst)
    .addr_dst5    (dst_5.addr_dst        ),
    .priority_dst5(dst_5.priority_dst    ),
    .valid_dst5   (dst_5.valid_dst       ),
    .data_dst5    (dst_5.data_dst        ),
    .ready_dst5   (dst_5.ready_dst       ),
// Arbiter channel6 modport (dst)
    .addr_dst6    (dst_6.addr_dst        ),
    .priority_dst6(dst_6.priority_dst    ),
    .valid_dst6   (dst_6.valid_dst       ),
    .data_dst6    (dst_6.data_dst        ),
    .ready_dst6   (dst_6.ready_dst       ),
// Arbiter channel7 modport (dst)
    .addr_dst7    (dst_7.addr_dst        ),
    .priority_dst7(dst_7.priority_dst    ),
    .valid_dst7   (dst_7.valid_dst       ),
    .data_dst7    (dst_7.data_dst        ),
    .ready_dst7   (dst_7.ready_dst       )
);

bind top_wrapper dut_io_assertion dut_io_assertion_inst(
// Critical system signal
    .clk          (clk                   ),
    .rst_n        (rst_n                 ),
// APB modport (source)
    .pwrite       (sch_0.channel_pwrite  ),
    .psel         (sch_0.channel_psel    ),
    .paddr        (sch_0.channel_paddr   ),
    .pwdata       (sch_0.channel_pwdata  ),
    .penable      (sch_0.channel_penable ),
    .prdata       (sch_0.channel_prdata  ),
    .pready       (sch_0.channel_pready  ),
// Arbiter channel0 modport (dst)
    .addr_dst0    (dst_0.addr_dst        ),
    .priority_dst0(dst_0.priority_dst    ),
    .valid_dst0   (dst_0.valid_dst       ),
    .data_dst0    (dst_0.data_dst        ),
    .ready_dst0   (dst_0.ready_dst       ),
// Arbiter channel1 modport (dst)
    .addr_dst1    (dst_1.addr_dst        ),
    .priority_dst1(dst_1.priority_dst    ),
    .valid_dst1   (dst_1.valid_dst       ),
    .data_dst1    (dst_1.data_dst        ),
    .ready_dst1   (dst_1.ready_dst       ),
// Arbiter channel2 modport (dst)
    .addr_dst2    (dst_2.addr_dst        ),
    .priority_dst2(dst_2.priority_dst    ),
    .valid_dst2   (dst_2.valid_dst       ),
    .data_dst2    (dst_2.data_dst        ),
    .ready_dst2   (dst_2.ready_dst       ),
// Arbiter channel3 modport (dst)
    .addr_dst3    (dst_3.addr_dst        ),
    .priority_dst3(dst_3.priority_dst    ),
    .valid_dst3   (dst_3.valid_dst       ),
    .data_dst3    (dst_3.data_dst        ),
    .ready_dst3   (dst_3.ready_dst       ),
// Arbiter channel4 modport (dst)
    .addr_dst4    (dst_4.addr_dst        ),
    .priority_dst4(dst_4.priority_dst    ),
    .valid_dst4   (dst_4.valid_dst       ),
    .data_dst4    (dst_4.data_dst        ),
    .ready_dst4   (dst_4.ready_dst       ),
// Arbiter channel5 modport (dst)
    .addr_dst5    (dst_5.addr_dst        ),
    .priority_dst5(dst_5.priority_dst    ),
    .valid_dst5   (dst_5.valid_dst       ),
    .data_dst5    (dst_5.data_dst        ),
    .ready_dst5   (dst_5.ready_dst       ),
// Arbiter channel6 modport (dst)
    .addr_dst6    (dst_6.addr_dst        ),
    .priority_dst6(dst_6.priority_dst    ),
    .valid_dst6   (dst_6.valid_dst       ),
    .data_dst6    (dst_6.data_dst        ),
    .ready_dst6   (dst_6.ready_dst       ),
// Arbiter channel7 modport (dst)
    .addr_dst7    (dst_7.addr_dst        ),
    .priority_dst7(dst_7.priority_dst    ),
    .valid_dst7   (dst_7.valid_dst       ),
    .data_dst7    (dst_7.data_dst        ),
    .ready_dst7   (dst_7.ready_dst       )
);

bind top_wrapper.fifo_wrapper_inst.fifo_ctrl_inst dut_fifo_assertion dut_fifo_assertion_inst(.*);
endmodule
