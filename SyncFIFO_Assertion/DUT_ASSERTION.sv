//+FHDR//////////////////////////////////////////////////////////////////////////////
// Company: Shanghai Jiao Tong University
// Original Source: EST8703-039-M01 LAB3 DUT_ASSERTION.sv
// Engineer: Yu Huang
// Copyright: (c) This file is originally from the course "SystemVerilog Circuit Design
// and Verfication (EST8703-039-M01)" by Shanghai Jiao Tong University Prof. Jiang Jianfei.
// The author partly modify the original source and resubmit it.
//
// Create Date: 2023.12.7
// DUT Name: SyncFIFO
// DUT Top: top_wrapper
// Testbench Name: SyncFIFO Assertion
// Testbench Design: DUT_ASSERTION
// Tool versions: QuestaSim 10.6c
// Description: 
// Assertions of the DUT, including 19 assertion properties of APB, 15 assertion properties
// of Arbiter, and 17 assertion properties of FIFO. In assertion properties defination,
// we try to fully cover the all the signal ports and the possible behavior with the 
// consideration of the spec of the module.
// Dependencies:
// N/A
//
// Revision:
// ---------------------------------------------------------------------------------
// [Date]         [By]         [Version]         [Change Log]
// ---------------------------------------------------------------------------------
// 2023/12/07     Yu Huang     1.0               APB assertion
// 2023/12/19     Yu Huang     1.1               Read channel assertion
// 2023/12/20     Yu Huang     1.2               FIFO assertion
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

module dut_io_assertion(
// system signal
    input clk,
    input rst_n,
// APB signal
    input pwrite,
    input psel,
    input [31:0] paddr,
    input [31:0] pwdata,
    input penable,
    input [31:0] prdata,
    input pready,
// Read channel-0 signal
    input [7:0]  addr_dst0,
    input [7:0]  priority_dst0,
    input        valid_dst0,
    input [31:0] data_dst0,
    input        ready_dst0,
// Read channel-1 signal
    input [7:0]  addr_dst1,
    input [7:0]  priority_dst1,
    input        valid_dst1,
    input [31:0] data_dst1,
    input        ready_dst1,
// Read channel-2 signal
    input [7:0]  addr_dst2,
    input [7:0]  priority_dst2,
    input        valid_dst2,
    input [31:0] data_dst2,
    input        ready_dst2,
// Read channel-3 signal
    input [7:0]  addr_dst3,
    input [7:0]  priority_dst3,
    input        valid_dst3,
    input [31:0] data_dst3,
    input        ready_dst3,
// Read channel-4 signal
    input [7:0]  addr_dst4,
    input [7:0]  priority_dst4,
    input        valid_dst4,
    input [31:0] data_dst4,
    input        ready_dst4,
// Read channel-5 signal
    input [7:0]  addr_dst5,
    input [7:0]  priority_dst5,
    input        valid_dst5,
    input [31:0] data_dst5,
    input        ready_dst5,
// Read channel-6 signal
    input [7:0]  addr_dst6,
    input [7:0]  priority_dst6,
    input        valid_dst6,
    input [31:0] data_dst6,
    input        ready_dst6,
// Read channel-7 signal
    input [7:0]  addr_dst7,
    input [7:0]  priority_dst7,
    input        valid_dst7,
    input [31:0] data_dst7,
    input        ready_dst7
);
// assertion instance of read channel-0
    channel_assertion ch0_assertion(
        .clk     (clk),
        .rst_n   (rst_n),
        .addr    (addr_dst0),
        .prior   (priority_dst0),
        .valid   (valid_dst0),
        .data    (data_dst0),
        .ready   (ready_dst0)
    );
// assertion instance of read channel-1
    channel_assertion ch1_assertion(
        .clk     (clk),
        .rst_n   (rst_n),
        .addr    (addr_dst1),
        .prior   (priority_dst1),
        .valid   (valid_dst1),
        .data    (data_dst1),
        .ready   (ready_dst1)
    );
// assertion instance of read channel-2
    channel_assertion ch2_assertion(
        .clk     (clk),
        .rst_n   (rst_n),
        .addr    (addr_dst2),
        .prior   (priority_dst2),
        .valid   (valid_dst2),
        .data    (data_dst2),
        .ready   (ready_dst2)
    );
