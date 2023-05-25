`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly 
// Engineer: Danny Moreno
// 
// Create Date: 02/07/2023 02:28:25 PM
// Design Name: Branch Address generator
// Module Name: B_ADDR
// Project Name: HW5
// Target Devices: Basys3
// Description: This is the branch address generator for the otter mcu
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module B_ADDR(
    input [31:0] PC,
    input [31:0] J_TYPE,
    input [31:0] B_TYPE,
    input [31:0] I_TYPE,
    input [31:0] RS1,
    output logic [31:0] JALR,
    output logic [31:0] JAL,
    output logic [31:0] BRANCH
    );
    
    assign JALR = I_TYPE + RS1; //creates the JALR address
    assign JAL = PC + J_TYPE; //creates the JAL address
    assign BRANCH = PC + B_TYPE; //creates the BRANCH address
    
    
endmodule
