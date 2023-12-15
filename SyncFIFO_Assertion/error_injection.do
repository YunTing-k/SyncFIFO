onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench_top/testbench/clk
add wave -noupdate /testbench_top/testbench/rst_n
add wave -noupdate /testbench_top/dut/top_wrapper/fifo_wrapper_inst/fifo_ctrl_inst/rd_en
add wave -noupdate /testbench_top/dut/top_wrapper/fifo_wrapper_inst/fifo_ctrl_inst/rd_only
add wave -noupdate /testbench_top/dut/top_wrapper/fifo_wrapper_inst/fifo_ctrl_inst/fifo_pop
add wave -noupdate -radix unsigned /testbench_top/dut/top_wrapper/fifo_wrapper_inst/fifo_ctrl_inst/rd_addr
add wave -noupdate /testbench_top/dut/top_wrapper/fifo_wrapper_inst/fifo_mem_inst/rd_data
add wave -noupdate /testbench_top/dut/top_wrapper/fifo_wrapper_inst/fifo_ctrl_inst/wr_en
add wave -noupdate -radix unsigned /testbench_top/dut/top_wrapper/fifo_wrapper_inst/fifo_mem_inst/wr_addr
add wave -noupdate /testbench_top/dut/top_wrapper/fifo_wrapper_inst/fifo_mem_inst/wr_data
add wave -noupdate -color Coral -itemcolor Coral /testbench_top/dut/top_wrapper/fifo_wrapper_inst/ptr_encode_instB/enc_data
add wave -noupdate -color Coral -itemcolor Coral /testbench_top/dut/top_wrapper/fifo_wrapper_inst/ptr_decode_instB/enc_data
add wave -noupdate -color Coral -itemcolor Coral -radix unsigned /testbench_top/dut/top_wrapper/fifo_wrapper_inst/ptr_decode_instB/out_data
add wave -noupdate -color Coral -itemcolor Coral -radix unsigned /testbench_top/dut/top_wrapper/fifo_wrapper_inst/ptr_decode_instB/err_index
add wave -noupdate -color Khaki -itemcolor Khaki /testbench_top/dut/top_wrapper/fifo_wrapper_inst/ptr_encode_instA/enc_data
add wave -noupdate -color Khaki -itemcolor Khaki /testbench_top/dut/top_wrapper/fifo_wrapper_inst/ptr_decode_instA/enc_data
add wave -noupdate -color Khaki -itemcolor Khaki -radix unsigned /testbench_top/dut/top_wrapper/fifo_wrapper_inst/ptr_decode_instA/out_data
add wave -noupdate -color Khaki -itemcolor Khaki -radix unsigned /testbench_top/dut/top_wrapper/fifo_wrapper_inst/ptr_decode_instA/err_index
add wave -noupdate -color Khaki -itemcolor Khaki /testbench_top/dut/top_wrapper/fifo_wrapper_inst/fifo_mem_inst/rd_data
add wave -noupdate -color {Medium Spring Green} -itemcolor {Medium Spring Green} /testbench_top/dut/top_wrapper/fifo_wrapper_inst/data_decode_inst/enc_data
add wave -noupdate -color {Medium Spring Green} -itemcolor {Medium Spring Green} -radix unsigned /testbench_top/dut/top_wrapper/fifo_wrapper_inst/data_decode_inst/out_data
add wave -noupdate -color {Medium Spring Green} -itemcolor {Medium Spring Green} -max 38.0 -radix unsigned /testbench_top/dut/top_wrapper/fifo_wrapper_inst/data_decode_inst/err_index
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20325000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 105
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
WaveRestoreZoom {20299247 ps} {20365264 ps}
