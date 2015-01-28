module PipelineRegister (clk, reset, wrtEn, dataOut2In, aluOutIn, pcLogicOutIn, wrtIndexIn, memOutSelIn, regFileEnIn, isLoadIn, isStoreIn, isStalledIn, dataOut2Out, aluOutOut, pcLogicOutOut, wrtIndexOut, memOutSelOut, regFileEnOut, isLoadOut, isStoreOut, isStalledOut);
parameter DATA_BIT_WIDTH = 32;

input clk, reset, wrtEn;

input[DATA_BIT_WIDTH - 1: 0] dataOut2In;
input[DATA_BIT_WIDTH - 1: 0] aluOutIn;
input[DATA_BIT_WIDTH - 1: 0] pcLogicOutIn;
input[3: 0] wrtIndexIn;
input[1:0] memOutSelIn;
input regFileEnIn, isLoadIn, isStoreIn, isStalledIn;

output[DATA_BIT_WIDTH - 1: 0] dataOut2Out;
output[DATA_BIT_WIDTH - 1: 0] aluOutOut;
output[DATA_BIT_WIDTH - 1: 0] pcLogicOutOut;
output[3: 0] wrtIndexOut;
output[1:0] memOutSelOut;
output regFileEnOut, isLoadOut, isStoreOut, isStalledOut;

Register #(.BIT_WIDTH(DATA_BIT_WIDTH), .RESET_VALUE(0)) dataOut2Reg (clk, reset, wrtEn, dataOut2In, dataOut2Out);
Register #(.BIT_WIDTH(DATA_BIT_WIDTH), .RESET_VALUE(0)) aluOutReg (clk, reset, wrtEn, aluOutIn, aluOutOut);
Register #(.BIT_WIDTH(DATA_BIT_WIDTH), .RESET_VALUE(0)) pcLogicOutReg (clk, reset, wrtEn, pcLogicOutIn, pcLogicOutOut);
Register #(.BIT_WIDTH(4), .RESET_VALUE(0)) wrtIndexReg (clk, reset, wrtEn, wrtIndexIn, wrtIndexOut);
Register #(.BIT_WIDTH(2), .RESET_VALUE(0)) memOutSelReg (clk, reset, wrtEn, memOutSelIn, memOutSelOut);
Register #(.BIT_WIDTH(1), .RESET_VALUE(0)) regFileEnReg (clk, reset, wrtEn, regFileEnIn, regFileEnOut);
Register #(.BIT_WIDTH(1), .RESET_VALUE(0)) isLoadReg (clk, reset, wrtEn, isLoadIn, isLoadOut);
Register #(.BIT_WIDTH(1), .RESET_VALUE(0)) isStoreReg (clk, reset, wrtEn, isStoreIn, isStoreOut);
Register #(.BIT_WIDTH(1), .RESET_VALUE(0)) isStalledReg (clk, reset, wrtEn, isStalledIn, isStalledOut);

endmodule
