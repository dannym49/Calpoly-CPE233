`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Danny Moreno
// 
// Create Date: 01/18/2023 06:53:09 PM
// Design Name: Program Counter
// Module Name: PC
// Project Name: HW2
// Target Devices: Basys3
// Description: This is the Program Counter module for hardware 2.
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////


module PC(
    input PC_WRITE,
    input PC_RST,
    input CLK,
    input logic [31:0] PC_DIN,
    output logic [31:0] PC_COUNT
    );
    
    always_ff @(posedge CLK) begin
    if (PC_RST) //synchronous reset
        PC_COUNT <= 0;
    else if (PC_WRITE) //checks if PC_WRITE is a 1 or 0
        PC_COUNT <= PC_DIN; //if PC_write is 1, PC_COUNT becomes a new value
    else
        PC_COUNT <= PC_COUNT; //if PC_WRITE is 0, no change
    end

endmodule
