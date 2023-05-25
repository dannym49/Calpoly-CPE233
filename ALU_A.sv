`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2023 03:38:26 PM
// Design Name: 
// Module Name: ALU_A
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


module ALU_A(
    input [1:0] ALU_SRCA,
    input [31:0] RS1,
    input [31:0] U_TYPE,
    input [31:0] NRS1,
    output logic [31:0] SRCA
    );
    
      always_comb begin
        case (ALU_SRCA)//selects the case based on value of the PC_SOURCE
        0 : SRCA = RS1;
        1 : SRCA = U_TYPE;
        2 : SRCA = NRS1;
        default : SRCA = 0;
        endcase
    end
    
endmodule
