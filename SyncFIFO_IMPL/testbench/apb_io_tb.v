//+FHDR//////////////////////////////////////////////////////////////////////////////
// Company: Shanghai Jiao Tong University
// Engineer: Yu Huang
//
// Create Date: 2023.11.12
// Design Name: SyncFIFO
// Module Name: apb_io_tb
// Target Device: N/A
// Tool versions: QuestaSim 10.6c
// Description: 
// Testbench of the apb data I/O, to verify the basic function of APB slave I/O ctrl.
// This testbench verify two APB write mode:
//     [1]: Discrete read of reg file with APB slave
//     [2]: Continuous read of reg file with APB slave
//     Note: Modify the read mode with PARAMETER METHOD
// This testbench also verify invalid access address behavior:
//     [1]: Access addr out of reg file range
//     [2]: Try to write a read onlu reg
// Dependencies:
// top_wrapper.v
//
// Revision:
// ---------------------------------------------------------------------------------
// [Date]         [By]         [Version]         [Change Log]
// ---------------------------------------------------------------------------------
// 2023/11/12     Yu Huang     1.0               First implmentation
// 2023/12/15     Yu Huang     1.1               reset_n -> rst_n
// ---------------------------------------------------------------------------------
//
//-FHDR//////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`define FIFO_BASE_ADDR    32'h2000_0000              // base addr of FIFO device
`define FIFO_WRITE_DATA   (`FIFO_BASE_ADDR + 32'h00)   // FIFO write data (read/write)
`define FIFO_STATUS       (`FIFO_BASE_ADDR + 32'h04)   // FIFO status (read)

module apb_io_tb();

//-----------------------parameter define-----------------------//
parameter PERIOD  = 2;   // clock period
parameter DEPTH  = 1024; // FIFO depth
parameter METHOD = 1;    // 0: APB discrete read
                         // 1: APB continuous read
//--------------------------reg define--------------------------//
reg clk;
reg rst_n;
reg pwrite, psel, penable;
reg [31:0] paddr, pwdata;
reg [7:0] addr_dst0, addr_dst1, addr_dst2, addr_dst3, addr_dst4, addr_dst5, addr_dst6, addr_dst7;
reg [7:0] priority_dst0, priority_dst1, priority_dst2, priority_dst3, priority_dst4, priority_dst5, priority_dst6, priority_dst7;
reg valid_dst0, valid_dst1, valid_dst2, valid_dst3, valid_dst4, valid_dst5, valid_dst6, valid_dst7;

reg [10:0] write_counter;
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
    end
    else if (METHOD == 1) begin // continuous read
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
        else begin // fifo full test
            // valid access
            apb_task_C_start(`FIFO_WRITE_DATA, {{21{1'b0}}, write_counter}, 1'b0);
            apb_task_C_busy(`FIFO_STATUS, {{21{1'b0}}, write_counter}, 1'b0);
            apb_task_C_busy(`FIFO_WRITE_DATA, {{21{1'b0}}, write_counter}, 1'b0);
            fork
            // invalid access test (out of reg range)
            apb_task_C_busy(`FIFO_BASE_ADDR + 32'hFF, {{21{1'b0}}, write_counter}, 1'b0);
            // valid access
            #10 apb_task_C_start(`FIFO_WRITE_DATA, {{21{1'b0}}, write_counter}, 1'b0);
            join
            // valid access
            apb_task_C_busy(`FIFO_STATUS, {{21{1'b0}}, write_counter}, 1'b0);
            apb_task_C_busy(`FIFO_WRITE_DATA, {{21{1'b0}}, write_counter}, 1'b0);
            // invalid access test (write a read only reg)
            apb_task_C_busy(`FIFO_STATUS, {{21{1'b0}}, write_counter}, 1'b1);
            $stop;
        end
    end
    else begin // discrete read
        if (write_counter == 0) begin
            write_counter <= write_counter + 1'b1;
            fork
            // invalid access test (out of reg range)
            apb_task_D(`FIFO_BASE_ADDR + 32'hFF, {{21{1'b0}}, write_counter}, 1'b1);
            #10 apb_task_D(`FIFO_BASE_ADDR + 32'h6F, {{21{1'b0}}, write_counter}, 1'b0);
            // valid access
            #20 apb_task_D(`FIFO_WRITE_DATA, {{21{1'b0}}, write_counter}, 1'b0);
            join
            // valid access
            apb_task_D(`FIFO_WRITE_DATA, {{21{1'b0}}, write_counter}, 1'b1);
            apb_task_D(`FIFO_WRITE_DATA, {{21{1'b0}}, write_counter}, 1'b0);
            apb_task_D(`FIFO_STATUS, {{21{1'b0}}, write_counter}, 1'b0);
        end
        else if (write_counter < DEPTH) begin
            // valid access
            write_counter <= write_counter + 1'b1;
            apb_task_D(`FIFO_WRITE_DATA, {{21{1'b0}}, write_counter}, 1'b1);
            apb_task_D(`FIFO_WRITE_DATA, {{21{1'b0}}, write_counter}, 1'b0);
            apb_task_D(`FIFO_STATUS, {{21{1'b0}}, write_counter}, 1'b0);
        end
        else begin
            // fifo full test
            apb_task_D(`FIFO_WRITE_DATA, {{21{1'b0}}, write_counter}, 1'b0);
            apb_task_D(`FIFO_STATUS, {{21{1'b0}}, write_counter}, 1'b0);
            // invalid access test (write a read only reg)
            apb_task_D(`FIFO_STATUS, {{21{1'b0}}, write_counter}, 1'b1);
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

endmodule