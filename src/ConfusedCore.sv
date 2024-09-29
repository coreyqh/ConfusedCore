/*

confusedcore.sv

Created by chickson@hmc.edu - 4 August, 2024

This is the top level module for the ConfusedCore hmmm processor 
https://github.com/coreyqh/ConfusedCore

For documentation see /ConfusedCore/docs/confusedcore.md 

*/

module confusedcore (
    input  logic        clk,
    input  logic        reset,
    // i/o via off chip periferal
    input  logic        IOReady,
    output logic        IOWaiting,
    input  logic [15:0] ParallelIn,
    output logic [15:0] ParallelOut,
    // input signal to flash code to ROM via i/o input port
    input  logic        FlashEnable
);
    //////////////////////
    // internal signals //
    //////////////////////

    // Control Signals
    logic [1:0]  PCSrc;
    logic        Stall;
    logic        Flash;
    logic        A2Src;
    logic        A3Src;
    logic        ExtType;
    logic        RFWrite;
    logic        ALUSrc1;
    logic        ALUSrc2;
    logic [1:0]  OpCtrl;
    logic        AdrSrc;
    logic        DMWrite;
    logic [2:0]  ResultSrc;
    logic        DivBusy;
    logic [1:0]  Comp;

    // Data Signals
    logic [7:0]  PC;
    logic [7:0]  PCPlus1;
    logic [7:0]  NextPC;
    logic [15:0] Instr;
    logic [3:0]  RFAdr2;
    logic [3:0]  RFAdr3;
    logic [15:0] RD1;
    logic [15:0] RD2;
    logic [15:0] ExtImm;
    logic [15:0] ALUArg1;
    logic [15:0] ALUArg2;
    logic [15:0] ALUOut;
    logic [15:0] MultOut;
    logic [15:0] DivOut;
    logic [3:0]  DMEMAdr;
    logic [15:0] DMEMOut;
    logic [15:0] Result;

    //////////////////////
    //     datapath     //
    //////////////////////

    // Flop that updates the PC/Stalls the core
    flop_en_r PCFlop(clk, reset, ~Stall, NextPC, PC);

    // misc. muxes
    mux2 #(4)   A2Mux       (Instr[11:8], Instr[3:0], A2Src, RFAdr2);
    mux2 #(4)   A3Mux       (Instr[11:8], Instr[7:4], A3Src, RFAdr3);
    mux2 #(16)  Arg1Mux     (RD1, ExtImm, ALUSrc1, ALUArg1);
    mux2 #(16)  Arg2Mux     (RD2,  16'b1, ALUSrc2, ALUArg2);
    mux2 #(8)   AdrMux      (ALUArg1[7:0], ALUOut[7:0], AdrSrc, DMEMAdr);
    mux3 #(8)   PCMux       (PCPlus1, Instr[7:0], RD2[7:0], PCSrc, NextPC);
    mux7 #(16)  ResultMux   (DMEMOut, ALUOut, DivOut, MultOut, ExtImm, {8'b0, PCPlus1}, ParallelIn, ResultSrc, Result);

    // PC incrementer
    adder       PCAdder     (PC, 8'b1, PCPlus1);

    // arithmetic blocks
    extender    extender    (ExtType, Instr[7:0], ExtImm);
    compzero    comp0       (RD2, Comp);
    alu         alu         (ALUArg1, ALUArg2, OpCtrl[0], ALUOut);
    div         div         (clk, reset, RD1, RD2, DivOut, DivBusy);
    mult        mult        (RD1, RD2, MultOut);

    regfile     regfile     (clk, RFWrite, Instr[7:4], RFAdr2, RFAdr3, Result, RD1, RD2);

    // memory modules
    memory      IROM        (clk, Flash, PC, ParallelIn, Instr);
    memory      DMEM        (clk, DMWrite, DMEMAdr, RD2, DMEMOut);
    regfile     regfile     (clk, RFWrite, Instr[7:4], RFAdr2, RFAdr3, Result, RD1, RD2);

    
    //////////////////////
    //    controller    //
    //////////////////////
    
    controller  ctrl        (.Op(Instr[15:12]), .FuncID(Instr[3:0]), .*);

endmodule