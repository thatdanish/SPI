module  spi_master_tb();

parameter CLOCKPERIOD = 100;
parameter DWIDTH = 32;

logic clk_i = 1'b0;
logic rst_i = 1'b0;
logic data_valid_i = 1'b0;
logic mosi_o, miso_i, tx_ready_o, cs_o, s_clk_o;
logic [DWIDTH-1:0] data_i;

always #(CLOCKPERIOD/2) clk_i = ~clk_i;

// Testcase

initial begin
    #(20*CLOCKPERIOD);
    @(posedge clk_i);
    rst_i = 1'b1;

    #(2*CLOCKPERIOD);
    
    wait(tx_ready_o == 1'b1);
    #(CLOCKPERIOD);
    @(posedge clk_i);
    data_valid_i = 1'b1;
    data_i = 'd673;

    #(CLOCKPERIOD);
    @(posedge clk_i);
    data_valid_i = 1'b0;

    #(CLOCKPERIOD);
    wait(tx_ready_o == 1'b1);
    #(CLOCKPERIOD);
    @(posedge clk_i);
    data_valid_i = 1'b1;
    data_i = 'd121;
    
    #(CLOCKPERIOD);
    @(posedge clk_i);
    data_valid_i = 1'b0;
end

// DUT

spi_master #(
   .DWIDTH(DWIDTH) 
) spi_master_i (
    .clk_i,
    .rst_i,
    .miso_i,
    .data_valid_i,
    .data_i,
    .tx_ready_o,
    .cs_o,
    .s_clk_o,
    .mosi_o
);

initial begin
    #(1000*CLOCKPERIOD);
    $finish;
end

initial begin
    $dumpfile("./temp/spi_master.vcd");
    $dumpvars(0, spi_master_tb);
end

endmodule