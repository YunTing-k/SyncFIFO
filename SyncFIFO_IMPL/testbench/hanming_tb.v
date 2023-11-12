//+FHDR//////////////////////////////////////////////////////////////////////////////
// Company: Shanghai Jiao Tong University
// Engineer: Yu Huang
//
// Create Date: 2023.11.12
// Design Name: SyncFIFO
// Module Name: hanming_tb
// Target Device: N/A
// Tool versions: QuestaSim 10.6c
// Description: 
// Testbench of the hanming code.s
// verify the following properties:
//     [1]: Hanming encode and decode without error
//     [2]: Hanming encode and decode with error
// Dependencies:
// data_encode.v data_decode.v ptr_encode.v ptr_decode.v
//
// Revision:
// ---------------------------------------------------------------------------------
// [Date]         [By]         [Version]         [Change Log]
// ---------------------------------------------------------------------------------
// 2023/11/12     Yu Huang     1.0               First implmentation
// ---------------------------------------------------------------------------------
//
//-FHDR//////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`define FIFO_BASE_ADDR    32'h2000_0000                // base addr of FIFO device
`define FIFO_WRITE_DATA   (`FIFO_BASE_ADDR + 32'h00)   // FIFO write data (read/write)
`define FIFO_STATUS       (`FIFO_BASE_ADDR + 32'h04)   // FIFO status (read)s
`define FIFO_OUT_DATA       8'd0                       // FIFO output data (read)
`define DATA_ERR_IDX        8'd1                       // FIFO data error index (read)
`define WRITE_PTR           8'd2                       // FIFO write pointer (read)
`define WRITE_PTR_ERR_IDX   8'd3                       // FIFO write pointer error index (read)
`define READ_PTR            8'd4                       // FIFO read pointer (read)
`define READ_PTR_ERR_IDX    8'd5                       // FIFO read pointer error index (read)

module hanming_tb();

//-----------------------parameter define-----------------------//
parameter PERIOD  = 2;   // clock period

//--------------------------reg define--------------------------//
reg clk;
reg rst_n;
reg [32 - 1:0] data_raw;
reg [10 - 1:0] ptr_raw;
reg [38 - 1:0] data_temp;
reg [14 - 1:0] ptr_temp;

//-------------------------wire define----------------- --------//
wire [38 - 1:0] data_encoded;
wire [32 - 1:0] data_decoded;
wire [6 - 1:0] data_err_idx;
wire [14 - 1:0] ptr_encoded;
wire [10 - 1:0] ptr_decoded;
wire [4 - 1:0] ptr_err_idx;

//-----------------------instance define------------------------//
data_encode data_encode_inst
(
    .raw_data(data_raw),             // input raw data to be encoded
    .enc_data(data_encoded)                // output data after encoding
);

data_decode data_decode_inst
(
    .enc_data(data_encoded),               // input encoded data
    .out_data(data_decoded),               // output decoded data
    .err_index(data_err_idx)               // error index, 0:no error detected, else:error detected
                                           // error take place in index = err_index - 1
);

ptr_encode ptr_encode_inst
(
    .raw_data(ptr_raw),                     // input raw data to be encoded
    .enc_data(ptr_encoded)              // output data after encoding
);

ptr_decode ptr_decode_inst
(
    .enc_data(ptr_encoded),             // input encoded data
    .out_data(ptr_decoded),             // output decoded data
    .err_index(ptr_err_idx)             // error index, 0:no error detected, else:error detected
                                           // error take place in index = err_index - 1
);
//---------------------inital block define----------------------//
initial begin
    clk = 1'b0;
    rst_n = 1'b0;
    data_raw = 32'd0;
    ptr_raw = 10'd0;
    data_temp = 38'd0;
    ptr_temp = 14'd0;
    #(5);
    rst_n = 1'b1;
    data_decode(32'h0000_FFFF, 0, 0);
    data_decode(32'hFF00_00FF, 4 - 1, 1);
    data_decode(32'hFF00_00FF, 38 - 1, 1);
    data_decode(32'hFF00_00FF, 12 - 1, 1);

    ptr_decode(10'b1110000011, 0, 0);
    ptr_decode(10'b1110000011, 1 - 1, 1);
    ptr_decode(10'b1110000011, 5 - 1, 1);
    ptr_decode(10'b1110000011, 10 - 1, 1);
    $stop;
end

//-----------------------[clock generate]-----------------------//
always #(PERIOD/2) clk = ~clk;

// [DATA]
task data_decode;
    input [31:0] data;
    input [5:0] flip;
    input err;

begin
    // decode stage
    @(posedge clk)
        data_raw = data;
    // error stage
    @(posedge clk)
        if (err == 1'b1) begin
            data_temp = data_encoded;
            data_temp[flip] = !data_temp[flip];
            force data_decode_inst.enc_data = data_temp;
        end
    // release stage
    @(posedge clk)
        release data_decode_inst.enc_data;
end
endtask

// [POINTER]
task ptr_decode;
    input [9:0] data;
    input [3:0] flip;
    input err;

begin
    // decode stage
    @(posedge clk)
        ptr_raw = data;
    // error stage
    @(posedge clk)
        if (err == 1'b1) begin
            ptr_temp = ptr_encoded;
            ptr_temp[flip] = !ptr_temp[flip];
            force ptr_decode_inst.enc_data = ptr_temp;
        end
    // release stage
    @(posedge clk)
        release ptr_decode_inst.enc_data;
end
endtask

endmodule