`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Danny Moreno
// 
// Create Date: 02/01/2023 05:52:48 PM
// Design Name: Arithmetic logic unit
// Module Name: ALU
// Project Name: Hw4
// Target Devices: Otter mcu
// Description: This is the ALU for the otter mcu
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALU_FUN,
    output logic [31:0] RESULT
    );
    
    always_comb begin
        case (ALU_FUN)
            4'b0000: RESULT = $signed(A) + $signed(B); //ADD
            4'b1000: RESULT = $signed(A) - $signed(B);//SUB
            4'b0110: RESULT = A | B;//OR
            4'b0111: RESULT = A & B;//AND
            4'b0100: RESULT = A ^ B;//XOR
            4'b0101: RESULT = A >> B[4:0];//SRL
            4'b0001: RESULT = A << B[4:0];//SLL
            4'b1101: RESULT = $signed(A) >>> B[4:0];//SRA
            4'b0010: if ($signed(A) < $signed(B)) //SLT
                        RESULT = 32'b1;
                     else
                        RESULT = 32'd0;
                        
            4'b0011:if (A < B) //SLTU
                        RESULT = 32'd1;
                     else
                        RESULT = 32'd0;
                        
            4'b1001: RESULT = A;//LUI-COPY
            default: RESULT = 32'b0;
            
        endcase
    
    end 
endmodule
