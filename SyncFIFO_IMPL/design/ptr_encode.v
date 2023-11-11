//+FHDR//////////////////////////////////////////////////////////////////////////////
// Company: Shanghai Jiao Tong University
// Engineer: Yu Huang
//
// Create Date: 2023.11.03
// Design Name: SyncFIFO
// Module Name: ptr_encode
// Target Device: N/A
// Tool versions: QuestaSim 10.6c
// Description: 
// Encode the write/read pointer of the fifo, raw data's bit length is 10, so the 
// redundancy code's bit lenght is 4 with (2^4 >= 10 + 4 + 1), even check
// Dependencies:
// N/A
//
// Revision:
// ---------------------------------------------------------------------------------
// [Date]         [By]         [Version]         [Change Log]
// ---------------------------------------------------------------------------------
// 2023/11/03     Yu Huang     1.0               First implmentation
// ---------------------------------------------------------------------------------
//
//-FHDR//////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module ptr_encode
(
    input  [9:0] raw_data,        // input raw data to be encoded
    output [13:0] enc_data        // output data after encoding
);
// data parity flag
wire parity_0;
wire parity_1;
wire parity_2;
wire parity_3;

// data parity flag gen
assign parity_0 = (raw_data[0] + raw_data[1]) + (raw_data[3] + raw_data[4]) + (raw_data[6] + raw_data[8]); // raw 0 1 3 4 6 8 ==> redundancy bit 0
assign parity_1 = (raw_data[0] + raw_data[2]) + (raw_data[3] + raw_data[5]) + (raw_data[6] + raw_data[9]); // raw 0 2 3 5 6 9 ==> redundancy bit 1
assign parity_2 = (raw_data[1] + raw_data[2]) + (raw_data[3] + raw_data[7]) + (raw_data[8] + raw_data[9]); // raw 1 2 3 7 8 9 ==> redundancy bit 2
assign parity_3 = (raw_data[4] + raw_data[5]) + (raw_data[6] + raw_data[7]) + (raw_data[8] + raw_data[9]); // raw 4 5 6 7 8 9 ==> redundancy bit 3

// redundacy bit gen with even check
assign enc_data[0] = parity_0;
assign enc_data[1] = parity_1;
assign enc_data[3] = parity_2;
assign enc_data[7] = parity_3;

// orignal data remap [out]2 4 5 6 8 9 10 11 12 13 <==> 0 1 2 3 4 5 6 7 8 9[in]
assign enc_data[2] = raw_data[0];
assign enc_data[6:4] = raw_data[3:1];
assign enc_data[13:8] = raw_data[9:4];

endmodule