// assertion instance of read channel-3
    channel_assertion ch3_assertion(
        .clk     (clk),
        .rst_n   (rst_n),
        .addr    (addr_dst3),
        .prior   (priority_dst3),
        .valid   (valid_dst3),
        .data    (data_dst3),
        .ready   (ready_dst3)
    );
// assertion instance of read channel-4
    channel_assertion ch4_assertion(
        .clk     (clk),
        .rst_n   (rst_n),
        .addr    (addr_dst4),
        .prior   (priority_dst4),
        .valid   (valid_dst4),
        .data    (data_dst4),
        .ready   (ready_dst4)
    );
// assertion instance of read channel-5
    channel_assertion ch5_assertion(
        .clk     (clk),
        .rst_n   (rst_n),
        .addr    (addr_dst5),
        .prior   (priority_dst5),
        .valid   (valid_dst5),
        .data    (data_dst5),
        .ready   (ready_dst5)
    );
// assertion instance of read channel-6
    channel_assertion ch6_assertion(
        .clk     (clk),
        .rst_n   (rst_n),
        .addr    (addr_dst6),
        .prior   (priority_dst6),
        .valid   (valid_dst6),
        .data    (data_dst6),
        .ready   (ready_dst6)
    );
// assertion instance of read channel-7
    channel_assertion ch7_assertion(
        .clk     (clk),
        .rst_n   (rst_n),
        .addr    (addr_dst7),
        .prior   (priority_dst7),
        .valid   (valid_dst7),
        .data    (data_dst7),
        .ready   (ready_dst7)
    );
// assertion instance of apb slave
    apb_assertion dut_apb_assertion(
        .clk     (clk)    ,
        .rst_n   (rst_n),
        .pwrite  (pwrite),
        .psel    (psel),
        .paddr   (paddr),
        .pwdata  (pwdata),
        .penable (penable),
        .prdata  (prdata),
        .pready  (pready)
    );
endmodule

