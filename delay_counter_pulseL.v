module delay_counter_pulseL(clk,out,rst);
	parameter cycle2one = 10;
	parameter size_cyc = 30;
	
	input clk;
	input rst;
	output reg out;
	reg [size_cyc-1:0] cyc;
	
	initial begin
		out <= 1'b1;
		cyc <= cycle2one;
	end
	
	always @(posedge clk) begin
		if(~rst) begin
			out <= 1'b1;
			cyc <= cycle2one;
		end
		else begin
			if(cyc == 1) out <= 0;
			else begin
				cyc <= cyc - 1;
				out <= 1'b1;
			end
		end
	end
endmodule
