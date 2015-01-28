module TFlipFlop(reset, clk, tOut);
	input reset, clk;
	output tOut;
	reg tOut = 0;
	
	always @(negedge reset or negedge clk) begin
		if (reset == 1'b0)
			tOut <= 0;
		else 
			tOut <= ~tOut;
	end
endmodule