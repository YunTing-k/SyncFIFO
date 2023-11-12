onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /hanming_tb/clk
add wave -noupdate /hanming_tb/rst_n
add wave -noupdate -itemcolor Khaki -radix hexadecimal /hanming_tb/data_raw
add wave -noupdate -itemcolor Khaki -radix hexadecimal /hanming_tb/data_encode_inst/raw_data
add wave -noupdate -itemcolor Khaki -radix hexadecimal /hanming_tb/data_encode_inst/enc_data
add wave -noupdate -itemcolor Khaki /hanming_tb/data_temp
add wave -noupdate -itemcolor Khaki -radix hexadecimal /hanming_tb/data_decode_inst/enc_data
add wave -noupdate -itemcolor Khaki -radix hexadecimal /hanming_tb/data_decode_inst/out_data
add wave -noupdate -itemcolor Khaki -radix unsigned /hanming_tb/data_decode_inst/err_index
add wave -noupdate -itemcolor {Pale Green} -radix hexadecimal /hanming_tb/ptr_raw
add wave -noupdate -itemcolor {Pale Green} -radix hexadecimal /hanming_tb/ptr_encode_inst/raw_data
add wave -noupdate -itemcolor {Pale Green} -radix hexadecimal /hanming_tb/ptr_encode_inst/enc_data
add wave -noupdate -itemcolor {Pale Green} /hanming_tb/ptr_temp
add wave -noupdate -itemcolor {Pale Green} -radix hexadecimal /hanming_tb/ptr_decode_inst/enc_data
add wave -noupdate -itemcolor {Pale Green} -radix hexadecimal /hanming_tb/ptr_decode_inst/out_data
add wave -noupdate -itemcolor {Pale Green} -radix unsigned /hanming_tb/ptr_decode_inst/err_index
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {19524 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 328
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
WaveRestoreZoom {0 ps} {52984 ps}
