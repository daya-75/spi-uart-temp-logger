module spi_master (
    input clk,
    input rst,
    input start,
    input [7:0] spi_data_in,
    input spi_data_ready,
    output reg spi_start,
    output reg [7:0] temp_out,
    output reg data_valid
);
    reg [1:0] state, next_state;

    parameter IDLE = 2'b00;
    parameter REQUEST = 2'b01;
    parameter WAIT = 2'b10;
    parameter DONE = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        spi_start = 0;
        data_valid = 0;
        next_state = state;

        case (state)
            IDLE: begin
                if (start)
                    next_state = REQUEST;
            end
            REQUEST: begin
                spi_start = 1;
                next_state = WAIT;
            end
            WAIT: begin
                if (spi_data_ready)
                    next_state = DONE;
            end
            DONE: begin
                data_valid = 1;
                next_state = IDLE;
            end
        endcase
    end

    always @(posedge clk) begin
        if (state == DONE)
            temp_out <= spi_data_in;
    end
endmodule

