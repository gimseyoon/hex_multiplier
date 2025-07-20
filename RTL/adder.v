module adder(
    input clk, 
    input rst_n,
    input adder_en,
    input [2:0] state,
    input [15:0] adder_in,
    input done,
    output reg [16:0] adder_out 
    );

parameter IDLE = 3'b000, COMPUTE_1 = 3'b001, COMPUTE_2 = 3'b010, COMPUTE_3 = 3'b011, COMPUTE_4 = 3'b100, COMPUTE_5 = 3'b101, COMPUTE_6 = 3'b110;

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        adder_out <= 0;
    end
    else begin
        if(done) begin
            adder_out <= 0;
        end
        else begin
            if(adder_en) begin
                adder_out <= adder_out + adder_in;
            end
        end
    end
end
    
    
endmodule