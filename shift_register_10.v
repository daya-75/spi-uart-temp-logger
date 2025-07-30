module shift_register_10 (
    input clk,
    input rst,
    input [7:0] in,
    input load,
    output [7:0] out0, out1, out2, out3, out4,
    output [7:0] out5, out6, out7, out8, out9
);
    reg [7:0] regs [9:0];

    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 10; i = i + 1)
                regs[i] <= 8'h00;
        end else if (load) begin
            for (i = 9; i > 0; i = i - 1)
                regs[i] <= regs[i - 1];
            regs[0] <= in;
        end
    end

    assign out0 = regs[0];
    assign out1 = regs[1];
    assign out2 = regs[2];
    assign out3 = regs[3];
    assign out4 = regs[4];
    assign out5 = regs[5];
    assign out6 = regs[6];
    assign out7 = regs[7];
    assign out8 = regs[8];
    assign out9 = regs[9];
endmodule
