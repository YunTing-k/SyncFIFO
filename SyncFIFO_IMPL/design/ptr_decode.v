//+FHDR//////////////////////////////////////////////////////////////////////////////
// Company: Shanghai Jiao Tong University
// Engineer: Yu Huang
//
// Create Date: 2023.11.06
// Design Name: SyncFIFO
// Module Name: ptr_decode
// Target Device: N/A
// Tool versions: QuestaSim 10.6c
// Description: 
// Decode the write/read pointer of the fifo, raw data's bit length is 10, so the 
// redundancy code's bit lenght is 4 with (2^4 >= 10 + 4 + 1), even check
// Dependencies:
// N/A
//
// Revision:
// ---------------------------------------------------------------------------------
// [Date]         [By]         [Version]         [Change Log]
// ---------------------------------------------------------------------------------
// 2023/11/06     Yu Huang     1.0               First implmentation
// ---------------------------------------------------------------------------------
//
//-FHDR//////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module ptr_decode
(
    input  [13:0] enc_data,        // input encoded data
    output [9:0] out_data,         // output decoded data
    output [3:0] err_index         // error index, 0:no error detected, else:error detected
                                   // error take place in index = err_index - 1
);
// data parity flag
wire parity_0;
wire parity_1;
wire parity_2;
wire parity_3;

// enc_data 0 2 4 6 8 10 12 ==> group1 parity
assign parity_0 = (enc_data[0] + enc_data[2]) + (enc_data[4] + enc_data[6]) + (enc_data[8] + enc_data[10] + enc_data[12]);
// enc_data 1 2 5 6 9 10 13 ==> group2 parity
assign parity_1 = (enc_data[1] + enc_data[2]) + (enc_data[5] + enc_data[6]) + (enc_data[9] + enc_data[10] + enc_data[13]);
// enc_data 3 4 5 6 11 12 13 ==> group3 parity
assign parity_2 = (enc_data[3] + enc_data[4]) + (enc_data[5] + enc_data[6]) + (enc_data[11] + enc_data[12] + enc_data[13]);
// enc_data 7 8 9 10 11 12 13 ==> group4 parity
assign parity_3 = (enc_data[7] + enc_data[8]) + (enc_data[9] + enc_data[10]) + (enc_data[11] + enc_data[12] + enc_data[13]);

// error bit index in enc_data
assign err_index = {parity_3, parity_2, parity_1, parity_0};

// orignal data remap and correct, [in]2 4 5 6 8 9 10 11 12 13 <==> 0 1 2 3 4 5 6 7 8 9[out]
// only when index == 3 5 6 7 9 10 11 12 13 14, does the output need correction
assign out_data[0] = (err_index == 4'd3) ? !enc_data[2] : enc_data[2];
assign out_data[1] = (err_index == 4'd5) ? !enc_data[4] : enc_data[4];
assign out_data[2] = (err_index == 4'd6) ? !enc_data[5] : enc_data[5];
assign out_data[3] = (err_index == 4'd7) ? !enc_data[6] : enc_data[6];
assign out_data[4] = (err_index == 4'd9) ? !enc_data[8] : enc_data[8];
assign out_data[5] = (err_index == 4'd10) ? !enc_data[9] : enc_data[9];
assign out_data[6] = (err_index == 4'd11) ? !enc_data[10] : enc_data[10];
assign out_data[7] = (err_index == 4'd12) ? !enc_data[11] : enc_data[11];
assign out_data[8] = (err_index == 4'd13) ? !enc_data[12] : enc_data[12];
assign out_data[9] = (err_index == 4'd14) ? !enc_data[13] : enc_data[13];

endmodule
