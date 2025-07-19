`timescale 1ns / 1ps
module tb_top_hex_multiplier(
    );

parameter IDLE = 3'b000, COMPUTE_1 = 3'b001, COMPUTE_2 = 3'b010, COMPUTE_3 = 3'b011, COMPUTE_4 = 3'b100;

reg clk;
reg rst_n;
reg [7:0] in_1;
reg [7:0] in_2;
wire [16:0] out_data;
    


top_hex_multiplier uut (
    .clk(clk),
    .rst_n(rst_n),
    .in_1(in_1),
    .in_2(in_2),
    .out_data(out_data)
);


initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns 주기
end

initial begin
    // 초기값
    rst_n = 1;
    in_1 = 0;
    in_2 = 0;

    // 비동기 리셋
    #7 rst_n = 0;
    #10 rst_n = 1;
end

initial begin
    #20 in_1 = 8'h0A; in_2 = 8'h0B;
    #10 in_1 = 0; in_2 = 0;
    
    #150 in_1 = 8'h7C; in_2 = 8'h12;
    #10 in_1 = 0; in_2 = 0;
    
    #150 in_1 = 8'h5A; in_2 = 8'h21;
    #10 in_1 = 0; in_2 = 0;
    
    #150 in_1 = 8'hFF; in_2 = 8'h94;
    #10 in_1 = 0; in_2 = 0;
    
    #150 in_1 = 8'hFF; in_2 = 8'h94;
    #10 in_1 = 0; in_2 = 0;

    #150 in_1 = 8'hAB; in_2 = 8'hCD;
    #10 in_1 = 0; in_2 = 0;
    
    #150 in_1 = 8'h7E; in_2 = 8'hB2;
    #10 in_1 = 0; in_2 = 0;
    
    #150 in_1 = 8'h3D; in_2 = 8'hEF;
    #10 in_1 = 0; in_2 = 0;
    
    #150 in_1 = 8'hF1; in_2 = 8'h9B;
    #10 in_1 = 0; in_2 = 0;
    
    #150 in_1 = 8'hD4; in_2 = 8'hA7;
    #10 in_1 = 0; in_2 = 0;
    
    #150 in_1 = 8'hB6; in_2 = 8'h8F;
    #10 in_1 = 0; in_2 = 0;
    
    #150 in_1 = 8'hCE; in_2 = 8'hD3;
    #10 in_1 = 0; in_2 = 0;
    
    #150 in_1 = 8'h5F; in_2 = 8'h9D;
    #10 in_1 = 0; in_2 = 0;
    
    #150 in_1 = 8'hE9; in_2 = 8'hB8;
    #10 in_1 = 0; in_2 = 0;
    
    #150 in_1 = 8'hF2; in_2 = 8'h6A;
    #10 in_1 = 0; in_2 = 0;
    
    #150 in_1 = 8'hC7; in_2 = 8'h5E;
    #10 in_1 = 0; in_2 = 0;
    
    #150 in_1 = 8'hAD; in_2 = 8'hBE;
    #10 in_1 = 0; in_2 = 0;
    
    #150 in_1 = 8'h4B; in_2 = 8'hFC;
    #10 in_1 = 0; in_2 = 0;
    
    #150 in_1 = 8'h8C; in_2 = 8'hDA;
    #10 in_1 = 0; in_2 = 0;
    
    #150 in_1 = 8'h6E; in_2 = 8'hF9;
    #10 in_1 = 0; in_2 = 0;

    #500 $stop;
end

endmodule
