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
// Testbench Name: SyncFIFO Verification Framework
// Testbench Design: ENV
// Tool versions: QuestaSim 10.6c
// Description: 
// Env of the testbench, src agent and dst agent buiding and interface connection
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
                "Apb_Write/Read": begin
                    $display("[ENV] start work : Apb_Write/Read !");
                    repeat(1024) begin
                        // random write
                        src_agent.single_tran(1, 1, `FIFO_WRITE_DATA, 32'h0000_0000);
                        // random read
                        src_agent.single_tran(0, 1, `FIFO_WRITE_DATA, 32'h0000_0000);
                    end
                    $display("[ENV] finish work : Apb_Write/Read !");
                end
                "Config_Priority": begin
                    $display("[ENV] start work : Config_Priority !");
                    // example :
                    // in this example, the priority ports are all firstly set to zero, and then set to others.
                end
                "Start_Destination_Agent": begin
                    $display("[ENV] start work : Start_Destination_Agent !");
                    
                    // ...

                end
                "Time_Run": begin
                    $display("[ENV] start work : Time_Run !");
                    #1000000000
                    $display("[ENV] time out !");
                end
                default: begin
                end
            endcase
        endtask

    endclass

endpackage
