//+FHDR//////////////////////////////////////////////////////////////////////////////
// Company: Shanghai Jiao Tong University
// Engineer: Yu Huang
//
// Create Date: 2023.11.12
// Design Name: SyncFIFO
// Module Name: arbiter_read_tb
// Target Device: N/A
// Tool versions: QuestaSim 10.6c
// Description: 
// Testbench of the Sync FIFO with APB+Arbiter read data, from Arbiter -> FIFO -> Arbiter,
// to verify the dynamic priority readout function of arbiter read ctrl. This testbench
// verify the following properties:
//     [1]: Dynamic priority with read (POP and nPOP)
//     [2]: Dynamic priority with read and write (POP and nPOP)
//     [3]: FIFO status varies with FIFO stack volume
// Dependencies:
// top_wrapper.v
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

module arbiter_read_tb();

//-----------------------parameter define-----------------------//
parameter PERIOD  = 2;   // clock period
parameter DEPTH  = 1024; // FIFO depth
parameter METHOD = 1;    // 0: APB discrete write
                         // 1: APB continuous write
//--------------------------reg define--------------------------//
reg clk;
reg rst_n;
reg pwrite, psel, penable;
reg [31:0] paddr, pwdata;
reg [7:0] addr_dst0, addr_dst1, addr_dst2, addr_dst3, addr_dst4, addr_dst5, addr_dst6, addr_dst7;
reg [7:0] priority_dst0, priority_dst1, priority_dst2, priority_dst3, priority_dst4, priority_dst5, priority_dst6, priority_dst7;
reg valid_dst0, valid_dst1, valid_dst2, valid_dst3, valid_dst4, valid_dst5, valid_dst6, valid_dst7;

reg [10:0] write_counter;
reg [10:0] read_counter;
//-------------------------wire define----------------- --------//
wire pready;
wire [31:0] prdata;
wire [31:0] data_dst0, data_dst1, data_dst2, data_dst3, data_dst4, data_dst5, data_dst6, data_dst7;
wire ready_dst0, ready_dst1, ready_dst2, ready_dst3, ready_dst4, ready_dst5, ready_dst6, ready_dst7;


//-----------------------instance define------------------------//
top_wrapper top_wrapper_inst(
    .clk            (clk          ),  // clock
    .rst_n          (rst_n        ),  // reset signal, active low
    .pwrite         (pwrite       ),  // 1-write, 0-read
    .psel           (psel         ),  // scletion signal
    .paddr          (paddr        ),  // address bus
    .pwdata         (pwdata       ),  // the data to be written
    .penable        (penable      ),  // enable signal
    .prdata         (prdata       ),  // the data to be read
    .pready         (pready       ),  // slave ready signal
    .addr_dst0      (addr_dst0    ),
    .priority_dst0  (priority_dst0),
    .valid_dst0     (valid_dst0   ),
    .data_dst0      (data_dst0    ),
    .ready_dst0     (ready_dst0   ),
    .addr_dst1      (addr_dst1    ),
    .priority_dst1  (priority_dst1),
    .valid_dst1     (valid_dst1   ),
    .data_dst1      (data_dst1    ),
    .ready_dst1     (ready_dst1   ),
    .addr_dst2      (addr_dst2    ),
    .priority_dst2  (priority_dst2),
    .valid_dst2     (valid_dst2   ),
    .data_dst2      (data_dst2    ),
    .ready_dst2     (ready_dst2   ),
    .addr_dst3      (addr_dst3    ),
    .priority_dst3  (priority_dst3),
    .valid_dst3     (valid_dst3   ),
    .data_dst3      (data_dst3    ),
    .ready_dst3     (ready_dst3   ),
    .addr_dst4      (addr_dst4    ),
    .priority_dst4  (priority_dst4),
    .valid_dst4     (valid_dst4   ),
    .data_dst4      (data_dst4    ),
    .ready_dst4     (ready_dst4   ),
    .addr_dst5      (addr_dst5    ),
    .priority_dst5  (priority_dst5),
    .valid_dst5     (valid_dst5   ),
    .data_dst5      (data_dst5    ),
    .ready_dst5     (ready_dst5   ),
    .addr_dst6      (addr_dst6    ),
    .priority_dst6  (priority_dst6),
    .valid_dst6     (valid_dst6   ),
    .data_dst6      (data_dst6    ),
    .ready_dst6     (ready_dst6   ),
    .addr_dst7      (addr_dst7    ),
    .priority_dst7  (priority_dst7),
    .valid_dst7     (valid_dst7   ),
    .data_dst7      (data_dst7    ),
    .ready_dst7     (ready_dst7   )
);
//---------------------inital block define----------------------//
initial begin
    clk = 1'b0;
    rst_n = 1'b0;
    #(5);
    rst_n = 1'b1;
