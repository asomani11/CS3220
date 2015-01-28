module Project4(SW,KEY,LEDR,LEDG,HEX0,HEX1,HEX2,HEX3,CLOCK_50);
	input  [9:0] SW;
	input  [3:0] KEY;
	input  CLOCK_50;
	output [9:0] LEDR;
	output [7:0] LEDG;
	output [6:0] HEX0,HEX1,HEX2,HEX3; 
	
	parameter DBITS         				 = 32;
	parameter INST_SIZE      				 = 32'd4;
	parameter INST_BIT_WIDTH				 = 32;
	parameter START_PC       			 	 = 32'h40;
	parameter REG_INDEX_BIT_WIDTH 		 = 4;
	parameter ADDR_KEY  						 = 32'hF0000010;
	parameter ADDR_SW   						 = 32'hF0000014;
	parameter ADDR_HEX  						 = 32'hF0000000;
	parameter ADDR_LEDR 						 = 32'hF0000004;
	parameter ADDR_LEDG 						 = 32'hF0000008;
  
	parameter IMEM_INIT_FILE				 = "Sort2.mif";
	parameter IMEM_ADDR_BIT_WIDTH 		 = 11;
	parameter IMEM_DATA_BIT_WIDTH 		 = INST_BIT_WIDTH;
	parameter IMEM_PC_BITS_HI     		 = IMEM_ADDR_BIT_WIDTH + 2;
	parameter IMEM_PC_BITS_LO     		 = 2;
	
	parameter DMEM_ADDR_BIT_WIDTH 		 = 11;
	parameter DMEM_DATA_BIT_WIDTH 		 = 32;
	parameter DMEM_ADDR_BITS_HI     		 = DMEM_ADDR_BIT_WIDTH + 2;
	parameter DMEM_ADDR_BITS_LO     		 = 2;
	
	parameter OP1_ALUR 					 = 4'b0000;
	parameter OP1_ALUI 					 = 4'b1000;
	parameter OP1_CMPR 					 = 4'b0010;
	parameter OP1_CMPI 					 = 4'b1010;
	parameter OP1_BCOND					 = 4'b0110;
	parameter OP1_SW   					 = 4'b0101;
	parameter OP1_LW   					 = 4'b1001;
	parameter OP1_JAL  					 = 4'b1011;
	parameter OP1_NOP						 = 4'b1111;
  
	// Add parameters for various secondary opcode values
  
	//PLL, clock genration, and reset generation
	wire clk, lock;
	//Pll pll(.inclk0(CLOCK_50), .c0(clk), .locked(lock));
	PLL	PLL_inst (.inclk0 (CLOCK_50),.c0 (clk),.locked (lock));
	//ClkDivider #(.divider(2500000)) clkdi(CLOCK_50, clk);
	
	wire reset =  SW[0];//~lock;
	
	wire busWrtEn;
	wire [DMEM_DATA_BIT_WIDTH - 1:0] ledgdata;
	wire [DMEM_DATA_BIT_WIDTH - 1:0] ledrdata;
	wire [DMEM_DATA_BIT_WIDTH - 1:0] hexdata;
	wire [DMEM_DATA_BIT_WIDTH - 1: 0] addrbus;
	tri [DMEM_DATA_BIT_WIDTH - 1: 0] databus;
	
	//Processor
	Processor #(.DMEM_DATA_BIT_WIDTH(DMEM_DATA_BIT_WIDTH), .DBITS(DBITS), .INST_SIZE(INST_SIZE), .IMEM_DATA_BIT_WIDTH(IMEM_DATA_BIT_WIDTH), .INST_BIT_WIDTH(INST_BIT_WIDTH),
					.START_PC(START_PC), .IMEM_ADDR_BIT_WIDTH(IMEM_ADDR_BIT_WIDTH), .IMEM_PC_BITS_HI(IMEM_PC_BITS_HI), .IMEM_PC_BITS_LO(IMEM_PC_BITS_LO), .IMEM_INIT_FILE(IMEM_INIT_FILE))
					proc (.clk(clk), .reset(reset), .busWrtEn(busWrtEn), .addrbus(addrbus), .databus(databus));
	
	//Data Memory
	DataMemory #(DMEM_ADDR_BIT_WIDTH, DMEM_DATA_BIT_WIDTH) dataMem (.clk(clk), .addrbus(addrbus), .wrtEn(busWrtEn), .databus(databus));

	//IO Devices
	IO_LEDG iomod_ledg (clk, reset, busWrtEn, addrbus, ledgdata, databus);
	IO_LEDR iomod_ledr (clk, reset, busWrtEn, addrbus, ledrdata, databus);
	IO_HEX iomod_hex (clk, reset, busWrtEn, addrbus, hexdata, databus);
	IO_KEY iomod_key (clk, reset, busWrtEn, addrbus, KEY, databus);
	IO_SW #(.DEBOUNCE_LEN(100000)) iomod_sw (clk, reset, busWrtEn, addrbus, SW, databus);
	IO_TIMER #(.DELAY(10000)) iomod_timer (clk, reset, busWrtEn, addrbus, databus);
	
	assign LEDG[7:0] = ledgdata[7:0];
	assign LEDR = ledrdata[9:0];
	dec2_7seg hex0Converter(hexdata[3:0], HEX0);
	dec2_7seg hex1Converter(hexdata[7:4], HEX1);
	dec2_7seg hex2Converter(hexdata[11:8], HEX2);
	dec2_7seg hex3Converter(hexdata[15:12], HEX3);
	
endmodule

