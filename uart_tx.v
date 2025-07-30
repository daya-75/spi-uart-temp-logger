module uart_tx (
    input clk,
    input rst,
    input tx_start,
    input [7:0] tx_data,
    output reg tx,
    output reg tx_busy
);
    parameter CLK_PER_BIT = 87;

    reg [7:0] tx_shift;
    reg [3:0] bit_index;
    reg [15:0] clk_cnt;
    reg [1:0] state;

    parameter IDLE = 2'b00;
    parameter START = 2'b01;
    parameter DATA = 2'b10;
    parameter STOP = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1'b1;
            tx_busy <= 0;
            clk_cnt <= 0;
            bit_index <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    tx <= 1'b1;
                    tx_busy <= 0;
                    if (tx_start) begin
                        tx_shift <= tx_data;
                        state <= START;
                        tx_busy <= 1;
                        clk_cnt <= 0;
                    end
                end

                START: begin
                    tx <= 0;
                    if (clk_cnt < CLK_PER_BIT)
                        clk_cnt <= clk_cnt + 1;
                    else begin
                        clk_cnt <= 0;
                        state <= DATA;
                        bit_index <= 0;
                    end
                end

                DATA: begin
                    tx <= tx_shift[bit_index];
                    if (clk_cnt < CLK_PER_BIT)
                        clk_cnt <= clk_cnt + 1;
                    else begin
                        clk_cnt <= 0;
                        if (bit_index < 7)
                            bit_index <= bit_index + 1;
                        else
                            state <= STOP;
                    end
                end

                STOP: begin
                    tx <= 1;
                    if (clk_cnt < CLK_PER_BIT)
                        clk_cnt <= clk_cnt + 1;
                    else begin
                        state <= IDLE;
                        tx_busy <= 0;
                    end
                end
            endcase
        end
    end
endmodule
