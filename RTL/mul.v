module mul(
    input clk,
    input rst_n,
    input [2:0] state,
    input [3:0] mul_in_1,
    input [3:0] mul_in_2,
    output reg [15:0] mul_out
    );
    
parameter IDLE = 3'b000, COMPUTE_1 = 3'b001, COMPUTE_2 = 3'b010, COMPUTE_3 = 3'b011,COMPUTE_4 = 3'b100;


always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        mul_out <= 0;
    end
    else begin
        case(state)
            IDLE: mul_out <= 0;
            COMPUTE_1: mul_out <= (mul_in_1 * mul_in_2);
            COMPUTE_2: mul_out <= (mul_in_1 * mul_in_2) << 4;
            COMPUTE_3: mul_out <= (mul_in_1 * mul_in_2) << 4;
            COMPUTE_4: mul_out <= (mul_in_1 * mul_in_2) << 8;
            default: mul_out <= 0;
        endcase
    end
end


endmodule

