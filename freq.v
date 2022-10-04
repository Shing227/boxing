module freq(input clkin,output reg clkout,input rst);
	parameter cycle = 500;
	parameter size = 30;
	reg[size-1:0] cyc;
	
	
	initial begin
		clkout <= 1'b0;
		cyc <= cycle;
	end
	
	
	always @(posedge clkin) begin
		if(~rst) begin
			clkout <= 1'b1;
			cyc <= cycle;
		end
		else begin
			if(cyc == 1) begin
				clkout <= ~clkout;
				cyc <= cycle;
			end
			else cyc <= cyc - 1;
		end
	end
endmodule
