`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2023 03:38:26 PM
// Design Name: 
// Module Name: ALU_B
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU_B(
    input [2:0] ALU_SRCB,
    input [31:0] RS2,
    input [31:0] I_TYPE,
    input [31:0] S_TYPE,
    input [31:0] PC,
    input [31:0] CSR_RD,
    output logic [31:0] SRCB
    );
    
     always_comb begin
        case (ALU_SRCB)//selects the case based on value of the PC_SOURCE
        0 : SRCB = RS2;
        1 : SRCB = I_TYPE;
        2 : SRCB = S_TYPE;
        3 : SRCB = PC;
        4 : SRCB = CSR_RD;
        default : SRCB = 0;
        endcase
    end
    
endmodule
