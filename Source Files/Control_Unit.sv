`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2025 08:38:22 PM
// Design Name: 
// Module Name: Control_Unit
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


module Control_Unit(
    input [6:0] op,
    input [2:0] funct3,
    input funct7,
    output logic RegWrite,
    output logic [1:0] ResultSrc,
    output logic MemWrite,
    output logic Jump,
    output logic Branch,
    output logic [2:0] ALUControl,
    output logic ALUSrc,
    output logic [1:0] ImmSrc);


    logic [1:0] ALUOp;
    
    always_comb begin
        RegWrite = 1'b0;
        ImmSrc = 2'b00;
        ALUSrc = 1'b0;
        MemWrite = 1'b0;
        ResultSrc = 2'b00;
        Branch = 1'b0;
        ALUOp = 2'b00;
        
        case(op) 
            7'b0000011 : begin
                RegWrite = 1'b1;
                ImmSrc = 2'b00;
                ALUSrc = 1'b1;
                MemWrite = 1'b0;
                ResultSrc = 2'b01;
                Branch = 1'b0;
                ALUOp = 2'b00;
                Jump = 1'b0;
            end
            7'b0100011 : begin
                RegWrite = 1'b0;
                ImmSrc = 2'b01;
                ALUSrc = 1'b1;
                MemWrite = 1'b1;
                ResultSrc = 2'b00;
                Branch = 1'b0;
                ALUOp = 2'b00;
                Jump = 1'b0;
            end
            7'b0110011 : begin
                RegWrite = 1'b1;
                ImmSrc = 2'b00;
                ALUSrc = 1'b0;
                MemWrite = 1'b0;
                ResultSrc = 2'b00;
                Branch = 1'b0;
                ALUOp = 2'b10;
                Jump = 1'b0;
            end
            7'b1100011 : begin
                RegWrite = 1'b0;
                ImmSrc = 2'b10;
                ALUSrc = 1'b0;
                MemWrite = 1'b0;
                ResultSrc = 2'b00;   
                Branch = 1'b1;
                ALUOp = 2'b01;
                Jump = 1'b0;
            end
            7'b0010011 : begin
                RegWrite = 1'b1;
                ImmSrc = 2'b00;
                ALUSrc = 1'b1;
                MemWrite = 1'b0;
                ResultSrc = 2'b00;
                Branch = 1'b0;
                ALUOp = 2'b10;
                Jump = 1'b0;
            end
            7'b1101111 : begin
                RegWrite = 1'b1;
                ImmSrc = 2'b11;
                ALUSrc = 1'b0;
                MemWrite = 1'b0;
                ResultSrc = 2'b10;
                Branch = 1'b0;
                ALUOp = 2'b00;
                Jump = 1'b1;
            end
                
                
            
        endcase
        
        
        case(ALUOp)
            2'b00 : ALUControl = 3'b000;
            2'b01 : ALUControl = 3'b001;
            2'b10 : begin
                case(funct3)
                    3'b000 : ALUControl = ({op[5], funct7} < 2'b11) ? 3'b000 : 3'b001;
                    3'b010 : ALUControl = 3'b101;
                    3'b110 : ALUControl = 3'b011;
                    3'b111 : ALUControl = 3'b010;
                    default : ALUControl = 3'bxxx;
                endcase
            end
            default : ALUControl = 3'bxxx;
        endcase
        
    end
   
   
endmodule