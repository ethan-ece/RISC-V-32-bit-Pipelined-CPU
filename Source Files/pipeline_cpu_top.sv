`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2025 07:15:51 PM
// Design Name: 
// Module Name: pipeline_cpu_top
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


module pipeline_cpu_top(
    input clk,
    input reset);
    
    // Fetch 
    logic [31:0] PCFPrime;
    logic [31:0] PCF;
    logic [31:0] PCPlus4F;
    logic [31:0] InstrF;
    
    // Decode
    logic RegWriteD;
    logic [1:0] ResultSrcD;
    logic MemWriteD;
    logic JumpD;
    logic BranchD;
    logic [2:0] ALUControlD;
    logic ALUSrcD;
    logic [1:0] ImmSrcD;
    logic [31:0] InstrD;
    logic [31:0] RD1D;
    logic [31:0] RD2D;
    logic [31:0] PCD;
    logic [4:0] Rs1D;
    logic [4:0] Rs2D;
    logic [4:0] RdD;
    logic [31:0] ImmExtD;
    logic [31:0] PCPlus4D;
    
    // Execute
    logic PCSrcE;
    logic ZeroE;
    logic RegWriteE;
    logic [1:0] ResultSrcE;
    logic MemWriteE;
    logic JumpE;
    logic BranchE;
    logic [2:0] ALUControlE;
    logic ALUSrcE;
    logic [31:0] RD1E;
    logic [31:0] RD2E;
    logic [31:0] SrcAE;
    logic [31:0] SrcBE;
    logic [31:0] WriteDataE;
    logic [31:0] MPOut1;
    logic [31:0] PCE;
    logic [4:0] Rs1E;
    logic [4:0] Rs2E;
    logic [4:0] RdE;
    logic [31:0] ImmExtE;
    logic [31:0] PCPlus4E;
    logic [31:0] PCTargetE;
    logic [31:0] ALUResultE;
    
    // Memory    
    logic RegWriteM;
    logic [1:0] ResultSrcM;
    logic MemWriteM;
    logic [31:0] ALUResultM;
    logic [31:0] WriteDataM;
    logic [4:0] RdM;
    logic [31:0] PCPlus4M;
    logic [31:0] ReadDataM;
    
    // Writeback
    logic RegWriteW;
    logic [1:0] ResultSrcW;
    logic [31:0] ALUResultW;
    logic [31:0] ReadDataW;
    logic [4:0] RdW;
    logic [31:0] PCPlus4W;
    logic [31:0] ResultW;
    
    // Hazard Control
    logic StallF;
    logic StallD;
    logic FlushD;
    logic FlushE;
    logic [1:0] ForwardAE;
    logic [1:0] ForwardBE;
    
    
    
    // Fetch/Decode Pipeline
    always @(posedge clk or posedge reset) begin
        if(reset || FlushD) begin
            PCD <= 0;
            PCPlus4D <= 0;
            InstrD <= 0;
        end else if(~StallD) begin
            InstrD <= InstrF;
            PCD <= PCF;
            PCPlus4D <= PCPlus4F;
        end
    end
    
    // Decode/Execute Pipeline
    always @(posedge clk or posedge reset) begin
        if(reset || FlushE) begin
            RegWriteE <= 0; ResultSrcE <= 0; MemWriteE <= 0;
            JumpE <= 0; BranchE <= 0; ALUControlE <= 0;
            ALUSrcE <= 0; RD1E <= 0; RD2E <= 0;
            PCE <= 0; Rs1E <= 0; Rs2E <= 0;
            RdE <= 0; ImmExtE <= 0; PCPlus4E <= 0;
        end else begin
            RegWriteE <= RegWriteD; ResultSrcE <= ResultSrcD; MemWriteE <= MemWriteD; 
            JumpE <= JumpD; BranchE <= BranchD; ALUControlE <= ALUControlD;
            ALUSrcE <= ALUSrcD; RD1E <= RD1D; RD2E <= RD2D; 
            PCE <= PCD; Rs1E <= Rs1D; Rs2E <= Rs2D;
            RdE <= RdD; ImmExtE <= ImmExtD; PCPlus4E <= PCPlus4D;
        end
        
    end
    
    
    // Execute/Memory Pipeline
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            RegWriteM <= 0;
            ResultSrcM <= 0;
            MemWriteM <= 0;
            ALUResultM <= 0;
            WriteDataM <= 0;
            RdM <= 0;
            PCPlus4M <= 0;
        end else begin
            RegWriteM <= RegWriteE;
            ResultSrcM <= ResultSrcE;
            MemWriteM <= MemWriteE;
            ALUResultM <= ALUResultE;
            WriteDataM <= WriteDataE;
            RdM <= RdE;
            PCPlus4M <= PCPlus4E;
        end
    end
    
    
    // Memory/Writeback Pipeline
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            RegWriteW <= 0;
            ResultSrcW <= 0;
            ALUResultW <= 0;
            ReadDataW <= 0;
            RdW <= 0;
            PCPlus4W <= 0;
        end else begin
            RegWriteW <= RegWriteM;
            ResultSrcW <= ResultSrcM;
            ALUResultW <= ALUResultM;
            ReadDataW <= ReadDataM;
            RdW <= RdM;
            PCPlus4W <= PCPlus4M;
        end
    end

    
    
    // Fetch Logic
    assign PCFPrime = (PCSrcE) ? PCTargetE : PCPlus4F;
    PC_Register pr(clk, reset, StallF, PCFPrime, PCF);
    Ins_Memory im(PCF, InstrF);
    PCIncrement pi(PCF, PCPlus4F);
    
    
    // Decode Logic
    Control_Unit cu(InstrD[6:0], InstrD[14:12], InstrD[30], RegWriteD, ResultSrcD, 
    MemWriteD, JumpD, BranchD, ALUControlD, ALUSrcD, ImmSrcD);
    Reg_File rf(clk, InstrD[19:15], InstrD[24:20], RdW, ResultW, RegWriteW, RD1D, RD2D);
    Extend e(InstrD[31:7], ImmSrcD, ImmExtD);
    assign Rs1D = InstrD[19:15];
    assign Rs2D = InstrD[24:20];
    assign RdD = InstrD[11:7];
    
    // Execute Logic
    logic BranchTaken;
    
    assign BranchTaken = ZeroE & BranchE;
    
    
    
    always_comb begin
        case(JumpE | BranchTaken)
            1'bx : PCSrcE = 1'b0; // Fixes the case in which BranchTaken or JumpE is 1'bx (floating zero)
            default : PCSrcE = JumpE | BranchTaken;
        endcase
    end
    
    always_comb
        case(ForwardBE)
            2'b00 : WriteDataE = RD2E;
            2'b01 : WriteDataE = ResultW;
            2'b10 : WriteDataE = ALUResultM;
        endcase
        
    
        
    always_comb
        case(ForwardAE)
            2'b00 : SrcAE = RD1E;
            2'b01 : SrcAE = ResultW;
            2'b10 : SrcAE = ALUResultM;
        endcase
    
    assign SrcBE = (ALUSrcE) ? ImmExtE : WriteDataE;
    
    PCTarget pt(PCE, ImmExtE, PCTargetE);
    ALU a(ALUControlE, SrcAE, SrcBE, ZeroE, ALUResultE);
    
    
    // Memory Logic
    Data_Mem dm(clk, ALUResultM, WriteDataM, MemWriteM, ReadDataM);
    
    
    // Writeback Logic
    always_comb
        case(ResultSrcW)
            2'b00 : ResultW = ALUResultW;
            2'b01 : ResultW = ReadDataW;
            2'b10 : ResultW = PCPlus4W;
        endcase
        
     
    // Hazard Logic
    logic lwStall;
    always_comb begin
        if(((Rs1E == RdM) && RegWriteM) && (Rs1E != 0)) begin
            ForwardAE = 2'b10;
        end else if(((Rs1E == RdW) && RegWriteW) && (Rs1E != 0)) begin
            ForwardAE = 2'b01;
        end else begin 
            ForwardAE = 2'b00;
        end
        
        if(((Rs2E == RdM) && RegWriteM) && (Rs2E != 0)) begin
            ForwardBE = 2'b10;
        end else if(((Rs2E == RdW) && RegWriteW) && (Rs2E != 0)) begin
            ForwardBE = 2'b01;
        end else begin 
            ForwardBE = 2'b00;
        end
        
        lwStall = ResultSrcE[0] && ((Rs1D == RdE) | (Rs2D == RdE));
        StallF = lwStall;
        StallD = lwStall;
        
        
        FlushD = PCSrcE;
        FlushE = lwStall | PCSrcE;
    end
        

endmodule
