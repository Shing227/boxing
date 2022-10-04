module cyc_counter5_rl(clk,out,rst);
	parameter cycle2one = 10;
	parameter size_cyc = 30;
	parameter count = 5;
	parameter size_cnt = 3;
	input clk;
	input rst;
	output reg[size_cnt-1:0] out;
	reg [size_cyc-1:0] cyc;
	
	initial begin
		out <= 0;
		cyc <= cycle2one;
	end
	
	always @(posedge clk) begin
		if(~rst) begin
			out <= 0;
			cyc <= cycle2one;
		end
		else begin
			if(cyc == 1) begin
				if(out == count - 1) out <= 0;
				else out <= out + 1;
				cyc <= cycle2one;
			end
			else begin
				cyc <= cyc - 1;
			end
		end
	end
endmodule
