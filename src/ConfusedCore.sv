/*

confusedcore.sv

Created by chickson@hmc.edu - 4 August, 2024

This is the top level module for the ConfusedCore hmmm processor 
https://github.com/coreyqh/ConfusedCore

For documentation see /ConfusedCore/docs/* 


*/

module confusedcore (

    input  logic        clk,
    input  logic        reset,
    // i/o via off chip periferal
    input  logic        inputReady,
    output logic        inputWaiting,
    input  logic [15:0] parallelIn,
    output logic [15:0] parallelOut,
    // input signal to flash code to ROM via i/o input port
    input  logic        flashEnable

);
    //////////////////////
    // internal signals //
    //////////////////////

    // Control Signals
    logic [1:0]  PCSrc;
    logic        stall;
    logic        adrSrc;
    logic        aluSrc;
    logic [2:0]  opCtrl;
    logic        ramWrite;
    logic [2:0]  resultSrc;
    logic        comp;
    logic        divBusy;
    logic        IObusy;
    
    // Data Signals
    logic [7:0]  PC;
    logic [7:0]  PCplus1;
    logic [7:0]  nextPC;
    logic [7:0]  instr;
    logic [15:0] ROMrd1;
    logic [15:0] ROMrd2;
    logic [15:0] ALUSrc2;
    logic [15:0] imm;
    logic [15:0] RAMrd;
    logic [15:0] ALUOut;
    logic [15:0] divOut;
    logic [15:0] multOut;
    logic [15:0] result;


    // TODO: body goes here

endmodule