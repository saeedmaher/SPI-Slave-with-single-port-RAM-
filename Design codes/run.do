vlib work
vlog RAM.v SPI_slave.v top_module.v top_module_tb.v
vsim -voptargs=+acc work.top_module_SPI_tb  
add wave *
add wave -position insertpoint  \
sim:/top_module_SPI_tb/dut/RAM_block/mem
add wave -position insertpoint  \
sim:/top_module_SPI_tb/dut/RAM_block/mem
add wave -position insertpoint  \
sim:/top_module_SPI_tb/dut/SPI_block/cs \
sim:/top_module_SPI_tb/dut/SPI_block/rx_data \
sim:/top_module_SPI_tb/dut/SPI_block/rx_valid \
sim:/top_module_SPI_tb/dut/SPI_block/tx_data \
sim:/top_module_SPI_tb/dut/SPI_block/tx_valid
run -all
#quit -sim