`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Danny Moreno
// 
// Create Date: 01/24/2023 02:49:43 PM
// Design Name: Otter MCU reg file
// Module Name: reg_file
// Project Name: HW3
// Target Devices: OTTER MCU
// Description: This is the module for the reg file of the OTTER MCU
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////


module otter_regmem(
    input [4:0] RF_ADR1, //address 1
    input [4:0] RF_ADR2, //address 2
    input [4:0] RF_WA,//write address
    input [31:0] RF_WD,//write data
    input RF_EN, //enable
    input CLK, //clock
    output logic [31:0] RF_RS1, //
    output logic [31:0] RF_RS2
    );
    
    logic [31:0] ram [0:31]; //creates 32x32 memory array
    logic [31:0] x5, x8, x10, x12, x13;
    assign x5 = ram[5'b00101];
    assign x8 = ram[5'b01000];
    assign x10 = ram[5'b01010];
    assign x12 = ram[5'b01100];
    assign x13 = ram[5'b01101];
    
    //initializes all registers to zero
    initial begin
        int i;
        for (i=0; i<32; i=i+1) begin
            ram[i] = 0;
            end
        end
       
    //reading or outputting to RS1 and RS2 happens continuously
     assign RF_RS1 = ram[RF_ADR1]; //data stored in the selected register address is stored in RS1
     assign RF_RS2 = ram[RF_ADR2]; //data stored in the selected register address is stored in RS2
            
    always_ff@(posedge CLK) begin
        //data is only saved if enable is high on the rising clock edge
        if ((RF_EN == 1'b1) && (RF_WA != 5'b00000)) begin //enable is high and address is not x0         
                ram[RF_WA] <= RF_WD; //data from WD is stored in register at address WA        
         end
    end
    
   
    
    
endmodule