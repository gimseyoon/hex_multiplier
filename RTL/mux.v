module mux(
    input clk,
    input rst_n,
    input enable,
    input mux_en,
    input [2:0] state,
    input [7:0] mux_in_1,
    input [7:0] mux_in_2,
    output start,
    output reg [3:0] mux_out_1,
    output reg [3:0] mux_out_2
    );

parameter IDLE = 3'b000, COMPUTE_1 = 3'b001, COMPUTE_2 = 3'b010, COMPUTE_3 = 3'b011,COMPUTE_4 = 3'b100;

reg [31:0] mux_in_1_reg;
reg [31:0] mux_in_2_reg;

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        mux_in_1_reg <= 0;
        mux_in_2_reg <= 0;
    end
    else begin
    if(enable)begin
        
            mux_in_1_reg[7:0] <= mux_in_1;              //0~7
            mux_in_2_reg[7:0] <= mux_in_2;
            
            mux_in_1_reg[15:8] <= mux_in_1_reg[7:0];    //8~15
            mux_in_2_reg[15:8] <= mux_in_2_reg[7:0];
            
            mux_in_1_reg[23:16] <= mux_in_1_reg[15:8];  //16~23
            mux_in_2_reg[23:16] <= mux_in_2_reg[15:8];
            
            mux_in_1_reg[31:24] <= mux_in_1_reg[23:16]; //24~31
            mux_in_2_reg[31:24] <= mux_in_2_reg[23:16];        

    end
    else begin
        mux_in_1_reg <= 0;
        mux_in_2_reg <= 0;
    end
        
    end
end

always@(*) begin
        case(state)
            IDLE: begin mux_out_1 = 0; mux_out_2 = 0; end
            COMPUTE_1: begin mux_out_1 = mux_in_1_reg[3:0]; mux_out_2 = mux_in_2_reg[3:0];  end//0~7
            COMPUTE_2: begin mux_out_1 = mux_in_1_reg[15:12]; mux_out_2 = mux_in_2_reg[11:8];    end//8~15
            COMPUTE_3: begin mux_out_1 = mux_in_1_reg[19:16]; mux_out_2 = mux_in_2_reg[23:20];  end//16~23
            COMPUTE_4: begin mux_out_1 = mux_in_1_reg[31:28]; mux_out_2 = mux_in_2_reg[31:28];  end//24~31
            default: begin mux_out_1 = 0; mux_out_2 <= 0; end
        endcase

end
    
assign start = (mux_in_1) && (mux_in_2);
    
endmodule
