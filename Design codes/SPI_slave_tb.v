module SPI_slave_tb();
reg MOSI_tb,SS_n_tb,clk_tb,rst_n_tb,tx_valid_tb;
reg [7:0]tx_data_tb;
wire MISO_tb,rx_valid_tb; 
wire [9:0]rx_data_tb;
reg MISO_expected,rx_valid_expected; 
reg [9:0]rx_data_expected;

SPI_slave dut (MOSI_tb,SS_n_tb,clk_tb,rst_n_tb,tx_valid_tb,tx_data_tb,MISO_tb,rx_valid_tb,rx_data_tb);

initial begin
    clk_tb = 0;
    forever begin
        #10
        clk_tb = ~clk_tb;
    end
end

// used this task to sent 10 bits in serial to SPI
// the task made the test easier 
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
    // check reset
    rst_n_tb=0;
    MOSI_tb=0;
    SS_n_tb=0;
    tx_valid_tb=0;
    tx_data_tb=0;
    MISO_expected=0;
    rx_data_expected=0;
    rx_valid_expected=0;
    @(negedge clk_tb);
    if (MISO_tb != MISO_expected || rx_data_expected != rx_data_tb || rx_valid_expected != rx_valid_tb) begin
        $display("error in reset");
        $stop;
    end
    
    // CHECK giving address to write in 
    rst_n_tb=1;
    repeat(2) @(negedge clk_tb); // goes to WRITE state
    spi_send_10bits(10'b00_1111_1010);
    rx_data_expected=10'b00_1111_1010;
    @(negedge clk_tb);
    rx_valid_expected=1;
    SS_n_tb=1;
    if (MISO_tb != MISO_expected || rx_data_expected != rx_data_tb || rx_valid_expected != rx_valid_tb) begin
        $display("error in write address command");
        $stop;
    end    
    @(negedge clk_tb); // enter the IDLE state
    @(negedge clk_tb); // give the rx_ valid output to execute
    rx_valid_expected=0;
    if (rx_valid_expected != rx_valid_tb) begin
        $display("error in backing to IDLE from WRITE address");
        $stop;
    end   


    // check writing data
    SS_n_tb=0;
    MOSI_tb=0;
    repeat(2) @(negedge clk_tb); // goes to WRITE state
    spi_send_10bits(10'b01_1010_1111);
    rx_data_expected=10'b01_1010_1111;
    @(negedge clk_tb);
    rx_valid_expected=1;
    SS_n_tb=1;
    if (MISO_tb != MISO_expected || rx_data_expected != rx_data_tb || rx_valid_expected != rx_valid_tb) begin
        $display("error in write data command");
        $stop;
    end
    @(negedge clk_tb); // enter the IDLE state
    @(negedge clk_tb); // give the rx_ valid output to execute
    rx_valid_expected=0;
    if (rx_valid_expected != rx_valid_tb) begin
        $display("error in backing to IDLE from WRTIE data");
        $stop;
    end   

    // check giving reading address 
    SS_n_tb=0;
    MOSI_tb=1;
    repeat(2) @(negedge clk_tb); // goes to READ_ADD state
    spi_send_10bits(10'b10_1100_0011);
    rx_data_expected=10'b10_1100_0011;
    @(negedge clk_tb);
    rx_valid_expected=1;
    SS_n_tb=1;
    if (MISO_tb != MISO_expected || rx_data_expected != rx_data_tb || rx_valid_expected != rx_valid_tb) begin
        $display("error in read address command");
        $stop;
    end
    @(negedge clk_tb); // enter the IDLE state
    @(negedge clk_tb); // give the rx_ valid output to execute
    rx_valid_expected=0;
    if (rx_valid_expected != rx_valid_tb) begin
        $display("error in backing to IDLE from READ ADD");
        $stop;
    end   

    // check read data of the address given 
    SS_n_tb=0;
    MOSI_tb=1;
    repeat(2) @(negedge clk_tb); // goes to READ_DATA state
    spi_send_10bits(10'b11_0011_0011);
    rx_data_expected=10'b11_0011_0011;
    @(negedge clk_tb);
    rx_valid_expected=1;
    @(negedge clk_tb);
    if (MISO_tb != MISO_expected || rx_data_expected != rx_data_tb || rx_valid_expected != rx_valid_tb) begin
        $display("error in read data command");
        $stop;
    end
    repeat(2) @(negedge clk_tb); // equivalent to the number of cycles till RAM gives tx_valid "1"
    tx_valid_tb=1;
    tx_data_tb=8'b0110_1111;
    rx_valid_expected=0;
    repeat(8) @(negedge clk_tb);

    SS_n_tb=1; // back to idle

    $stop;
end

endmodule
