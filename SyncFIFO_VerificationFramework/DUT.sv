//-----------------------------------------------------
// DUT.sv
// this a file that connecting your dut(.v file) in 
// system verilog's intreface way.
//-----------------------------------------------------

module dut (

    input clk  ,
    input rst_n,
    
    // add your modport here
    // example : 
    duttb_intf_srcchannel.DUTconnect sch_0

);

    top_wrapper top_wrapper (
    
        .clk          (clk                   ),
        .reset_n      (rst_n                 ),

        // connect your modport connection here
        // example : 
        .pwrite       (sch_0.channel_pwrite  ),
        .psel         (sch_0.channel_psel    ),
        .paddr        (sch_0.channel_paddr   ),
        .pwdata       (sch_0.channel_pwdata  ),
        .penable      (sch_0.channel_penable ),
        .prdata       (sch_0.channel_prdata  ),
        .pready       (sch_0.channel_pready  ),

        .addr_dst0    (0),
        .priority_dst0(0),
        .valid_dst0   (0),   
        .data_dst0    (),    
        .ready_dst0   (),

        .addr_dst1    (0),
        .priority_dst1(0),
        .valid_dst1   (0),
        .data_dst1    (),
        .ready_dst1   (),

        .addr_dst2    (0),
        .priority_dst2(0),
        .valid_dst2   (0),
        .data_dst2    (),
        .ready_dst2   (),

        .addr_dst3    (0),
        .priority_dst3(0),
        .valid_dst3   (0),
        .data_dst3    (),
        .ready_dst3   (),

        .addr_dst4    (0),
        .priority_dst4(0),
        .valid_dst4   (0),
        .data_dst4    (),
        .ready_dst4   (),

        .addr_dst5    (0),
        .priority_dst5(0),
        .valid_dst5   (0),
        .data_dst5    (),
        .ready_dst5   (),

        .addr_dst6    (0),
        .priority_dst6(0),
        .valid_dst6   (0),
        .data_dst6    (),
        .ready_dst6   (),

        .addr_dst7    (0),
        .priority_dst7(0),
        .valid_dst7   (0),
        .data_dst7    (),
        .ready_dst7   ()
    );


endmodule