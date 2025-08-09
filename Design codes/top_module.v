module top_module_SPI(MOSI,MISO,SS_n,clk,rst_n);
input clk,rst_n,SS_n,MOSI;
output MISO;
wire tx_valid,rx_valid;
wire [9:0]rx_data;
wire [7:0]tx_data;

RAM RAM_block (clk,rst_n,rx_valid,rx_data,tx_valid,tx_data);
SPI_slave SPI_block (MOSI,SS_n,clk,rst_n,tx_valid,tx_data,MISO,rx_valid,rx_data);

endmodule
