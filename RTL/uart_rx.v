`timescale 1ns / 1ps

module uart_rx #(
    parameter DBIT = 8,            // 데이터 비트 수
    parameter SB_TICK = 16         // Stop bit 기간 (16 tick = 1bit)
)(
    input  wire       clk,
    input  wire       reset,
    input  wire       rx,
    input  wire       s_tick,      // Baud generator의 tick (예: 16x oversampling)
    output reg [7:0]  rx_data,     // 수신한 데이터
    output reg        rx_done      // 1클럭 동안 high (데이터 수신 완료)
);

    localparam [1:0] IDLE  = 2'b00,
                     START = 2'b01,
                     DATA  = 2'b10,
                     STOP  = 2'b11;

    reg [1:0] state_reg, state_next;
    reg [3:0] s_reg, s_next;     // sample count
    reg [2:0] n_reg, n_next;     // bit count
    reg [7:0] b_reg, b_next;     // shift register
    reg       rx_done_next;

    // state & register update
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_reg <= IDLE;
            s_reg     <= 0;
            n_reg     <= 0;
            b_reg     <= 0;
            rx_done   <= 0;
        end else begin
            state_reg <= state_next;
            s_reg     <= s_next;
            n_reg     <= n_next;
            b_reg     <= b_next;
            rx_done   <= rx_done_next;
        end
    end

    // FSM
    always @(*) begin
        state_next = state_reg;
        s_next     = s_reg;
        n_next     = n_reg;
        b_next     = b_reg;
        rx_done_next = 1'b0;

        case (state_reg)
            IDLE: begin
                if (~rx) begin // start bit 감지
                    state_next = START;
                    s_next = 0;
                end
            end

            START: begin
                if (s_tick) begin
                    if (s_reg == 7) begin // 중간지점 샘플링
                        state_next = DATA;
                        s_next = 0;
                        n_next = 0;
                    end else
                        s_next = s_reg + 1;
                end
            end

            DATA: begin
                if (s_tick) begin
                    if (s_reg == 15) begin
                        s_next = 0;
                        b_next = {rx, b_reg[7:1]}; // LSB first
                        if (n_reg == (DBIT-1))
                            state_next = STOP;
                        else
                            n_next = n_reg + 1;
                    end else
                        s_next = s_reg + 1;
                end
            end

            STOP: begin
                if (s_tick) begin
                    if (s_reg == (SB_TICK - 1)) begin
                        state_next = IDLE;
                        rx_done_next = 1'b1;
                    end else
                        s_next = s_reg + 1;
                end
            end
        endcase
    end

    // 수신된 바이트 출력
    always @(posedge clk)
        if (rx_done)
            rx_data <= b_reg;

endmodule
