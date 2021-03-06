`timescale 1ns/1ps

module CPU(clk, rst);
	input clk;
	input rst;
 
	wire[1:0] NPCOp;
	wire[3:0] ALUOp;
	wire RegDst;
	wire EXTOp;
	wire ALUSrc;
	wire RFWrite;
	wire jal;
	wire zero;
	wire MemWrite;
	wire MemRead;
	wire WRSrc;

	//wire[25:0] IMM;
	wire[31:0] npc;
	wire[31:0] pc;
	wire[31:0] instruct;
	wire[31:0] pc4;
	wire[31:0] WriteData;
	wire[4:0]  WriteDst;
	wire[31:0] readD1;
	wire[31:0] readD2;
	wire[31:0] ALUIMM;
	wire[31:0] srcVal;
	wire[31:0] aluResult;
	//wire[31:0] writeMemData;
	wire[31:0] readMemData;
	
	
	PC myPC(npc,
		   pc);

	NPC myNPC(pc,NPCOp,instruct[25:0],readD1,
	          npc);

	IMEM myIMEM(pc,
		     instruct,pc4);

	mux2 myMux_1 #(5)(instruct[15:11],instruct[20:16],RegDst,
			   WriteDst);

	RF myRF(clk,rst,RFWrite,jal,instruct[25:21],instruct[20:16],WriteDst,WriteData,
		 readD1,readD2);

	Extend myExtend(instruct[15:0],EXTOp,
			ALUIMM);

	mux2 myMux_2 #(32)(readD2,ALUIMM,ALUSrc
			   srcVal);

	alu myALU(readD1,srcVal,instruct[10:6],
		   aluResult,zero);

	DMEM my_DMEM(clk,aluResult,readD2,MemWrite,Memread,
			           readMemData);

	mux2 myMux_3 #(32)(aluResult,readMemData,WRSrc,
			   WriteData);
endmodule
	
	
