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
// Assertion of the DUT, including assertions of APB, Arbiter, FIFO
// Dependencies:
// N/A
//
// Revision:
// ---------------------------------------------------------------------------------
// [Date]         [By]         [Version]         [Change Log]
// ---------------------------------------------------------------------------------
// 2023/12/07     Yu Huang     1.0               First implmentation
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
// [1]: valid-ready handshake check
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
    property _ch_handshake_check;
        @(posedge clk) $rose(valid) |-> ##[1:$] (valid && ready);
    endproperty
    ch_handshake_check: assert property (_ch_handshake_check) else $error($time, "\t\t Valid-Ready handshake of read channel FAILED!\n");
endmodule

// ---------------------------------------------------------------------------------
// APB slave assertion defination, assertion properties:
// ---------------------------------------------------------------------------------
// [1]: 
// ---------------------------------------------------------------------------------
module apb_assertion(
    input clk,
    input rst_n,
    input pwrite,       // APB write signal
    input psel,         // APB select signal
    input [31:0] paddr, // APB address data
    input [31:0] pwdata,// APB write data
    input penable,      // APB enable data
    input [31:0] prdata,// APB read out data
    input pready        // APB ready signal
);
//PADDR ASSERTION
    property _paddr_no_x_psel_high;
        // after psel set high, paddr shouldn't be X
        @(posedge clk)  psel |-> not ($isunknown(paddr));
    endproperty

    property _paddr_valid;
        // after psel set high, paddr shouldn't be out of access range
        @(posedge clk)  psel |-> ((paddr == `FIFO_WRITE_DATA) || (paddr == `FIFO_STATUS));
    endproperty

    property _paddr_stable_in_trans;
        // paddr should be stable when APB slave in SETUP state
	    @(posedge clk) (psel && penable) |-> $stable(paddr);
    endproperty

    property _paddr_stable_until_next_trans;
        // paddr should be stable until next transmission
        logic[31:0] addr1, addr2;
        @(posedge clk) first_match(($rose(penable),addr1=paddr) ##[1:$] ((psel && !penable),addr2=$past(paddr))) |-> addr1 == addr2;
    endproperty

paddr_no_x: assert property (_paddr_no_x_psel_high) else $error($stime,"\t\t Check paddr no X FAILED!\n");
paddr_valid:assert property (_paddr_valid) else $error($stime,"\t\t Check paddr valid FAILED!\n");
paddr_stable_in_trans: assert property(_paddr_stable_in_trans) else $error($stime,"\t\t Check paddr stable in transmission FAILED!\n");
paddr_stable_until_next_trans: assert property(_paddr_stable_until_next_trans) else $error($stime,"\t\t Check paddr stable before next transmission FAILED!\n");

//PENABLE ASSERTION
    property _penable_rise;
        // after psel rises, penable must rose in next cycle
        @(posedge clk) $rose(psel) |=> $rose(penable);
    endproperty

    property _penable_stable;
        // when pready dosen't rise, penable should be stable after it rises
        @(posedge clk) (!pready && penable && !$rose(penable)) |-> $stable(penable);
    endproperty

    property _penable_instant_fall;
        // penable must fall one cycle after it rises
        @(posedge clk) (penable && pready) |=> $fell(penable);
    endproperty

penable_rise: assert property (_penable_rise) else $error($stime,"\t\t Check penable rise after psel rises FAILED!\n");
penable_stable:assert property (_penable_stable) else $error($stime,"\t\t Check penable stable before pready rises FAILED!\n");
penable_instant_fall:assert property (_penable_instant_fall) else $error($stime,"\t\t Check penable falls one cycle after it rises FAILED!\n");

//PSEL ASSERTION
    property _psel_stable;
        // psel must be stable until the pready rises
        @(posedge clk) (!pready && psel && !$rose(psel)) |-> $stable(psel);
    endproperty

psel_stable: assert property(_psel_stable) else $error($stime,"\t\t Check psel stable until pready rises FAILED!\n");

//PWDATA ASSERTION
    property _pwdata_stable_in_trans;
        // when before access, pwdata should be stable
        @(posedge clk) (psel && penable) |-> $stable(pwdata);
    endproperty

    property _pwdata_stable_until_next_trans;
        // pwdata should be stable until the next trans
        logic[31:0] data1, data2;
        @(posedge clk) first_match(($rose(psel),data1=pwdata) ##[1:$] ((psel && !penable),data2=$past(pwdata))) |-> data1 == data2;
    endproperty

pwdata_stable_in_trans: assert property(_pwdata_stable_in_trans) else $error($stime,"\t\t Check pwdata stable in this transmission FAILED!\n");
pwdata_stable_until_next_trans: assert property(_pwdata_stable_until_next_trans) else $error($stime,"\t\t Check pwdata stable until next transmission FAILED!\n");

//PWRITE ASSERTION
    property _pwrite_stable;
        // pwrite must be stable until the pready rises
        @(posedge clk) (!pready && psel && !$rose(pwrite)) |-> $stable(pwrite);
    endproperty

pwrite_stable: assert property(_pwrite_stable) else $error($stime,"\t\t Check pwrite stable FAILED!\n");

//PRDATA ASSERTION
    property _prdata_stable_until_next_trans;
        // prdata must be stable until the next transmission
        logic[31:0] data1, data2;
        @(posedge clk) first_match(($rose(pready) && !pwrite, data1=prdata) ##[1:$] ((psel && !penable),data2=$past(prdata))) |-> data1 == data2;
    endproperty

prdata_stable_until_next_trans: assert property(_prdata_stable_until_next_trans) else $error($stime,"\t\t Check prdata stable until next transmission FAILED!\n");

//PREADY ASSERTION
    property _pready_fall_with_psel;
        // pready must fall with psel
        @(posedge clk) ($fell(pready) && rst_n == 1'b1) |-> $fell(psel)
    endproperty

    property _pready_fall_with_penable;
        // pready must fall with penable
        @(posedge clk) ($fell(pready) && rst_n == 1'b1) |-> $fell(penable)
    endproperty

pready_fall_with_psel: assert property(_pready_fall_with_psel) else $error($stime,"\t\t Check pready falls with psel FAILED!\n");
pready_fall_with_penable: assert property(_pready_fall_with_penable) else $error($stime,"\t\t Check pready falls with penable FAILED!\n");
endmodule

// ---------------------------------------------------------------------------------
// FIFO assertion defination, assertion properties:
// ---------------------------------------------------------------------------------
// [1]: 
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
    property _rd_addr_stable_empty;
        logic[ADDR - 1:0] addr1, addr2;
        @(posedge clk) (($rose(rd_en) && fifo_status == 3'd0), addr1=rd_addr) ##1 (rd_en == 1'b0, addr2=rd_addr) |-> addr1 == addr2;
    endproperty

rd_addr_stable_empty: assert property (_rd_addr_stable_empty) else $error($stime,"\t\t FAIL::rd_addr_stable_empty\n");
endmodule