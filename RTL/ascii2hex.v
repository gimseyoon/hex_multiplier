`timescale 1ns / 1ps

module ascii2hex (
    input  wire [7:0] ascii0,  // ���� A�� upper nibble (��: '0'~'F')
    input  wire [7:0] ascii1,  // ���� A�� lower nibble
    input  wire [7:0] ascii2,  // ���� B�� upper nibble
    input  wire [7:0] ascii3,  // ���� B�� lower nibble
    input  wire [2:0] top_state,
    output reg  [7:0] hex_a,   // ��ȯ�� A
    output reg  [7:0] hex_b    // ��ȯ�� B
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
                ascii_to_nibble = 4'h0;  // �߸��� ���� ó��
        end
    endfunction

    always @(*) begin
        hex_a = {ascii_to_nibble(ascii0), ascii_to_nibble(ascii1)};
        hex_b = {ascii_to_nibble(ascii2), ascii_to_nibble(ascii3)};
    end
endmodule
