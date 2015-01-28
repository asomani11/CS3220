module FlashLEDs(input clk, input enable, output [9:0] ledout);	
	reg[31: 0] counter;
	reg out;
	
	assign ledout = {out,out,out,out,out,out,out,out,out,out};
	
	always @(posedge clk) begin
		if (enable) begin
			counter <= counter + 1;
			if (counter == 25000000) begin
				out <= ~out;
				counter <= 0;
			end
		end else begin
			out <= 0;
		end
	end
endmodule