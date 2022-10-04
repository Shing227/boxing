module led_display(state,in,out,clk,rst);
	input wire[2:0] in;
	input wire[1:0] state;
	output reg[4:0] out;
	input rst;
	input clk;
	
	always @(posedge clk) begin
		if(~rst) out <= 5'b11111;
		else begin
			case(state)
				2'b10 : begin // *00 -> 0*0 -> 00* 
					case (in) 
						3'd0: out <= 5'b00001;
						3'd1: out <= 5'b00011;
						3'd2: out <= 5'b00111;
						3'd3: out <= 5'b01111;
						3'd4: out <= 5'b11111;
					endcase
					end
				2'b11 : begin // 00* -> 0** -> *0*
					case (in)
						3'd0: out <= 5'b10000;
						3'd1: out <= 5'b01000;
						3'd2: out <= 5'b00100;
						3'd3: out <= 5'b00010;
						3'd4: out <= 5'b00001;
					endcase
					end
				2'b01 : begin // *** -> 0** -> 00* 
					case (in) 
						3'd0: out <= 5'b11111;
						3'd1: out <= 5'b10111;
						3'd2: out <= 5'b10011;
						3'd3: out <= 5'b10001;
						3'd4: out <= 5'b00000;
					endcase
					end
				2'b00 : begin // 00*
						out <= 5'b00000;
					end
				default :;
			endcase
		end
	end
	
endmodule
