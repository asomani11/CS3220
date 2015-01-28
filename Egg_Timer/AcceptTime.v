module AcceptTime
  (clk,
   reset,
   enable,
	sel,
	switchin,
	timerdata);
	
	input clk, reset, enable, sel;
	input [7:0] switchin;
	
	output [15:0] timerdata;
	
	reg [15:0] timerdata;
	
	always @(posedge clk) begin
		if(reset) begin
			timerdata <= 0;
		end
		if (enable) begin
			if (sel) begin
				timerdata[15:8] <= switchin[7:0];
			end else begin
				timerdata[7:0] <= switchin[7:0];
			end
		end
	end
endmodule