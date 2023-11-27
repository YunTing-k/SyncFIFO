//-----------------------------------------------------
// INTF.sv
// this a file that define your interfaces which connect
// your dut and testbench.
//-----------------------------------------------------

// example :
interface duttb_intf_srcchannel (
    input clk,
    input rst_n
);

//-----------------------------------------------------
// parameters
//-----------------------------------------------------

    localparam SADDR_W = 32;
    localparam SDATA_W = 32;
    // data width of source channel

//-----------------------------------------------------
// ios
//-----------------------------------------------------

    logic                  channel_pwrite   ;
    logic                  channel_psel     ;
    logic [SADDR_W-1   :0] channel_paddr    ;
    logic [SDATA_W-1   :0] channel_pwdata   ;
    logic                  channel_penable  ;
    logic [SDATA_W-1   :0] channel_prdata   ;
    logic                  channel_pready   ;

//-----------------------------------------------------
// modports
//-----------------------------------------------------

    modport DUTconnect (
        input  channel_pwrite, channel_psel, channel_paddr, channel_pwdata, channel_penable,
        output channel_prdata, channel_pready
    );

    modport TBconnect (
        input  clk,
        output channel_pwrite, channel_psel, channel_paddr, channel_pwdata, channel_penable,
        input  channel_prdata, channel_pready
    );

endinterface
