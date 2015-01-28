module IO_SW(clk, reset, wrtEn, addrbus, SW, databus);
	parameter DEBOUNCE_LEN = 100; 
	parameter DATA_BIT_WIDTH = 32;
	parameter RESET_VALUE = 0;
	
	input clk,reset,wrtEn;
	input [DATA_BIT_WIDTH - 1: 0] addrbus;
	input [9:0] SW;
	inout [DATA_BIT_WIDTH - 1: 0] databus;
	
	reg [DATA_BIT_WIDTH - 1:0] cnt_deb;
	reg [DATA_BIT_WIDTH - 1: 0] data_sdata;
	reg [DATA_BIT_WIDTH - 1: 0] data_sctrl;
	
	always @(posedge clk) begin
		if (reset == 1'b1)
			data_sctrl <= RESET_VALUE;
		else if(data_sdata != {22'd0,SW}) begin
			cnt_deb = cnt_deb + 1;
			if(cnt_deb == DEBOUNCE_LEN) begin
				data_sdata <= {22'd0,SW};
				if(data_sctrl[0] == 1'b1)
					data_sctrl <= data_sctrl | 32'h00000004; //Writing the overrun bit
				else
					data_sctrl <= data_sctrl | 32'h00000001; //Writing the ready bit
			end
		end
		else
			cnt_deb = 0;
		if(addrbus == 32'hF0000014 && ~wrtEn)
			data_sctrl <= data_sctrl & 32'hFFFFFFFE; //Clearing the ready bit
		else if(addrbus == 32'hF0000114 && wrtEn)
				data_sctrl <= (databus[2] == 1'b0)?(data_sctrl & 32'hFFFFFFFB):data_sctrl;  //Clearing the overrun bit
	end
	
	assign databus = (addrbus == 32'hF0000014 && ~wrtEn) ? data_sdata
						:((addrbus == 32'hF0000114 && ~wrtEn) ? data_sctrl
						:32'hZZZZZZZZ);

endmodule
