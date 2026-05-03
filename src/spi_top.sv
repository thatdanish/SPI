module spi_top #(
    parameter DWIDTH = 32
) (
    input clk_i,
    input rst_i,
    input data_valid_i,
    input logic [DWIDTH-1:0] data_i,
    output tx_ready_o,
    output data_valid_o,
    output logic [DWIDTH-1:0] data_o
);

logic miso, mosi, cs, s_clk;

spi_master #(
    .DWIDTH(DWIDTH)
) spi_master_i (
    .clk_i,
    .rst_i,
    .miso_i(miso),
    .data_valid_i,
    .data_i,
    .tx_ready_o,
    .cs_o(cs),
    .s_clk_o(s_clk),
    .mosi_o(mosi)
);

spi_slave #(
    .DWIDTH(DWIDTH)
) spi_slave_i (
    .clk_i,
    .rst_i,
    .cs_i(cs),
    .s_clk_i(s_clk),
    .mosi_i(mosi),
    .miso_o(miso),
    .data_valid_o,
    .data_o
);


endmodule