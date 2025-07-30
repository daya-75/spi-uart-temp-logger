`timescale 1ns / 1ps

module tb_temp_logger;

    reg clk = 0;
    reg rst;
    wire uart_tx;
    wire [1:0] status_leds;

    temp_logger_top DUT (
        .clk(clk),
        .rst(rst),
        .uart_tx(uart_tx),
        .status_leds(status_leds)
    );

    // Clock generation (10 MHz)
    always #50 clk = ~clk;

    initial begin
        $display("Simulation Started");
        rst = 1;
        #200;
        rst = 0;

        // Run for some seconds (e.g. 12 seconds simulated)
        #120000000;

        $display("Simulation Complete");
        $stop;
    end

endmodule
