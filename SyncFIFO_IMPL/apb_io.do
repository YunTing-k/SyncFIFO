onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /apb_io_tb/clk
add wave -noupdate /apb_io_tb/rst_n
add wave -noupdate -radix unsigned /apb_io_tb/write_counter
add wave -noupdate -itemcolor Khaki /apb_io_tb/pwrite
add wave -noupdate /apb_io_tb/psel
add wave -noupdate /apb_io_tb/penable
add wave -noupdate /apb_io_tb/paddr
add wave -noupdate -itemcolor Khaki -radix unsigned /apb_io_tb/pwdata
add wave -noupdate /apb_io_tb/pready
add wave -noupdate -itemcolor Khaki /apb_io_tb/top_wrapper_inst/apb_slave_inst/write_data
add wave -noupdate -itemcolor Khaki /apb_io_tb/top_wrapper_inst/apb_slave_inst/prdata
add wave -noupdate /apb_io_tb/top_wrapper_inst/fifo_wrapper_inst/fifo_status
add wave -noupdate -radix unsigned /apb_io_tb/top_wrapper_inst/apb_slave_inst/fifo_status
add wave -noupdate -radix unsigned /apb_io_tb/top_wrapper_inst/fifo_wrapper_inst/fifo_ctrl_inst/fifo_counter
add wave -noupdate /apb_io_tb/METHOD
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4101000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 451
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
WaveRestoreZoom {4071494 ps} {4119188 ps}
