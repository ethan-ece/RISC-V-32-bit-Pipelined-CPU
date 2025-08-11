`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2025 09:17:02 PM
// Design Name: 
// Module Name: Extend
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


module Extend(
    input [31:7] Instr,
    input [1:0] ImmSrc,
    output logic [31:0] ImmExt);
    
    always_comb begin
        case(ImmSrc)
            2'b00 : ImmExt = {{20{Instr[31]}}, Instr[31:20]};
            2'b01 : ImmExt = {{20{Instr[31]}}, Instr[30:25], Instr[11:7]};
            2'b10 : ImmExt = {{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0};
        endcase
    end
    
endmodule