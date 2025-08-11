`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2025 08:33:12 PM
// Design Name: 
// Module Name: Ins_Memory
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


module Ins_Memory(
    input [31:0] A,
    output logic [31:0] RD);
    
    logic [31:0] insmem [255:0];
    
    generate
        if(1) begin : MEM_INIT
            initial begin
                $readmemh("program.mem", insmem);
            end
        end
    endgenerate
    
    always_comb begin
        RD = insmem[A[9:2]];
    end
    
        
endmodule
