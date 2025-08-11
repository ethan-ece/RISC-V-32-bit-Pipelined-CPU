`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2025 08:36:00 PM
// Design Name: 
// Module Name: PCIncrement
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


module PCIncrement(
     input [31:0] PC, 
     output [31:0] PCPlus4);
     
     assign PCPlus4 = PC + 4;
     
endmodule
