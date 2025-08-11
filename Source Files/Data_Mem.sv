`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2025 09:30:04 PM
// Design Name: 
// Module Name: Data_Mem
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


module Data_Mem(
    input clk,
    input [31:0] A, 
    input [31:0] WD,
    input WE,
    output logic [31:0] RD);
    
    
    logic [31:0] regmem [255:0];
    
    always @(posedge clk) begin
        if (WE) begin
            regmem[A[9:2]] <= WD;
        end 
    end
    
    assign RD = regmem[A[9:2]];

endmodule
