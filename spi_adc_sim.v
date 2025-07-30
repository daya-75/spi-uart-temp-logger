//  ├── spi_adc_sim.v      

module spi_adc_sim (
    input clk,
    input start,
    output reg [7:0] data_out,
    output reg data_ready
);
    always @(posedge clk) begin
        if (start) begin
            data_out <= $random % 256;
            data_ready <= 1'b1;
        end else begin
            data_ready <= 1'b0;
        end
    end
endmodule
