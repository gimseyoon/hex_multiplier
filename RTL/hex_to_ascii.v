module hex_to_ascii (
    input  wire        clk,
    input  wire [15:0] hex_in,
    output reg  [7:0]  ascii0,
    output reg  [7:0]  ascii1,
    output reg  [7:0]  ascii2,
    output reg  [7:0]  ascii3
);

    function [7:0] nibble_to_ascii;
        input [3:0] nib;
        begin
            if (nib < 10)
                nibble_to_ascii = 8'd48 + nib;  // '0' ~ '9'
            else
                nibble_to_ascii = 8'd55 + nib;  // 'A' ~ 'F'
        end
    endfunction

    always @(posedge clk) begin
        ascii0 <= nibble_to_ascii(hex_in[15:12]);
        ascii1 <= nibble_to_ascii(hex_in[11:8]);
        ascii2 <= nibble_to_ascii(hex_in[7:4]);
        ascii3 <= nibble_to_ascii(hex_in[3:0]);
    end

endmodule
