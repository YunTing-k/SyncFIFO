//+FHDR//////////////////////////////////////////////////////////////////////////////
// Company: Shanghai Jiao Tong University
// Original Source: EST8703-039-M01 LAB2 DST_AGENT.sv(empty file)
// Engineer: Yu Huang
//
// Create Date: 2023.11.28
// DUT Name: SyncFIFO
// DUT Top: top_wrapper
// Testbench Name: SyncFIFO Verification Framework
// Testbench Design: DST_AGENT
// Tool versions: QuestaSim 10.6c
// Description: 
// Arbiter's agent moudule for testbench of DUT. Arbiter read with priority and addr.
// And realiaztion of random access and monitor.
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
`define FIFO_OUT_DATA       8'd0   // FIFO output data (read)
`define DATA_ERR_IDX        8'd1   // FIFO data error index (read)
`define WRITE_PTR           8'd2   // FIFO write pointer (read)
`define WRITE_PTR_ERR_IDX   8'd3   // FIFO write pointer error index (read)
`define READ_PTR            8'd4   // FIFO read pointer (read)
`define READ_PTR_ERR_IDX    8'd5   // FIFO read pointer error index (read)

package dst_agent_objects;
    // Package of Arbiter agent objects:
    //   [1] dst data class
    //   [2] dst data generator
    //   [3] dst driver
    class dst_randomgen_datapkg; // Data used in Arbiter agent
        bit random_addr;         // Flag of arbiter random addr access
        bit random_priority;     // Flag of arbiter random channel priority
        bit [7:0] ch_priority;   // Arbiter channel priority
        bit [7:0] addr;          // Arbiter access addr
    endclass

    class dst_generator;  // Dst data generator for Arbiter agent
        // mailbox for generated data to driver
        mailbox #(dst_randomgen_datapkg) gen2drv;
        function new(
            mailbox #(dst_randomgen_datapkg) gen2drv
        );
            this.gen2drv = gen2drv;
        endfunction

        // -------------------------------------------------------------------------
        // [data_gen]: Generate data for Arbiter agent's driver
        // -------------------------------------------------------------------------
        task automatic data_gen(
            input random_addr,         // Flag of arbiter random addr access
            input random_priority,     // Flag of arbiter random channel priority
            input [7:0] ch_priority,   // Arbiter channel priority
            input [7:0] addr           // Arbiter access addr
        );
            dst_randomgen_datapkg tran_data;
            bit [7:0] _random_addr;
            bit [7:0] _random_priority;
            tran_data = new();                    // consturctor of the src_randomgen_datapkg class
            tran_data.random_addr = random_addr;  // Flag of arbiter random addr access
            tran_data.random_priority = random_priority;// Flag of arbiter random channel priority
            if (random_addr == 1'b0) begin  // not a random addr access
                tran_data.addr = addr;      // get Arbiter access addr
            end
            else begin // random addr access
                _random_addr = ($urandom() % 6);
                tran_data.addr = _random_addr;
            end
            if (random_priority == 1'b0) begin  // not a random priority
                tran_data.ch_priority = ch_priority;
            end
            else begin // random priority
                _random_priority = ($urandom() % 256);
                tran_data.ch_priority = _random_priority;
            end
            gen2drv.put(tran_data);     // put the data into mailbox for driver to get
        endtask
    endclass

    class dst_driver;  // Driver of the Arbiter agent, data transimit class define
        // mailbox for generated data to driver
        mailbox #(dst_randomgen_datapkg) gen2drv;
        function new( // constructor of driver class
            mailbox #(dst_randomgen_datapkg) gen2drv
        );
            this.gen2drv = gen2drv;
        endfunction

        // connection of TB to DUT
        local virtual duttb_intf_dstchannel.TBconnect active_channel;
        // -------------------------------------------------------------------------
        // [set_interface]: set interface of TB <==> DUT and initizalize data
        // -------------------------------------------------------------------------
        function void set_interface(
            virtual duttb_intf_dstchannel.TBconnect dst_ch
        );
            this.active_channel = dst_ch; // set dst class driver channel
            // port initialization to avoid 'x' state in dut
            // this.active_channel.addr_dst = 8'd0;
            // this.active_channel.priority_dst = 8'd0;
            // this.active_channel.valid_dst = 1'b0;
            this.active_channel.cb_dst.addr_dst <= 8'd0;
            this.active_channel.cb_dst.priority_dst <= 8'd0;
            this.active_channel.cb_dst.valid_dst <= 1'b0;
        endfunction
        
        // -------------------------------------------------------------------------
        // [data_read]: Arbiter read data handhsake
        // -------------------------------------------------------------------------
        task data_read(
            input [2:0] channel,
            ref bit [31:0] data [8192],
            ref bit [12:0] popped_count
            );
            // get data from mailbox to random_data_get
            dst_randomgen_datapkg random_data_get;
            this.gen2drv.get(random_data_get);
            // Arbiter config
            @(posedge this.active_channel.clk)
                // this.active_channel.addr_dst = random_data_get.addr;
                // this.active_channel.priority_dst = random_data_get.ch_priority;
                // this.active_channel.valid_dst = 1'b1;
                this.active_channel.cb_dst.addr_dst <= random_data_get.addr;
                this.active_channel.cb_dst.priority_dst <= random_data_get.ch_priority;
                this.active_channel.cb_dst.valid_dst <= 1'b1;
            // Wait for Arbiter slave ready
            // wait(this.active_channel.ready_dst)
            wait(this.active_channel.cb_dst.ready_dst == 1'b1)
                if (random_data_get.addr == `FIFO_OUT_DATA) begin
                    data[popped_count] = active_channel.cb_dst.data_dst;
                    popped_count = popped_count + 1'b1;
                    $display("[DST AGENT] @%0d ns Data popped in ch-[%d] from FIFO: %h, total popped: %d",
                             $time, channel, this.active_channel.cb_dst.data_dst, popped_count);
                end
                // to Arbiter idle
                @(posedge this.active_channel.clk)
                    // this.active_channel.addr_dst = 8'd0;
                    // this.active_channel.priority_dst = 8'd0;
                    // this.active_channel.valid_dst = 1'b0;
                    this.active_channel.cb_dst.addr_dst <= 8'd0;
                    this.active_channel.cb_dst.priority_dst <= 8'd0;
                    this.active_channel.cb_dst.valid_dst <= 1'b0;
        endtask
    endclass
endpackage

package dst_agent_main;
// Package of Arbiter agent main realization:
    import dst_agent_objects ::*; // import defined agent objects
    class dst_agent; // dst agent realization
        // -------------------------------------------------------------------------
        // BUILD
        // -------------------------------------------------------------------------
        bit [31:0] data [8192];
        bit [12:0] popped_count;
        dst_generator                    dst_generator;   // dst generator instance
        mailbox #(dst_randomgen_datapkg) mailbox_gen2drv; // mailbox of dst agent
        dst_driver                       dst_driver[8];   // dst driver instance
        bit err_rd_data = 1'b1;                           // if inject error in FIFO readout data
        bit err_rd_addr = 1'b1;                           // if inject error in read addr

        function new(); // constuctor of dst agent
            this.popped_count = 13'd0;
            this.mailbox_gen2drv = new(16);                  // create a 16 size mailbox
            this.dst_generator   = new(mailbox_gen2drv);     // pass mailbox to data gen
            this.dst_driver[0]      = new(mailbox_gen2drv);  // pass mailbox to data drive[0]
            this.dst_driver[1]      = new(mailbox_gen2drv);  // pass mailbox to data drive[1]
            this.dst_driver[2]      = new(mailbox_gen2drv);  // pass mailbox to data drive[2]
            this.dst_driver[3]      = new(mailbox_gen2drv);  // pass mailbox to data drive[3]
            this.dst_driver[4]      = new(mailbox_gen2drv);  // pass mailbox to data drive[4]
            this.dst_driver[5]      = new(mailbox_gen2drv);  // pass mailbox to data drive[5]
            this.dst_driver[6]      = new(mailbox_gen2drv);  // pass mailbox to data drive[6]
            this.dst_driver[7]      = new(mailbox_gen2drv);  // pass mailbox to data drive[7]
        endfunction

        // -------------------------------------------------------------------------
        // CONNECT
        // -------------------------------------------------------------------------
        function void set_interface(
            virtual duttb_intf_dstchannel.TBconnect dst_0,
            virtual duttb_intf_dstchannel.TBconnect dst_1,
            virtual duttb_intf_dstchannel.TBconnect dst_2,
            virtual duttb_intf_dstchannel.TBconnect dst_3,
            virtual duttb_intf_dstchannel.TBconnect dst_4,
            virtual duttb_intf_dstchannel.TBconnect dst_5,
            virtual duttb_intf_dstchannel.TBconnect dst_6,
            virtual duttb_intf_dstchannel.TBconnect dst_7
        );
            // connect to dst
            this.dst_driver[0].set_interface(dst_0);
            this.dst_driver[1].set_interface(dst_1);
            this.dst_driver[2].set_interface(dst_2);
            this.dst_driver[3].set_interface(dst_3);
            this.dst_driver[4].set_interface(dst_4);
            this.dst_driver[5].set_interface(dst_5);
            this.dst_driver[6].set_interface(dst_6);
            this.dst_driver[7].set_interface(dst_7);

        endfunction

        // -------------------------------------------------------------------------
        // FUN : Single data transimit
        // -------------------------------------------------------------------------
        task single_tran(
            input [2:0] channel,       // Access channel
            input random_addr,         // Flag of arbiter random addr access
            input random_priority,     // Flag of arbiter random channel priority
            input [7:0] ch_priority,   // Arbiter channel priority
            input [7:0] addr           // Arbiter access addr
         );
            // generate data
            this.dst_generator.data_gen(random_addr, random_priority, ch_priority, addr);
            // select and ask the driver to read the data
            this.dst_driver[channel].data_read(channel, this.data, this.popped_count);
        endtask
    endclass
endpackage

