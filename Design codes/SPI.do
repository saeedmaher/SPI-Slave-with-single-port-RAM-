vlib work
vlog SPI_slave.v SPI_slave_tb.v
vsim -voptargs=+acc work.SPI_slave_tb 
add wave *
run -all
#quit -sim