module  spi_top_tb();

parameter CLOCKPERIOD = 10;
parameter DWIDTH = 8;

logic clk_i = 1'b0;
logic rst_i = 1'b0;
logic data_valid_i = 1'b0;
logic tx_ready_o, data_valid_o;
logic [DWIDTH-1:0] data_i, data_o;

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

spi_top #(
   .DWIDTH(DWIDTH) 
) spi_top_i (
    .clk_i,
    .rst_i,
    .data_valid_i,
    .data_i,
    .tx_ready_o,
    .data_valid_o,
    .data_o
);

initial begin
    #(500*CLOCKPERIOD);
    $finish;
end

initial begin
    $dumpfile("./temp/spi_top.vcd");
    $dumpvars(0, spi_top_tb);
end

endmodule