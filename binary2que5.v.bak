module binary2que5(in,out,rst);
	input wire[2:0] in;
	output wire[4:0] out;
	input rst;
	
	assign out[0] = ~in[2] & ~in[1] & ~in[0] & rst;
	assign out[1] = ~in[2] & ~in[1] &  in[0] & rst;
	assign out[2] = ~in[2] &  in[1] & ~in[0] & rst;
	assign out[3] = ~in[2] &  in[1] &  in[0] & rst;
	assign out[4] =  in[2] & ~in[1] & ~in[0] & rst;
	
endmodule
