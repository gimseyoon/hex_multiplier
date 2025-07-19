`timescale 1ns / 1ps

module top_uart_hex_multiplier (
    input  wire clk,
    input  wire reset,       // Active-high
    input  wire rx,
    output wire tx
);

    // 내부 신호
    wire       tick;
    wire [7:0] rx_data;
    wire       rx_done;
    wire       tx_busy;
    reg        tx_start;
    reg  [7:0] tx_data;

    // ASCII 입력 버퍼
    reg [7:0] ascii [0:3];
    reg [1:0] ascii_cnt;

    // FSM 상태 정의
    reg [2:0] state;
    localparam S_IDLE   = 3'd0,
               S_RECV   = 3'd1,
               S_PARSE  = 3'd2,
               S_WAIT   = 3'd3,
               S_TO_ASC = 3'd4,
               S_SEND   = 3'd5;
    reg enable;
    wire [7:0] hex_a, hex_b;
    wire [16:0] result;
    wire done;

    // ASCII 변환 결과
    wire [7:0] ascii0, ascii1, ascii2, ascii3;
    reg  [1:0] send_idx;
    
    reg [7:0] ascii_buf [0:3];  // 레지스터 버퍼
    wire rx_all_done;
    assign rx_all_done = (state == S_RECV) && rx_done && (ascii_cnt == 2'd3);


    
    // ========== Baud Generator ==========
    baud_generator baudgen (
        .clk(clk),
        .reset(reset),
        .tick(tick)
    );

    // ========== UART Receiver ==========
    uart_rx uart_rx_inst (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .s_tick(tick),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    // ========== UART Transmitter ==========
    uart_tx uart_tx_inst (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .s_tick(tick),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    // ========== ASCII → HEX ==========
    ascii2hex a2h (
        .ascii0(ascii[0]),
        .ascii1(ascii[1]),
        .ascii2(ascii[2]),
        .ascii3(ascii[3]),
        .top_state(state),
        .hex_a(hex_a),
        .hex_b(hex_b)
    );

    // ========== HEX Multiplier ==========
    hex_multiplier mul (
        .clk(clk),
        .rst_n(~reset),
        .enable(enable),
        .in_1(hex_a),
        .in_2(hex_b),
        .top_state(state),
        .out_data(result),
        .done(done)
    );

    // ========== HEX → ASCII ==========
    hex_to_ascii h2a (
        .clk(clk),
        .hex_in(result[15:0]),  // 하위 16비트만 사용
        .ascii0(ascii0),
        .ascii1(ascii1),
        .ascii2(ascii2),
        .ascii3(ascii3)
    );

    // ========== FSM ==========
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S_IDLE;
            ascii_cnt <= 0;
            tx_start <= 0;
            tx_data <= 8'h00;
            send_idx <= 0;
            enable <= 0;
        end else begin
            tx_start <= 0;

            case (state)
                S_IDLE: begin
                enable <= 0;
                    ascii_cnt <= 0;
                    if (rx_done)
                        state <= S_RECV;
                end

                S_RECV: begin
                    
                    
                    if (rx_done) begin
                        ascii[ascii_cnt] <= rx_data;
                        
                        if (ascii_cnt == 2'd3)
                            state <= S_PARSE;
                        else
                            ascii_cnt <= ascii_cnt + 1;
                    end
                    if(rx_all_done) begin
                        enable <= 1;
                    end
                end

                S_PARSE: begin
                    // hex_a, hex_b는 자동 갱신됨
                    state <= S_WAIT;
                    enable <= 1;
                end

                S_WAIT: begin
                
                        enable <= 1;
                    if (done)
                        state <= S_TO_ASC;
                        
                end

                S_TO_ASC: begin
                    enable <= 0;
                    send_idx <= 0;
                    
                    ascii_buf[0] <= ascii0;
                    ascii_buf[1] <= ascii1;
                    ascii_buf[2] <= ascii2;
                    ascii_buf[3] <= ascii3;
                
                    state <= S_SEND;
                end

                S_SEND: begin
                    enable <= 0;
                    if (!tx_busy && !tx_start) begin
                        tx_data <= ascii_buf[send_idx]; 
                        tx_start <= 1'b1;
                
                        if (send_idx == 2'd3)
                            state <= S_IDLE;
                        else
                            send_idx <= send_idx + 1;
                    end
                end
            endcase
        end
    end

endmodule
