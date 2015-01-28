module Assign1
  (input CLOCK_50, 
   input [9:0] SW,	
   input [3:0] KEY, 
   output [6:0] HEX0,
   output [6:0] HEX1,
   output [6:0] HEX2,
   output [6:0] HEX3,
   output [7:0] LEDG,
   output [9:0] LEDR
	);
	
	wire [3:0] num = 0;
	wire [3:0] seconds;
	wire [3:0] seconds_10;
	wire [3:0] min;
	wire [3:0] min_10;
	wire [2:0] sval;
	wire keyin1;
	wire keyin2;
	wire cntfin;
	wire [4:0] transout;
	wire [15:0] data;
	
	assign cntfin = ({min_10,min,seconds_10,seconds} == 0)?1:0;
	
	assign LEDG[2:0] = sval;
	
	ClkDivider hz1_clk (CLOCK_50, CLOCK);
	TFlipFlop tff1 (KEY[0], ~KEY[1], keyin1);
	TFlipFlop tff2 (KEY[0], ~KEY[2], keyin2);
	
	TimerController eggmachine (CLOCK_50, ~KEY[0], {keyin2,keyin1}, cntfin, sval);
	
	StateTranslate stmachine (sval,transout);
	
	AcceptTime mm_ss (CLOCK_50, ~KEY[0], transout[3], transout[2], SW[7:0], data);
	
	Counter_MMSS egg_timer (CLOCK, transout[0], transout[1], ~KEY[0], data, seconds, seconds_10, min, min_10);
	
	FlashLEDs ledr_flash (CLOCK_50,transout[4],LEDR);
	
	dec2_7seg u1 (seconds, HEX0);
	dec2_7seg u2 (seconds_10, HEX1);
	dec2_7seg u3 (min, HEX2);
	dec2_7seg u4 (min_10, HEX3);	

endmodule
