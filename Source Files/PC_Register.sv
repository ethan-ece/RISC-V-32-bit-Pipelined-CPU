`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2025 08:29:58 PM
// Design Name: 
// Module Name: PC_Register
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


module PC_Register(
    input clk,
    input reset,
    input enable,
    input [31:0] PCNext,
    output logic [31:0] PC
    );
    
    
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            PC <= 32'b0;
        end else if(~enable) begin
            PC <= PCNext;
        end
    end
    
endmodule
