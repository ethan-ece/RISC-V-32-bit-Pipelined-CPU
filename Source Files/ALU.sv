`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2025 09:28:25 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [2:0] ALUControl,
    input [31:0] SrcA,
    input [31:0] SrcB,
    output logic Zero,
    output logic [31:0] ALUResult);
    

    always_comb begin
        case(ALUControl)
            3'b000 : ALUResult = SrcA + SrcB;
            3'b001 : ALUResult = SrcA - SrcB;
            3'b101 : ALUResult = (SrcA < SrcB) ? 32'd1 : 32'd0;
            3'b011 : ALUResult = SrcA | SrcB;
            3'b010 : ALUResult = SrcA & SrcB;
            default : ALUResult = 32'b0;
        endcase 
    end
    
    assign Zero = (ALUResult == 32'b0);
    
    
endmodule