// ---------------------------------------------------------------------------------
// Read channel assertion defination, assertion properties:
// ---------------------------------------------------------------------------------
// [1]:  after valid set high, addr shouldn't be X
// [2]:  after valid set high, addr shouldn't be out of access range
// [3]:  addr should be stable during request
// [4]:  addr should be stable until next request
// [5]:  after valid set high, priority shouldn't be X
// [6]:  priority should be stable during request
// [7]:  priority should be stable until next request
// [8]:  valid shouldn't be x after reset
// [9]:  valid must be stable until the ready rises
// [10]: valid must fall in next cycle when ready is high
// [11]: after ready set high, data shouldn't be X
// [12]: data should be stable until next request
// [13]: ready shouldn't be x after reset
// [14]: ready must fall with valid (disable when reset)
// [15]: ready must fall in next cycle when ready is high
// ---------------------------------------------------------------------------------
module channel_assertion(
    input clk,
    input rst_n,
    input [7:0] addr,  // read address
    input [7:0] prior, // read priority
    input valid,       // channal valid
    input [31:0] data, // channel output data
    input ready        // channel ready signal
);
//ADDR ASSERTION
    property _addr_no_x_valid_high;
        // after valid set high, addr shouldn't be X
        @(posedge clk) $rose(valid) |-> not ($isunknown(addr));
    endproperty

    property _addr_valid;
        // after valid set high, addr shouldn't be out of access range
        @(posedge clk) $rose(valid) |-> (addr <= `READ_PTR_ERR_IDX);
    endproperty

    property _addr_stable_in_req;
        // addr should be stable during request
        @(posedge clk) (!ready && valid && !$rose(valid)) |-> $stable(addr);
    endproperty

    property _addr_stable_until_next_req;
        // addr should be stable until next request
        logic[7:0] addr1, addr2;
        // avoid multiple matched sequences (multiple addr1 and addr2 that may not in a nearby request)
        @(posedge clk) first_match(($rose(valid),addr1=addr) ##[1:$] ($rose(valid),addr2=$past(addr))) |-> addr1 == addr2;
    endproperty

chaddr_no_x: assert property (_addr_no_x_valid_high) else $error($time, "\t\t Check channel addr no X FAILED!\n");
chaddr_valid: assert property (_addr_valid) else $error($time, "\t\t Check channel addr valid FAILED!\n");
chaddr_stable_in_req: assert property (_addr_stable_in_req) else $error($time, "\t\t Check channel addr stable during request FAILED!\n");
chaddr_satble_until_next_req: assert property (_addr_stable_until_next_req) else $error($time, "\t\t Check channel addr stable until next request FAILED!\n");

//PRIORITY ASSERTION
    property _prior_no_x_valid_high;
        // after valid set high, priority shouldn't be X
        @(posedge clk) $rose(valid) |-> not ($isunknown(prior));
    endproperty

    property _prior_stable_in_req;
        // priority should be stable during request
        @(posedge clk) (!ready && valid && !$rose(valid)) |-> $stable(prior);
    endproperty

    property _prior_stable_until_next_req;
        // priority should be stable until next request
        logic[7:0] prior1, prior2;
        // avoid multiple matched sequences (multiple priority1 and priority2 that may not in a nearby request)
        @(posedge clk) first_match(($rose(valid),prior1=prior) ##[1:$] ($rose(valid),prior2=$past(prior))) |-> prior1 == prior2;
    endproperty

chprior_no_x: assert property (_prior_no_x_valid_high) else $error($time, "\t\t Check priority no X FAILED!\n");
chprior_stable_in_req: assert property (_prior_stable_in_req) else $error($time, "\t\t Check priority stable during request FAILED!\n");
chprior_satble_until_next_req: assert property (_prior_stable_until_next_req) else $error($time, "\t\t Check priority stable until next request FAILED!\n");

//VALID ASSERTION
    property _valid_no_x;
        // valid shouldn't be x after reset
        @(posedge clk) disable iff(~rst_n)
            not $isunknown(prior);
    endproperty

    property _valid_stable;
        // valid must be stable until the ready rises
        @(posedge clk) disable iff(~rst_n)
            $rose(valid) |-> valid[*1:$] ##0 $rose(ready);
    endproperty

    property _valid_instant_fall;
        // valid must fall in next cycle when ready is high
        @(posedge clk) (ready) |=> $fell(valid);
    endproperty

valid_no_x: assert property (_valid_no_x) else $error($time, "\t\t Check valid no X FAILED!\n");
valid_stable: assert property (_valid_stable) else $error($time, "\t\t Check channel valid stable FAILED!\n");
valid_instant_fall: assert property (_valid_instant_fall) else $error($time, "\t\t Check cahnnel valid instantly falls FAILED!\n");

//DATA ASSERTION
    property _data_no_x_ready_high;
        // after ready set high, data shouldn't be X
        @(posedge clk) $rose(ready) |-> not ($isunknown(data));
    endproperty

    property _data_stable_until_next_req;
        // data should be stable until next request
        logic[31:0] data1, data2;
        // avoid multiple matched sequences (multiple data1 and data2 that may not in a nearby request)
        @(posedge clk) first_match(($rose(ready),data1=data) ##[1:$] ($rose(ready),data2=$past(data))) |-> data1 == data2;
    endproperty

chdata_no_x: assert property (_data_no_x_ready_high) else $error($time, "\t\t Check channel read data no X FAILED!\n");
chdata_satble_until_next_req: assert property (_data_stable_until_next_req) else $error($time, "\t\t Check channel read data stable until next request FAILED!\n");

//READY ASSERTION
    property _ready_no_x;
        // ready shouldn't be x after reset
        @(posedge clk) disable iff(~rst_n)
            not $isunknown(ready);
    endproperty

    property _ready_fall_with_valid;
        // ready must fall with valid (disable when reset)
        @(posedge clk) disable iff(~rst_n)
            $fell(ready) |-> $fell(valid);
    endproperty

    property _ready_instant_fall;
        // ready must fall in next cycle when ready is high
        @(posedge clk) (ready) |-> $rose(ready);
    endproperty

ready_no_x: assert property (_ready_no_x) else $error($time, "\t\t Check channel ready no X FAILED!\n");
ready_fall_with_valid: assert property(_ready_fall_with_valid) else $error($stime,"\t\t Check ready falls with valid FAILED!\n");
ready_instant_fall: assert property(_ready_instant_fall) else $error($stime,"\t\t Check ready instantly falls FAILED!\n");
endmodule

// ---------------------------------------------------------------------------------
// APB slave assertion defination, assertion properties:
// ---------------------------------------------------------------------------------
// [1]:  after psel set high, paddr shouldn't be X
// [2]:  after psel set high, paddr shouldn't be out of access range
// [3]:  paddr should be stable when APB slave in SETUP state
// [4]:  paddr should be stable until next transmission
// [5]:  penable shouldn't be x after reset
// [6]:  after psel rises, penable must rose in next cycle
// [7]:  when pready dosen't rise, penable should be stable after it rises
// [8]:  penable must fall in next cycle when pready is high
// [9]:  psel shouldn't be x after reset
// [10]: psel must be stable until the pready rises
// [11]: after psel set high, pwdata shouldn't be X
// [12]: when before access, pwdata should be stable
// [13]: pwdata should be stable until the next trans
// [14]: pwrite shouldn't be x after reset
// [15]: pwrite must be stable until the pready rises
// [16]: after pready set high, prdata shouldn't be X
// [17]: prdata must be stable until the next transmission
// [18]: pready must fall with penable (disable when reset)
// [19]: pready must fall in next cycle when pready is high
// ---------------------------------------------------------------------------------
module apb_assertion(
    input clk,
    input rst_n,
    input pwrite,         // APB write signal
    input psel,           // APB select signal
    input [31:0] paddr,   // APB address data
    input [31:0] pwdata,  // APB write data
    input penable,        // APB enable data
    input [31:0] prdata,  // APB read out data
    input pready          // APB ready signal
);
//PADDR ASSERTION
    property _paddr_no_x_psel_high;
        // after psel set high, paddr shouldn't be X
        @(posedge clk) $rose(psel) |-> not ($isunknown(paddr));
    endproperty

    property _paddr_valid;
        // after psel set high, paddr shouldn't be out of access range
        @(posedge clk) $rose(psel) |-> ((paddr == `FIFO_WRITE_DATA) || (paddr == `FIFO_STATUS));
    endproperty

    property _paddr_stable_in_trans;
        // paddr should be stable when APB slave in SETUP state
        @(posedge clk) (psel && penable) |-> $stable(paddr);
    endproperty

    property _paddr_stable_until_next_trans;
        // paddr should be stable until next transmission
        logic[31:0] addr1, addr2;
        // avoid multiple matched sequences (multiple addr1 and addr2 that may not in a nearby request)
        @(posedge clk) first_match(($rose(penable),addr1=paddr) ##[1:$] ((psel && !penable),addr2=$past(paddr))) |-> addr1 == addr2;
    endproperty

paddr_no_x: assert property (_paddr_no_x_psel_high) else $error($stime,"\t\t Check paddr no X FAILED!\n");
paddr_valid:assert property (_paddr_valid) else $error($stime,"\t\t Check paddr valid FAILED!\n");
paddr_stable_in_trans: assert property(_paddr_stable_in_trans) else $error($stime,"\t\t Check paddr stable in transmission FAILED!\n");
paddr_stable_until_next_trans: assert property(_paddr_stable_until_next_trans) else $error($stime,"\t\t Check paddr stable before next transmission FAILED!\n");

//PENABLE ASSERTION
    property _penable_no_x;
        // penable shouldn't be x after reset
        @(posedge clk) disable iff(~rst_n)
            not $isunknown(penable);
    endproperty

    property _penable_rise;
        // after psel rises, penable must rose in next cycle
        @(posedge clk) $rose(psel) |=> $rose(penable);
    endproperty

    property _penable_stable;
        // when pready dosen't rise, penable should be stable after it rises
        @(posedge clk) disable iff(~rst_n)
            $rose(penable) |-> penable[*1:$] ##0 $rose(pready);
    endproperty

    property _penable_instant_fall;
        // penable must fall in next cycle when ready is high
        @(posedge clk) (penable && pready) |=> $fell(penable);
    endproperty

penable_no_x: assert property (_penable_no_x) else $error($stime,"\t\t Check penable no X FAILED!\n");
penable_rise: assert property (_penable_rise) else $error($stime,"\t\t Check penable rise after psel rises FAILED!\n");
penable_stable:assert property (_penable_stable) else $error($stime,"\t\t Check penable stable before pready rises FAILED!\n");
penable_instant_fall:assert property (_penable_instant_fall) else $error($stime,"\t\t Check penable falls one cycle after it rises FAILED!\n");

//PSEL ASSERTION
    property _psel_no_x;
        // psel shouldn't be x after reset
        @(posedge clk) disable iff(~rst_n)
            not $isunknown(psel);
    endproperty

    property _psel_stable;
        // psel must be stable until the pready rises
        @(posedge clk) disable iff(~rst_n)
            $rose(psel) |-> psel[*1:$] ##0 $rose(pready);
    endproperty

    // PSEL may not instant fall, because there exists back-to-back transfer

psel_no_x: assert property (_psel_no_x) else $error($stime,"\t\t Check psel no X FAILED!\n");
psel_stable: assert property(_psel_stable) else $error($stime,"\t\t Check psel stable until pready rises FAILED!\n");

//PWDATA ASSERTION
    property _pwdata_no_x_psel_high;
        // after psel set high, pwdata shouldn't be X
        @(posedge clk) $rose(psel) |-> not ($isunknown(pwdata));
    endproperty

    property _pwdata_stable_in_trans;
        // when before access, pwdata should be stable
        @(posedge clk) (psel && penable) |-> $stable(pwdata);
    endproperty

    property _pwdata_stable_until_next_trans;
        // pwdata should be stable until the next trans
        logic[31:0] data1, data2;
        // avoid multiple matched sequences (multiple data1 and data2 that may not in a nearby request)
        @(posedge clk) first_match(($rose(psel),data1=pwdata) ##[1:$] ((psel && !penable),data2=$past(pwdata))) |-> data1 == data2;
    endproperty

pwdata_no_x_psel_high: assert property(_pwdata_no_x_psel_high) else $error($stime,"\t\t Check pwdata no X FAILED!\n");
pwdata_stable_in_trans: assert property(_pwdata_stable_in_trans) else $error($stime,"\t\t Check pwdata stable in this transmission FAILED!\n");
pwdata_stable_until_next_trans: assert property(_pwdata_stable_until_next_trans) else $error($stime,"\t\t Check pwdata stable until next transmission FAILED!\n");

//PWRITE ASSERTION
    property _pwrite_no_x;
        // pwrite shouldn't be x after reset
        @(posedge clk) disable iff(~rst_n)
            not $isunknown(pwrite);
    endproperty

    property _pwrite_stable;
        // pwrite must be stable until the pready rises
        @(posedge clk) $rose(pwrite) |-> pwrite[*1:$] ##0 $rose(pready);
    endproperty

pwrite_no_x: assert property (_pwrite_no_x) else $error($stime,"\t\t Check pwrite no X FAILED!\n");
pwrite_stable: assert property(_pwrite_stable) else $error($stime,"\t\t Check pwrite stable FAILED!\n");

//PRDATA ASSERTION
    property _prdata_no_x_pready_high;
        // after pready set high, prdata shouldn't be X
        @(posedge clk) $rose(pready) |-> not ($isunknown(prdata));
    endproperty

    property _prdata_stable_until_next_trans;
        // prdata must be stable until the next transmission
        logic[31:0] data1, data2;
        // avoid multiple matched sequences (multiple data1 and data2 that may not in a nearby request)
        @(posedge clk) first_match(($rose(pready) && !pwrite, data1=prdata) ##[1:$] ((psel && !penable),data2=$past(prdata))) |-> data1 == data2;
    endproperty

prdata_no_x_pready_high: assert property(_prdata_no_x_pready_high) else $error($stime,"\t\t Check prdata no X FAILED!\n");
prdata_stable_until_next_trans: assert property(_prdata_stable_until_next_trans) else $error($stime,"\t\t Check prdata stable until next transmission FAILED!\n");

//PREADY ASSERTION

    // PREADY may not fall with psel, because there exists back-to-back transfer

    property _pready_fall_with_penable;
        // pready must fall with penable (disable when reset)
        @(posedge clk) disable iff(~rst_n)
            $fell(pready) |-> $fell(penable);
    endproperty

    property _pready_instant_fall;
        // pready must fall in next cycle when pready is high
        @(posedge clk) (pready) |=> $fell(pready);
    endproperty

pready_fall_with_penable: assert property(_pready_fall_with_penable) else $error($stime,"\t\t Check pready falls with penable FAILED!\n");
pready_instant_fall: assert property(_pready_instant_fall) else $error($stime,"\t\t Check pready instantly falls FAILED!\n");
endmodule

// ---------------------------------------------------------------------------------
// FIFO assertion defination, assertion properties:
// ---------------------------------------------------------------------------------
// [1]:  wr_en shouldn't be x after reset
// [2]:  rd_en and rd_only shouldn't be x after reset
// [3]:  wr_addr shouldn't be x after wr_en sets high
// [4]:  wr_addr should increase when FIFO push data
// [5]:  wr_addr should be stable when FIFO full
// [6]:  wr_addr should be stable when wr_en low
// [7]:  rd_addr shouldn't be x after rd_en sets high
// [8]:  rd_addr should increase when FIFO pop data
// [9]:  rd_addr should be stable when FIFO empty
// [10]: rd_addr should be stable when FIFO read only
// [11]: rd_addr should be stable when rd_en low
// [12]: fifo_status shouldn't be x after reset
// [13]: fifo_status keep in the valid range
// [14]: fifo_status should increase from 0 to 1 when FIFO only push data
// [15]: fifo_status should decrease from 5 to 4 when FIFO only pop data
// [16]: fifo_status should be stable when no push and pop request
// [17]: fifo_status should be stable when no FIFO both push and pop
// ---------------------------------------------------------------------------------
module dut_fifo_assertion
#(parameter  WIDTH = 32,   // data bit width
  parameter  DEPTH = 1024, // depth of mem
  parameter  ADDR = 10)    // address length
(
    input clk,                        // clock
    input rst_n,                      // reset signal active low
    input wr_en,                      // write enable (from APB slave)
    input rd_en,                      // read enable (from Arbiter)
    input rd_only,                    // read only signel (from Arbiter), ture: only read fifo but don't pop
    input [ADDR - 1:0] wr_addr,       // write address
    input [ADDR - 1:0] rd_addr,       // read address
    input wr_clk,                     // write clock
    input rd_clk,                     // read clock
    input [2:0] fifo_status           // fifo status (to APB slave and Arbiter, in decimal)
                                      // 0:empty, 1:(3/4)empty, 2:(2/4)empty, 3-(1/4)empty, 4-(0/4)empty, 5-full
);
//WR_EN ASSERTION
    property _wr_en_no_x;
        // wr_en shouldn't be x after reset
        @(posedge clk) disable iff(~rst_n)
            not $isunknown(wr_en);
    endproperty

wr_en_no_x: assert property (_wr_en_no_x) else $error($stime,"\t\t Check wr_en no X FAILED!\n");

//RD_EN & RD_ONLY ASSERTION
    property _rd_en_only_no_x;
        // rd_en and rd_only shouldn't be x after reset
        @(posedge clk) disable iff(~rst_n)
            (! $isunknown(rd_en)) && (! $isunknown(rd_only));
    endproperty

rd_en_only_no_x: assert property (_rd_en_only_no_x) else $error($stime,"\t\t Check rd_en and rd_only no X FAILED!\n");

//WR_ADDR ASSERTION
    property _wr_addr_no_x_wr_en_high;
        // wr_addr shouldn't be x after wr_en sets high
        @(posedge clk) wr_en |-> not ($isunknown(wr_addr));
    endproperty

    property _wr_addr_inc_when_push;
        // wr_addr should increase when FIFO push data
        logic[ADDR - 1:0] addr;
        @(posedge clk) (wr_en && fifo_status != 3'd5, addr=wr_addr) |=> (wr_addr == (addr + 1'b1));
    endproperty

    property _wr_addr_stable_when_full;
        // wr_addr should be stable when FIFO full
        logic[ADDR - 1:0] addr;
        @(posedge clk) (wr_en && fifo_status == 3'd5, addr=wr_addr) |=> (wr_addr == addr);
    endproperty

    property _wr_addr_stable_wr_en_low;
        // wr_addr should be stable when wr_en low
        @(posedge clk) disable iff(~rst_n)
            (!wr_en && !$fell(wr_en)) |-> $stable(wr_addr);
    endproperty

wr_addr_no_x_wr_en_high: assert property(_wr_addr_no_x_wr_en_high) else $error($stime,"\t\t Check wr_addr no X FAILED!\n");
wr_addr_inc_when_push: assert property(_wr_addr_inc_when_push) else $error($stime,"\t\t Check wr_addr increase when FIFO push data FAILED!\n");
wr_addr_stable_when_full: assert property(_wr_addr_stable_when_full) else $error($stime,"\t\t Check wr_addr stable when FIFO full FAILED!\n");
wr_addr_stable_wr_en_low: assert property(_wr_addr_stable_wr_en_low) else $error($stime,"\t\t Check wr_addr stable when wr_en low FAILED!\n");

//RD_ADDR ASSERTION
    property _rd_addr_no_x_rd_en_high;
        // rd_addr shouldn't be x after rd_en sets high
        @(posedge clk) $rose(rd_en) |-> not ($isunknown(rd_addr));
    endproperty

    property _rd_addr_inc_when_pop;
        // rd_addr should increase when FIFO pop data
        logic[ADDR - 1:0] addr;
        @(posedge clk) ($rose(rd_en) && fifo_status != 3'd0 && !rd_only, addr=rd_addr) |=> (rd_addr == (addr + 1'b1));
    endproperty

    property _rd_addr_stable_when_empty;
        // rd_addr should be stable when FIFO empty
        logic[ADDR - 1:0] addr;
        @(posedge clk) ($rose(rd_en) && fifo_status == 3'd0, addr=rd_addr) |=> (rd_addr == addr);
    endproperty

    property _rd_addr_stable_when_rdonly;
        // rd_addr should be stable when FIFO read only
        logic[ADDR - 1:0] addr;
        @(posedge clk) ($rose(rd_en) && rd_only, addr=rd_addr) |=> (rd_addr == addr);
    endproperty

    property _rd_addr_stable_rd_en_low;
        // rd_addr should be stable when rd_en low
        @(posedge clk) disable iff(~rst_n)
            (!rd_en && !$fell(rd_en)) |-> $stable(rd_addr);
    endproperty

rd_addr_no_x_rd_en_high: assert property(_rd_addr_no_x_rd_en_high) else $error($stime,"\t\t Check rd_addr no X FAILED!\n");
rd_addr_inc_when_pop: assert property(_rd_addr_inc_when_pop) else $error($stime,"\t\t Check rd_addr increase when FIFO pop data FAILED!\n");
rd_addr_stable_when_empty: assert property(_rd_addr_stable_when_empty) else $error($stime,"\t\t Check rd_addr stable when FIFO empty FAILED!\n");
rd_addr_stable_when_rdonly: assert property(_rd_addr_stable_when_rdonly) else $error($stime,"\t\t Check rd_addr stable when FIFO read only FAILED!\n");
rd_addr_stable_rd_en_low: assert property(_rd_addr_stable_rd_en_low) else $error($stime,"\t\t Check rd_addr stable when rd_en low FAILED!\n");

//FIFO_STATUS ASSERTION
    property _fifo_status_no_x;
        // fifo_status shouldn't be x after reset
        @(posedge clk) disable iff(~rst_n)
            not $isunknown(fifo_status);
    endproperty

    property _fifo_status_valid;
        // fifo_status keep in the valid range
        @(posedge clk)  disable iff(~rst_n)
            (fifo_status <= 3'd5);
    endproperty

    property _fifo_status_inc;
        // fifo_status should increase from 0 to 1 when FIFO only push data
        @(posedge clk) ($rose(wr_en) && fifo_status == 3'd0 && !(rd_en && !rd_only)) |=> (fifo_status == 3'd1);
    endproperty

    property _fifo_status_dec;
        // fifo_status should decrease from 5 to 4 when FIFO only pop data
        @(posedge clk) ($rose(rd_en) && fifo_status == 3'd5 && !rd_only && !wr_en) |=> (fifo_status == 3'd4);
    endproperty

    property _fifo_status_stable_idle;
        // fifo_status should be stable when no push and pop request
        @(posedge clk) disable iff(~rst_n)
            (!(rd_en || wr_en) && !$fell(rd_en || wr_en)) |-> $stable(fifo_status);
    endproperty

    property _fifo_status_stable_io;
        // fifo_status should be stable when no FIFO both push and pop
        @(posedge clk) ($rose(rd_en) && !rd_only) |-> ($rose(wr_en)) |=> $stable(fifo_status);
    endproperty

fifo_status_no_x: assert property(_fifo_status_no_x) else $error($stime,"\t\t Check fifo_status no X FAILED!\n");
fifo_status_valid: assert property(_fifo_status_valid) else $error($stime,"\t\t Check fifo_status valid FAILED!\n");
fifo_status_inc: assert property(_fifo_status_inc) else $error($stime,"\t\t Check fifo_status increase FAILED!\n");
fifo_status_dec: assert property(_fifo_status_dec) else $error($stime,"\t\t Check fifo_status decrease FAILED!\n");
fifo_status_stable_idle: assert property(_fifo_status_stable_idle) else $error($stime,"\t\t Check fifo_status stable when idle FAILED!\n");
fifo_status_stable_io: assert property(_fifo_status_stable_io) else $error($stime,"\t\t Check fifo_status when both push and pop FAILED!\n");
endmodule
