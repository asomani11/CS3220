module IO_HEX(clk, reset, wrtEn, addrbus, hexdata, databus);
	parameter DATA_BIT_WIDTH = 32;
	parameter RESET_VALUE = 0;
	
	input clk, reset, wrtEn;
	input [DATA_BIT_WIDTH - 1: 0] addrbus;
	output [DATA_BIT_WIDTH - 1:0] hexdata;
	inout [DATA_BIT_WIDTH - 1: 0] databus;
	
	reg [DATA_BIT_WIDTH - 1: 0] hexdata;
	
	always @(posedge clk) begin
		if (reset == 1'b1)
			hexdata <= RESET_VALUE;
		else if(addrbus == 32'hF0000000 && wrtEn) begin
				hexdata <= databus & 32'h0000FFFF;
		end
	end
	
	assign databus = (addrbus == 32'hF0000000 && ~wrtEn)?(hexdata & 32'h0000FFFF):32'hZZZZZZZZ;
endmodule
