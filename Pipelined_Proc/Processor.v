module Processor(clk, reset,busWrtEn, addrbus, databus);

	parameter DMEM_DATA_BIT_WIDTH 		 = 32;
	parameter DBITS         				 = 32;
	parameter INST_SIZE      				 = 32'd4;
	parameter IMEM_DATA_BIT_WIDTH 		 = INST_BIT_WIDTH;
	parameter INST_BIT_WIDTH				 = 32;
	parameter START_PC       			 	 = 32'h40;
	parameter IMEM_ADDR_BIT_WIDTH 		 = 11;
	parameter IMEM_PC_BITS_HI     		 = IMEM_ADDR_BIT_WIDTH + 2;
	parameter IMEM_PC_BITS_LO     		 = 2;
	
	parameter IMEM_INIT_FILE				 = "Test2.mif";//"Sort2_counter.mif"; //"Sorter2.mif";
	
	
	input clk, reset;
	output busWrtEn;
	output [DMEM_DATA_BIT_WIDTH - 1: 0] addrbus;
	inout [DMEM_DATA_BIT_WIDTH - 1: 0] databus;

	wire [DMEM_DATA_BIT_WIDTH - 1: 0] aluIn2;
	wire immSel;
   wire [1:0] memOutSel;
	wire [3: 0] wrtIndex, rdIndex1, rdIndex2;
	wire [4: 0] sndOpcode;
	wire [15: 0] imm;
	wire regFileEn;
	
	wire [DMEM_DATA_BIT_WIDTH - 1: 0] dataIn, dataOut1, dataOut2;
	wire cmpOut_top;  
	wire [DMEM_DATA_BIT_WIDTH - 1: 0] aluOut;
	wire [DMEM_DATA_BIT_WIDTH - 1: 0] seImm;
	wire[IMEM_DATA_BIT_WIDTH - 1: 0] instWordIn;
	wire[IMEM_DATA_BIT_WIDTH - 1: 0] instWordOut;
	wire[DBITS - 1: 0] branchPc;
	wire isStore, isStalled;
	
	//PipeLine Registers
	wire[DBITS - 1: 0] pipepcLogicOut;
	wire [3: 0] pipewrtIndex;
	wire [1:0] pipememOutSel;
	wire piperegFileEn, pipeisStalled;
   wire pipeRegWrtEn = 1'b1; // always write to Pipeline Register
	wire [DMEM_DATA_BIT_WIDTH - 1: 0] pipedataOut2;
	
	// PC Register
	wire pcWrtEn;
	wire[DBITS - 1: 0] pcIn; // Implement the logic that generates pcIn; you may change pcIn to reg if necessary
	wire[DBITS - 1: 0] pcOut;
	wire[DBITS - 1: 0] pcLogicOut;
	wire [1:0] pcSel; // 0: pcOut + 4, 1: branchPc
	
	Register #(.BIT_WIDTH(DBITS), .RESET_VALUE(START_PC)) pc (clk, reset, pcWrtEn, pcIn, pcOut);
	PcLogic pcLogic (pcOut, pcLogicOut);
	
	Mux4to1 muxPcOut (pcSel, pcLogicOut, branchPc, aluOut, 32'd0, pcIn);

	
	// Instruction Memory
	InstMemory #(IMEM_INIT_FILE, IMEM_ADDR_BIT_WIDTH, IMEM_DATA_BIT_WIDTH) instMem (pcOut[IMEM_PC_BITS_HI - 1: IMEM_PC_BITS_LO], instWordIn);
  
	//Pipeline Staller
	Staller pipelinestall (pipeisStalled,instWordIn, isStalled, pcWrtEn, instWordOut); 
	
	// Controller
	Controller cont (.inst(instWordOut), .aluCmpIn(cmpOut_top), .sndOpcode(sndOpcode), .dRegAddr(wrtIndex), .s1RegAddr(rdIndex1), .s2RegAddr(rdIndex2), .imm(imm), 
							.regFileWrtEn(regFileEn), .immSel(immSel), .memOutSel(memOutSel), .pcSel(pcSel), .isStore(isStore));
  
	// RegisterFile
	RegisterFile regFile (.clk(clk), .wrtEn(piperegFileEn), .wrtIndex(pipewrtIndex), .rdIndex1(rdIndex1), .rdIndex2(rdIndex2), .dataIn(dataIn), .dataOut1(dataOut1), .dataOut2(dataOut2));
 
	// ALU
	Alu alu1 (.ctrl(sndOpcode), .rawDataIn1(dataOut1), .rawDataIn2(aluIn2), .dataOut(aluOut), .cmpOut(cmpOut_top)); 
  
   // Sign Extension
	SignExtension #(.IN_BIT_WIDTH(16), .OUT_BIT_WIDTH(32)) se (imm, seImm);
 
	// ALU Mux
	Mux2to1 #(.DATA_BIT_WIDTH(DBITS)) muxAluIn (immSel, dataOut2, seImm, aluIn2);

	//Pipeline Register
	PipelineRegister #(.DATA_BIT_WIDTH(DMEM_DATA_BIT_WIDTH)) stage2pipe (.clk(clk), .reset(reset), .wrtEn(pipeRegWrtEn), .dataOut2In(dataOut2), .aluOutIn(aluOut), .pcLogicOutIn(pcLogicOut), .wrtIndexIn(wrtIndex), .memOutSelIn(memOutSel), .regFileEnIn(regFileEn), .isStoreIn(isStore), .isStalledIn(isStalled),
																								.dataOut2Out(pipedataOut2), .aluOutOut(addrbus), .pcLogicOutOut(pipepcLogicOut), .wrtIndexOut(pipewrtIndex), .memOutSelOut(pipememOutSel), .regFileEnOut(piperegFileEn), .isStoreOut(busWrtEn), .isStalledOut(pipeisStalled));
	
	Mux4to1 muxMemOut (pipememOutSel, addrbus, databus, pipepcLogicOut, 32'd0, dataIn);
	
	assign databus = busWrtEn?pipedataOut2:{DBITS{1'bz}};
	
	// Branch Address Calculator
	BranchAddrCalculator bac (.nextPc(pcLogicOut), .pcRel(seImm), .branchAddr(branchPc));
	
endmodule
	