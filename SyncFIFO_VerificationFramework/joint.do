onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench_top/testbench/clk
add wave -noupdate /testbench_top/testbench/rst_n
add wave -noupdate /testbench_top/dut/top_wrapper/fifo_wrapper_inst/fifo_ctrl_inst/rd_en
add wave -noupdate /testbench_top/dut/top_wrapper/fifo_wrapper_inst/fifo_ctrl_inst/rd_only
add wave -noupdate /testbench_top/dut/top_wrapper/fifo_wrapper_inst/fifo_ctrl_inst/fifo_pop
add wave -noupdate -radix unsigned /testbench_top/dut/top_wrapper/fifo_wrapper_inst/fifo_ctrl_inst/rd_addr
add wave -noupdate /testbench_top/dut/top_wrapper/fifo_wrapper_inst/fifo_mem_inst/rd_data
add wave -noupdate -radix unsigned /testbench_top/dut/top_wrapper/fifo_wrapper_inst/fifo_mem_inst/wr_addr
add wave -noupdate -radix unsigned /testbench_top/dut/top_wrapper/fifo_wrapper_inst/fifo_ctrl_inst/fifo_counter
add wave -noupdate /testbench_top/dut/top_wrapper/fifo_status
add wave -noupdate -radix unsigned -childformat {{{/testbench_top/dut/top_wrapper/arbiter_inst/find_max_inst/select[7]} -radix unsigned} {{/testbench_top/dut/top_wrapper/arbiter_inst/find_max_inst/select[6]} -radix unsigned} {{/testbench_top/dut/top_wrapper/arbiter_inst/find_max_inst/select[5]} -radix unsigned} {{/testbench_top/dut/top_wrapper/arbiter_inst/find_max_inst/select[4]} -radix unsigned} {{/testbench_top/dut/top_wrapper/arbiter_inst/find_max_inst/select[3]} -radix unsigned} {{/testbench_top/dut/top_wrapper/arbiter_inst/find_max_inst/select[2]} -radix unsigned} {{/testbench_top/dut/top_wrapper/arbiter_inst/find_max_inst/select[1]} -radix unsigned} {{/testbench_top/dut/top_wrapper/arbiter_inst/find_max_inst/select[0]} -radix unsigned}} -subitemconfig {{/testbench_top/dut/top_wrapper/arbiter_inst/find_max_inst/select[7]} {-height 15 -radix unsigned} {/testbench_top/dut/top_wrapper/arbiter_inst/find_max_inst/select[6]} {-height 15 -radix unsigned} {/testbench_top/dut/top_wrapper/arbiter_inst/find_max_inst/select[5]} {-height 15 -radix unsigned} {/testbench_top/dut/top_wrapper/arbiter_inst/find_max_inst/select[4]} {-height 15 -radix unsigned} {/testbench_top/dut/top_wrapper/arbiter_inst/find_max_inst/select[3]} {-height 15 -radix unsigned} {/testbench_top/dut/top_wrapper/arbiter_inst/find_max_inst/select[2]} {-height 15 -radix unsigned} {/testbench_top/dut/top_wrapper/arbiter_inst/find_max_inst/select[1]} {-height 15 -radix unsigned} {/testbench_top/dut/top_wrapper/arbiter_inst/find_max_inst/select[0]} {-height 15 -radix unsigned}} /testbench_top/dut/top_wrapper/arbiter_inst/find_max_inst/select
add wave -noupdate /testbench_top/dut/top_wrapper/arbiter_inst/fifo_read_inst/busy
add wave -noupdate -color Cyan -itemcolor Cyan /testbench_top/if_schannel_0/channel_pwrite
add wave -noupdate -color Cyan -itemcolor Cyan /testbench_top/if_schannel_0/channel_psel
add wave -noupdate -color Cyan -itemcolor Cyan /testbench_top/if_schannel_0/channel_paddr
add wave -noupdate -color Cyan -itemcolor Cyan /testbench_top/if_schannel_0/channel_pwdata
add wave -noupdate -color Cyan -itemcolor Cyan /testbench_top/if_schannel_0/channel_penable
add wave -noupdate -color Cyan -itemcolor Cyan /testbench_top/if_schannel_0/channel_prdata
add wave -noupdate -color Cyan -itemcolor Cyan /testbench_top/if_schannel_0/channel_pready
add wave -noupdate -group {channel priority} -radix unsigned /testbench_top/dut/top_wrapper/arbiter_inst/channel0/priority
add wave -noupdate -group {channel priority} -radix unsigned /testbench_top/dut/top_wrapper/arbiter_inst/channel1/priority
add wave -noupdate -group {channel priority} -radix unsigned /testbench_top/dut/top_wrapper/arbiter_inst/channel2/priority
add wave -noupdate -group {channel priority} -radix unsigned /testbench_top/dut/top_wrapper/arbiter_inst/channel3/priority
add wave -noupdate -group {channel priority} -radix unsigned /testbench_top/dut/top_wrapper/arbiter_inst/channel4/priority
add wave -noupdate -group {channel priority} -radix unsigned /testbench_top/dut/top_wrapper/arbiter_inst/channel5/priority
add wave -noupdate -group {channel priority} -radix unsigned /testbench_top/dut/top_wrapper/arbiter_inst/channel6/priority
add wave -noupdate -group {channel priority} -radix unsigned /testbench_top/dut/top_wrapper/arbiter_inst/channel7/priority
add wave -noupdate -group {channel state} /testbench_top/dut/top_wrapper/arbiter_inst/channel0/cfg_done
add wave -noupdate -group {channel state} /testbench_top/dut/top_wrapper/arbiter_inst/channel1/cfg_done
add wave -noupdate -group {channel state} /testbench_top/dut/top_wrapper/arbiter_inst/channel2/cfg_done
add wave -noupdate -group {channel state} /testbench_top/dut/top_wrapper/arbiter_inst/channel3/cfg_done
add wave -noupdate -group {channel state} /testbench_top/dut/top_wrapper/arbiter_inst/channel4/cfg_done
add wave -noupdate -group {channel state} /testbench_top/dut/top_wrapper/arbiter_inst/channel5/cfg_done
add wave -noupdate -group {channel state} /testbench_top/dut/top_wrapper/arbiter_inst/channel6/cfg_done
add wave -noupdate -group {channel state} /testbench_top/dut/top_wrapper/arbiter_inst/channel7/cfg_done
add wave -noupdate -group {channel state} -radix unsigned /testbench_top/dut/top_wrapper/arbiter_inst/channel0/current_state
add wave -noupdate -group {channel state} -radix unsigned /testbench_top/dut/top_wrapper/arbiter_inst/channel1/current_state
add wave -noupdate -group {channel state} -radix unsigned /testbench_top/dut/top_wrapper/arbiter_inst/channel2/current_state
add wave -noupdate -group {channel state} -radix unsigned /testbench_top/dut/top_wrapper/arbiter_inst/channel3/current_state
add wave -noupdate -group {channel state} -radix unsigned /testbench_top/dut/top_wrapper/arbiter_inst/channel4/current_state
add wave -noupdate -group {channel state} -radix unsigned /testbench_top/dut/top_wrapper/arbiter_inst/channel5/current_state
add wave -noupdate -group {channel state} -radix unsigned /testbench_top/dut/top_wrapper/arbiter_inst/channel6/current_state
add wave -noupdate -group {channel state} -radix unsigned /testbench_top/dut/top_wrapper/arbiter_inst/channel7/current_state
add wave -noupdate -color Khaki -itemcolor Khaki /testbench_top/dut/top_wrapper/addr_dst0
add wave -noupdate -color Wheat -itemcolor Wheat /testbench_top/dut/top_wrapper/addr_dst1
add wave -noupdate -color Tan -itemcolor Tan /testbench_top/dut/top_wrapper/addr_dst2
add wave -noupdate -color Goldenrod -itemcolor Goldenrod /testbench_top/dut/top_wrapper/addr_dst3
add wave -noupdate -color Orange -itemcolor Orange /testbench_top/dut/top_wrapper/addr_dst4
add wave -noupdate -color Coral -itemcolor Coral /testbench_top/dut/top_wrapper/addr_dst5
add wave -noupdate -color {Orange Red} -itemcolor {Orange Red} /testbench_top/dut/top_wrapper/addr_dst6
add wave -noupdate -color {Indian Red} -itemcolor {Indian Red} /testbench_top/dut/top_wrapper/addr_dst7
add wave -noupdate -color Khaki -itemcolor Khaki -radix unsigned /testbench_top/dut/top_wrapper/priority_dst0
add wave -noupdate -color Wheat -itemcolor Wheat -radix unsigned /testbench_top/dut/top_wrapper/priority_dst1
add wave -noupdate -color Tan -itemcolor Tan -radix unsigned /testbench_top/dut/top_wrapper/priority_dst2
add wave -noupdate -color Goldenrod -itemcolor Goldenrod -radix unsigned /testbench_top/dut/top_wrapper/priority_dst3
add wave -noupdate -color Orange -itemcolor Orange -radix unsigned /testbench_top/dut/top_wrapper/priority_dst4
add wave -noupdate -color Coral -itemcolor Coral -radix unsigned /testbench_top/dut/top_wrapper/priority_dst5
add wave -noupdate -color {Orange Red} -itemcolor {Orange Red} -radix unsigned /testbench_top/dut/top_wrapper/priority_dst6
add wave -noupdate -color {Indian Red} -itemcolor {Indian Red} -radix unsigned /testbench_top/dut/top_wrapper/priority_dst7
add wave -noupdate -color Khaki -itemcolor Khaki /testbench_top/dut/top_wrapper/valid_dst0
add wave -noupdate -color Wheat -itemcolor Wheat /testbench_top/dut/top_wrapper/valid_dst1
add wave -noupdate -color Tan -itemcolor Tan /testbench_top/dut/top_wrapper/valid_dst2
add wave -noupdate -color Goldenrod -itemcolor Goldenrod /testbench_top/dut/top_wrapper/valid_dst3
add wave -noupdate -color Orange -itemcolor Orange /testbench_top/dut/top_wrapper/valid_dst4
add wave -noupdate -color Coral -itemcolor Coral /testbench_top/dut/top_wrapper/valid_dst5
add wave -noupdate -color {Orange Red} -itemcolor {Orange Red} /testbench_top/dut/top_wrapper/valid_dst6
add wave -noupdate -color {Indian Red} -itemcolor {Indian Red} /testbench_top/dut/top_wrapper/valid_dst7
add wave -noupdate -color Khaki -itemcolor Khaki -radix unsigned /testbench_top/dut/top_wrapper/data_dst0
add wave -noupdate -color Wheat -itemcolor Wheat -radix unsigned /testbench_top/dut/top_wrapper/data_dst1
add wave -noupdate -color Tan -itemcolor Tan -radix unsigned /testbench_top/dut/top_wrapper/data_dst2
add wave -noupdate -color Goldenrod -itemcolor Goldenrod -radix unsigned /testbench_top/dut/top_wrapper/data_dst3
add wave -noupdate -color Orange -itemcolor Orange -radix unsigned /testbench_top/dut/top_wrapper/data_dst4
add wave -noupdate -color Coral -itemcolor Coral -radix unsigned /testbench_top/dut/top_wrapper/data_dst5
add wave -noupdate -color {Orange Red} -itemcolor {Orange Red} -radix unsigned /testbench_top/dut/top_wrapper/data_dst6
add wave -noupdate -color {Indian Red} -itemcolor {Indian Red} -radix unsigned /testbench_top/dut/top_wrapper/data_dst7
add wave -noupdate -color Khaki -itemcolor Khaki /testbench_top/dut/top_wrapper/ready_dst0
add wave -noupdate -color Wheat -itemcolor Wheat /testbench_top/dut/top_wrapper/ready_dst1
add wave -noupdate -color Tan -itemcolor Tan /testbench_top/dut/top_wrapper/ready_dst2
add wave -noupdate -color Goldenrod -itemcolor Goldenrod /testbench_top/dut/top_wrapper/ready_dst3
add wave -noupdate -color Orange -itemcolor Orange /testbench_top/dut/top_wrapper/ready_dst4
add wave -noupdate -color Coral -itemcolor Coral /testbench_top/dut/top_wrapper/ready_dst5
add wave -noupdate -color {Orange Red} -itemcolor {Orange Red} /testbench_top/dut/top_wrapper/ready_dst6
add wave -noupdate -color {Indian Red} -itemcolor {Indian Red} /testbench_top/dut/top_wrapper/ready_dst7
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6152953 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 136
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
WaveRestoreZoom {9145132 ps} {9243940 ps}
