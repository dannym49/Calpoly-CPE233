`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Danny Moreno
// 
// Create Date: 02/16/2023 02:18:37 PM
// Design Name: OTTER MCU 
// Module Name: Otter_mcu
// Project Name: HW6
// Target Devices: Basys3
// Description: This is the module that connects all of the components of the OTTER MCU
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////


module Otter_mcu(
    input [31:0] IOBUS_IN,
    input RST, 
    input INTR, 
    input CLK, 
    output [31:0] IOBUS_OUT,  
    output [31:0] IOBUS_ADDR, 
    output IOBUS_WR);
    
    //PC
    logic [31:0] JALR, JAL, BRANCH, MTVEC, MEPC, PC_ADDRESS, MUX_OUT, PC_4;
    logic [31:0] PC4;
    logic [2:0] PC_SOURCE;
    logic PC_WRITE, PC_RST;
    assign PC4 = PC_ADDRESS + 32'b00000000000000000000000000000100;
    PC_MUX mux_mod(.PC_4(PC4), .JALR(JALR), .BRANCH(BRANCH), .JAL(JAL), .MTVEC(MTVEC), .MEPC(MEPC), .PC_SOURCE(PC_SOURCE), .MUX_OUT(MUX_OUT));
    PC pc_mod(.PC_WRITE(PC_WRITE), .PC_RST(RESET), .CLK(CLK), .PC_DIN(MUX_OUT), .PC_COUNT(PC_ADDRESS));    
    
    //Memory
    logic MEM_RDEN1, MEM_RDEN2, MEM_WE2, MEM_SIGN, IO_WR;
    logic [13:0] MEM_ADDR1;
    logic [31:0] MEM_ADDR2, MEM_DIN2, IO_IN, MEM_DOUT1, MEM_DOUT2, ALU_RESULT,  RF_RS2;
    logic [1:0] MEM_SIZE; 
    
    Memory mem_mod(.MEM_CLK(CLK), .MEM_RDEN1(MEM_RDEN1), .MEM_RDEN2(MEM_RDEN2), .MEM_WE2(MEM_WE2), .MEM_SIGN(MEM_DOUT1[14]), .IO_WR(IOBUS_WR), .MEM_ADDR2(ALU_RESULT), .MEM_ADDR1(PC_ADDRESS[15:2]), .MEM_DIN2(RF_RS2), .IO_IN(IOBUS_IN), .MEM_DOUT1(MEM_DOUT1), .MEM_DOUT2(MEM_DOUT2), .MEM_SIZE(MEM_DOUT1[13:12]));
    
  
    //reg_file
    
    logic [4:0] RF_ADR1, RF_ADR2, RF_WA;
    logic RF_EN;
    logic [31:0] RF_WD, RF_RS1, RD, DOUT2, WD;
    logic [1:0] RF_WR_SEL;
    
    reg_mux regmux(.PC_4(PC4), .RESULT(ALU_RESULT), .DOUT2(MEM_DOUT2), .RD(RD), .RF_WR_SEL(RF_WR_SEL), .WD(WD));
    otter_regmem regfile(.RF_ADR1(MEM_DOUT1[19:15]), .RF_ADR2(MEM_DOUT1[24:20]), .RF_WA(MEM_DOUT1[11:7]), .RF_EN(RF_EN), .RF_WD(WD), .RF_RS1(RF_RS1), .RF_RS2(RF_RS2), .CLK(CLK));
    assign IOBUS_OUT = RF_RS2;
    
    //immed generator
    logic [31:0] U_TYPE, I_TYPE, J_TYPE, S_TYPE, B_TYPE;
    
    IMMED_GEN immed_gen(.INSTRUCT(MEM_DOUT1[31:7]), .U_TYPE(U_TYPE), .I_TYPE(I_TYPE), .J_TYPE(J_TYPE), .S_TYPE(S_TYPE), .B_TYPE(B_TYPE));
    
    
    //ALU
    
    logic [1:0] ALU_SRCA;
    logic [2:0] ALU_SRCB;
    logic [31:0] SRCA, SRCB;
    logic [3:0] ALU_FUN;
    
    ALU_A alu_a(.ALU_SRCA(ALU_SRCA), .RS1(RF_RS1), .U_TYPE(U_TYPE), .NRS1(~RF_RS1), .SRCA(SRCA));
    ALU_B alu_b(.ALU_SRCB(ALU_SRCB), .RS2(RF_RS2), .S_TYPE(S_TYPE), .I_TYPE(I_TYPE), .PC(PC_ADDRESS), .CSR_RD(RD), .SRCB(SRCB));
    ALU alu(.A(SRCA), .B(SRCB), .ALU_FUN(ALU_FUN), .RESULT(ALU_RESULT));
    assign IOBUS_ADDR = ALU_RESULT;
    
    
    //branch address generator
    B_ADDR address_gen(.PC(PC_ADDRESS), .J_TYPE(J_TYPE), .B_TYPE(B_TYPE), .I_TYPE(I_TYPE), .RS1(RF_RS1), .JALR(JALR), .JAL(JAL), .BRANCH(BRANCH));
   
    //branch condition generator
    logic BR_EQ, BR_LT, BR_LTU;
    B_COND branch_cond(.RS1(RF_RS1), .RS2(RF_RS2), .BR_EQ(BR_EQ), .BR_LT(BR_LT), .BR_LTU(BR_LTU));
    
    
    logic MRET_EXEC, INT_TAKEN, WR_EN, MIE;
    //CU Decoder
    CU_DECODER cu_dcdr(.INT_TAKEN(INT_TAKEN), .IR_30(MEM_DOUT1[30]), .PC_SOURCE(PC_SOURCE), .IR_1412(MEM_DOUT1[14:12]), .ALU_SRCB(ALU_SRCB), .ALU_SRCA(ALU_SRCA), .RF_WR_SEL(RF_WR_SEL), .BR_EQ(BR_EQ), .BR_LT(BR_LT), .BR_LTU(BR_LTU), .ALU_FUN(ALU_FUN), .IR_60(MEM_DOUT1[6:0])); 
    
    //CU FSM
    CU_FSM cu_fsm(.INTR(INTR), .MIE(MIE), .RST(RST), .CLK(CLK), .IR_60(MEM_DOUT1[6:0]), .IR_1412(MEM_DOUT1[14:12]), .PC_WRITE(PC_WRITE), .REG_WRITE(RF_EN), .MEM_WE2(MEM_WE2), .MEM_RDEN1(MEM_RDEN1), .MEM_RDEN2(MEM_RDEN2), .RESET(RESET), .INT_TAKEN(INT_TAKEN), .CSR_WE(WR_EN), .MRET_EXEC(MRET_EXEC));  
    
    logic [31:0] MSTATUS;
    //CSR
    CSR csr(.MSTATUS(MSTATUS), .RST(RST), .MRET_EXEC(MRET_EXEC), .INT_TAKEN(INT_TAKEN), .ADDR(MEM_DOUT1[31:20]), .WR_EN(WR_EN), .PC(PC_ADDRESS), .WD(ALU_RESULT), .CLK(CLK), .MIE(MIE), .MEPC(MEPC), .MTVEC(MTVEC), .RD(RD));
endmodule
