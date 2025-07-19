module baud_generator #(
    parameter CLOCK_FREQ = 40_000_000,
    parameter BAUD_RATE = 115200
)(
    input clk,
    input reset,
    output reg tick
);

    localparam integer COUNT_MAX = CLOCK_FREQ / (BAUD_RATE * 16);  // 16x ¿À¹ö»ùÇÃ¸µ
    reg [15:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            tick <= 0;
        end else if (count == COUNT_MAX - 1) begin
            count <= 0;
            tick <= 1;
        end else begin
            count <= count + 1;
            tick <= 0;
        end
    end
endmodule
