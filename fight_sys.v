module fight_sys(state1,state2,clk,rst,point1_1,point1_0,point2_1,point2_0,win/*,ctk1,ctk2*/);
	input [1:0] state1,state2;
	input clk,rst;
	output reg[3:0] point1_1,point1_0,point2_1,point2_0;
	output reg win;
	//output ctk1,ctk2;//
	parameter inipoint1 = 10;
	parameter inipoint2 = 10;
	
	initial begin
		point1_1 <= 0;
		point1_0 <= 0;
		point2_1 <= 0;
		point2_0 <= 0;
		point1 <= inipoint1;
		point2 <= inipoint2;
		
		win <= 0;
	end

	
	
	
	reg st1_buf1,st1_buf2;
	reg ph_access1;
	always @(posedge clk) begin
			st1_buf1 <= state1;
			st1_buf2 <= st1_buf1;
			if(st1_buf1 == st1_buf2) ph_access1 <= 1'b0;
			else begin
				if(state1 == 2'b11) ph_access1 <= 1'b1;
			end
	end
	
	reg st2_buf1,st2_buf2;
	reg ph_access2;
	always @(posedge clk) begin
			st2_buf1 <= state2;
			st2_buf2 <= st2_buf1;
			if(st2_buf1 == st2_buf2) ph_access2 <= 1'b0;
			else begin
				if(state2 == 2'b11) ph_access2 <= 1'b1;
			end
	end

	reg [4:0] point1,point2;
	always @(posedge clk or negedge rst) begin
		if(~rst) begin
			point1 <= inipoint1;
			point2 <= inipoint2;
			win <= 0;
		end
		else if(win)win <= win;
		else if(ph_access1)begin
			case (state2)
				//A atk B
				2'b00: begin
					if(point2 > 5'd2) begin
						point2 <= point2 - 5'd2;
						point1 <= point1 + 5'd2;
					end
					else begin
						win <= 1'b1;
						point2 <= 0;
						point1 <= 5'd20;
					end
				end
				2'b01: begin
					if(point2 > 5'd1) begin
						point2 <= point2 - 5'd1;
						point1 <= point1 + 5'd1;
					end
					else begin
						win <= 1'b1;
						point2 <= 0;
						point1 <= 5'd20;
					end
				end
				2'b10,2'b11: begin
					if(point2 > 5'd3) begin
						point2 <= point2 - 5'd3;
						point1 <= point1 + 5'd3;
					end
					else begin
						win <= 1'b1;
						point2 <= 0;
						point1 <= 5'd20;
					end
				end
				2'b11: begin
					if(point2 > 5'd3) begin
						point2 <= point2 - 5'd3;
						point1 <= point1 + 5'd3;
					end
					else begin
						win <= 1'b1;
						point2 <= 0;
						point1 <= 5'd20;
					end
				end
				default: begin
					point1 <= point1;
					point2 <= point2;
				end
			endcase
		end
		else if(ph_access2) begin
			case (state1)
				//B atk A
				2'b00: begin
					if(point1 > 5'd2) begin
						point1 <= point1 - 5'd2;
						point2 <= point2 + 5'd2;
					end
					else begin
						win <= 1'b1;
						point1 <= 0;
						point2 <= 5'd20;
					end
				end
				2'b10,2'b11: begin
					if(point1 > 5'd3) begin
						point1 <= point1 - 5'd3;
						point2 <= point2 + 5'd3;
					end
					else begin
						win <= 1'b1;
						point1 <= 0;
						point2 <= 5'd20;
					end
				end
				2'b01: begin
					if(point1 > 5'd1) begin
						point1 <= point1 - 5'd1;
						point2 <= point2 + 5'd1;
					end
					else begin
						win <= 1'b1;
						point1 <= 0;
						point2 <= 5'd20;
					end
				end
				default: begin
					point1 <= point1;
					point2 <= point2;
				end
			endcase
		end
		else point1 <= point1;
					
	end
	/*
	reg [1:0]num_palus;
	always @(posedge clk) begin
		if(num_palus == 0) pulse <= 1'b0;
		else begin
			pulse <= 1'b1;
			num_palus <= num_palus - 1;
		end
	end
	*/
	always @(clk) begin
		if(point1 == 5'd20) begin
			point1_1 <= 4'b0010;
			point1_0 <= 0;
		end
		else if (point1 > 5'd10)begin
			point1_1 <= 4'd1;
			point1_0 <= point1[3:0] + 4'd6;
		end
		else if(point1 == 5'd10) begin
			point1_1 <= 4'd1;
			point1_0 <= 0;
		end
		else begin
			point1_1 <= 0;
			point1_0 <= point1[3:0];
		end
		
		if(point2 == 5'd20) begin
			point2_1 <= 4'd2;
			point2_0 <= 0;
		end
		else if (point2 > 5'd10)begin
			point2_1 <= 4'd1;
			point2_0 <= point2[3:0] + 4'd6;
		end
		else if(point2 == 5'd10) begin
			point2_1 <= 4'd1;
			point2_0 <= 0;
		end
		else begin
			point2_1 <= 0;
			point2_0 <= point2[3:0];
		end
	end



endmodule
