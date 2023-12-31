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
// Testbench Name: SyncFIFO Assertion
// Testbench Design: SRC_AGENT
// Tool versions: QuestaSim 10.6c
// Description: 
// APB's agent moudule for testbench of DUT. APB single Read/Write event define.
// APB back-to-back Read/Write event define. APB write data randomize and monitor.
// Dependencies:
// N/A
//
// Revision:
// ---------------------------------------------------------------------------------
// [Date]         [By]         [Version]         [Change Log]
// ---------------------------------------------------------------------------------
// 2023/11/15     Yu Huang     1.0               First implmentation
// 2023/12/07     Yu Huang     1.1               Modify timing for low-power spec
// 2023/12/20     Yu Huang     1.2               Add back-to-back transmit timing
// ---------------------------------------------------------------------------------
//
//-FHDR//////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
`define FIFO_BASE_ADDR    32'h2000_0000                // base addr of FIFO device
`define FIFO_WRITE_DATA   (`FIFO_BASE_ADDR + 32'h00)   // FIFO write data (read/write)
`define FIFO_STATUS       (`FIFO_BASE_ADDR + 32'h04)   // FIFO status (read)

package src_agent_objects;
    // Package of APB agent objects:
    //   [1] source data class
    //   [2] source data generator
    //   [3] source driver
    class src_randomgen_datapkg; // Data used in APB agent
        bit mode;         // APB access mode: 0-read, 1-write
        bit random;       // APB random acess: read - random addr, write - random data
        bit [31:0] addr;  // APB access addr
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
            input random,       // APB random acess: read - random addr, write - random data
            input [31:0] addr,  // APB access addr
            input [31:0] data   // APB access data
        );
            src_randomgen_datapkg tran_data;
            bit [31:0] random_val;
            tran_data = new();              // consturctor of the src_randomgen_datapkg class
            tran_data.mode = mode;          // get APB access mode
            tran_data.random = random;      // APB access if random
            if (random == 1'b0) begin       // not a random access
                tran_data.addr = addr;      // get APB access addr
                tran_data.data = data;      // get APB access data
            end
            else if (mode == 1'b0) begin    // random read acess
                random_val = $urandom();
                if (random_val > 32'h7FFF_FFFF) begin
                    tran_data.addr = `FIFO_WRITE_DATA;  // get APB access addr
                    tran_data.data = data;              // get APB access data
                end
                else begin
                    tran_data.addr = `FIFO_STATUS;      // get APB access addr
                    tran_data.data = data;              // get APB access data
                end
            end
            else begin // random write access
                random_val = $urandom();
                tran_data.addr = `FIFO_WRITE_DATA;      // get APB access addr
                tran_data.data = random_val;            // get APB access data
            end
            gen2drv.put(tran_data);     // put the data into mailbox for driver to get
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
            // this.active_channel.channel_pwrite = 1'b0;
            // this.active_channel.channel_psel = 1'b0;
            // this.active_channel.channel_paddr = 32'h0000_0000;
            // this.active_channel.channel_pwdata = 32'h0000_0000;
            // this.active_channel.channel_penable = 1'b0;
            this.active_channel.cb_src.channel_pwrite <= 1'b0;
            this.active_channel.cb_src.channel_psel <= 1'b0;
            this.active_channel.cb_src.channel_paddr <= 32'h0000_0000;
            this.active_channel.cb_src.channel_pwdata <= 32'h0000_0000;
            this.active_channel.cb_src.channel_penable <= 1'b0;
        endfunction
        
        // -------------------------------------------------------------------------
        // [data_read]: APB read data handhsake
        // -------------------------------------------------------------------------
        task data_read();
            // get data from mailbox to random_data_get
            src_randomgen_datapkg random_data_get;
            this.gen2drv.get(random_data_get);
            // APB config
            @(posedge this.active_channel.clk)
                // this.active_channel.channel_pwrite = 1'b0;
                // this.active_channel.channel_psel = 1'b1;
                // this.active_channel.channel_paddr = random_data_get.addr;
                // this.active_channel.channel_pwdata = random_data_get.data;
                // this.active_channel.channel_penable = 1'b0;
                this.active_channel.cb_src.channel_pwrite <= 1'b0;
                this.active_channel.cb_src.channel_psel <= 1'b1;
                this.active_channel.cb_src.channel_paddr <= random_data_get.addr;
                this.active_channel.cb_src.channel_pwdata <= random_data_get.data;
                this.active_channel.cb_src.channel_penable <= 1'b0;
            // APB access
            @(posedge this.active_channel.clk)
                // this.active_channel.channel_penable = 1'b1;
                this.active_channel.cb_src.channel_penable <= 1'b1;
            // Wait for APB slave ready
            // wait(this.active_channel.channel_pready)
            wait(this.active_channel.cb_src.channel_pready == 1'b1)
                // to APB idle
                @(posedge this.active_channel.clk)
                    // this.active_channel.channel_pwrite = 1'b0;
                    // this.active_channel.channel_psel = 1'b0;
                    // this.active_channel.channel_paddr = 32'h0000_0000;
                    // this.active_channel.channel_pwdata = 32'h0000_0000;
                    // this.active_channel.channel_penable = 1'b0;
                    this.active_channel.cb_src.channel_pwrite <= 1'b0;
                    this.active_channel.cb_src.channel_psel <= 1'b0;
                    // this.active_channel.cb_src.channel_paddr <= 32'h0000_0000; // for addr stable until next transmission
                    // this.active_channel.cb_src.channel_pwdata <= 32'h0000_0000; // for addr stable until next transmission
                    this.active_channel.cb_src.channel_penable <= 1'b0;
        endtask

        // -------------------------------------------------------------------------
        // [data_read_head]: Head of the back-to-back APB read data handhsake
        // -------------------------------------------------------------------------
        task data_read_head();
            // get data from mailbox to random_data_get
            src_randomgen_datapkg random_data_get;
            this.gen2drv.get(random_data_get);
            // APB config
            @(posedge this.active_channel.clk)
                // this.active_channel.channel_pwrite = 1'b0;
                // this.active_channel.channel_psel = 1'b1;
                // this.active_channel.channel_paddr = random_data_get.addr;
                // this.active_channel.channel_pwdata = random_data_get.data;
                // this.active_channel.channel_penable = 1'b0;
                this.active_channel.cb_src.channel_pwrite <= 1'b0;
                this.active_channel.cb_src.channel_psel <= 1'b1;
                this.active_channel.cb_src.channel_paddr <= random_data_get.addr;
                this.active_channel.cb_src.channel_pwdata <= random_data_get.data;
                this.active_channel.cb_src.channel_penable <= 1'b0;
            // APB access
            @(posedge this.active_channel.clk)
                // this.active_channel.channel_penable = 1'b1;
                this.active_channel.cb_src.channel_penable <= 1'b1;
        endtask

        // -------------------------------------------------------------------------
        // [data_read_body]: Body of the back-to-back APB read data handhsake
        // -------------------------------------------------------------------------
        task data_read_body();
            // get data from mailbox to random_data_get
            src_randomgen_datapkg random_data_get;
            this.gen2drv.get(random_data_get);
            // Wait for APB slave ready
            // wait(this.active_channel.channel_pready)
            wait(this.active_channel.cb_src.channel_pready == 1'b1)
                // APB config
                // @(negedge this.active_channel.channel_pready)
                @(negedge this.active_channel.cb_src.channel_pready)
                    // this.active_channel.channel_pwrite = 1'b0;
                    // this.active_channel.channel_psel = 1'b1;
                    // this.active_channel.channel_paddr = random_data_get.addr;
                    // this.active_channel.channel_pwdata = random_data_get.data;
                    // this.active_channel.channel_penable = 1'b0;
                    this.active_channel.cb_src.channel_pwrite <= 1'b0;
                    this.active_channel.cb_src.channel_psel <= 1'b1;
                    this.active_channel.cb_src.channel_paddr <= random_data_get.addr;
                    this.active_channel.cb_src.channel_pwdata <= random_data_get.data;
                    this.active_channel.cb_src.channel_penable <= 1'b0;
                // APB access
                @(posedge this.active_channel.clk)
                    // this.active_channel.channel_penable = 1'b1;
                    this.active_channel.cb_src.channel_penable <= 1'b1;
        endtask

        // -------------------------------------------------------------------------
        // [data_read_tail]: Tail of the back-to-back APB read data handhsake
        // -------------------------------------------------------------------------
        task data_read_tail();
            // get data from mailbox to random_data_get
            src_randomgen_datapkg random_data_get;
            this.gen2drv.get(random_data_get);
            // Wait for APB slave ready
            // wait(this.active_channel.channel_pready)
            wait(this.active_channel.cb_src.channel_pready == 1'b1)
                // APB config
                // @(negedge this.active_channel.channel_pready)
                @(negedge this.active_channel.cb_src.channel_pready)
                    // this.active_channel.channel_pwrite = 1'b0;
                    // this.active_channel.channel_psel = 1'b1;
                    // this.active_channel.channel_paddr = random_data_get.addr;
                    // this.active_channel.channel_pwdata = random_data_get.data;
                    // this.active_channel.channel_penable = 1'b0;
                    this.active_channel.cb_src.channel_pwrite <= 1'b0;
                    this.active_channel.cb_src.channel_psel <= 1'b1;
                    this.active_channel.cb_src.channel_paddr <= random_data_get.addr;
                    this.active_channel.cb_src.channel_pwdata <= random_data_get.data;
                    this.active_channel.cb_src.channel_penable <= 1'b0;
                // APB access
                @(posedge this.active_channel.clk)
                    // this.active_channel.channel_penable = 1'b1;
                    this.active_channel.cb_src.channel_penable <= 1'b1;
                @(negedge this.active_channel.cb_src.channel_pready)
                    // this.active_channel.channel_pwrite = 1'b0;
                    // this.active_channel.channel_psel = 1'b0;
                    // this.active_channel.channel_paddr = 32'h0000_0000;
                    // this.active_channel.channel_pwdata = 32'h0000_0000;
                    // this.active_channel.channel_penable = 1'b0;
                    this.active_channel.cb_src.channel_pwrite <= 1'b0;
                    this.active_channel.cb_src.channel_psel <= 1'b0;
                    // this.active_channel.cb_src.channel_paddr <= 32'h0000_0000; // for addr stable until next transmission
                    // this.active_channel.cb_src.channel_pwdata <= 32'h0000_0000; // for addr stable until next transmission
                    this.active_channel.cb_src.channel_penable <= 1'b0;
        endtask

        // -------------------------------------------------------------------------
        // [data_write]: APB write data handhsake
        // -------------------------------------------------------------------------
        task data_write(
            ref bit [31:0] data [8192],
            ref bit [12:0] pushed_count
        );
            // get data from mailbox to random_data_get
            src_randomgen_datapkg random_data_get;
            this.gen2drv.get(random_data_get);
            // APB config
            @(posedge this.active_channel.clk)
                // this.active_channel.channel_pwrite = 1'b1;
                // this.active_channel.channel_psel = 1'b1;
                // this.active_channel.channel_paddr = random_data_get.addr;
                // this.active_channel.channel_pwdata = random_data_get.data;
                // this.active_channel.channel_penable = 1'b0;
                this.active_channel.cb_src.channel_pwrite <= 1'b1;
                this.active_channel.cb_src.channel_psel <= 1'b1;
                this.active_channel.cb_src.channel_paddr <= random_data_get.addr;
                this.active_channel.cb_src.channel_pwdata <= random_data_get.data;
                this.active_channel.cb_src.channel_penable <= 1'b0;
            // APB access
            @(posedge this.active_channel.clk)
                // this.active_channel.channel_penable = 1'b1;
                this.active_channel.cb_src.channel_penable <= 1'b1;
            // Wait for APB slave ready
            // wait(this.active_channel.channel_pready)
            wait(this.active_channel.cb_src.channel_pready == 1'b1)
                data[pushed_count] = random_data_get.data;
                pushed_count = pushed_count + 1'b1;
                $display("[SRC AGENT] @%0d ns Data pushed into FIFO: %h, total pushed: %d ",
                         $time, random_data_get.data, pushed_count);
                // to APB idle
                @(posedge this.active_channel.clk)
                    // this.active_channel.channel_pwrite = 1'b0;
                    // this.active_channel.channel_psel = 1'b0;
                    // this.active_channel.channel_paddr = 32'h0000_0000;
                    // this.active_channel.channel_pwdata = 32'h0000_0000;
                    // this.active_channel.channel_penable = 1'b0;
                    // this.active_channel.cb_src.channel_pwrite <= 1'b0; // // for low-power spec
                    this.active_channel.cb_src.channel_psel <= 1'b0;
                    // this.active_channel.cb_src.channel_paddr <= 32'h0000_0000; // for low-power spec
                    // this.active_channel.cb_src.channel_pwdata <= 32'h0000_0000; // for low-power spec
                    this.active_channel.cb_src.channel_penable <= 1'b0;
        endtask

        // -------------------------------------------------------------------------
        // [data_write_head]: Head of the back-to-back APB write data handhsake
        // -------------------------------------------------------------------------
        task data_write_head(
            ref bit [31:0] data [8192],
            ref bit [12:0] pushed_count
        );
            // get data from mailbox to random_data_get
            src_randomgen_datapkg random_data_get;
            this.gen2drv.get(random_data_get);
            // APB config
            @(posedge this.active_channel.clk)
                // this.active_channel.channel_pwrite = 1'b1;
                // this.active_channel.channel_psel = 1'b1;
                // this.active_channel.channel_paddr = random_data_get.addr;
                // this.active_channel.channel_pwdata = random_data_get.data;
                // this.active_channel.channel_penable = 1'b0;
                this.active_channel.cb_src.channel_pwrite <= 1'b1;
                this.active_channel.cb_src.channel_psel <= 1'b1;
                this.active_channel.cb_src.channel_paddr <= random_data_get.addr;
                this.active_channel.cb_src.channel_pwdata <= random_data_get.data;
                this.active_channel.cb_src.channel_penable <= 1'b0;
            // APB access
            @(posedge this.active_channel.clk)
                // this.active_channel.channel_penable = 1'b1;
                this.active_channel.cb_src.channel_penable <= 1'b1;
                data[pushed_count] = random_data_get.data;
                pushed_count = pushed_count + 1'b1;
                $display("[SRC AGENT] Data pushed into FIFO: %h, total pushed: %d ", random_data_get.data, pushed_count);
        endtask

        // -------------------------------------------------------------------------
        // [data_write_body: Body of the back-to-back APB write data handhsake
        // -------------------------------------------------------------------------
        task data_write_body(
            ref bit [31:0] data [8192],
            ref bit [12:0] pushed_count
        );
            // get data from mailbox to random_data_get
            src_randomgen_datapkg random_data_get;
            this.gen2drv.get(random_data_get);
            // Wait for APB slave ready
            // wait(this.active_channel.channel_pready)
            wait(this.active_channel.cb_src.channel_pready == 1'b1)
                // APB config
                // @(negedge this.active_channel.channel_pready)
                @(negedge this.active_channel.cb_src.channel_pready)
                    // this.active_channel.channel_pwrite = 1'b1;
                    // this.active_channel.channel_psel = 1'b1;
                    // this.active_channel.channel_paddr = random_data_get.addr;
                    // this.active_channel.channel_pwdata = random_data_get.data;
                    // this.active_channel.channel_penable = 1'b0;
                    this.active_channel.cb_src.channel_pwrite <= 1'b1;
                    this.active_channel.cb_src.channel_psel <= 1'b1;
                    this.active_channel.cb_src.channel_paddr <= random_data_get.addr;
                    this.active_channel.cb_src.channel_pwdata <= random_data_get.data;
                    this.active_channel.cb_src.channel_penable <= 1'b0;
                // APB access
                @(posedge this.active_channel.clk)
                    // this.active_channel.channel_penable = 1'b1;
                    this.active_channel.cb_src.channel_penable <= 1'b1;
                    data[pushed_count] = random_data_get.data;
                    pushed_count = pushed_count + 1'b1;
                    $display("[SRC AGENT] Data pushed into FIFO: %h, total pushed: %d ", random_data_get.data, pushed_count);
        endtask

        // -------------------------------------------------------------------------
        // [data_write_tail]: Tail of the back-to-back APB write data handhsake
        // -------------------------------------------------------------------------
        task data_write_tail(
            ref bit [31:0] data [8192],
            ref bit [12:0] pushed_count
        );
            // get data from mailbox to random_data_get
            src_randomgen_datapkg random_data_get;
            this.gen2drv.get(random_data_get);
            // Wait for APB slave ready
            // wait(this.active_channel.channel_pready)
            wait(this.active_channel.cb_src.channel_pready == 1'b1)
                // APB config
                // @(negedge this.active_channel.channel_pready)
                @(negedge this.active_channel.cb_src.channel_pready)
                    // this.active_channel.channel_pwrite = 1'b1;
                    // this.active_channel.channel_psel = 1'b1;
                    // this.active_channel.channel_paddr = random_data_get.addr;
                    // this.active_channel.channel_pwdata = random_data_get.data;
                    // this.active_channel.channel_penable = 1'b0;
                    this.active_channel.cb_src.channel_pwrite <= 1'b1;
                    this.active_channel.cb_src.channel_psel <= 1'b1;
                    this.active_channel.cb_src.channel_paddr <= random_data_get.addr;
                    this.active_channel.cb_src.channel_pwdata <= random_data_get.data;
                    this.active_channel.cb_src.channel_penable <= 1'b0;
                // APB access
                @(posedge this.active_channel.clk)
                    // this.active_channel.channel_penable = 1'b1;
                    this.active_channel.cb_src.channel_penable <= 1'b1;
                    data[pushed_count] = random_data_get.data;
                    pushed_count = pushed_count + 1'b1;
                    $display("[SRC AGENT] Data pushed into FIFO: %h, total pushed: %d ", random_data_get.data, pushed_count);
                // to APB idle
                @(posedge this.active_channel.clk)
                    // this.active_channel.channel_pwrite = 1'b0;
                    // this.active_channel.channel_psel = 1'b0;
                    // this.active_channel.channel_paddr = 32'h0000_0000;
                    // this.active_channel.channel_pwdata = 32'h0000_0000;
                    // this.active_channel.channel_penable = 1'b0;
                    // this.active_channel.cb_src.channel_pwrite <= 1'b0; // // for low-power spec
                    this.active_channel.cb_src.channel_psel <= 1'b0;
                    // this.active_channel.cb_src.channel_paddr <= 32'h0000_0000; // for low-power spec
                    // this.active_channel.cb_src.channel_pwdata <= 32'h0000_0000; // for low-power spec
                    this.active_channel.cb_src.channel_penable <= 1'b0;
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
        bit [31:0] data [8192];
        bit [12:0] pushed_count;
        src_generator                    src_generator;   // src generator instance
        mailbox #(src_randomgen_datapkg) mailbox_gen2drv; // mailbox of src agent
        src_driver                       src_driver;      // src driver instance
        bit err_wr_addr = 1'b0;                           // if inject error in write addr

        function new(); // constuctor of src agent
            this.pushed_count = 13'd0;
            this.mailbox_gen2drv = new(16);               // create a 16 size mailbox
            this.src_generator   = new(mailbox_gen2drv);  // pass mailbox to data gen
            this.src_driver     = new(mailbox_gen2drv);   // pass mailbox to data drive
            if (this.err_wr_addr == 1'b1) begin
                $display("Error injection of write address [ACTIVE]");
            end
            else begin
                $display("Error injection of write address [INACTIVE]");
            end
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
            input mode,        // write or read
            input random,      // random access flag
            input [31:0] addr, // access addr
            input [31:0] data  // access data
         );
            if (mode == 1'b0) begin // read mode
                // generate data
                this.src_generator.data_gen(mode, random, addr, data);
                // select and ask the driver to read the data
                this.src_driver.data_read();
            end
            else begin // write mode
                // generate data
                this.src_generator.data_gen(mode, random, addr, data);
                // select and ask the driver to write the data
                this.src_driver.data_write(this.data, this.pushed_count);
            end
        endtask

        // -------------------------------------------------------------------------
        // FUN : Head of a back-to-back data transimit
        // -------------------------------------------------------------------------
        task b2b_tran_head(
            input mode,        // write or read
            input random,      // random access flag
            input [31:0] addr, // access addr
            input [31:0] data  // access data
         );
            if (mode == 1'b0) begin // read mode
                // generate data
                this.src_generator.data_gen(mode, random, addr, data);
                // select and ask the driver to read the data
                this.src_driver.data_read_head();
            end
            else begin // write mode
                // generate data
                this.src_generator.data_gen(mode, random, addr, data);
                // select and ask the driver to write the data
                this.src_driver.data_write_head(this.data, this.pushed_count);
            end
        endtask

        // -------------------------------------------------------------------------
        // FUN : Body of a back-to-back data transimit
        // -------------------------------------------------------------------------
        task b2b_tran_body(
            input mode,        // write or read
            input random,      // random access flag
            input [31:0] addr, // access addr
            input [31:0] data  // access data
         );
            if (mode == 1'b0) begin // read mode
                // generate data
                this.src_generator.data_gen(mode, random, addr, data);
                // select and ask the driver to read the data
                this.src_driver.data_read_body();
            end
            else begin // write mode
                // generate data
                this.src_generator.data_gen(mode, random, addr, data);
                // select and ask the driver to write the data
                this.src_driver.data_write_body(this.data, this.pushed_count);
            end
        endtask

        // -------------------------------------------------------------------------
        // FUN : Tail of a back-to-back data transimit
        // -------------------------------------------------------------------------
        task b2b_tran_tail(
            input mode,        // write or read
            input random,      // random access flag
            input [31:0] addr, // access addr
            input [31:0] data  // access data
         );
            if (mode == 1'b0) begin // read mode
                // generate data
                this.src_generator.data_gen(mode, random, addr, data);
                // select and ask the driver to read the data
                this.src_driver.data_read_tail();
            end
            else begin // write mode
                // generate data
                this.src_generator.data_gen(mode, random, addr, data);
                // select and ask the driver to write the data
                this.src_driver.data_write_tail(this.data, this.pushed_count);
            end
        endtask
    endclass
endpackage
