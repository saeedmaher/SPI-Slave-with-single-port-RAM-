module top_module_SPI_tb();
reg clk_tb,rst_n_tb,SS_n_tb,MOSI_tb;
wire MISO_tb;

top_module_SPI dut (MOSI_tb,MISO_tb,SS_n_tb,clk_tb,rst_n_tb);

initial begin
    clk_tb = 0;
    forever begin
        #10
        clk_tb = ~clk_tb;
    end
end

task spi_send_10bits(input [9:0] data_in);
  integer i;
  begin
    for (i = 9; i >= 0; i = i - 1) begin   
      MOSI_tb = data_in[i];
      @(negedge clk_tb);    
    end
  end
endtask

initial begin
    // intializing the RAM with zeros
    $readmemh("mem.dat",dut.RAM_block.mem);

    // check reset
    rst_n_tb=0;
    MOSI_tb=0;
    SS_n_tb=0;
    @(negedge clk_tb);

    
    // CHECK giving address to write in 
    rst_n_tb=1;
    repeat(2) @(negedge clk_tb);
    spi_send_10bits(10'b00_1111_1010);
    @(negedge clk_tb);
    SS_n_tb=1;
    @(negedge clk_tb);
    @(negedge clk_tb);

    // check writing data
    SS_n_tb=0;
    MOSI_tb=0;
    repeat(2) @(negedge clk_tb);
    spi_send_10bits(10'b01_1010_1111);
    @(negedge clk_tb);
    SS_n_tb=1;
    @(negedge clk_tb);
    @(negedge clk_tb);

    // check giving read address
    SS_n_tb=0;
    MOSI_tb=1;
    repeat(2) @(negedge clk_tb);
    spi_send_10bits(10'b10_1111_1010);
    @(negedge clk_tb);
    SS_n_tb=1;
    @(negedge clk_tb);
    @(negedge clk_tb);

    // check to read the written data before
    SS_n_tb=0;
    MOSI_tb=1;
    repeat(2) @(negedge clk_tb);
    spi_send_10bits(10'b11_0011_0011);
    @(negedge clk_tb);
    @(negedge clk_tb);
    repeat(2) @(negedge clk_tb);
    repeat(8) @(negedge clk_tb);

    SS_n_tb=1;
    @(negedge clk_tb);

    // check to read another data saved before in memory
    // first read address state
    SS_n_tb=0;
    MOSI_tb=1;
    repeat(2) @(negedge clk_tb);
    spi_send_10bits(10'b10_0011_0011);
    @(negedge clk_tb);
    SS_n_tb=1;
    @(negedge clk_tb);
    @(negedge clk_tb);

    // second read data state
    SS_n_tb=0;
    MOSI_tb=1;
    repeat(2) @(negedge clk_tb);
    spi_send_10bits(10'b11_0011_0011);
    @(negedge clk_tb);
    @(negedge clk_tb);
    repeat(2) @(negedge clk_tb);
    repeat(8) @(negedge clk_tb);

    $stop;
end


endmodule