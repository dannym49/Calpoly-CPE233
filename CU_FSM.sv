`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Danny Moreno
// 
// Create Date: 02/20/2023 11:12:06 PM
// Design Name: Control Unit FSM
// Module Name: CU_FSM
// Project Name: HW7
// Target Devices: Basys3
// Tool Versions: 
// Description: This is the fsm for the Otter Mcu
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////


module CU_FSM(
    input RST,
    input CLK,
    input [6:0] IR_60,
    input [2:0] IR_1412,
    input INTR,
    input MIE,
    output logic PC_WRITE,
    output logic REG_WRITE,
    output logic MEM_WE2,
    output logic MEM_RDEN1,
    output logic MEM_RDEN2,
    output logic RESET,
    output logic INT_TAKEN,
    output logic MRET_EXEC,
    output logic CSR_WE
    );
    
    typedef enum{ST_INIT, ST_FETCH, ST_EXECUTE, ST_WRITEBACK, ST_INTR} state_type;
    state_type PS, NS;
    
    always_ff @(posedge CLK) begin
        if (RST == 1'b1)
            PS <= ST_INIT;
        else
            PS <= NS;
    end
    
    logic INTERRUPT;
    assign INTERRUPT = INTR & MIE; 
   
    always_comb begin
        PC_WRITE = 1'b0;
        REG_WRITE = 1'b0;
        MEM_WE2 = 1'b0;
        MEM_RDEN1 = 1'b0;
        MEM_RDEN2 = 1'b0;
        RESET = 1'b0;
        INT_TAKEN = 1'b0;
        CSR_WE = 1'b0;
        MRET_EXEC = 1'b0;
        case(PS) 
            ST_INIT : begin
                RESET = 1'b1;
                NS = ST_FETCH;
                end
            ST_FETCH : begin
                MEM_RDEN1 = 1'b1;
                NS = ST_EXECUTE;
                end
            ST_EXECUTE : begin
                case(IR_60) 
                    7'b0110011 : begin //all R-TYPE instructions
                                    PC_WRITE = 1'b1;
                                    REG_WRITE = 1'b1;
                                    if (INTERRUPT)
                                        NS = ST_INTR;
                                    else
                                        NS = ST_FETCH;
                                    end
                    7'b0010011 : begin    //I-type
                                    PC_WRITE = 1'b1;
                                    REG_WRITE = 1'b1;
                                    if (INTERRUPT)
                                        NS = ST_INTR;
                                    else
                                        NS = ST_FETCH;
                                    end
                    7'b1100111 : begin//JALR
                                    PC_WRITE = 1'b1;
                                    REG_WRITE = 1'b1;
                                    if (INTERRUPT)
                                        NS = ST_INTR;
                                    else
                                        NS = ST_FETCH;
                                    end
                    7'b0100011 : begin //S-Type
                                    PC_WRITE = 1'b1;
                                    MEM_WE2 = 1'b1;
                                    if (INTERRUPT)
                                        NS = ST_INTR;
                                    else
                                        NS = ST_FETCH;
                                    end
                    7'b1100011 : begin //B-TYPE
                                    PC_WRITE = 1;
                                    if (INTERRUPT)
                                        NS = ST_INTR;
                                    else
                                        NS = ST_FETCH;
                                    end 
                    7'b0110111 : begin //lui
                                    PC_WRITE = 1'b1;
                                    REG_WRITE = 1'b1;
                                    if (INTERRUPT)
                                        NS = ST_INTR;
                                    else
                                        NS = ST_FETCH;
                                    end
                    7'b0010111 : begin //aupic
                                    PC_WRITE = 1'b1;
                                    REG_WRITE = 1'b1;
                                    if (INTERRUPT)
                                        NS = ST_INTR;
                                    else
                                        NS = ST_FETCH;
                                    end      
                    7'b1101111: begin //J-TYPE
                                    PC_WRITE = 1'b1;
                                    REG_WRITE = 1'b1;
                                    if (INTERRUPT)
                                        NS = ST_INTR;
                                    else
                                        NS = ST_FETCH;
                                    end
                    7'b0000011 : begin  //Load instructions
                                    MEM_RDEN2 = 1'b1;
                                    NS = ST_WRITEBACK;
                                    end
                                    
                    7'b1110011: begin //CSR instructions
                        case (IR_1412)
                            3'b000:begin
                                MRET_EXEC = 1'b1;
                                PC_WRITE = 1'b1;
                                if (INTERRUPT)
                                        NS = ST_INTR;
                                    else
                                        NS = ST_FETCH;
                                    
                                end
                            3'b011:begin
                                CSR_WE = 1'b1;
                                PC_WRITE = 1'b1;
                                REG_WRITE = 1'b1;
                                if (INTERRUPT)
                                        NS = ST_INTR;
                                    else
                                        NS = ST_FETCH;
                                end
                            3'b010: begin
                                CSR_WE = 1'b1;
                                PC_WRITE = 1'b1;
                                REG_WRITE = 1'b1;
                                if (INTERRUPT)
                                        NS = ST_INTR;
                                    else
                                        NS = ST_FETCH;
                            end     
                            3'b001: begin
                                CSR_WE = 1'b1;
                                PC_WRITE = 1'b1;
                                REG_WRITE = 1'b1;
                                if (INTERRUPT)
                                        NS = ST_INTR;
                                    else
                                        NS = ST_FETCH;
                                end  
                             default: NS = ST_INIT;   
                            endcase
                       
                            
                        end
                        
                    default : NS = ST_INIT;
                endcase
           
                end
           
            ST_WRITEBACK : begin
                            REG_WRITE = 1'b1;
                            PC_WRITE = 1'b1;
                            if (INTERRUPT)
                                NS = ST_INTR;
                            else
                                NS = ST_FETCH;
                            end
            ST_INTR : begin
                INT_TAKEN = 1'b1;
                PC_WRITE = 1'b1;
                NS = ST_FETCH;
            end

            default : NS = ST_INIT;
        endcase
    
    end
    
endmodule

//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: Cal Poly
//// Engineer: Danny Moreno
//// 
//// Create Date: 02/20/2023 11:12:06 PM
//// Design Name: Control Unit FSM
//// Module Name: CU_FSM
//// Project Name: HW7
//// Target Devices: Basys3
//// Tool Versions: 
//// Description: This is the fsm for the Otter Mcu
//// Revision 0.01 - File Created
////////////////////////////////////////////////////////////////////////////////////


//module CU_FSM(
//    input RST,
//    input CLK,
//    input [6:0] IR_60,
//    input [2:0] IR_1412,
//    output logic PC_WRITE,
//    output logic REG_WRITE,
//    output logic MEM_WE2,
//    output logic MEM_RDEN1,
//    output logic MEM_RDEN2,
//    output logic RESET
//    );
    
//    typedef enum{ST_INIT, ST_FETCH, ST_EXECUTE, ST_WRITEBACK} state_type;
//    state_type PS, NS;
    
//    always_ff @(posedge CLK) begin
//        if (RST == 1'b1)
//            PS <= ST_INIT;
//        else
//            PS <= NS;
//    end
    
//    always_comb begin
//        PC_WRITE = 1'b0;
//        REG_WRITE = 1'b0;
//        MEM_WE2 = 1'b0;
//        MEM_RDEN1 = 1'b0;
//        MEM_RDEN2 = 1'b0;
//        RESET = 1'b0;
//        case(PS) 
//            ST_INIT : begin
//                RESET = 1'b1;
//                NS = ST_FETCH;
//                end
//            ST_FETCH : begin
//                MEM_RDEN1 = 1'b1;
//                NS = ST_EXECUTE;
//                end
//            ST_EXECUTE : begin
//                case(IR_60) 
//                    7'b0110011 : begin //all R-TYPE instructions
//                                    PC_WRITE = 1'b1;
//                                    REG_WRITE = 1'b1;
//                                    NS = ST_FETCH;
//                                    end
//                    7'b0010011 : begin    //I-type
//                                    PC_WRITE = 1'b1;
//                                    REG_WRITE = 1'b1;
//                                    NS = ST_FETCH;
//                                    end
//                    7'b1100111 : begin//JALR
//                                    PC_WRITE = 1'b1;
//                                    REG_WRITE = 1'b1;
//                                    NS = ST_FETCH;
//                                    end
//                    7'b0100011 : begin //S-Type
//                                    PC_WRITE = 1'b1;
//                                    MEM_WE2 = 1'b1;
//                                    NS = ST_FETCH;
//                                    end
//                    7'b1100011 : begin //B-TYPE
//                                    PC_WRITE = 1;
//                                    NS = ST_FETCH;
//                                    end 
//                    7'b0110111 : begin //lui
//                                    PC_WRITE = 1'b1;
//                                    REG_WRITE = 1'b1;
//                                    NS = ST_FETCH;
//                                    end
//                    7'b0010111 : begin //aupic
//                                    PC_WRITE = 1'b1;
//                                    REG_WRITE = 1'b1;
//                                    NS = ST_FETCH;
//                                    end      
//                    7'b1101111: begin //J-TYPE
//                                    PC_WRITE = 1'b1;
//                                    REG_WRITE = 1'b1;
//                                    NS = ST_FETCH;
//                                    end
//                    7'b0000011 : begin  //Load instructions
//                                    MEM_RDEN2 = 1'b1;
//                                    NS = ST_WRITEBACK;
//                                    end
//                    default : NS = ST_INIT;
//                endcase
           
//                end
           
//            ST_WRITEBACK : begin
                            
//                            REG_WRITE = 1'b1;
//                            PC_WRITE = 1'b1;
//                            NS = ST_FETCH;
                           
//                            end
//            default : NS = ST_INIT;
//        endcase
    
//    end
    
//endmodule
