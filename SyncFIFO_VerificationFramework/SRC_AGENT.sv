//+FHDR//////////////////////////////////////////////////////////////////////////////
// Company: Shanghai Jiao Tong University
// Original Source: EST8703-039-M01 LAB2 SRC_AGENT.sv
// Engineer: Yu Huang
// Copyright: (c) This file is originally from the course "SystemVerilog Circuit Design
// and Verfication (EST8703-039-M01)" by Shanghai Jiao Tong University Prof. Jiang Jianfei.
// The author partly modify the original source and resubmit it.
//
// Create Date: 2023.11.15
// DUT Name: SyncFIFO
// DUT Top: top_wrapper
// Testbench Name: SyncFIFO Verification Framework
// Testbench Design: SRC_AGENT
// Tool versions: QuestaSim 10.6c
// Description: 
// APB's agent moudule for testbench of DUT. APB single Read/Write, continuous
// Read/Write event define. APB write data randomize.
// Dependencies:
// .sv
//
// Revision:
// ---------------------------------------------------------------------------------
// [Date]         [By]         [Version]         [Change Log]
// ---------------------------------------------------------------------------------
// 2023/11/15     Yu Huang     1.0               First implmentation
// ---------------------------------------------------------------------------------
//
//-FHDR//////////////////////////////////////////////////////////////////////////////
`define FIFO_BASE_ADDR    32'h2000_0000                // base addr of FIFO device
`define FIFO_WRITE_DATA   (`FIFO_BASE_ADDR + 32'h00)   // FIFO write data (read/write)
`define FIFO_STATUS       (`FIFO_BASE_ADDR + 32'h04)   // FIFO status (read)

package src_agent_objects;
    // Package of APB agent objects:
    //   [1] 
    class src_randomgen_datapkg; // Data used in APB agent
        bit mode;         // APB access mode: 0-read, 1-write
        bit [31:0] data;  // APB access data
    endclass

    class src_generator;  // Source data generator for APB agent
        // mailbox for generated data to driver
        mailbox #(src_randomgen_datapkg) gen2drv;
        function new(
            mailbox #(src_randomgen_datapkg) gen2drv
        );
            this.gen2drv = gen2drv;
        endfunction

        // -------------------------------------------------------------------------
        // [data_gen]: Generate data for APB agent's driver
        // -------------------------------------------------------------------------
        task data_gen(
            input mode,         // APB access mode: 0-read, 1-write
            input [31:0] data   // APB access data
        );
            src_randomgen_datapkg tran_data;
            tran_data = new();      // consturctor of the src_randomgen_datapkg class
            tran_data.mode = mode;  // get APB access mode
            tran_data.data = data;  // get APB access data
            gen2drv.put(tran_data); // put the data into mailbox for driver to get
        endtask
    endclass

    class src_driver;  // Driver of the APB agent, data transimit class define
        // mailbox for generated data to driver
        mailbox #(src_randomgen_datapkg) gen2drv;
        function new( // constructor of driver class
            mailbox #(src_randomgen_datapkg) gen2drv
        );
            this.gen2drv = gen2drv;
        endfunction

        // connection of TB to DUT
        local virtual duttb_intf_srcchannel.TBconnect active_channel;
        // -------------------------------------------------------------------------
        // [set_interface]: set interface of TB <==> DUT and initizalize data
        // -------------------------------------------------------------------------
        function void set_interface(
            virtual duttb_intf_srcchannel.TBconnect source_ch
        );
            this.active_channel = source_ch; // set src class driver channel
            // port initialization to avoid 'x' state in dut
            this.active_channel.channel_pwrite = 1'b0;
            this.active_channel.channel_psel = 1'b0;
            this.active_channel.channel_paddr = 32'h0000_0000;
            this.active_channel.channel_pwdata = 32'h0000_0000;
            this.active_channel.channel_penable = 1'b0;
        endfunction

        // -------------------------------------------------------------------------
        // [data_write]: APB write data handhsake
        // -------------------------------------------------------------------------
        task data_write();
            // get data from mailbox to random_data_get
            src_randomgen_datapkg random_data_get;
            this.gen2drv.get(random_data_get);
            // APB config
            @(posedge this.active_channel.clk)
                this.active_channel.channel_pwrite = 1'b1;
                this.active_channel.channel_psel = 1'b1;
                this.active_channel.channel_paddr = `FIFO_WRITE_DATA;
                this.active_channel.channel_pwdata = random_data_get.data;
                this.active_channel.channel_penable = 1'b0;
            // APB access
            @(posedge this.active_channel.clk)
                this.active_channel.channel_penable = 1'b1;
            // Wait for APB slave ready
            wait(this.active_channel.channel_pready)
                // to APB idle
                @(posedge this.active_channel.clk)
                    this.active_channel.channel_pwrite = 1'b0;
                    this.active_channel.channel_psel = 1'b0;
                    this.active_channel.channel_paddr = 32'h0000_0000;
                    this.active_channel.channel_pwdata = 32'h0000_0000;
                    this.active_channel.channel_penable = 1'b0;
        endtask
    endclass
endpackage

package src_agent_main;
    // Package of APB agent main realization:
    import src_agent_objects ::*; // import defined agent objects
    class src_agent; // source agent realization
        // -------------------------------------------------------------------------
        // BUILD
        // -------------------------------------------------------------------------
        src_generator                    src_generator;   // src generator instance
        mailbox #(src_randomgen_datapkg) mailbox_gen2drv; // mailbox of src agent
        src_driver                       src_driver;     // src driver instance
 
        function new(); // constuctor of src agent
            this.mailbox_gen2drv = new(16);               // create a 16 size mailbox
            this.src_generator   = new(mailbox_gen2drv);  // pass mailbox to data gen
            this.src_driver     = new(mailbox_gen2drv);  // pass mailbox to data drive
        endfunction

        // -------------------------------------------------------------------------
        // CONNECT
        // -------------------------------------------------------------------------
        function void set_interface(
            virtual duttb_intf_srcchannel.TBconnect sch_0
        );
            // connect to src_driver
            this.src_driver.set_interface(sch_0);

        endfunction

        // -------------------------------------------------------------------------
        // FUN : Single data transimit
        // -------------------------------------------------------------------------
        task single_tran(
            input [1:0]  mode, // write or read
            input [31:0] data  // acess data
         );
            // generate data
            this.src_generator.data_gen(mode, data);
            // select and ask the driver to write the data
            src_driver.data_write();

        endtask

    endclass

endpackage
