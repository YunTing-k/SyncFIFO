//+FHDR//////////////////////////////////////////////////////////////////////////////
// Company: Shanghai Jiao Tong University
// Engineer: Yu Huang
//
// Create Date: 2023.11.06
// Design Name: SyncFIFO
// Module Name: data_encode
// Target Device: N/A
// Tool versions: QuestaSim 10.6c
// Description: 
// Encode the write data of the fifo, raw data's bit length is 32, so the 
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
module data_encode
(
    input  [31:0] raw_data,        // input raw data to be encoded
    output [37:0] enc_data         // output data after encoding
);
// data parity flag
wire parity_0;
wire parity_1;
wire parity_2;
wire parity_3;
wire parity_4;
wire parity_5;

// raw [0,1,3,4,6,8,10,11,13,15,17,19,21,23,25,26,28,30] ==> redundancy bit 0
assign parity_0 = (raw_data[0] + raw_data[1]) + (raw_data[3] + raw_data[4]) + (raw_data[6] + raw_data[8]) +
                  (raw_data[10] + raw_data[11]) + (raw_data[13] + raw_data[15]) + (raw_data[17] + raw_data[19]) +
                  (raw_data[21] + raw_data[23]) + (raw_data[25] + raw_data[26]) + (raw_data[28] + raw_data[30]);
// raw [0,2,3,5,6,9,10,12,13,16,17,20,21,24,25,27,28,31] ==> redundancy bit 1
assign parity_1 = (raw_data[0] + raw_data[2]) + (raw_data[3] + raw_data[5]) + (raw_data[6] + raw_data[9]) +
                  (raw_data[10] + raw_data[12]) + (raw_data[13] + raw_data[16]) + (raw_data[17] + raw_data[20]) +
                  (raw_data[21] + raw_data[24]) + (raw_data[25] + raw_data[27]) + (raw_data[28] + raw_data[31]);
// raw [1,2,3,7,8,9,10,14,15,16,17,22,23,24,25,29,30,31] ==> redundancy bit 2
assign parity_2 = (raw_data[1] + raw_data[2]) + (raw_data[3] + raw_data[7]) + (raw_data[8] + raw_data[9]) +
                  (raw_data[10] + raw_data[14]) + (raw_data[15] + raw_data[16]) + (raw_data[17] + raw_data[22]) +
                  (raw_data[23] + raw_data[24]) + (raw_data[25] + raw_data[29]) + (raw_data[30] + raw_data[31]);
// raw [4,5,6,7,8,9,10,18,19,20,21,22,23,24,25] ==> redundancy bit 3
assign parity_3 = (raw_data[4] + raw_data[5]) + (raw_data[6] + raw_data[7]) + (raw_data[8] + raw_data[9]) +
                  (raw_data[10] + raw_data[18]) + (raw_data[19] + raw_data[20]) + (raw_data[21] + raw_data[22]) +
                  (raw_data[23] + raw_data[24]) + raw_data[25];
// raw [11,12,13,14,15,16,17,18,19,20,21,22,23,24,25] ==> redundancy bit 4
assign parity_4 = (raw_data[11] + raw_data[12]) + (raw_data[13] + raw_data[14]) + (raw_data[15] + raw_data[16]) +
                  (raw_data[17] + raw_data[18]) + (raw_data[19] + raw_data[20]) + (raw_data[21] + raw_data[22]) +
                  (raw_data[23] + raw_data[24]) + raw_data[25];
// raw [26 27 28 29 30 31] ==> redundancy bit 5
assign parity_5 = (raw_data[26] + raw_data[27]) + (raw_data[28] + raw_data[29]) + (raw_data[30] + raw_data[31]);

// redundacy bit gen with even check
assign enc_data[0] = parity_0;
assign enc_data[1] = parity_1;
assign enc_data[3] = parity_2;
assign enc_data[7] = parity_3;
assign enc_data[15] = parity_3;
assign enc_data[31] = parity_3;

// orignal data remap [out][2,4:6,8:14,16:30,32:37] <==> 0:31[in]
assign enc_data[2] = raw_data[0];
assign enc_data[6:4] = raw_data[3:1];
assign enc_data[14:8] = raw_data[10:4];
assign enc_data[30:16] = raw_data[25:11];
assign enc_data[37:32] = raw_data[31:26];

endmodule
