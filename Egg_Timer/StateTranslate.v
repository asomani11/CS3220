module StateTranslate(input [2:0] state, output [4:0] out);
	assign out = (state == 3'b000 ) ? 5'b01001 : 
					 (state == 3'b001 ) ? 5'b01101 :
					 (state == 3'b010 ) ? 5'b00000 :
				    (state == 3'b011 ) ? 5'b00010 :	
					 (state == 3'b100 ) ? 5'b10000 :	
					 5'b00000;
endmodule