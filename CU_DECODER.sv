`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2023 08:24:38 PM
// Design Name: 
// Module Name: CU_DECODER
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


module CU_DECODER(
    input [2:0] IR_1412,
    input IR_30,
    input BR_EQ,
    input BR_LT,
    input BR_LTU,
    input [6:0] IR_60,
    input logic INT_TAKEN,
    output logic [3:0] ALU_FUN,
    output logic [1:0] ALU_SRCA,
    output logic [2:0] ALU_SRCB,
    output logic [2:0] PC_SOURCE,
    output logic [1:0] RF_WR_SEL
    );
    
    always_comb begin
    ALU_FUN = 4'b0;
    ALU_SRCA = 2'b0;
    ALU_SRCB = 3'b0;
    PC_SOURCE = 3'b0;
    RF_WR_SEL = 2'b0;
    

    
    if (INT_TAKEN) begin
        PC_SOURCE = 3'b100;  //MTVEC      
        end
    else begin
        case (IR_60) 
        7'b0110011 : begin //opcode
            RF_WR_SEL = 2'b11;//R-type
                if (IR_30 == 1'b0)begin
                    case (IR_1412)
                        3'b000 : ALU_FUN = 4'b0000;//add
                        3'b111 : ALU_FUN = 4'b0111;//and
                        3'b110 : ALU_FUN = 4'b0110;//or
                        3'b001 : ALU_FUN = 4'b0001;//sll
                        3'b010 : ALU_FUN = 4'b0010;//slt
                        3'b011 : ALU_FUN = 4'b0011;//sltu
                        3'b101 : ALU_FUN = 4'b0101;//srl
                        3'b100 : ALU_FUN = 4'b0100; //xor
                    endcase
                end
                else begin 
                    case (IR_1412)
                        3'b000 : ALU_FUN = 4'b1000; //sub
                        3'b101 : ALU_FUN = 4'b1101; //sra
                    endcase
                end
            end
                   
        7'b0010011 : begin 
            ALU_SRCA = 2'b00;//rs1
            ALU_SRCB = 3'b001;//I_type
            PC_SOURCE = 3'b000;//add 4
            RF_WR_SEL = 2'b11;//alu output
            case (IR_1412) //I_TYPE
                3'b000 : ALU_FUN = 4'b0000;//addi
                3'b111 : ALU_FUN = 4'b0111;//andi
                3'b110 : ALU_FUN = 4'b0110;//ori
                3'b001 : ALU_FUN = 4'b0001;//slli
                3'b010 : ALU_FUN = 4'b0010;//slti
                3'b011 : ALU_FUN = 4'b0011;//sltiu
                3'b101 : if (IR_30 == 1'b1) 
                            ALU_FUN = 4'b1101; //srai
                        else 
                            ALU_FUN = 4'b0101;//srli
                        
                3'b100 : ALU_FUN = 4'b0100;//xori
                  endcase 
              end
          
         7'b1100111 : begin 
            
            PC_SOURCE = 3'b001;//jalr
            end
            
         7'b0000011 : begin 
            ALU_SRCB = 3'b001;
            RF_WR_SEL = 2'b10;
            ALU_FUN = 4'b0000;//all outputs the same for load instructions
                   end
                   
         7'b0100011 : begin //S-type
            ALU_SRCB = 3'b010;//immed gen
            RF_WR_SEL = 2'b11;//doesnt matter
            ALU_FUN = 4'b0000;//all outputs is the same for save instructions
            
                   end  
         7'b1100011 : begin //B-type
            
            case (IR_1412) 
                3'b000 : begin 
                         if (BR_EQ == 1'b1)
                            PC_SOURCE = 3'b010;//Branch source
                         else 
                            PC_SOURCE = 3'b000;//add 4 to pc
                            end 
                3'b101 : begin 
                         if (BR_LT == 1'b0)
                            PC_SOURCE = 3'b010;//Branch source
                         else 
                            PC_SOURCE = 3'b000;//add 4 to pc
                            end 
                3'b111 : begin 
                         if (BR_LTU == 1'b0)
                            PC_SOURCE = 3'b010;//Branch source
                         else 
                            PC_SOURCE = 3'b000;//add 4 to pc
                            end 
                3'b100 : begin 
                         if (BR_LT == 1'b1)
                            PC_SOURCE = 3'b010;//Branch source
                         else 
                            PC_SOURCE = 3'b000;//add 4 to pc
                            end 
                3'b110 : begin 
                         if (BR_LTU == 1'b1)
                            PC_SOURCE = 3'b010;//Branch source
                         else 
                            PC_SOURCE = 3'b000;//add 4 to pc
                            end 
                3'b001 : begin 
                         if (BR_EQ == 1'b0)
                            PC_SOURCE = 3'b010;//Branch source
                         else 
                            PC_SOURCE = 3'b000;//add 4 to pc
                            end 
                endcase
            end        
            
         7'b0110111 : begin //U_TYPE
            ALU_SRCA = 2'b01; 
            RF_WR_SEL = 2'b11;
            ALU_FUN = 4'b1001;//lui
                end          
                
         7'b0010111 : begin//auipc
            ALU_SRCA = 2'b01;
            ALU_SRCB = 3'b011;
            RF_WR_SEL = 2'b11;
            end
         7'b1101111 : begin //JAL
            PC_SOURCE = 3'b011;//JAL source
            end
            
         7'b1110011: begin //CSR instructions
            case(IR_1412)
                3'b000: PC_SOURCE = 4'b101;//MRET
                
                3'b001: begin//CSRRW
                    PC_SOURCE = 3'b000;
                    RF_WR_SEL = 2'b01;//CSR_RD
                    ALU_FUN = 4'b1001;//lui copy
                    end
                3'b010: begin//CSRRS
                    PC_SOURCE = 3'b000;
                    RF_WR_SEL = 2'b01;//CSR_RD
                    ALU_SRCB = 3'b100;//CSR_RD into the ALU
                    ALU_FUN = 4'b0110;//ORs the value in rs1 with the CSR_RD to set the bits
                    end
                3'b011: begin //CSRRC
                    PC_SOURCE = 3'b000;
                    RF_WR_SEL = 2'b01; //CSR_RD
                    ALU_SRCB = 3'b100;//CSR_RD into the ALU
                    ALU_SRCA = 3'b010;
                    ALU_FUN = 4'b0111; //AND the value in RS1 with the CSR_RD to clear the bits
                    end
                endcase
            
           
            
            
            
            end
         
            endcase
       end
    
    end
    
endmodule

//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 02/16/2023 08:24:38 PM
//// Design Name: 
//// Module Name: CU_DECODER
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////


//module CU_DECODER(
//    input [2:0] IR_1412,
//    input IR_30,
//    input BR_EQ,
//    input BR_LT,
//    input BR_LTU,
//    input [6:0] IR_60,
//    output logic [3:0] ALU_FUN,
//    output logic [1:0] ALU_SRCA,
//    output logic [2:0] ALU_SRCB,
//    output logic [2:0] PC_SOURCE,
//    output logic [1:0] RF_WR_SEL
//    );
    
//    always_comb begin
//    ALU_FUN = 4'b0;
//    ALU_SRCA = 2'b0;
//    ALU_SRCB = 3'b0;
//    PC_SOURCE = 3'b0;
//    RF_WR_SEL = 2'b0;
    
//    case (IR_60) 
//    7'b0110011 : begin //opcode
//        RF_WR_SEL = 2'b11;//R-type
//            if (IR_30 == 1'b0)begin
//                case (IR_1412)
//                    3'b000 : ALU_FUN = 4'b0000;//add
//                    3'b111 : ALU_FUN = 4'b0111;//and
//                    3'b110 : ALU_FUN = 4'b0110;//or
//                    3'b001 : ALU_FUN = 4'b0001;//sll
//                    3'b010 : ALU_FUN = 4'b0010;//slt
//                    3'b011 : ALU_FUN = 4'b0011;//sltu
//                    3'b101 : ALU_FUN = 4'b0101;//srl
//                    3'b100 : ALU_FUN = 4'b0100; //xor
//                endcase
//            end
//            else begin 
//                case (IR_1412)
//                    3'b000 : ALU_FUN = 4'b1000; //sub
//                    3'b101 : ALU_FUN = 4'b1101; //sra
//                endcase
//            end
//        end
               
//    7'b0010011 : begin 
//        ALU_SRCA = 2'b00;//rs1
//        ALU_SRCB = 3'b001;//I_type
//        PC_SOURCE = 3'b000;//add 4
//        RF_WR_SEL = 2'b11;//alu output
//        case (IR_1412) //I_TYPE
//            3'b000 : ALU_FUN = 4'b0000;//addi
//            3'b111 : ALU_FUN = 4'b0111;//andi
//            3'b110 : ALU_FUN = 4'b0110;//ori
//            3'b001 : ALU_FUN = 4'b0001;//slli
//            3'b010 : ALU_FUN = 4'b0010;//slti
//            3'b011 : ALU_FUN = 4'b0011;//sltiu
//            3'b101 : if (IR_30 == 1'b1) 
//                        ALU_FUN = 4'b1101; //srai
//                    else 
//                        ALU_FUN = 4'b0101;//srli
                    
//            3'b100 : ALU_FUN = 4'b0100;//xori
//              endcase 
//          end
      
//     7'b1100111 : begin 
        
//        PC_SOURCE = 3'b001;//jalr
//        end
        
//     7'b0000011 : begin 
//        ALU_SRCB = 3'b001;
//        RF_WR_SEL = 2'b10;
//        ALU_FUN = 4'b0000;//all outputs the same for load instructions
//               end
               
//     7'b0100011 : begin //S-type
//        ALU_SRCB = 3'b010;//immed gen
//        RF_WR_SEL = 2'b11;//doesnt matter
//        ALU_FUN = 4'b0000;//all outputs is the same for save instructions
        
//               end  
//     7'b1100011 : begin //B-type
        
//        case (IR_1412) 
//            3'b000 : begin 
//                     if (BR_EQ == 1'b1)
//                        PC_SOURCE = 3'b010;//Branch source
//                     else 
//                        PC_SOURCE = 3'b000;//add 4 to pc
//                        end 
//            3'b101 : begin 
//                     if (BR_LT == 1'b0)
//                        PC_SOURCE = 3'b010;//Branch source
//                     else 
//                        PC_SOURCE = 3'b000;//add 4 to pc
//                        end 
//            3'b111 : begin 
//                     if (BR_LTU == 1'b0)
//                        PC_SOURCE = 3'b010;//Branch source
//                     else 
//                        PC_SOURCE = 3'b000;//add 4 to pc
//                        end 
//            3'b100 : begin 
//                     if (BR_LT == 1'b1)
//                        PC_SOURCE = 3'b010;//Branch source
//                     else 
//                        PC_SOURCE = 3'b000;//add 4 to pc
//                        end 
//            3'b110 : begin 
//                     if (BR_LTU == 1'b1)
//                        PC_SOURCE = 3'b010;//Branch source
//                     else 
//                        PC_SOURCE = 3'b000;//add 4 to pc
//                        end 
//            3'b001 : begin 
//                     if (BR_EQ == 1'b0)
//                        PC_SOURCE = 3'b010;//Branch source
//                     else 
//                        PC_SOURCE = 3'b000;//add 4 to pc
//                        end 
//            endcase
//        end        
        
//     7'b0110111 : begin //U_TYPE
//        ALU_SRCA = 2'b01; 
//        RF_WR_SEL = 2'b11;
//        ALU_FUN = 4'b1001;//lui
//            end          
            
//     7'b0010111 : begin//auipc
//        ALU_SRCA = 2'b01;
//        ALU_SRCB = 3'b011;
//        RF_WR_SEL = 2'b11;
//        end
//     7'b1101111 : begin //JAL
//        PC_SOURCE = 3'b011;//JAL source
//        end
     
//        endcase
        
    
//    end
    
//endmodule
