module Counter_MMSS
  (clk,
	load,
   enable,
	reset,
	value,
   seconds,
	seconds_10,
	min,
	min_10
	);
	
	input clk, load, enable, reset;
	input [15:0] value;
	
	output [3:0] seconds;
	output [3:0] seconds_10;
	output [3:0] min;
	output [3:0] min_10;
	
	reg [3:0] seconds;
	reg [3:0] seconds_10;
	reg [3:0] min;
	reg [3:0] min_10;
	
	always @(posedge clk) begin
		if (reset) begin
			seconds <= 0;
			seconds_10 <= 0;	
			min <= 0;
			min_10 <= 0;
		end else if (load) begin
			seconds <= value [3:0];
			seconds_10 <= value [7:4];	
			min <= value [11:8];
			min_10 <= value [15:12];		
		end else if (enable) begin
			seconds <= seconds - 1;
			if (seconds == 0) begin
				seconds <= 9;
				seconds_10 <= seconds_10 - 1;
				if (seconds_10 == 0) begin
					seconds_10 <= 5;
					min <= min - 1;
					if (min == 0) begin
						min <= 9;
						min_10 <= min_10 - 1;
					end
				end
			end
		end
	end
endmodule
