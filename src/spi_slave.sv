`default_nettype  none

module spi_slave #(
    parameter DWIDTH = 32
) (
    input clk_i,
    input rst_i,
    input cs_i,
    input s_clk_i,
    input mosi_i,
    output miso_o,
    output data_valid_o,
    output logic[DWIDTH-1:0]data_o
);

typedef enum bit[1:0] { IDLE, DATA, DATAVALID } state_t;
bit [DWIDTH-1:0] data;
state_t current_state, next_state;
bit [5:0] counter_32;
bit counter_32_indication;

assign counter_32_indication = (counter_32 == DWIDTH-1);
assign data_valid_o = (current_state == DATAVALID);

always_ff @( posedge s_clk_i ) begin
    if (!rst_i) begin
        counter_32 <= 'd0;
        data <= 'd0;
    end else begin
        if (cs_i == 1'b0) begin
            data[counter_32] <= mosi_i;
            counter_32 <= (counter_32 == DWIDTH-1) ? 'd0 : counter_32 + 'd1;            
        end else begin
            counter_32 <= 'd0;
            data <= 'd0;
        end 
    end
end

// Slave FSM

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
            if (cs_i == 1'b0) next_state = DATA;
        end
        DATA: begin
            if (counter_32_indication == 1'b1) next_state = DATAVALID;
            else next_state = DATA;
        end
        DATAVALID: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase 
end

always_comb begin 
    case (current_state)
        IDLE: begin
            data_o = 'd0;
        end
        DATA: begin
            data_o = 'd0;
        end
        DATAVALID: begin
            data_o = data;
        end
        default: data_o = 'd0;
    endcase 
end
endmodule