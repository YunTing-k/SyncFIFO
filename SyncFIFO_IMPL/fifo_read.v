//+FHDR//////////////////////////////////////////////////////////////////////////////
// Company: Shanghai Jiao Tong University
// Engineer: Yu Huang
//
// Create Date: 2023.11.10
// Design Name: SyncFIFO
// Module Name: fifo_read
// Target Device: N/A
// Tool versions: QuestaSim 10.6c
// Description: 
// FIFO read control signal generation according to channels' signal
// Dependencies:
// N/A
//
// Revision:
// ---------------------------------------------------------------------------------
// [Date]         [By]         [Version]         [Change Log]
// ---------------------------------------------------------------------------------
// 2023/11/10     Yu Huang     1.0               First implmentation
// ---------------------------------------------------------------------------------
//
//-FHDR//////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module fifo_read
(
    input  rd_en0,                        // read enable channel0
    input  rd_only0,                      // read only channel0
    input  rd_en1,                        // read enable channel1
    input  rd_only1,                      // read only channel1
    input  rd_en2,                        // read enable channel2
    input  rd_only2,                      // read only channel2
    input  rd_en3,                        // read enable channel3
    input  rd_only3,                      // read only channel3
    input  rd_en4,                        // read enable channel4
    input  rd_only4,                      // read only channel4
    input  rd_en5,                        // read enable channel5
    input  rd_only5,                      // read only channel5
    input  rd_en6,                        // read enable channel6
    input  rd_only6,                      // read only channel6
    input  rd_en7,                        // read enable channel7
    input  rd_only7,                      // read only channel7
    input  [7:0] select,                  // select signal
    output reg rd_en,                     // read enable signal
    output reg rd_only                    // read only signal
);
// fifo read signal mux
always @(*) begin
    case(select)
    8'b0000_0001:
    begin
        rd_en = rd_en0;
        rd_only = rd_only0;
    end
    8'b0000_0010:
    begin
        rd_en = rd_en1;
        rd_only = rd_only1;
    end
    8'b0000_0100:
    begin
        rd_en = rd_en2;
        rd_only = rd_only2;
    end
    8'b0000_1000:
    begin
        rd_en = rd_en3;
        rd_only = rd_only3;
    end
    8'b0001_0000:
    begin
        rd_en = rd_en4;
        rd_only = rd_only4;
    end
    8'b0010_0000:
    begin
        rd_en = rd_en5;
        rd_only = rd_only5;
    end
    8'b0100_0000:
    begin
        rd_en = rd_en6;
        rd_only = rd_only6;
    end
    8'b1000_0000:
    begin
        rd_en = rd_en7;
        rd_only = rd_only7;
    end
    default:
    begin
        rd_en = rd_en0;
        rd_only = rd_only0;
    end
    endcase
end
endmodule
