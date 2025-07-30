//   ├── temp_logger_top.v         # Top-level integration module

module temp_logger_top (
    input wire clk,
    input wire rst,
    output wire uart_tx,
    output wire [1:0] status_leds
);

    // SPI ADC Simulation signals
    wire [7:0] sensor_data;
    wire sensor_ready;
    reg adc_trigger;

    // SPI FSM outputs
    wire spi_start;
    wire [7:0] temp_out;
    wire temp_valid;

    // Shift Register Storage
    wire [7:0] temp_fifo [9:0];
    reg store_temp;

    // UART
    reg [3:0] uart_idx;
    reg uart_trigger;
    wire uart_busy;
    reg [7:0] uart_data;
    reg uart_active;

    // LED Status
    assign status_leds[0] = uart_active;
    assign status_leds[1] = (uart_idx == 4'd10); 
    reg [23:0] sec_counter;
    wire one_sec_pulse = (sec_counter == 24'd9999999);

    always @(posedge clk or posedge rst) begin
        if (rst)
            sec_counter <= 0;
        else if (sec_counter == 24'd9999999)
            sec_counter <= 0;
        else
            sec_counter <= sec_counter + 1;
    end

    always @(posedge clk)
        adc_trigger <= one_sec_pulse;

    always @(posedge clk)
        store_temp <= temp_valid;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            uart_trigger <= 0;
            uart_idx <= 0;
            uart_active <= 0;
        end else if (uart_active == 0 && uart_busy == 0) begin
            uart_trigger <= 1;
            uart_idx <= 0;
            uart_active <= 1;
        end else if (uart_trigger) begin
            uart_trigger <= 0;
        end else if (uart_active && uart_busy == 0 && uart_idx < 10) begin
            uart_data <= temp_fifo[uart_idx];
            uart_trigger <= 1;
            uart_idx <= uart_idx + 1;
        end else if (uart_idx == 10)
            uart_active <= 0;
    end

    // --- Module Instantiations ---
    spi_adc_sim u_adc (
        .clk(clk),
        .start(adc_trigger),
        .data_out(sensor_data),
        .data_ready(sensor_ready)
    );

    spi_master u_spi (
        .clk(clk),
        .rst(rst),
        .start(adc_trigger),
        .spi_data_in(sensor_data),
        .spi_data_ready(sensor_ready),
        .spi_start(spi_start),
        .temp_out(temp_out),
        .data_valid(temp_valid)
    );

    shift_register_10 u_fifo (
        .clk(clk),
        .rst(rst),
        .in(temp_out),
        .load(store_temp),
.out0(temp_fifo[0]),
.out1(temp_fifo[1]),
.out2(temp_fifo[2]),
.out3(temp_fifo[3]),
.out4(temp_fifo[4]),
.out5(temp_fifo[5]),
.out6(temp_fifo[6]),
.out7(temp_fifo[7]),
.out8(temp_fifo[8]),
.out9(temp_fifo[9])
    );

    uart_tx u_uart (
        .clk(clk),
        .rst(rst),
        .tx_start(uart_trigger),
        .tx_data(uart_data),
        .tx(uart_tx),
        .tx_busy(uart_busy)
    );

endmodule

