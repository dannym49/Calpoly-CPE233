`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Danny Moreno
// 
// Create Date: 02/07/2023 02:28:25 PM
// Design Name: Branch Condition Generator
// Module Name: B_COND
// Project Name: HW5 
// Target Devices: Basys3
// Description: This is the branch condition generator for the otter mcu
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////


module B_COND(
    input [31:0] RS1,
    input [31:0] RS2,
    output logic BR_EQ,
    output logic BR_LT,
    output logic BR_LTU
    );
    
    
    
    
    assign BR_EQ = (RS1 == RS2); //assigns BR_EQ
    assign BR_LTU = (RS1 < RS2); //assigns BR_LTU
    assign BR_LT = ($signed(RS1) < $signed(RS2)); //assigns BR_LT
    
endmodule
