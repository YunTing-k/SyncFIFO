package env;

    import src_agent_main ::*;
    import dst_agent_main ::*;  

    class env_ctrl;

        // BUILD
        // ---------------------------------------------------
        // the new function is to build the class object's subordinates

        // first declare your subordinates
        src_agent src_agent;

        bit [31:0] data;

        // new them
        function new();
            this.src_agent = new();
        endfunction        

        // CONNECT
        // ---------------------------------------------------
        // the set_interface function is to connect the interface to itself
        // and then also connect to its subordinates
        // (only if used)
        function void set_interface(
            virtual duttb_intf_srcchannel.TBconnect sch_0
        );

            // connect to src_agent
            this.src_agent.set_interface(
                sch_0        
            );
            // ...

            // connect to dst_agent

            // ...
            
        endfunction 

        // RUN
        // ---------------------------------------------------
        // manage your work here : 
        // (1) receive the command from the testbench
        // (2) call its subordinates to work
        task run(string state);
            case(state)
                "Apb_Write/Read": begin
                    $display("[ENV] start work : Apb_Write/Read !");
                    // example :
                    // in this example, we test our apb port.
                    #10000
                    $display("[ENV] finish work : Apb_Write/Read !");
                end
                "Config_Priority": begin
                    $display("[ENV] start work : Config_Priority !");
                    // example :
                    // in this example, the priority ports are all firstly set to zero, and then set to others.
                end
                "Start_Destination_Agent": begin
                    $display("[ENV] start work : Start_Destination_Agent !");
                    
                    // ...

                end
                "Time_Run": begin
                    $display("[ENV] start work : Time_Run !");
                    #10000000
                    $display("[ENV] time out !");
                end
                default: begin
                end
            endcase
        endtask

    endclass

endpackage
