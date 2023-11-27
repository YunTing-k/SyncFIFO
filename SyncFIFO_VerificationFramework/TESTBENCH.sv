//-----------------------------------------------------
// TESTBENCH.sv
// in the 'testbench_top', build the instance of the 
// module of dut and program of testbench, even the 
// intreface and some global signals.
// 'testbench' file control the total sim process, here
// add your command to ENV object
//-----------------------------------------------------

`timescale 1ns/1ps

module testbench_top ();

//-----------------------------------------------------
// parameters
//-----------------------------------------------------

    parameter CLK_PERIOD = 10;

//-----------------------------------------------------
// signals define
//-----------------------------------------------------

    // uninterface signals 
    logic clk  ;
    logic rst_n;
    
    // interface signals 
    duttb_intf_srcchannel if_schannel_0(.*);


//-----------------------------------------------------
// signals' fun
//-----------------------------------------------------
       
	initial begin 
		clk    = 0 ;
		forever #(CLK_PERIOD /2) clk = ~clk;
	end

	initial begin
		rst_n   = 0;
		repeat(10) @(posedge clk) ;
		rst_n   = 1;
	end 

//-----------------------------------------------------
// connections
//-----------------------------------------------------

    testbench testbench(
        .clk   (clk          ),
        .rst_n (rst_n        ),

        // source channel connections
        .sch_0 (if_schannel_0)

    ); 

    dut dut(
        .clk   (clk          ),
        .rst_n (rst_n        ),

        // source channel connections
        .sch_0 (if_schannel_0)
    );
    
endmodule

program testbench(

    input clk  ,
    input rst_n,
    
    // your modport connection
    duttb_intf_srcchannel.TBconnect sch_0


);
    
    import env ::*;   // impport your ENV object
    env_ctrl envctrl; // first declare it

    initial begin
        
        $display("[TB-SYS] welcome to sv testbench plateform !");

        // BUILD
        // ---------------------------------------------------        
        // the first step in testbench is build your env object 
        // as your command manager, after that you can call it
        // also with its subordinates
        $display("[TB-SYS] building");
        envctrl = new();

        // CONNECT
        // ---------------------------------------------------
        // let your manager connected to your dut by interface
        $display("[TB-SYS] connecting");
        envctrl.set_interface(
            sch_0
        );

        // RUN
        // ---------------------------------------------------
        // give command to your env object
        $display("[TB-SYS] running");

        // (1) waiting for rst done in dut
        repeat(11) @(posedge clk);
        
            // (2) add your command here 
            // example :
            //envctrl.run("Config_Priority");                   // actually not work, because priority port are all set zero
    
            fork
                envctrl.run("Apb_Write/Read");            // in this demo, we just driver a handshake process in channel 0
                envctrl.run("Time_Run");                      // time out limitation
            join_any
            disable fork;        

        // END
        // ---------------------------------------------------        
        $display("[TB-SYS] testbench system has done all the work, exit !");

    end

endprogram