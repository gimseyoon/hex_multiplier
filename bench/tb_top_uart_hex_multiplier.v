`timescale 1ns / 1ps

module tb_top_uart_hex_multiplier;

    // �⺻ ��ȣ
    reg clk = 0;
    reg reset = 1;
    wire tx;
    wire rx;

    // UART ���� �����
    wire uart_line;
    reg tx_driver = 1'b1;
    assign rx = uart_line;
    assign uart_line = tx_driver;

    // DUT
    top_uart_hex_multiplier dut (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .tx(tx)
    );

    // 40MHz clock
    always #12.5 clk = ~clk;

    parameter UART_BIT_DELAY = 8675;

    // UART �۽� �½�ũ
    task uart_send_byte;
        input [7:0] data;
        integer j;
        begin
            tx_driver = 0;
            #(UART_BIT_DELAY);
            for (j = 0; j < 8; j = j + 1) begin
                tx_driver = data[j];
                #(UART_BIT_DELAY);
            end
            tx_driver = 1;
            #(UART_BIT_DELAY);
        end
    endtask

    // HEX �� ASCII ��ȯ �Լ�
    function [7:0] nibble_to_ascii;
        input [3:0] nib;
        begin
            nibble_to_ascii = (nib < 10) ? (8'd48 + nib) : (8'd55 + nib);
        end
    endfunction

    // ���� ����Ʈ ó���� ����
    reg [7:0] rx_byte;
    integer bit_idx, bit_idx_1;
    integer i,j,k;
    reg [7:0] hex_a, hex_b;
    
    
    initial begin
        $display("=== UART MULTIPLIER TEST START ===");
        #100;
        reset = 0;

        // ? �⺻ �׽�Ʈ ("3A5B")
        uart_send_byte("3");
        uart_send_byte("A");
        uart_send_byte("5");
        uart_send_byte("B");
        uart_send_byte(" ");

        // ��� ���� (�⺻)
        for (i = 0; i < 4; i = i + 1) begin
            wait(tx == 0);
            #(UART_BIT_DELAY / 2);
            #UART_BIT_DELAY;

            rx_byte = 0;
            for (bit_idx = 0; bit_idx < 8; bit_idx = bit_idx + 1) begin
                rx_byte[bit_idx] = tx;
                #(UART_BIT_DELAY);
            end
            $display("[�⺻ RX %0d] = %c", i, rx_byte);
            #(UART_BIT_DELAY);
        end

        // ? ���� �׽�Ʈ 20ȸ �ݺ�
        for (k = 0; k < 20; k = k + 1) begin
            
            hex_a = $urandom % 256;
            hex_b = $urandom % 256;

            $display("--- Test %0d: hex_a = %02h, hex_b = %02h ---", i, hex_a, hex_b);

            uart_send_byte(nibble_to_ascii(hex_a[7:4]));
            uart_send_byte(nibble_to_ascii(hex_a[3:0]));
            uart_send_byte(nibble_to_ascii(hex_b[7:4]));
            uart_send_byte(nibble_to_ascii(hex_b[3:0]));
            uart_send_byte(" "); // ������

            // ��� ����
            for (j = 0; j < 4; j = j+1) begin
                wait(tx == 0);
                #(UART_BIT_DELAY / 2);
                #UART_BIT_DELAY;

                rx_byte = 0;
                for (bit_idx_1 = 0; bit_idx_1 < 8; bit_idx_1 = bit_idx_1 + 1) begin
                    rx_byte[bit_idx_1] = tx;
                    #(UART_BIT_DELAY);
                end
                $display("  [RX %0d] = %c", j, rx_byte);
                #(UART_BIT_DELAY);
            end
        end

        $display("=== TEST DONE ===");
        #100;
        $finish;
    end

endmodule
