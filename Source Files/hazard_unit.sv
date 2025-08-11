`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2025 07:28:41 PM
// Design Name: 
// Module Name: hazard_unit
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


module hazard_unit(
    input [4:0] Rs1E,
    input [4:0] Rs2E,
    input [4:0] Rs1D,
    input [4:0] Rs2D,
    input [4:0] RdM,
    input [4:0] RdW,
    input [4:0] RdE,
    input RegWriteM,
    input RegWriteW,
    input ResultSrcE,
    input PCSrcE,
    output logic [1:0] ForwardAE,
    output logic [1:0] ForwardBE,
    output logic FlushE,
    output logic StallD,
    output logic StallF,
    output logic FlushD);
    
    logic lwStall;
    always_comb begin
        if(((Rs1E == RdM) & RegWriteM) & (Rs1E != 0)) begin
            ForwardAE = 2'b10;
        end
        if(((Rs1E == RdW) & RegWriteW) & (Rs1E != 0)) begin
            ForwardAE = 2'b01;
        end else ForwardAE = 2'b00;
        
        lwStall = ResultSrcE & ((Rs1D == RdE) | (Rs2D == RdE));
        StallF = lwStall;
        StallD = lwStall;
        
        FlushD = PCSrcE;
        FlushE = lwStall | PCSrcE;
    end
    
    
            
endmodule
