`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Danny Moreno
// 
// Create Date: 01/18/2023 07:16:58 PM
// Design Name: Multiplexer
// Module Name: PC_MUX
// Project Name: HW2
// Target Devices: Basys3
// Description: This is the module for the multiplexer for hw2
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////


module PC_MUX(
    input logic [31:0] PC_4,
    input logic [31:0] JALR,
    input logic [31:0] BRANCH,
    input logic [31:0] JAL,
    input logic [31:0] MTVEC,
    input logic [31:0] MEPC,
    input logic [2:0] PC_SOURCE, //SEL
    output logic [31:0] MUX_OUT
    );
    
    always_comb begin
        case (PC_SOURCE)//selects the case based on value of the PC_SOURCE
        0 : MUX_OUT = PC_4;
        1 : MUX_OUT = JALR;
        2 : MUX_OUT = BRANCH;
        3 : MUX_OUT = JAL;
        4 : MUX_OUT = MTVEC;
        5: MUX_OUT = MEPC; 
        default : MUX_OUT = 0;
        endcase
    end
endmodule
