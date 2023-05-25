`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Danny Moreno
// 
// Create Date: 03/08/2023 12:36:00 PM
// Design Name: Control Status Registers
// Module Name: CSR
// Project Name: HW8
// Target Devices: OTTER MCU
// Description: This is the CSR for the OTTER MCU
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////


module CSR(

    input CLK,
    input RST, 
    input MRET_EXEC, 
    input INT_TAKEN, 
    input WR_EN,
    input [11:0] ADDR,
    input [31:0] PC, WD,
    output logic [31:0] MSTATUS, 
    output logic [31:0] MEPC, 
    output logic [31:0] MTVEC, 
    output logic [31:0] RD,
    output logic  MIE

    );
    
    /*assign MEPC = 32'b0; //initializing all registers
    assign MTVEC = 32'b0;
    assign MSTATUS = 32'b0; */
    
    assign MIE = MSTATUS[3];
    
    
    //asynchronous reading
    always_comb
        begin
        case(ADDR)        
            12'h300: RD = MSTATUS;
            12'h305: RD = MTVEC;
            12'h341: RD = MEPC;     
            default: RD = 32'h0;
        endcase
        end
    
    //synchronous write
    always_ff @ (posedge CLK) //MSTATUS 
        begin
            if (RST == 1'b1) //RESET
                MSTATUS <= 32'b0;              
            else if (WR_EN == 1'b1 & ADDR == 12'h300)//If write is high and CSR is MSTATUS
                MSTATUS <= WD;              
            else if (INT_TAKEN == 1'b1) 
                MSTATUS <= 32'h00000080; //disable interrupts    
            else if (MRET_EXEC == 1'b1) 
                MSTATUS <= 32'h00000008; //re-enable interrupts
         end
        
    always_ff @ (posedge CLK) begin//MEPC
        if (RST == 1'b1) //RESET
            MEPC <= 32'b0;
        else if (INT_TAKEN == 1'b1)  //might need if WR_EN == 1 
            MEPC <= PC;  //save current PC in MEPC to be used for returning 
        end
    
     always_ff @ (posedge CLK) begin // MTVEC
        if (RST == 1'b1) //RESET
            MTVEC <= 32'b0;           
        else if (WR_EN == 1'b1 & ADDR == 12'h305) 
            MTVEC <= WD;              
        end 
endmodule


/*

module CSR(
    input RST,
    input logic MRET_EXEC,
    input logic INT_TAKEN,
    input logic [11:0] ADDR,
    input logic WR_EN,
    input logic [31:0] PC,
    input logic [31:0] WD,
    output logic MSTATUS_3,
    output logic [31:0] MEPC,
    output logic [31:0] MTVEC,
    output logic [31:0] RD,
    input CLK
    );
    
    logic [31:0] MSTATUS; 
    always_ff @ (posedge CLK) begin
        if (RST) begin
            MEPC <= 32'b0;
            MSTATUS <= 32'h0;
            MTVEC <= 32'b0;
            MSTATUS_3 <= 1'b1;
        end
        else if (WR_EN) begin//write to registers
            case (ADDR) 
                12'h300: begin //write to mstatus
                    RD = MSTATUS;
                    MSTATUS = WD;
                    MSTATUS_3 = MSTATUS[3];
                end
                12'h305: begin //write to mtvec
                    RD = MTVEC;
                    MTVEC = WD;
                end
                12'h341: begin //write to MEPC
                    RD = MEPC;
                    MEPC = WD;
                end
                default: begin 
                    RD = 1'b0; // default value when no condition is met
                    MSTATUS = 1'b0;
                    MEPC = 1'b0;
                    MTVEC = 1'b0;
                    end
                endcase
        end 
        
        else if ((INT_TAKEN == 1'b1) & (MRET_EXEC == 1'b0)) begin//interrupt occurs
                MEPC = PC;
                MSTATUS[7] = MSTATUS[3];
                MSTATUS[3] = 1'b0;
            end
        else begin//if ((MRET_EXEC) & (INT_TAKEN == 1'b0)) //end of interrupt
                MSTATUS[3] = MSTATUS[7];
                MSTATUS[7] = 1'b0;
                
            end
        end
    
endmodule
*/