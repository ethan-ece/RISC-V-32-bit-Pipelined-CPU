`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2025 08:57:22 PM
// Design Name: 
// Module Name: Reg_File
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


module Reg_File(
    input clk,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD3,
    input WE3,
    output logic [31:0] RD1,
    output logic [31:0] RD2);
    
    
    logic [31:0] regmem [31:0];
    

    always @(posedge clk) begin
        if(WE3 && (A3 != 5'd0)) begin
            regmem[A3] <= WD3;
        end
       
    end
    
    
    assign RD1 = (A1 == 5'd0) ? 32'b0 : regmem[A1];
    assign RD2 = (A2 == 5'd0) ? 32'b0 : regmem[A2];
    
endmodule
