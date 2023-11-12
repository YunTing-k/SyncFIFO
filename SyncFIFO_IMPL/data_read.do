onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /data_read_tb/clk
add wave -noupdate /data_read_tb/rst_n
add wave -noupdate -radix unsigned /data_read_tb/write_counter
add wave -noupdate /data_read_tb/top_wrapper_inst/fifo_wrapper_inst/fifo_ctrl_inst/wr_en
add wave -noupdate /data_read_tb/top_wrapper_inst/fifo_wrapper_inst/fifo_ctrl_inst/wr_addr
add wave -noupdate /data_read_tb/top_wrapper_inst/fifo_wrapper_inst/fifo_mem_inst/wr_data
add wave -noupdate -itemcolor Khaki /data_read_tb/top_wrapper_inst/arbiter_inst/addr_dst0
add wave -noupdate -itemcolor Khaki -radix unsigned /data_read_tb/top_wrapper_inst/arbiter_inst/priority_dst0
add wave -noupdate -itemcolor Khaki /data_read_tb/top_wrapper_inst/arbiter_inst/valid_dst0
add wave -noupdate -itemcolor Khaki -radix unsigned /data_read_tb/top_wrapper_inst/arbiter_inst/data_dst0
add wave -noupdate -itemcolor Khaki /data_read_tb/top_wrapper_inst/arbiter_inst/ready_dst0
add wave -noupdate -itemcolor Khaki /data_read_tb/top_wrapper_inst/arbiter_inst/sel
add wave -noupdate -itemcolor {Medium Spring Green} /data_read_tb/top_wrapper_inst/arbiter_inst/channel0/sel
add wave -noupdate -itemcolor {Medium Spring Green} /data_read_tb/top_wrapper_inst/arbiter_inst/channel0/cfg_done
add wave -noupdate -itemcolor {Medium Spring Green} /data_read_tb/top_wrapper_inst/arbiter_inst/channel0/addr
add wave -noupdate -itemcolor {Medium Spring Green} /data_read_tb/top_wrapper_inst/arbiter_inst/channel0/priority
add wave -noupdate -itemcolor {Medium Spring Green} /data_read_tb/top_wrapper_inst/arbiter_inst/channel0/rd_en
add wave -noupdate -itemcolor {Medium Spring Green} /data_read_tb/top_wrapper_inst/arbiter_inst/channel0/rd_only
add wave -noupdate -itemcolor {Medium Spring Green} /data_read_tb/top_wrapper_inst/arbiter_inst/channel0/ctrl_done
add wave -noupdate -itemcolor {Medium Spring Green} /data_read_tb/top_wrapper_inst/arbiter_inst/channel0/wait_done
add wave -noupdate -itemcolor {Medium Spring Green} -radix unsigned /data_read_tb/top_wrapper_inst/arbiter_inst/channel0/data
add wave -noupdate -itemcolor {Medium Spring Green} /data_read_tb/top_wrapper_inst/arbiter_inst/channel0/output_done
add wave -noupdate -itemcolor {Medium Spring Green} /data_read_tb/top_wrapper_inst/arbiter_inst/channel0/ready
add wave -noupdate -radix unsigned /data_read_tb/read_counter
add wave -noupdate /data_read_tb/top_wrapper_inst/arbiter_inst/fifo_read_inst/rd_en
add wave -noupdate /data_read_tb/top_wrapper_inst/arbiter_inst/fifo_read_inst/rd_only
add wave -noupdate -radix unsigned /data_read_tb/top_wrapper_inst/fifo_wrapper_inst/fifo_ctrl_inst/fifo_counter
add wave -noupdate /data_read_tb/top_wrapper_inst/fifo_wrapper_inst/fifo_ctrl_inst/fifo_status
add wave -noupdate -radix unsigned /data_read_tb/top_wrapper_inst/arbiter_inst/channel0/fifo_out
add wave -noupdate /data_read_tb/top_wrapper_inst/arbiter_inst/channel0/data_err_idx
add wave -noupdate -radix unsigned /data_read_tb/top_wrapper_inst/arbiter_inst/channel0/wr_ptr
add wave -noupdate -radix unsigned /data_read_tb/top_wrapper_inst/arbiter_inst/channel0/wr_ptr_err_idx
add wave -noupdate -radix unsigned /data_read_tb/top_wrapper_inst/arbiter_inst/channel0/rd_ptr
add wave -noupdate -radix unsigned /data_read_tb/top_wrapper_inst/arbiter_inst/channel0/rd_ptr_err_idx
add wave -noupdate /data_read_tb/top_wrapper_inst/fifo_wrapper_inst/fifo_mem_inst/memory
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {92203243 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 453
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {92006150 ps} {92261782 ps}
