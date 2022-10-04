module get_act(in,out1,out2,clk,rst);
	input [7:0] in;
	output reg[1:0] out1;
	output reg[1:0] out2;
	input rst;
	input clk;
	
	reg [7:0] bufin1;
	reg [7:0] bufin2;
	reg access;
	
	parameter opt_freq = 50_000;//50M -> 1Khz
	reg [20:0] num;
	reg [3:0] tmp;
	reg break;
	
	initial begin
		num <= opt_freq;
		tmp <= 0;
		out1 <= 0;
		out2 <= 0;
		break <= 0;
	end
	
	always @(negedge clk) begin
		bufin1 <= in;
		bufin2 <= bufin1;
		if(bufin1 == bufin2) access <= 1'b0;
		else access <= 1'b1;
	end
	
	always @(posedge clk) begin
		if(~rst)  begin
			break <= 0;
			tmp <= 0;
		end
		else begin
			if(access) begin
				if(break) begin
					case (in)					  	
					8'h1c: begin
							tmp[3] <= 1'b0;	//A -> 
							break <= 1'b0;
						end
					8'h1b: begin
							tmp[2] <= 1'b0;	//S -> 
							break <= 1'b0;
						end
					8'h3b: begin
							tmp[1] <= 1'b0;	//J -> 
							break <= 1'b0;
						end
					8'h42: begin
							tmp[0] <= 1'b0;	//K -> 
							break <= 1'b0;
						end
					8'h00: begin
							tmp <= tmp;
						end
					default: begin
							tmp <= tmp;
							break <= 1'b1;
						end
					endcase
				end
				else begin
					case (in)					  	
						8'h1c: tmp[3] <= 1'b1;//A
						8'h1b: tmp[2] <= 1'b1;//S
						8'h3b: tmp[1] <= 1'b1;//J
						8'h42: tmp[0] <= 1'b1;//K
						8'hf0: break <= 1'b1;
						default:	tmp <= tmp;
					endcase
					
					
					
				end
			end
			else tmp <= tmp;
		end
	end
	
	
	always @(posedge clk) begin
		if(~rst)  begin
				num <= opt_freq;
				out1 <= 0;
				out2 <= 0;
			end
		else if(num == 0) begin
				out1[1] <= tmp[3];
				out1[0] <= tmp[2];
				out2[1] <= tmp[1];
				out2[0] <= tmp[0];
				num <= opt_freq;
			end
		else begin
				num <= num - 1;
		end
	end
endmodule
