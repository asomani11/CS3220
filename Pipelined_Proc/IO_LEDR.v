module IO_LEDR(clk, reset, wrtEn, addrbus, leddata, databus);
	parameter DATA_BIT_WIDTH = 32;
	parameter RESET_VALUE = 0;
	
	input clk, reset, wrtEn;
	input [DATA_BIT_WIDTH - 1: 0] addrbus;
	output [DATA_BIT_WIDTH - 1:0] leddata;
	inout [DATA_BIT_WIDTH - 1: 0] databus;
	
	reg [DATA_BIT_WIDTH - 1: 0] leddata;
	
	always @(posedge clk) begin
		if (reset == 1'b1)
			leddata <= RESET_VALUE;
		else if(addrbus == 32'hF0000004 && wrtEn) begin
				leddata <= databus & 32'h000003FF;
		end
	end
	
	assign databus = (addrbus == 32'hF0000004 && ~wrtEn)?(leddata & 32'h000003FF):32'hZZZZZZZZ;
endmodule
