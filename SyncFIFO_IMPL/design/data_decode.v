//+FHDR//////////////////////////////////////////////////////////////////////////////
// Company: Shanghai Jiao Tong University
// Engineer: Yu Huang
//
// Create Date: 2023.11.06
// Design Name: SyncFIFO
// Module Name: data_decode
// Target Device: N/A
// Tool versions: QuestaSim 10.6c
// Description: 
// Decode the write data of the fifo, raw data's bit length is 32, so the 
// redundancy code's bit lenght is 6 with (2^6 >= 32 + 6 + 1), even check
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
module data_decode
(
    input  [37:0] enc_data,        // input encoded data
    output [31:0] out_data,        // output decoded data
    output [5:0] err_index         // error index, 0:no error detected, else:error detected
                                   // error take place in index = err_index - 1
);
// data parity flag
wire parity_0;
wire parity_1;
wire parity_2;
wire parity_3;
wire parity_4;
wire parity_5;

// enc_data [0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36] ==> group1 parity
assign parity_0 = (enc_data[0] + enc_data[2]) + (enc_data[4] + enc_data[6]) + (enc_data[8] + enc_data[10]) +
                  (enc_data[12] + enc_data[14]) + (enc_data[16] + enc_data[18]) + (enc_data[20] + enc_data[22]) +
                  (enc_data[24] + enc_data[26]) + (enc_data[28] + enc_data[30]) + (enc_data[32] + enc_data[34]) + enc_data[36];
// enc_data [1,2,5,6,9,10,13,14,17,18,21,22,25,26,29,30,33,34,37] ==> group2 parity
assign parity_1 = (enc_data[1] + enc_data[2]) + (enc_data[5] + enc_data[6]) + (enc_data[9] + enc_data[10]) +
                  (enc_data[13] + enc_data[14]) + (enc_data[17] + enc_data[18]) + (enc_data[21] + enc_data[22]) +
                  (enc_data[25] + enc_data[26]) + (enc_data[29] + enc_data[30]) + (enc_data[33] + enc_data[34]) + enc_data[37];
// enc_data [3,4,5,6,11,12,13,14,19,20,21,22,27,28,29,30,35,36,37] ==> group3 parity
assign parity_2 = (enc_data[3] + enc_data[4]) + (enc_data[5] + enc_data[6]) + (enc_data[11] + enc_data[12]) +
                  (enc_data[13] + enc_data[14]) + (enc_data[19] + enc_data[20]) + (enc_data[21] + enc_data[22]) +
                  (enc_data[27] + enc_data[28]) + (enc_data[29] + enc_data[30]) + (enc_data[35] + enc_data[36]) + enc_data[37];
// enc_data [7,8,9,10,11,12,13,14,23,24,25,26,27,28,29,30] ==> group4 parity
assign parity_3 = (enc_data[7] + enc_data[8]) + (enc_data[9] + enc_data[10]) + (enc_data[11] + enc_data[12]) +
                  (enc_data[13] + enc_data[14]) + (enc_data[23] + enc_data[24]) + (enc_data[25] + enc_data[26]) +
                  (enc_data[27] + enc_data[28]) + (enc_data[29] + enc_data[30]);
// enc_data [15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30] ==> group5 parity
assign parity_4 = (enc_data[15] + enc_data[16]) + (enc_data[17] + enc_data[18]) + (enc_data[19] + enc_data[20]) +
                  (enc_data[21] + enc_data[22]) + (enc_data[23] + enc_data[24]) + (enc_data[25] + enc_data[26]) +
                  (enc_data[27] + enc_data[28]) + (enc_data[29] + enc_data[30]);
// enc_data [31,32,33,34,35,36,37] ==> group5 parity
assign parity_5 = (enc_data[31] + enc_data[32]) + (enc_data[33] + enc_data[34]) + (enc_data[35] + enc_data[36]) +
                   enc_data[37];

// error bit index in enc_data
assign err_index = {parity_5, parity_4, parity_3, parity_2, parity_1, parity_0};

// orignal data remap and correct, [in][2,4,5,6,8,9,10,11,12,13,14,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,32,33,34,35,36,37] <==> 0:31[out]
// only when index == [3,5,6,7,9,10,11,12,13,14,15,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,33,34,35,36,37,38], does the output need correction
assign out_data[0] = (err_index == 6'd3) ? !enc_data[2] : enc_data[2];
assign out_data[1] = (err_index == 6'd5) ? !enc_data[4] : enc_data[4];
assign out_data[2] = (err_index == 6'd6) ? !enc_data[5] : enc_data[5];
assign out_data[3] = (err_index == 6'd7) ? !enc_data[6] : enc_data[6];
assign out_data[4] = (err_index == 6'd9) ? !enc_data[8] : enc_data[8];
assign out_data[5] = (err_index == 6'd10) ? !enc_data[9] : enc_data[9];
assign out_data[6] = (err_index == 6'd11) ? !enc_data[10] : enc_data[10];
assign out_data[7] = (err_index == 6'd12) ? !enc_data[11] : enc_data[11];
assign out_data[8] = (err_index == 6'd13) ? !enc_data[12] : enc_data[12];
assign out_data[9] = (err_index == 6'd14) ? !enc_data[13] : enc_data[13];
assign out_data[10] = (err_index == 6'd15) ? !enc_data[14] : enc_data[14];
assign out_data[11] = (err_index == 6'd17) ? !enc_data[16] : enc_data[16];
assign out_data[12] = (err_index == 6'd18) ? !enc_data[17] : enc_data[17];
assign out_data[13] = (err_index == 6'd19) ? !enc_data[18] : enc_data[18];
assign out_data[14] = (err_index == 6'd20) ? !enc_data[19] : enc_data[19];
assign out_data[15] = (err_index == 6'd21) ? !enc_data[20] : enc_data[20];
assign out_data[16] = (err_index == 6'd22) ? !enc_data[21] : enc_data[21];
assign out_data[17] = (err_index == 6'd23) ? !enc_data[22] : enc_data[22];
assign out_data[18] = (err_index == 6'd24) ? !enc_data[23] : enc_data[23];
assign out_data[19] = (err_index == 6'd25) ? !enc_data[24] : enc_data[24];
assign out_data[20] = (err_index == 6'd26) ? !enc_data[25] : enc_data[25];
assign out_data[21] = (err_index == 6'd27) ? !enc_data[26] : enc_data[26];
assign out_data[22] = (err_index == 6'd28) ? !enc_data[27] : enc_data[27];
assign out_data[23] = (err_index == 6'd29) ? !enc_data[28] : enc_data[28];
assign out_data[24] = (err_index == 6'd30) ? !enc_data[29] : enc_data[29];
assign out_data[25] = (err_index == 6'd31) ? !enc_data[30] : enc_data[30];
assign out_data[26] = (err_index == 6'd33) ? !enc_data[32] : enc_data[32];
assign out_data[27] = (err_index == 6'd34) ? !enc_data[33] : enc_data[33];
assign out_data[28] = (err_index == 6'd35) ? !enc_data[34] : enc_data[34];
assign out_data[29] = (err_index == 6'd36) ? !enc_data[35] : enc_data[35];
assign out_data[30] = (err_index == 6'd37) ? !enc_data[36] : enc_data[36];
assign out_data[31] = (err_index == 6'd38) ? !enc_data[37] : enc_data[37];

endmodule
