module RAM_tb();
reg clk_tb,rst_n_tb,rx_valid_tb;
reg [9:0] din_tb;
wire tx_valid_tb;
wire [7:0] dout_tb; 

integer i;

RAM dut (clk_tb,rst_n_tb,rx_valid_tb,din_tb,tx_valid_tb,dout_tb);

initial begin
    clk_tb = 0;
    forever begin
        #10
        clk_tb = ~clk_tb;
    end
end

initial begin
    // initializing  the RAM with zeros
    $readmemh("mem.dat",dut.mem);

    // check reset
    rst_n_tb=0;
    din_tb=0;
    rx_valid_tb=0;
    @(negedge clk_tb);

    rst_n_tb=1;
    rx_valid_tb=1;
    // check write with address and data
    repeat(10) begin
      // check writng the address
      din_tb[9:8] = 2'b00;
      for(i=0;i<8;i=i+1) begin
        din_tb[i]=$random;
      end
      @(negedge clk_tb);

      // check to write the data in previous address  
      din_tb[9:8] = 2'b01;
      for(i=0;i<8;i=i+1) begin
        din_tb[i]=$random;
      end
      @(negedge clk_tb);
    end

    // check reading command
    repeat(10) begin
      // check reading the address
      din_tb[9:8] = 2'b10;
      for(i=0;i<8;i=i+1) begin
        din_tb[i]=$random;
      end
      @(negedge clk_tb);

      // check to read the data in previous address  
      din_tb[9:8] = 2'b11;
      for(i=0;i<8;i=i+1) begin
        din_tb[i]=$random;
      end
      @(negedge clk_tb);
    end

    $stop;
end

endmodule
