/*

controller.sv

Created by chickson@hmc.edu - 4 August, 2024

A control unit for the ConfusedCore hmmm processor 
https://github.com/coreyqh/ConfusedCore

For documentation see /ConfusedCore/docs/controller.md 

*/

module controller (
    input  logic        clk,
    input  logic        reset, 
    input  logic [3:0]  Op,
    input  logic [3:0]  FuncID,
    input  logic [1:0]  Comp,
    input  logic        IOReady, 
    input  logic        FlashEnable,
    input  logic        DivBusy,
    output logic [1:0]  PCSrc,
    output logic        A2Src, 
    output logic        A3Src, 
    output logic        ExtType, 
    output logic        RFWrite, 
    output logic        ALUSrc1, 
    output logic        ALUSrc2, 
    output logic [1:0]  OpCtrl, 
    output logic        AdrSrc, 
    output logic        DMWrite, 
    output logic [2:0]  ResultSrc,
    output logic        Flash,
    output logic        IOWaiting, 
    output logic        Stall
);

    ctrldecoder decoder (.*);
    ctrlFSM     fsm     (.*);
    assign      stall = DivBusy | FSMStall;

endmodule

// TODO: Finish design and fill in helper module bodies

module ctrldecoder (
    input  logic [3:0]  Op,
    input  logic [3:0]  FuncID,
    input  logic [1:0]  Comp,
    input  logic        Flash,
    output logic        PCSrc,
    output logic        A2Src, 
    output logic        A3Src, 
    output logic        ExtType, 
    output logic        RFWrite, 
    output logic        ALUSrc1, 
    output logic        ALUSrc2, 
    output logic [1:0]  OpCtrl, 
    output logic        AdrSrc, 
    output logic        DMWrite, 
    output logic [2:0]  ResultSrc
);

    // design work in progress

endmodule


module ctrlFSM (
    input  logic        clk,
    input  logic        reset, 
    input  logic [3:0]  Op, 
    input  logic [3:0]  FuncTD,
    input  logic        IOReady,
    input  logic        FlashEnable, 
    output logic        Flash,
    output logic        IOWaiting,
    output logic        FSMStall
);

    // design work in progress

endmodule