`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2025 09:27:03 PM
// Design Name: 
// Module Name: PCTarget
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


module PCTarget(
    input [31:0] PC,
    input [31:0] ImmExt,
    output logic [31:0] PC_T);
    
    assign PC_T = PC + ImmExt;

endmodule
