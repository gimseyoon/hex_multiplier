`timescale 1ns / 1ps

module ascii2hex (
    input  wire [7:0] ascii0,  // 상위 A의 upper nibble (예: '0'~'F')
    input  wire [7:0] ascii1,  // 상위 A의 lower nibble
    input  wire [7:0] ascii2,  // 하위 B의 upper nibble
    input  wire [7:0] ascii3,  // 하위 B의 lower nibble
    input  wire [2:0] top_state,
    output reg  [7:0] hex_a,   // 변환된 A
    output reg  [7:0] hex_b    // 변환된 B
);

    function [3:0] ascii_to_nibble;
        input [7:0] ascii;
        begin
            if (ascii >= "0" && ascii <= "9")
                ascii_to_nibble = ascii - "0";
            else if (ascii >= "A" && ascii <= "F")
                ascii_to_nibble = ascii - "A" + 4'd10;
            else if (ascii >= "a" && ascii <= "f")
                ascii_to_nibble = ascii - "a" + 4'd10;
            else
                ascii_to_nibble = 4'h0;  // 잘못된 문자 처리
        end
    endfunction

    always @(*) begin
        hex_a = {ascii_to_nibble(ascii0), ascii_to_nibble(ascii1)};
        hex_b = {ascii_to_nibble(ascii2), ascii_to_nibble(ascii3)};
    end
endmodule