end

//-----------------------[clock generate]-----------------------//
always #(PERIOD/2) clk = ~clk;

//----------------------[APB control gen]-----------------------//
always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        write_counter <= 11'd0;
        addr_dst0 <= 8'd0;
        addr_dst1 <= 8'd0;
        addr_dst2 <= 8'd0;
        addr_dst3 <= 8'd0;
        addr_dst4 <= 8'd0;
        addr_dst5 <= 8'd0;
        addr_dst6 <= 8'd0;
        addr_dst7 <= 8'd0;
        priority_dst0 <= 8'd0;
        priority_dst1 <= 8'd0;
        priority_dst2 <= 8'd0;
        priority_dst3 <= 8'd0;
        priority_dst4 <= 8'd0;
        priority_dst5 <= 8'd0;
        priority_dst6 <= 8'd0;
        priority_dst7 <= 8'd0;
        valid_dst0 <= 1'b0;
        valid_dst1 <= 1'b0;
        valid_dst2 <= 1'b0;
        valid_dst3 <= 1'b0;
        valid_dst4 <= 1'b0;
        valid_dst5 <= 1'b0;
        valid_dst6 <= 1'b0;
        valid_dst7 <= 1'b0;
    end
    else if (METHOD == 1) begin // continuous write
        if (write_counter == 1'b0) begin
            write_counter <= write_counter + 1'b1;
            apb_task_C_start(`FIFO_WRITE_DATA, {{21{1'b0}}, write_counter}, 1'b1);
        end
        else if (write_counter < DEPTH - 1) begin
            write_counter <= write_counter + 1'b1;
            apb_task_C_busy(`FIFO_WRITE_DATA, {{21{1'b0}}, write_counter}, 1'b1);
        end
        else if (write_counter < DEPTH) begin
            write_counter <= write_counter + 1'b1;
            apb_task_C_end(`FIFO_WRITE_DATA, {{21{1'b0}}, write_counter}, 1'b1);
        end
    end
    else begin // discrete write
        if (write_counter < DEPTH) begin
            write_counter <= write_counter + 1'b1;
            apb_task_D(`FIFO_WRITE_DATA, {{21{1'b0}}, write_counter}, 1'b1);
        end
    end
end

//----------------------[Arbiter control gen]-----------------------//
always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        read_counter <= 11'd0;
    end
    else if (write_counter == DEPTH) begin // fifo full start to read from arbiter
        if (read_counter == 11'd0) begin
            read_counter <= read_counter + 11'd8;
            fork
                // all channels with same priority
                arbiter_0(`FIFO_OUT_DATA    , 8'd255);
                arbiter_1(`FIFO_OUT_DATA    , 8'd255);
                arbiter_2(`FIFO_OUT_DATA    , 8'd255);
                arbiter_3(`FIFO_OUT_DATA    , 8'd255);
                arbiter_4(`FIFO_OUT_DATA    , 8'd255);
                arbiter_5(`FIFO_OUT_DATA    , 8'd255);
                arbiter_6(`FIFO_OUT_DATA    , 8'd255);
                arbiter_7(`FIFO_OUT_DATA    , 8'd255);
            join
        end
        else if (read_counter == 11'd8) begin
            read_counter <= read_counter + 11'd8;
            fork
                // all channels with different priority
                arbiter_0(`FIFO_OUT_DATA    , 8'd248);
                arbiter_1(`FIFO_OUT_DATA    , 8'd249);
                arbiter_2(`FIFO_OUT_DATA    , 8'd250);
                arbiter_3(`FIFO_OUT_DATA    , 8'd251);
                arbiter_4(`FIFO_OUT_DATA    , 8'd252);
                arbiter_5(`FIFO_OUT_DATA    , 8'd253);
                arbiter_6(`FIFO_OUT_DATA    , 8'd254);
                arbiter_7(`FIFO_OUT_DATA    , 8'd255);
            join
        end
        else if (read_counter < DEPTH) begin
            read_counter <= read_counter + 1'b1;
            apb_task_D(`FIFO_WRITE_DATA, {{21{1'b0}}, read_counter}, 1'b1);
            fork
                // 2 write 3 read
                apb_task_D(`FIFO_WRITE_DATA, {{21{1'b0}}, read_counter}, 1'b1);
                arbiter_0(`FIFO_OUT_DATA    , 8'd248);
                arbiter_1(`FIFO_OUT_DATA    , 8'd249);
                arbiter_2(`DATA_ERR_IDX     , 8'd250);
                arbiter_3(`WRITE_PTR        , 8'd251);
                arbiter_4(`WRITE_PTR_ERR_IDX, 8'd252);
                arbiter_5(`READ_PTR         , 8'd253);
                arbiter_6(`READ_PTR_ERR_IDX , 8'd254);
                arbiter_7(`FIFO_OUT_DATA    , 8'd255);
            join
        end
        else begin
            $stop;
        end
    end
end

// [APB Slave Task Discrete]
task apb_task_D;
    input [31:0] addr;
    input [31:0] wdata;
    input rw;

begin
    // inital stage
    psel    = 1'b0 ;
    penable = 1'b0 ;
    pwrite  = 1'b0 ;
    paddr   = 32'd0;
    pwdata  = 32'd0;
    // setup stage
    @(posedge clk)
        paddr = addr;
        pwrite = rw;
        psel = 1'b1;
        pwdata = wdata;
        penable = 1'b0 ;
    // access stage
    @(posedge clk)
        penable = 1'b1;
    // return to idle
    @(negedge pready)
        psel    = 1'b0 ;
        penable = 1'b0 ;
        pwrite  = 1'b0 ;
        paddr   = 32'd0;
        pwdata  = 32'd0;
end
endtask

// [APB Slave Task Continuous]
task apb_task_C_start;
    input [31:0] addr;
    input [31:0] wdata;
    input rw;

begin
    // inital stage
    psel    = 1'b0 ;
    penable = 1'b0 ;
    pwrite  = 1'b0 ;
    paddr   = 32'd0;
    pwdata  = 32'd0;
    // setup stage
    @(posedge clk)
        paddr = addr;
        pwrite = rw;
        psel = 1'b1;
        pwdata = wdata;
        penable = 1'b0 ;
    // access stage
    @(posedge clk)
        penable = 1'b1;
end
endtask

task apb_task_C_busy;
    input [31:0] addr;
    input [31:0] wdata;
    input rw;

begin
    // setup stage
    @(negedge pready)
        psel    = 1'b1 ;
        penable = 1'b0 ;
        pwrite  = rw   ;
        paddr   = addr ;
        pwdata  = wdata;
    @(posedge clk)
        penable = 1'b1;
end
endtask

task apb_task_C_end;
    input [31:0] addr;
    input [31:0] wdata;
    input rw;

begin
    // setup stage
    @(negedge pready)
        psel    = 1'b1 ;
        penable = 1'b0 ;
        pwrite  = rw   ;
        paddr   = addr ;
        pwdata  = wdata;
    // access stage
    @(posedge clk)
        penable = 1'b1;
    // return to idle
    @(negedge pready)
        psel    = 1'b0 ;
        penable = 1'b0 ;
        pwrite  = 1'b0 ;
        paddr   = 32'd0;
        pwdata  = 32'd0;
end
endtask

// [Arbiter Channel Task]
task arbiter_0;
    input [7:0] addr;
    input [7:0] priority;

begin
    // inital stage
    addr_dst0     = 8'd0 ;
    priority_dst0 = 8'b0 ;
    valid_dst0    = 1'b0 ;
    // config stage
    @(posedge clk)
        valid_dst0 = 1'b1;
        addr_dst0 = addr;
        priority_dst0 = priority;
    // return to idle
    @(negedge ready_dst0)
        addr_dst0     = 8'd0 ;
        priority_dst0 = 8'b0 ;
        valid_dst0    = 1'b0 ;
end
endtask

task arbiter_1;
    input [7:0] addr;
    input [7:0] priority;

begin
    // inital stage
    addr_dst1     = 8'd0 ;
    priority_dst1 = 8'b0 ;
    valid_dst1    = 1'b0 ;
    // config stage
    @(posedge clk)
        valid_dst1 = 1'b1;
        addr_dst1 = addr;
        priority_dst1 = priority;
    // return to idle
    @(negedge ready_dst1)
        addr_dst1     = 8'd0 ;
        priority_dst1 = 8'b0 ;
        valid_dst1    = 1'b0 ;
end
endtask

task arbiter_2;
    input [7:0] addr;
    input [7:0] priority;

begin
    // inital stage
    addr_dst2     = 8'd0 ;
    priority_dst2 = 8'b0 ;
    valid_dst2    = 1'b0 ;
    // config stage
    @(posedge clk)
        valid_dst2 = 1'b1;
        addr_dst2 = addr;
        priority_dst2 = priority;
    // return to idle
    @(negedge ready_dst2)
        addr_dst2     = 8'd0 ;
        priority_dst2 = 8'b0 ;
        valid_dst2    = 1'b0 ;
end
endtask

task arbiter_3;
    input [7:0] addr;
    input [7:0] priority;

begin
    // inital stage
    addr_dst3     = 8'd0 ;
    priority_dst3 = 8'b0 ;
    valid_dst3    = 1'b0 ;
    // config stage
    @(posedge clk)
        valid_dst3 = 1'b1;
        addr_dst3 = addr;
        priority_dst3 = priority;
    // return to idle
    @(negedge ready_dst3)
        addr_dst3     = 8'd0 ;
        priority_dst3 = 8'b0 ;
        valid_dst3    = 1'b0 ;
end
endtask

task arbiter_4;
    input [7:0] addr;
    input [7:0] priority;

begin
    // inital stage
    addr_dst4     = 8'd0 ;
    priority_dst4 = 8'b0 ;
    valid_dst4    = 1'b0 ;
    // config stage
    @(posedge clk)
        valid_dst4 = 1'b1;
        addr_dst4 = addr;
        priority_dst4 = priority;
    // return to idle
    @(negedge ready_dst4)
        addr_dst4     = 8'd0 ;
        priority_dst4 = 8'b0 ;
        valid_dst4    = 1'b0 ;
end
endtask

task arbiter_5;
    input [7:0] addr;
    input [7:0] priority;

begin
    // inital stage
    addr_dst5     = 8'd0 ;
    priority_dst5 = 8'b0 ;
    valid_dst5    = 1'b0 ;
    // config stage
    @(posedge clk)
        valid_dst5 = 1'b1;
        addr_dst5 = addr;
        priority_dst5 = priority;
    // return to idle
    @(negedge ready_dst5)
        addr_dst5     = 8'd0 ;
        priority_dst5 = 8'b0 ;
        valid_dst5    = 1'b0 ;
end
endtask

task arbiter_6;
    input [7:0] addr;
    input [7:0] priority;

begin
    // inital stage
    addr_dst6     = 8'd0 ;
    priority_dst6 = 8'b0 ;
    valid_dst6    = 1'b0 ;
    // config stage
    @(posedge clk)
        valid_dst6 = 1'b1;
        addr_dst6 = addr;
        priority_dst6 = priority;
    // return to idle
    @(negedge ready_dst6)
        addr_dst6     = 8'd0 ;
        priority_dst6 = 8'b0 ;
        valid_dst6    = 1'b0 ;
end
endtask

task arbiter_7;
    input [7:0] addr;
    input [7:0] priority;

begin
    // inital stage
    addr_dst7     = 8'd0 ;
    priority_dst7 = 8'b0 ;
    valid_dst7    = 1'b0 ;
    // config stage
    @(posedge clk)
        valid_dst7 = 1'b1;
        addr_dst7 = addr;
        priority_dst7 = priority;
    // return to idle
    @(negedge ready_dst7)
        addr_dst7     = 8'd0 ;
        priority_dst7 = 8'b0 ;
        valid_dst7    = 1'b0 ;
end
endtask

endmodule