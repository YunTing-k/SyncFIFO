//+FHDR//////////////////////////////////////////////////////////////////////////////
// Company: Shanghai Jiao Tong University
// Original Source: EST8703-039-M01 LAB2 ENV.sv
// Engineer: Yu Huang
// Copyright: (c) This file is originally from the course "SystemVerilog Circuit Design
// and Verfication (EST8703-039-M01)" by Shanghai Jiao Tong University Prof. Jiang Jianfei.
// The author partly modify the original source and resubmit it.
//
// Create Date: 2023.11.28
// DUT Name: SyncFIFO
// DUT Top: top_wrapper
// Testbench Name: SyncFIFO Assertion
// Testbench Design: ENV
// Tool versions: QuestaSim 10.6c
// Description: 
// Environment of the testbench, src agent and dst agent buiding and interface connection,
// data integrity validation scoreboard, simulation event contol.
// Dependencies:
// SRC_AGENT.sv, DST_AGENT.sv
//
// Revision:
// ---------------------------------------------------------------------------------
// [Date]         [By]         [Version]         [Change Log]
// ---------------------------------------------------------------------------------
// 2023/11/28     Yu Huang     1.0               First implmentation
// 2023/12/20     Yu Huang     1.1               Add back-to-back write test
// ---------------------------------------------------------------------------------
//
//-FHDR//////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
`define FIFO_BASE_ADDR    32'h2000_0000                // base addr of FIFO device
`define FIFO_WRITE_DATA   (`FIFO_BASE_ADDR + 32'h00)   // FIFO write data (read/write)
`define FIFO_STATUS       (`FIFO_BASE_ADDR + 32'h04)   // FIFO status (read)
`define FIFO_OUT_DATA       8'd0   // FIFO output data (read)
`define DATA_ERR_IDX        8'd1   // FIFO data error index (read)
`define WRITE_PTR           8'd2   // FIFO write pointer (read)
`define WRITE_PTR_ERR_IDX   8'd3   // FIFO write pointer error index (read)
`define READ_PTR            8'd4   // FIFO read pointer (read)
`define READ_PTR_ERR_IDX    8'd5   // FIFO read pointer error index (read)

package env;
    import src_agent_main ::*;
    import dst_agent_main ::*;  

    class env_ctrl;
        // -------------------------------------------------------------------------
        // BUILD the src and dst agent
        // -------------------------------------------------------------------------
        src_agent src_agent;
        dst_agent dst_agent;

        function new();
            this.src_agent = new();
            this.dst_agent = new();
        endfunction
        // -------------------------------------------------------------------------
        // DATA INTEGRITY VALIDATION
        // -------------------------------------------------------------------------
        function void integrity_valid();
            int push_count, pop_count;
            int correct_count;
            push_count = this.src_agent.pushed_count;
            pop_count = this.dst_agent.popped_count;
            $display("[ENV] FIFO data total pushed: %0d, total popped: %0d", push_count, pop_count);
            if (pop_count > push_count) begin
                $display("[ENV] Exist attempt to pop an empty FIFO!");
            end
            else begin
                correct_count = 0;
                for (int i = 0; i < pop_count; i++) begin
                    if (this.dst_agent.data[i] == this.src_agent.data[i]) begin
                        correct_count = correct_count + 1;
                    end
                end
                $display("[ENV] %0d elements checked, %0d passed with %0d failed, ratio = %4f %%",
                         pop_count, correct_count, (pop_count - correct_count), 100 * (correct_count / pop_count));
                if (correct_count == pop_count) begin
                    $display("[ENV] Data integrity validation PASSED!");
                end
                else begin
                    $display("[ENV] Data integrity validation FAILED!");
                end
            end
        endfunction
        // -------------------------------------------------------------------------
        // CONNECT
        // -------------------------------------------------------------------------
        function void set_interface(
            virtual duttb_intf_srcchannel.TBconnect sch_0,
            virtual duttb_intf_dstchannel.TBconnect dst_0,
            virtual duttb_intf_dstchannel.TBconnect dst_1,
            virtual duttb_intf_dstchannel.TBconnect dst_2,
            virtual duttb_intf_dstchannel.TBconnect dst_3,
            virtual duttb_intf_dstchannel.TBconnect dst_4,
            virtual duttb_intf_dstchannel.TBconnect dst_5,
            virtual duttb_intf_dstchannel.TBconnect dst_6,
            virtual duttb_intf_dstchannel.TBconnect dst_7
        );
            // connect to src_agent
            this.src_agent.set_interface(sch_0);
            // connect to dst_agent
            this.dst_agent.set_interface(dst_0, dst_1, dst_2, dst_3, dst_4, dst_5, dst_6, dst_7);
        endfunction 
        // -------------------------------------------------------------------------
        // RUN
        // -------------------------------------------------------------------------
        task run(string state);
            case(state)
                "APB Single Write": begin
                    // apb io test for reg of write data and fifo status, random read and random write
                    $display("[ENV] start work : APB Single Write!");
                    for (int i = 0;i < 1024;i++) begin // fill the fifo
                        src_agent.single_tran(1, 0, `FIFO_WRITE_DATA, i + 1);
                    end
                    // FIFO full write test
                    src_agent.single_tran(1, 0, `FIFO_WRITE_DATA, 32'hFFFF_FFFF);
                    $display("[ENV] finish work : APB Single Write!");
                end
                "APB B2B Write": begin
                    // apb io test for reg of write data and fifo status, random read and random write
                    $display("[ENV] start work : APB B2B Write!");
                    for (int i = 0;i < 1024;i++) begin // fill the fifo
                        if (i == 0)
                            src_agent.b2b_tran_head(1, 0, `FIFO_WRITE_DATA, i + 1);
                        else if(i != 1023)
                            src_agent.b2b_tran_body(1, 0, `FIFO_WRITE_DATA, i + 1);
                        else
                            src_agent.b2b_tran_tail(1, 0, `FIFO_WRITE_DATA, i + 1);
                    end
                    // FIFO full write test
                    src_agent.single_tran(1, 0, `FIFO_WRITE_DATA, 32'hFFFF_FFFF);
                    $display("[ENV] finish work : APB Single Write!");
                end
                "APB IO Random Access": begin
                    // apb io test for reg of write data and fifo status, random read and random write
                    $display("[ENV] start work : APB IO Random Access!");
                    repeat(1024) begin
                        // random write
                        src_agent.single_tran(1, 1, `FIFO_WRITE_DATA, 32'h0000_0000);
                        // random read
                        src_agent.single_tran(0, 1, `FIFO_WRITE_DATA, 32'h0000_0000);
                    end
                    // FIFO full write test
                    src_agent.single_tran(1, 1, `FIFO_WRITE_DATA, 32'h0000_0000);
                    $display("[ENV] finish work : APB IO Random Access!");
                end
                "Arbiter Read Single": begin
                    // arbiter test, single channel read
                    $display("[ENV] start work : Arbiter Read Single!");
                    for (int i = 0;i < 1024;i++)begin // fill the fifo
                        src_agent.single_tran(1, 0, `FIFO_WRITE_DATA, i + 1);
                    end
                    for (int i = 0;i < 1024;i++)begin // pop the fifo
                        dst_agent.single_tran(0, 0, 0, i % 256, 0);
                    end
                    // FIFO empty read test
                    dst_agent.single_tran(0, 0, 0, 0, 0);
                    $display("[ENV] finish work : Arbiter Read Single!");
                end
                "Arbiter Read Simultaneous": begin
                    // arbiter test, all channel will set the same priority and request at the same time
                    $display("[ENV] start work : Arbiter Test Simultaneous!");
                    for (int i = 0;i < 1024;i++)begin // fill the fifo
                        src_agent.single_tran(1, 0, `FIFO_WRITE_DATA, i + 1);
                    end
                    for (int i = 0;i < 128;i++)begin // pop the fifo
                        fork
                            dst_agent.single_tran(0, 0, 0, i, 0);
                            dst_agent.single_tran(1, 0, 0, i, 0);
                            dst_agent.single_tran(2, 0, 0, i, 0);
                            dst_agent.single_tran(3, 0, 0, i, 0);
                            dst_agent.single_tran(4, 0, 0, i, 0);
                            dst_agent.single_tran(5, 0, 0, i, 0);
                            dst_agent.single_tran(6, 0, 0, i, 0);
                            dst_agent.single_tran(7, 0, 0, i, 0);
                        join
                    end
                    // FIFO empty read test
                    fork
                        dst_agent.single_tran(0, 0, 0, 0, 0);
                        dst_agent.single_tran(1, 0, 0, 0, 0);
                        dst_agent.single_tran(2, 0, 0, 0, 0);
                        dst_agent.single_tran(3, 0, 0, 0, 0);
                        dst_agent.single_tran(4, 0, 0, 0, 0);
                        dst_agent.single_tran(5, 0, 0, 0, 0);
                        dst_agent.single_tran(6, 0, 0, 0, 0);
                        dst_agent.single_tran(7, 0, 0, 0, 0);
                    join
                    $display("[ENV] finish work : Arbiter Test Simultaneous!");
                end
                "Arbiter Read Race": begin
                    // arbiter test, channels' priority will be set to have a race
                    $display("[ENV] start work : Arbiter Test Simultaneous!");
                    for (int i = 0;i < 1024;i++)begin // fill the fifo
                        src_agent.single_tran(1, 0, `FIFO_WRITE_DATA, i + 1);
                    end
                    for (int i = 0;i < 128;i++)begin // pop the fifo
                        fork
                            begin #(2 * 0) dst_agent.single_tran(0, 0, 0, i + 0, 0); end
                            begin #(2 * 1) dst_agent.single_tran(1, 0, 0, i + 1, 0); end
                            begin #(2 * 2) dst_agent.single_tran(2, 0, 0, i + 2, 0); end
                            begin #(2 * 3) dst_agent.single_tran(3, 0, 0, i + 3, 0); end
                            begin #(2 * 4) dst_agent.single_tran(4, 0, 0, i + 4, 0); end
                            begin #(2 * 5) dst_agent.single_tran(5, 0, 0, i + 5, 0); end
                            begin #(2 * 6) dst_agent.single_tran(6, 0, 0, i + 6, 0); end
                            begin #(2 * 7) dst_agent.single_tran(7, 0, 0, i + 7, 0); end
                        join
                    end
                    // FIFO empty read test
                    fork
                        begin #(2 * 0) dst_agent.single_tran(0, 0, 0, 0, 0); end
                        begin #(2 * 1) dst_agent.single_tran(1, 0, 0, 1, 0); end
                        begin #(2 * 2) dst_agent.single_tran(2, 0, 0, 2, 0); end
                        begin #(2 * 3) dst_agent.single_tran(3, 0, 0, 3, 0); end
                        begin #(2 * 4) dst_agent.single_tran(4, 0, 0, 4, 0); end
                        begin #(2 * 5) dst_agent.single_tran(5, 0, 0, 5, 0); end
                        begin #(2 * 6) dst_agent.single_tran(6, 0, 0, 6, 0); end
                        begin #(2 * 7) dst_agent.single_tran(7, 0, 0, 7, 0); end
                    join
                    $display("[ENV] finish work : Arbiter Test Simultaneous!");
                end
                "Arbiter Random Access": begin
                    // arbiter test, random priority and random addr
                    $display("[ENV] start work : Arbiter Random Access!");
                    for (int i = 0;i < 1024;i++)begin // fill the fifo
                        src_agent.single_tran(1, 0, `FIFO_WRITE_DATA, i + 1);
                    end
                    for (int i = 0;i < 128;i++)begin // pop the fifo
                        fork
                            dst_agent.single_tran(0, 1, 1, 0, 0);
                            dst_agent.single_tran(1, 1, 1, 0, 0);
                            dst_agent.single_tran(2, 1, 1, 0, 0);
                            dst_agent.single_tran(3, 1, 1, 0, 0);
                            dst_agent.single_tran(4, 1, 1, 0, 0);
                            dst_agent.single_tran(5, 1, 1, 0, 0);
                            dst_agent.single_tran(6, 1, 1, 0, 0);
                            dst_agent.single_tran(7, 1, 1, 0, 0);
                        join
                    end
                    $display("[ENV] finish work : Arbiter Random Access!");
                end
                "Random APB/Arbiter Access": begin
                    // apb and arbiter joint test, random time access, random data access
                    $display("[ENV] start work : Random APB/Arbiter Access!");
                    for (int i = 0;i < 256;i++) begin // push 256 data into the fifo with single tran
                        src_agent.single_tran(1, 0, `FIFO_WRITE_DATA, i + 1);
                    end
                    for (int i = 256;i < 512;i++) begin // push 256 data into the fifo with b2b tran
                        if (i == 256)
                            src_agent.b2b_tran_head(1, 0, `FIFO_WRITE_DATA, i + 1);
                        else if(i != 511)
                            src_agent.b2b_tran_body(1, 0, `FIFO_WRITE_DATA, i + 1);
                        else
                            src_agent.b2b_tran_tail(1, 0, `FIFO_WRITE_DATA, i + 1);
                    end
                    for (int i = 0;i < 1024;i++) begin
                        // fifo random access and arbiter random access
                        fork
                            begin 
                                // random apb write
                                #(2 * ($urandom() % 5)) src_agent.single_tran(1, 1, `FIFO_WRITE_DATA, 32'h0000_0000);
                                // random read
                                #(2 * ($urandom() % 5)) src_agent.single_tran(0, 1, `FIFO_WRITE_DATA, 32'h0000_0000);
                            end
                            // random arbiter read
                            begin #(2 * ($urandom() % 10)) dst_agent.single_tran(0, 1, 1, 0, 0); end
                            begin #(2 * ($urandom() % 10)) dst_agent.single_tran(1, 1, 1, 0, 0); end
                            begin #(2 * ($urandom() % 10)) dst_agent.single_tran(2, 1, 1, 0, 0); end
                            begin #(2 * ($urandom() % 10)) dst_agent.single_tran(3, 1, 1, 0, 0); end
                            begin #(2 * ($urandom() % 10)) dst_agent.single_tran(4, 1, 1, 0, 0); end
                            begin #(2 * ($urandom() % 10)) dst_agent.single_tran(5, 1, 1, 0, 0); end
                            begin #(2 * ($urandom() % 10)) dst_agent.single_tran(6, 1, 1, 0, 0); end
                            begin #(2 * ($urandom() % 10)) dst_agent.single_tran(7, 1, 1, 0, 0); end
                        join
                    end
                    $display("[ENV] finish work : Random APB/Arbiter Access!");
                end
                "FIFO Assertion Supplementary": begin
                    // arbiter test, single channel read
                    $display("[ENV] start work : Arbiter Read Single!");
                    for (int i = 0;i < 1024;i++)begin // fill the fifo
                        src_agent.single_tran(1, 0, `FIFO_WRITE_DATA, i + 1);
                    end
                    fork
                        src_agent.single_tran(1, 0, `FIFO_WRITE_DATA, 1025);
                        for (int i = 0;i < 1024;i++)begin // pop the fifo
                            dst_agent.single_tran(0, 0, 0, i % 256, 0);
                        end
                    join
                    // FIFO empty read test
                    dst_agent.single_tran(0, 0, 0, 0, 0);
                    dst_agent.single_tran(0, 0, 0, 0, 0);
                    $display("[ENV] finish work : FIFO Assertion Supplementary!");
                end
                "Error Injection": begin
                    // Error injection test
                    $display("[ENV] start work : Error Injection!");
                    for (int i = 0;i < 1024;i++)begin // fill the fifo
                        src_agent.single_tran(1, 0, `FIFO_WRITE_DATA, i + 1);
                    end
                    for (int i = 0;i < 1024;i++)begin // pop the fifo
                        dst_agent.single_tran(0, 0, 0, i % 256, 0);
                    end
                    $display("[ENV] finish work : Error Injection!");
                end
                "Time Out": begin
                    $display("[ENV] start work : Time Out !");
                    #80000
                    $display("[ENV] time out !");
                end
                default: begin
                end
            endcase
        endtask
    endclass
endpackage
