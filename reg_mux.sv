`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2023 03:01:26 PM
// Design Name: 
// Module Name: reg_mux
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


module reg_mux(
    input [1:0] RF_WR_SEL,
    input [31:0] PC_4,
    input [31:0] RD,
    input [31:0] DOUT2,
    input [31:0] RESULT,
    output logic [31:0] WD
    );
    
    
     always_comb begin
        case (RF_WR_SEL)//selects the case based on value of the source
        0 : WD = PC_4;
        1 : WD = RD;
        2 : WD = DOUT2;
        3 : WD = RESULT;
        default : WD = 0;
        endcase
    end
endmodule
