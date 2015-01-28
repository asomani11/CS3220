module Staller (isStalledIn,instWordIn,isStalledOut,pcWrtEn,instWordOut);
	parameter DATA_BIT_WIDTH = 32;
	
	parameter OP1_BCOND					 = 4'b0110;
	parameter OP1_SW   					 = 4'b0101;
	parameter OP1_LW   					 = 4'b1001;
	parameter OP1_JAL  					 = 4'b1011;
	parameter OP1_NOP  					 = 4'b1111;
	
	input isStalledIn;
	input[DATA_BIT_WIDTH - 1: 0] instWordIn;
	
	output isStalledOut, pcWrtEn;
	output [DATA_BIT_WIDTH - 1: 0] instWordOut; 
	
	reg isStalledOut, pcWrtEn;
	reg [DATA_BIT_WIDTH - 1: 0] instWordOut;
	
	always @(*) begin
		if((instWordIn[31:28] == OP1_JAL)&(isStalledIn == 1'b0)) begin
			pcWrtEn = 1'b0;
			instWordOut = {OP1_NOP, 28'h0000000};
			isStalledOut = 1'b1;
		end
		else begin
			pcWrtEn <= 1'b1;
			instWordOut <= instWordIn;
			isStalledOut = 1'b0;
		end
	end
endmodule

