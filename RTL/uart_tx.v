`timescale 1ns / 1ps

module uart_tx #(
    parameter DBIT = 8,           // 데이터 비트 수
    parameter SB_TICK = 16        // stop bit 기간
)(
    input  wire       clk,
    input  wire       reset,
    input  wire       tx_start,
    input  wire [7:0] tx_data,
    input  wire       s_tick,     // Baud tick (보통 16배속)
    output reg        tx,
    output reg        tx_busy     // 전송 중
);

    localparam [1:0] IDLE  = 2'b00,
                     START = 2'b01,
                     DATA  = 2'b10,
                     STOP  = 2'b11;

    reg [1:0] state_reg, state_next;
    reg [3:0] s_reg, s_next;   // sample counter
    reg [2:0] n_reg, n_next;   // bit counter
    reg [7:0] b_reg, b_next;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_reg <= IDLE;
            s_reg     <= 0;
            n_reg     <= 0;
            b_reg     <= 0;
            tx        <= 1'b1;
            tx_busy   <= 1'b0;
        end else begin
            state_reg <= state_next;
            s_reg     <= s_next;
            n_reg     <= n_next;
            b_reg     <= b_next;
        end
    end

    // FSM
    always @(*) begin
        state_next = state_reg;
        s_next     = s_reg;
        n_next     = n_reg;
        b_next     = b_reg;

        case (state_reg)
            IDLE: begin
                tx = 1'b1;
                tx_busy = 1'b0;
                if (tx_start) begin
                    state_next = START;
                    b_next = tx_data;
                    s_next = 0;
                    tx_busy = 1'b1;
                end
            end

            START: begin
                tx = 1'b0;
                tx_busy = 1'b1;
                if (s_tick) begin
                    if (s_reg == 15) begin
                        s_next = 0;
                        n_next = 0;
                        state_next = DATA;
                    end else
                        s_next = s_reg + 1;
                end
            end

            DATA: begin
                tx = b_reg[0];
                tx_busy = 1'b1;
                if (s_tick) begin
                    if (s_reg == 15) begin
                        s_next = 0;
                        b_next = b_reg >> 1;
                        if (n_reg == (DBIT-1))
                            state_next = STOP;
                        else
                            n_next = n_reg + 1;
                    end else
                        s_next = s_reg + 1;
                end
            end

            STOP: begin
                tx = 1'b1;
                tx_busy = 1'b1;
                if (s_tick) begin
                    if (s_reg == (SB_TICK - 1)) begin
                        state_next = IDLE;
                        tx_busy = 1'b0;
                    end else
                        s_next = s_reg + 1;
                end
            end
        endcase
    end

endmodule
