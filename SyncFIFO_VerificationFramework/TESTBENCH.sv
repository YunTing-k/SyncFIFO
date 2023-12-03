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
// Build the instance of the module of dut and program of testbench, the intreface
// and some global signals. 'TESTBENCH' file control the total sim process. Simulation
// event control and error injection.
// Dependencies:
// ENV.sv
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

    import env ::*;               // impport ENV object
    env_ctrl envctrl;             // declare the class
    bit [13:0] wr_addr_temp;      // temp val of the write addr
    bit [3:0] wr_addr_flip_index; // flip index of the write addr
    bit [13:0] rd_addr_temp;      // temp val of the read addr
    bit [3:0] rd_addr_flip_index; // flip index of the read addr
    bit [37:0] data_temp;         // temp val of the FIFO readout data
    bit [5:0] data_flip_index;    // flip index of the FIFO readout data

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
            // envctrl.run("APB Single Write");
            // envctrl.run("APB IO Random Access");
            // envctrl.run("Arbiter Read Single");
            // envctrl.run("Arbiter Read Simultaneous");
            // envctrl.run("Arbiter Read Race");
            // envctrl.run("Arbiter Random Access");
            // envctrl.run("Random APB/Arbiter Access");
            envctrl.run("Error Injection");
            envctrl.run("Time Out");
        join_any
        disable fork;
        // -------------------------------------------------------------------------
        // VALID THE DATA INTEGRITY
        // -------------------------------------------------------------------------
        envctrl.integrity_valid();
        // -------------------------------------------------------------------------
        // END
        // -------------------------------------------------------------------------
        $display("[TB-SYS] testbench system has done all the work, exit !");
        $stop;
    end

    initial begin
        if (envctrl.src_agent.err_wr_addr == 1'b1)
            $display("[TB-SYS] error injection of write pointer");
        forever @(posedge dut.top_wrapper.fifo_wrapper_inst.fifo_ctrl_inst.wr_en) begin
            // trigger at the posedge of wr_en
            wr_addr_flip_index = $urandom() % 14;
            wr_addr_temp = dut.top_wrapper.fifo_wrapper_inst.ptr_encode_instB.enc_data;
            wr_addr_temp[wr_addr_flip_index] = ~wr_addr_temp[wr_addr_flip_index];
            if ((envctrl.src_agent.err_wr_addr == 1'b1) && ($urandom() % 2 == 1'b1)) begin
                // inject error during source request (write pointer)
                force dut.top_wrapper.fifo_wrapper_inst.ptr_encode_instB.enc_data = wr_addr_temp;
                @(negedge dut.top_wrapper.fifo_wrapper_inst.fifo_ctrl_inst.wr_en) begin
                // release at negedge
                release dut.top_wrapper.fifo_wrapper_inst.ptr_encode_instB.enc_data;
                end
            end
        end
    end

    initial begin
        if (envctrl.dst_agent.err_rd_addr == 1'b1)
            $display("[TB-SYS] error injection of read pointer");
        forever @(posedge dut.top_wrapper.fifo_wrapper_inst.fifo_ctrl_inst.rd_en) begin
            // trigger at the posedge of rd_en
            rd_addr_flip_index = $urandom() % 14;
            rd_addr_temp = dut.top_wrapper.fifo_wrapper_inst.ptr_encode_instA.enc_data;
            rd_addr_temp[rd_addr_flip_index] = ~rd_addr_temp[rd_addr_flip_index];
            if ((envctrl.dst_agent.err_rd_addr == 1'b1) && ($urandom() % 2 == 1'b1)) begin
                // inject error during dst request (read pointer)
                force dut.top_wrapper.fifo_wrapper_inst.ptr_encode_instA.enc_data = rd_addr_temp;
                @(negedge dut.top_wrapper.fifo_wrapper_inst.fifo_ctrl_inst.rd_en) begin
                // release at negedge
                release dut.top_wrapper.fifo_wrapper_inst.ptr_encode_instA.enc_data;
                end
            end
        end
    end

    initial begin
        if (envctrl.dst_agent.err_rd_data == 1'b1)
            $display("[TB-SYS] error injection of FIFO readout data");
        forever @(negedge dut.top_wrapper.fifo_wrapper_inst.fifo_ctrl_inst.rd_en) begin
            // trigger at thr negedge of rd_en
            data_flip_index = $urandom() % 38;
            data_temp = dut.top_wrapper.fifo_wrapper_inst.data_decode_inst.enc_data;
            data_temp[data_flip_index] = ~data_temp[data_flip_index];
            if ((envctrl.dst_agent.err_rd_data == 1'b1) && ($urandom() % 2 == 1'b1)) begin
                // inject error during dst request (FIFO readout data)
                force dut.top_wrapper.fifo_wrapper_inst.data_decode_inst.enc_data = data_temp;
                @ (posedge dut.top_wrapper.fifo_wrapper_inst.fifo_ctrl_inst.rd_en) begin
                    // release at posedge
                    release dut.top_wrapper.fifo_wrapper_inst.data_decode_inst.enc_data;
                end
            end
        end
    end
endprogram