//+FHDR//////////////////////////////////////////////////////////////////////////////
// Company: Shanghai Jiao Tong University
// Original Source: EST8703-039-M01 LAB2 TESTBENCH.sv
// Engineer: Yu Huang
// Copyright: (c) This file is originally from the course "SystemVerilog Circuit Design
// and Verfication (EST8703-039-M01)" by Shanghai Jiao Tong University Prof. Jiang Jianfei.
// The author partly modify the original source and resubmit it.
//
// Create Date: 2023.11.28
// DUT Name: SyncFIFO
// DUT Top: top_wrapper
// Testbench Name: SyncFIFO Verification Framework
// Testbench Design: TESTBENCH
// Tool versions: QuestaSim 10.6c
// Description: 
// Build the instance of the module of dut and program of testbench, even the  intreface
// and some global signals. 'TESTBENCH' file control the total sim process.
// Dependencies:
// .sv
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

module testbench_top ();
// ---------------------------------------------------------------------------------
// parameters
// ---------------------------------------------------------------------------------
    parameter CLK_PERIOD = 2;
// ---------------------------------------------------------------------------------
// signals define
// ---------------------------------------------------------------------------------
    // uninterface signals 
    logic clk  ;
    logic rst_n;
    // interface signals 
    duttb_intf_srcchannel if_schannel_0(.*);
    duttb_intf_dstchannel if_dstannel_0(.*);
    duttb_intf_dstchannel if_dstannel_1(.*);
    duttb_intf_dstchannel if_dstannel_2(.*);
    duttb_intf_dstchannel if_dstannel_3(.*);
    duttb_intf_dstchannel if_dstannel_4(.*);
    duttb_intf_dstchannel if_dstannel_5(.*);
    duttb_intf_dstchannel if_dstannel_6(.*);
    duttb_intf_dstchannel if_dstannel_7(.*);
// ---------------------------------------------------------------------------------
// clk and rst_n gen
// ---------------------------------------------------------------------------------
	initial begin 
		clk    = 0 ;
		forever #(CLK_PERIOD /2) clk = ~clk;
	end

	initial begin
		rst_n   = 0;
		repeat(10) @(posedge clk) ;
		rst_n   = 1;
	end 
// ---------------------------------------------------------------------------------
// connections
// ---------------------------------------------------------------------------------
    testbench testbench(
        // system critical signal
        .clk   (clk          ),
        .rst_n (rst_n        ),
        // source channel connections
        .sch_0 (if_schannel_0),
        .dst_0 (if_dstannel_0),
        .dst_1 (if_dstannel_1),
        .dst_2 (if_dstannel_2),
        .dst_3 (if_dstannel_3),
        .dst_4 (if_dstannel_4),
        .dst_5 (if_dstannel_5),
        .dst_6 (if_dstannel_6),
        .dst_7 (if_dstannel_7)
    ); 

    dut dut(
        // system critical signal
        .clk   (clk          ),
        .rst_n (rst_n        ),
        // source channel connections
        .sch_0 (if_schannel_0),
        .dst_0 (if_dstannel_0),
        .dst_1 (if_dstannel_1),
        .dst_2 (if_dstannel_2),
        .dst_3 (if_dstannel_3),
        .dst_4 (if_dstannel_4),
        .dst_5 (if_dstannel_5),
        .dst_6 (if_dstannel_6),
        .dst_7 (if_dstannel_7)
    );
endmodule

program testbench(
    // system critical signal
    input clk  ,
    input rst_n,
    // modport connection
    duttb_intf_srcchannel.TBconnect sch_0,
    duttb_intf_dstchannel.TBconnect dst_0,
    duttb_intf_dstchannel.TBconnect dst_1,
    duttb_intf_dstchannel.TBconnect dst_2,
    duttb_intf_dstchannel.TBconnect dst_3,
    duttb_intf_dstchannel.TBconnect dst_4,
    duttb_intf_dstchannel.TBconnect dst_5,
    duttb_intf_dstchannel.TBconnect dst_6,
    duttb_intf_dstchannel.TBconnect dst_7
);

    import env ::*;   // impport your ENV object
    env_ctrl envctrl; // first declare it

    initial begin
        $display("[TB-SYS] welcome to sv testbench plateform !");
        // -------------------------------------------------------------------------
        // BUILD
        // -------------------------------------------------------------------------        
        $display("[TB-SYS] building");
        envctrl = new();
        // -------------------------------------------------------------------------
        // CONNECT
        // -------------------------------------------------------------------------
        $display("[TB-SYS] connecting");
        envctrl.set_interface(sch_0, dst_0, dst_1, dst_2, dst_3, dst_4, dst_5, dst_6, dst_7);
        // -------------------------------------------------------------------------
        // RUN
        // -------------------------------------------------------------------------
        $display("[TB-SYS] running");
        repeat(11) @(posedge clk);
            fork
                envctrl.run("Apb_Write/Read");
                envctrl.run("Time_Run");
            join_any
            disable fork;
        // -------------------------------------------------------------------------
        // END
        // -------------------------------------------------------------------------
        $display("[TB-SYS] testbench system has done all the work, exit !");
        $stop;
    end
endprogram