module IO_KEY(clk, reset, wrtEn, addrbus, KEY, databus);
	parameter DATA_BIT_WIDTH = 32;
	parameter RESET_VALUE = 0;
	
	input clk,reset,wrtEn;
	input [DATA_BIT_WIDTH - 1: 0] addrbus;
	input [3:0] KEY;
	inout [DATA_BIT_WIDTH - 1: 0] databus;
	
	reg [DATA_BIT_WIDTH - 1: 0] data_kdata;
	reg [DATA_BIT_WIDTH - 1: 0] data_kctrl;
	
	always @(posedge clk) begin
		if (reset == 1'b1)
			data_kctrl <= RESET_VALUE;
		if(data_kdata != {28'd0,KEY}) begin
			data_kdata <= {28'd0,KEY};
			if(data_kctrl[0] == 1'b1)
				data_kctrl <= data_kctrl | 32'h00000004; //Writing the overrun bit
			else
				data_kctrl <= data_kctrl | 32'h00000001; //Writing the ready bit
		end
		if(addrbus == 32'hF0000010 && ~wrtEn)
			data_kctrl <= data_kctrl & 32'hFFFFFFFE; //Clearing the ready bit
		else if(addrbus == 32'hF0000110 && wrtEn)
				data_kctrl <= (databus[2] == 1'b0)?(data_kctrl & 32'hFFFFFFFB):data_kctrl;  //Clearing the overrun bit
	end
	
	assign databus = (addrbus == 32'hF0000010 && ~wrtEn) ? data_kdata
						:((addrbus == 32'hF0000110 && ~wrtEn) ? data_kctrl
						:32'hZZZZZZZZ);

endmodule
