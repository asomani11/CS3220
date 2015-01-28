module DataMemory(clk, wrtEn, addrbus, databus);
	parameter ADDR_BIT_WIDTH = 11;
	parameter DATA_BIT_WIDTH = 32;
	parameter N_WORDS = (1 << ADDR_BIT_WIDTH);
	
	input clk, wrtEn;
	input[DATA_BIT_WIDTH - 1: 0] addrbus;
	inout[DATA_BIT_WIDTH - 1: 0] databus;
	
	reg [DATA_BIT_WIDTH - 1: 0] data[0: N_WORDS - 1];
	
	always @ (posedge clk) begin
		if(addrbus[31:16]==16'h0000 && wrtEn) begin
				data[addrbus[ADDR_BIT_WIDTH + 2:2]] <= databus;
		end
	end
	
	assign databus = (addrbus[31:16]==16'h0000 && ~wrtEn)?data[addrbus[ADDR_BIT_WIDTH + 2:2]]:32'hZZZZZZZZ;
endmodule
