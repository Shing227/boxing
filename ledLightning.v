module ledLightning(clk, Led);
input clk;
output [4:0] Led;
reg [4:0] Led;
reg direction;

initial begin
	Led[4:1] <= 5'b0;
	Led[0] <= 1'b1;
	direction <= 1'b1;
end

always@(posedge clk) begin
	if(Led[1] && !direction)
		direction <= 1'b1;
	if(Led[4] && direction)
		direction <= 1'b0;
end

always@(posedge clk) begin
	if(direction) begin
		Led[0] <= Led[4];
		Led[1] <= Led[0];
		Led[2] <= Led[1];
		Led[3] <= Led[2];
		Led[4] <= Led[3];
	end
	else begin
		Led[3] <= Led[4];
		Led[2] <= Led[3];
		Led[1] <= Led[2];
		Led[0] <= Led[1];
		Led[4] <= Led[0];
	end
end

endmodule
