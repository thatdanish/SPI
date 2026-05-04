`default_nettype none

module spi_master #(
    parameter DWIDTH = 32,
    parameter CPOL = 0,
    parameter CPHA = 1
) (
    input clk_i,
    input rst_i,
    input miso_i,
    input data_valid_i,
    input logic[DWIDTH-1:0] data_i,
    output logic tx_ready_o,
    output cs_o,
    output logic s_clk_o,
    output logic mosi_o
);

// assert (CPOL == 0 && CPHA == 1) 
// else   $fatal("Only CPOL: 0 & CPHA: 1 is supported");

typedef enum bit[1:0] { IDLE, SCLK, DATA } state_t;
logic [5:0] counter_32;
logic [DWIDTH-1:0] data;
bit counter_32_indication;
state_t current_state, next_state;

assign counter_32_indication = (counter_32 == DWIDTH-1);
assign cs_o = (current_state != DATA);
assign tx_ready_o = (current_state == IDLE);

always_ff @( posedge clk_i ) begin 
    if (!rst_i) begin
        counter_32 <= 'd0;
        data <= 'd0;
    end else begin
        data <= (data_valid_i == 1'b1)  ? data_i : data;
        if (current_state == DATA) begin
            counter_32 <= (counter_32 == DWIDTH-1) ? 'd0 : counter_32 + 'd1;
        end else counter_32 <= 'd0;
    end  
end

// Master FSM

always_ff @( posedge clk_i ) begin 
    if (!rst_i) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

always_comb begin 
    next_state = IDLE;
    case (current_state)
        IDLE: begin
            if (data_valid_i == 1'b1) next_state = SCLK;
        end 
        SCLK: begin
            next_state = DATA;
        end
        DATA: begin
            if (counter_32_indication == 1'b1) next_state = IDLE;
            else next_state = DATA;
        end
        default: next_state = IDLE;
    endcase  
end

always_comb begin 
    case (current_state)
        IDLE: begin
            s_clk_o = 1'b0;
            mosi_o = 'd0;
        end 
        SCLK: begin
            s_clk_o = clk_i;
            mosi_o = 'd0;
        end
        DATA: begin
            s_clk_o = clk_i;
            mosi_o = data[counter_32];
        end
        default: begin 
            mosi_o = 'd0;
            s_clk_o = 1'b0;
        end
    endcase   
end

endmodule