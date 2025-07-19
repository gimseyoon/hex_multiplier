module hex_multiplier(
    input clk,
    input rst_n,
    input enable,
    input [7:0] in_1,
    input [7:0] in_2,
    input [2:0] top_state,
    output [16:0] out_data,
    output done
    );

wire adder_en;
wire mux_en;
wire start;
wire [2:0] ps;
wire [15:0] mul_out;
wire [3:0] mux_out_1;
wire [3:0] mux_out_2;


mux mux_0(
.clk(clk),
.rst_n(rst_n),
.enable(enable),
.state(ps),
.mux_en(mux_en),
.mux_in_1(in_1),
.mux_in_2(in_2),
.start(start),
.mux_out_1(mux_out_1),
.mux_out_2(mux_out_2)
);

FSM FSM_0(
.clk(clk),
.rst_n(rst_n),
.enable(enable),
.start(start),
.top_state(top_state),
.done(done),
.ps(ps),
.adder_en(adder_en),
.mux_en(mux_en)
);

mul mul_0(
.clk(clk),
.rst_n(rst_n),
.state(ps),
.mul_in_1(mux_out_1),
.mul_in_2(mux_out_2),
.mul_out(mul_out)
);
    
adder adder_0(
.clk(clk), 
.rst_n(rst_n),
.adder_en(adder_en),
.state(ps),
.adder_in(mul_out),
.done(done),
.adder_out(out_data)
);

endmodule

