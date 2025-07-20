module FSM(
    input clk,
    input rst_n,
    input start,
    input enable,
    input [2:0] top_state,
    output reg done,
    output reg [2:0] ps,
    output reg adder_en,
    output reg mux_en
    );
    
parameter IDLE = 3'b000, COMPUTE_1 = 3'b001, COMPUTE_2 = 3'b010, COMPUTE_3 = 3'b011, COMPUTE_4 = 3'b100, COMPUTE_5 = 3'b101, COMPUTE_6 = 3'b110;


reg [2:0] ns;



//update state
always@(posedge clk or negedge rst_n) begin
    if(!rst_n)  ps <= 0;
    else        ps <= ns;
end


//next state & enable
always@(*) begin
    if(!rst_n) begin
            ns <= IDLE;
    end
    else begin
        if(enable) begin
            case(ps)

                IDLE: if (!start) ns <= ps; 
                      else       ns <= COMPUTE_1; 
                COMPUTE_1:        ns <= COMPUTE_2; 
                COMPUTE_2:        ns <= COMPUTE_3; 
                COMPUTE_3:        ns <= COMPUTE_4; 
                COMPUTE_4:        ns <= COMPUTE_5; 
                COMPUTE_5:        ns <= COMPUTE_6; 
                COMPUTE_6:        ns <= IDLE; 
                default:         ns <= IDLE; 
            endcase
        end
        else begin
            ns <= IDLE;
        end
    end
end
    
always@(posedge clk or negedge rst_n) begin
    if(!rst_n ) begin
            adder_en <= 0;
            mux_en <= 0;
    end
    else begin
        if(enable) begin
                case(ps)
                    IDLE: if(!start)  begin adder_en <= 0; mux_en <= 0; end
                          else        begin adder_en <= 1; mux_en <= 1; end
                    COMPUTE_1:        begin adder_en <= 1; mux_en <= 1; end
                    COMPUTE_2:        begin adder_en <= 1; mux_en <= 1; end
                    COMPUTE_3:        begin adder_en <= 1; mux_en <= 1; end
                    COMPUTE_4:        begin adder_en <= 1; mux_en <= 1; end
                    COMPUTE_5:        begin adder_en <= 1; mux_en <= 0; end
                    COMPUTE_6:        begin adder_en <= 0; mux_en <= 0; end
                    default:         begin adder_en <= 0; mux_en <= 0; end
                endcase
        end
        else begin
            mux_en <= 0;
            adder_en <= 0;
        end
    end
end


always@(posedge clk or negedge rst_n) begin
    if(!rst_n)  done <= 0;
    else begin
        if(ps == COMPUTE_5) begin
            done <= 1;
        end
        else begin
            done <= 0;
        end
    end        
end



endmodule