vlib work
vlog RAM.v RAM_tb.v
vsim -voptargs=+acc work.RAM_tb  
add wave *
add wave -position insertpoint  \
sim:/RAM_tb/dut/mem
run -all
#quit -sim