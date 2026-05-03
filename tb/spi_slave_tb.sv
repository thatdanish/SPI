module  spi_slave_tb();

parameter CLOCKPERIOD = 100;
parameter DWIDTH = 8;

logic clk_i = 1'b0;
logic rst_i = 1'b0;
logic cs_i = 1'b1;
logic clk_enable = 1'b0;
logic mosi_i, miso_o, data_valid_o;
logic [DWIDTH-1:0] data_o;

always #(CLOCKPERIOD/2) clk_i = ~clk_i;

// Testcase

initial begin
    #(10*CLOCKPERIOD);
    @(posedge clk_i);
    rst_i = 1'b1;

    #(10*CLOCKPERIOD);
    cs_i = 1'b0;

    // Test case 1 : 11001100
    #(CLOCKPERIOD);
    @(posedge clk_i);
    clk_enable = 1'b1;
    mosi_i = 1'b1;
    
    #(CLOCKPERIOD);
    @(posedge clk_i);
    mosi_i = 1'b1;
    
    #(CLOCKPERIOD);
    @(posedge clk_i);
    mosi_i = 1'b0;
    
    #(CLOCKPERIOD);
    @(posedge clk_i);
    mosi_i = 1'b0;
    
    #(CLOCKPERIOD);
    @(posedge clk_i);
    mosi_i = 1'b1;
    
    #(CLOCKPERIOD);
    @(posedge clk_i);
    mosi_i = 1'b1;
    
    #(CLOCKPERIOD);
    @(posedge clk_i);
    mosi_i = 1'b0;
    
    #(CLOCKPERIOD);
    @(posedge clk_i);
    mosi_i = 1'b0;

    #(CLOCKPERIOD);
    cs_i = 1'b1;
    clk_enable = 1'b0;    
end

// DUT

spi_slave #(
   .DWIDTH(DWIDTH) 
) spi_slave_i (
    .clk_i,
    .rst_i,
    .cs_i,
    .s_clk_i(clk_i && clk_enable),
    .mosi_i,
    .miso_o,
    .data_valid_o,
    .data_o
);

initial begin
    #(1000*CLOCKPERIOD);
    $finish;
end

initial begin
    $dumpfile("./temp/spi_slave.vcd");
    $dumpvars(0, spi_slave_tb);
end

endmodule