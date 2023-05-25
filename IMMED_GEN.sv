`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Danny Moreno
// 
// Create Date: 01/30/2023 05:15:56 PM
// Design Name: Immediate Generator
// Module Name: IMMED_tb
// Project Name: HW4
// Target Devices: basys3
// Tool Versions: 
// Description: This is the immediate generator for the otter mcu
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module IMMED_GEN(
    input [24:0] INSTRUCT,
    output logic [31:0] U_TYPE,
    output logic [31:0] I_TYPE,
    output logic [31:0] S_TYPE,
    output logic [31:0] J_TYPE,
    output logic [31:0] B_TYPE
    );
    
        assign U_TYPE = {INSTRUCT[24:5], 12'b0}; //creates the U_TYPE instruction        
        assign I_TYPE = {{21{INSTRUCT[24]}},INSTRUCT[23:13]};//all other I type instructions            
        assign S_TYPE = {{21{INSTRUCT[24]}}, INSTRUCT[23:18], INSTRUCT[4:0]};
        assign B_TYPE = {{21{INSTRUCT[24]}}, INSTRUCT[0], INSTRUCT[23:18], INSTRUCT[4:1], 1'b0};
        assign J_TYPE = {{21{INSTRUCT[24]}}, INSTRUCT[12:5], INSTRUCT[13], INSTRUCT[23:14], 1'b0};
        
endmodule
