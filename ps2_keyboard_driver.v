module ps2_keyboard_driver(clk,rst_n,ps2k_clk,ps2k_data,ps2_byte,ps2_state);

input clk;		//50M時鐘訊號
input rst_n;	//復位訊號
input ps2k_clk;	//PS2介面時鐘訊號
input ps2k_data;		//PS2介面資料訊號
output wire [7:0] ps2_byte;	// 1byte鍵值，只做簡單的按鍵掃描
output ps2_state;		//鍵盤當前狀態，ps2_state=1表示有鍵被按下 


//------------------------------------------
reg ps2k_clk_r0,ps2k_clk_r1,ps2k_clk_r2;	//ps2k_clk狀態暫存器

//wire pos_ps2k_clk; 	// ps2k_clk上升沿標誌位
wire neg_ps2k_clk;	// ps2k_clk下降沿標誌位
//裝置傳送向主機的資料在下降沿有效，首先檢測PS2k_clk的下降沿
//利用上面邏輯賦值語句可以提取得下降沿，neg_ps2k_clk為高電平時表示資料可以被採集
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
			ps2k_clk_r0 <= 1'b0;
			ps2k_clk_r1 <= 1'b0;
			ps2k_clk_r2 <= 1'b0;
		end
	else begin								//鎖存狀態，進行濾波
			ps2k_clk_r0 <= ps2k_clk;
			ps2k_clk_r1 <= ps2k_clk_r0;
			ps2k_clk_r2 <= ps2k_clk_r1;
		end
end

assign neg_ps2k_clk = ~ps2k_clk_r1 & ps2k_clk_r2;	//下降沿

//-----------------資料採集-------------------------
	/*

	幀結構：裝置發往主機資料幀為11位元，（主機發送資料包為12bit） 
			1bit start bit ,This is always 0,
			 8bit data bits, 
			 1 parity bit,(odd parity)校驗位，奇校驗，
			 data bits 為偶數個1時該位為1，
			 data bits 為奇數個1時該位為0.
	         1bit stop bit ,this is always 1.
				num 範圍為 'h00,'h0A;
*/
reg[7:0] ps2_byte_r;		//PC接收來自PS2的一個位元組資料儲存器
reg[3:0] num;				//計數暫存器

reg[7:0] temp_data;			//當前接收資料暫存器
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
			num <= 4'd0;
			temp_data <= 8'd0;
		end
	else if(neg_ps2k_clk) begin	//檢測到ps2k_clk的下降沿
			case (num)
			 /*
		幀結構中資料位為一個位元組，且低位在前，高位在後，
		這裡要定義一個buf,size is one Byte.

	 */   
				4'd0:	num <= num+1'b1;
				4'd1:	begin
							num <= num+1'b1;
							temp_data[0] <= ps2k_data;	//bit0
						end
				4'd2:	begin
							num <= num+1'b1;
							temp_data[1] <= ps2k_data;	//bit1
						end
				4'd3:	begin
							num <= num+1'b1;
							temp_data[2] <= ps2k_data;	//bit2
						end
				4'd4:	begin
							num <= num+1'b1;
							temp_data[3] <= ps2k_data;	//bit3
						end
				4'd5:	begin
							num <= num+1'b1;
							temp_data[4] <= ps2k_data;	//bit4
						end
				4'd6:	begin
							num <= num+1'b1;
							temp_data[5] <= ps2k_data;	//bit5
						end
				4'd7:	begin
							num <= num+1'b1;
							temp_data[6] <= ps2k_data;	//bit6
						end
				4'd8:	begin
							num <= num+1'b1;
							temp_data[7] <= ps2k_data;	//bit7
						end
				4'd9:	begin
							num <= num+1'b1;	//奇偶校驗位，不做處理
						end
				4'd10: begin
							num <= 4'd0;	// num清零
						end
				default: ;
				endcase
		end	
		//else temp_data <= 8'h00;
end

reg key_f0;		//鬆鍵標誌位，置1表示接收到資料8'hf0，再接收到下一個資料後清零
reg ps2_state_r;	//鍵盤當前狀態，ps2_state_r=1表示有鍵被按下 
reg[7:0] ps2_asci;	//接收資料的相應ASCII碼
//+++++++++++++++資料處理開始++++++++++++++++=============
always @ (posedge clk or negedge rst_n) begin	//接收資料的相應處理，這裡只對1byte的鍵值進行處理
	if(!rst_n) begin
			key_f0 <= 1'b0;
			ps2_asci <= 1'b0;
		end
	else if(num==4'd10) begin///一幀資料是否採集完。
			case (temp_data)		//鍵值轉換為ASCII碼，這裡做的比較簡單，只處理字母				  	
				8'h1c,8'h1b,8'h3b,8'h42,8'hf0: begin 
					ps2_asci <= temp_data;	//A S J K stop
					ps2_state_r <= 1'b1;
				end
			default: 
				ps2_state_r <= 1'b0;
			endcase
		end
	else begin
		ps2_state_r <= 1'b0;
	end
end


assign ps2_byte[7] = ps2_asci[7] & ps2_state;	 
assign ps2_byte[6] = ps2_asci[6] & ps2_state;	 
assign ps2_byte[5] = ps2_asci[5] & ps2_state;	 
assign ps2_byte[4] = ps2_asci[4] & ps2_state;	 
assign ps2_byte[3] = ps2_asci[3] & ps2_state;	 
assign ps2_byte[2] = ps2_asci[2] & ps2_state;	 
assign ps2_byte[1] = ps2_asci[1] & ps2_state;	 
assign ps2_byte[0] = ps2_asci[0] & ps2_state;	 
assign ps2_state = ps2_state_r;

//==================keyboard driver part over======================

endmodule
