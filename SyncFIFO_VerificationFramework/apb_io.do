onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Cyan -itemcolor Cyan /testbench_top/if_schannel_0/clk
add wave -noupdate -color Cyan -itemcolor Cyan /testbench_top/if_schannel_0/rst_n
add wave -noupdate -color Cyan -itemcolor Cyan /testbench_top/if_schannel_0/channel_pwrite
add wave -noupdate -color Cyan -itemcolor Cyan /testbench_top/if_schannel_0/channel_psel
add wave -noupdate -color Cyan -itemcolor Cyan /testbench_top/if_schannel_0/channel_paddr
add wave -noupdate -color Cyan -itemcolor Cyan /testbench_top/if_schannel_0/channel_pwdata
add wave -noupdate -color Cyan -itemcolor Cyan /testbench_top/if_schannel_0/channel_penable
add wave -noupdate -color Cyan -itemcolor Cyan /testbench_top/if_schannel_0/channel_prdata
add wave -noupdate -color Cyan -itemcolor Cyan /testbench_top/if_schannel_0/channel_pready
add wave -noupdate -color Cyan -itemcolor Cyan /testbench_top/dut/top_wrapper/apb_slave_inst/access_valid
add wave -noupdate -color Cyan -itemcolor Cyan /testbench_top/dut/top_wrapper/apb_slave_inst/access_done
add wave -noupdate -color Cyan -itemcolor Cyan -radix unsigned /testbench_top/dut/top_wrapper/apb_slave_inst/current_state
add wave -noupdate -color Cyan -itemcolor Cyan -radix unsigned /testbench_top/dut/top_wrapper/apb_slave_inst/next_state
add wave -noupdate /testbench_top/dut/top_wrapper/fifo_wrapper_inst/fifo_mem_inst/wr_clk
add wave -noupdate /testbench_top/dut/top_wrapper/fifo_wrapper_inst/fifo_mem_inst/wr_en
add wave -noupdate /testbench_top/dut/top_wrapper/fifo_wrapper_inst/fifo_mem_inst/wr_addr
add wave -noupdate /testbench_top/dut/top_wrapper/fifo_wrapper_inst/fifo_mem_inst/wr_data
add wave -noupdate /testbench_top/dut/top_wrapper/fifo_wrapper_inst/fifo_mem_inst/memory
add wave -noupdate -radix unsigned /testbench_top/dut/top_wrapper/fifo_wrapper_inst/fifo_ctrl_inst/fifo_status
add wave -noupdate -radix unsigned /testbench_top/dut/top_wrapper/fifo_wrapper_inst/fifo_ctrl_inst/fifo_counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {26999 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 143
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {19190 ps} {34281 ps}
