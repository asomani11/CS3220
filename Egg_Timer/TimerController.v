module TimerController(input clk, input rst, input [1:0] keyin, input cntfin, output[2:0] currentState);

	parameter setSec = 3'b000;
	parameter setMin = 3'b001;
	parameter stop = 3'b010;
	parameter start = 3'b011;
	parameter finish = 3'b100;
	parameter reset = 3'b101;

	reg [2:0] state;
	
	assign currentState = state;

	always @(posedge clk) begin
		if (rst) begin
			state = reset;
		end
		else begin 
			case(state)
				reset: begin
					if(keyin[0]) state = setSec;
					else	state = state;
				end

				setSec: begin
					if(~keyin[0]) state = setMin; 
					else   state = state;
				end

				setMin: begin
					if(keyin[0]) state = stop;
					else   state = state;
				end

				stop: begin 
					if(keyin[1]) state = start;
					else	state = state;
				end

				start: begin
					if (~keyin[1]) state = stop;
					else	if (cntfin) state = finish;
					state = state;
				end

				finish: begin
					if(~keyin[0]) state = setSec;
					else 		state = state; 
				end
			endcase
		end
	end
endmodule 