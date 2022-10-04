module player(act,state,led_ctrl,clk,rst);
	input wire[1:0] act;
	output reg[1:0] state;
	output reg[2:0] led_ctrl;
	input clk,rst;
	// ex clk = 100K => fq_act = 100K / (2*def_rec_time) = 1Khz => 1ms
	parameter atk_pre_cyc = 10;//(1000/1K)*5= 5s
	parameter atk_rec_cyc = 2;//2.5
	parameter def_hld_cyc = 20;
	parameter def_rec_cyc = 1;//0.1
	parameter freq_base_time = 1000000;
	//freq
	wire clk_act;
	freq #(.cycle(freq_base_time)) fq_act(.clkin(clk),.clkout(clk_act),.rst(rst));
	//counter 
	wire [2:0] led_apt,led_art,led_drt,led_dht;
	reg [3:0] led_sel;
	reg rst_apt,rst_art,rst_drt,rst_dht;
	reg ct5;
	reg ct5_rec;
	//led_sel  {rst_apt,rst_art,rst_dht,rst_drt};
	cyc_counter5_rl #(.cycle2one(atk_pre_cyc)) ct_apt(.clk(clk_act),.out(led_apt),.rst(rst_apt));
	cyc_counter5_rl #(.cycle2one(atk_rec_cyc)) ct_art(.clk(clk_act),.out(led_art),.rst(rst_art));
	cyc_counter5_rl #(.cycle2one(def_rec_cyc)) ct_drt(.clk(clk_act),.out(led_drt),.rst(rst_drt));
	cyc_counter5_rl #(.cycle2one(def_hld_cyc)) ct_dht(.clk(clk_act),.out(led_dht),.rst(rst_dht));
	//state
	reg acting;
	parameter atk = 2'b10;
	parameter def = 2'b01;
	parameter nothing = 2'b00;
	parameter punching = 2'b11;
	
	//
	
	initial begin
		rst_apt <= 1'b0;
		rst_art <= 1'b0;
		rst_dht <= 1'b0;
		rst_drt <= 1'b0;
		led_ctrl <= 3'b000;
		state <= nothing;
		acting <= 1'b0;
		ct5 <= 1'b0;
		ct5_rec <= 1'b1;
	end
	//
	
	always @(posedge clk_act) begin
		if(~rst) begin
			rst_apt <= 1'b0;
			rst_art <= 1'b0;
			rst_dht <= 1'b0;
			rst_drt <= 1'b0;
			led_ctrl <= 3'b000;
			state <= nothing;
			acting <= 1'b0;
		end
		else begin
			if(acting) begin
				//led_sel  {rst_apt,rst_art,rst_dht,rst_drt};
				if(ct5 && ct5_rec)begin//counter == 5
					case(led_sel)
						4'b0001 : begin//player at def_rec
							rst_drt <= 1'b0;
							acting <= 1'b0;
								 end
						4'b0010 : begin//player at def_hold
							rst_dht <= 1'b0;
							rst_drt <= 1'b1;
							state <= nothing;
								 end
						4'b0100 : begin//player at atk_rec
							rst_art <= 1'b0;
							acting <= 1'b0;
							state <= nothing;
								 end
						4'b1000 : begin//player at atk_prepare
							rst_apt <= 1'b0;
							rst_art <= 1'b1;
							state <= punching;
								 end
						default :  begin
							rst_apt <= 1'b0;
							rst_art <= 1'b0;
							rst_dht <= 1'b0;
							rst_drt <= 1'b0;
							acting <= 1'b0;
									  end
					endcase
					ct5_rec <= 1'b0;
				end
				else begin //player is acting but counter != 5
					if(state == def && act == nothing) begin
						state <= nothing;
						rst_dht <= 1'b0;
						rst_drt <= 1'b1;
					end
					else	acting <= acting;
					ct5_rec <= (led_apt[2] | led_art[2] |led_drt[2] | led_dht[2]) & ~ct5;
					ct5 <= led_apt[2] | led_art[2] |led_drt[2] | led_dht[2];
				end
			end
			else begin
				case(act)
				2'b00 : begin //nothing
					state <= nothing;
					acting <= 1'b0;
					end
				2'b01,2'b11 : begin // def
					state <= def;//def 
					rst_dht <= 1'b1;
					acting <= 1'b1;
					end
				2'b10 : 	begin // atk
					state <= atk;
					rst_apt <= 1'b1;
					acting <= 1'b1;
					end
				default : begin
					state <= nothing;
					acting <= 1'b0;
					end
				endcase
			end
			
			led_sel[0] <= rst_drt;
	      led_sel[1] <= rst_dht;
			led_sel[2] <= rst_art; 
			led_sel[3] <= rst_apt; 
			case(led_sel)
				4'b0001 : led_ctrl <= led_drt;
				4'b0010 : led_ctrl <= led_dht;
				4'b0100 : led_ctrl <= led_art;
				4'b1000 : led_ctrl <= led_apt;
				default : led_ctrl <= 3'b0;
			endcase;
		end
		
	end
	

	
endmodule
