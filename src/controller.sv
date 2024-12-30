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
    input  logic        DivBusy,
    input  logic        PopC2,
    input  logic        Flash,
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
    output logic [2:0]  ResultSrc
);

    logic [14:0] controls; 

    always_comb
        casex({Op, FuncID, Comp, flash}) 
            11'b0110_xxxx_xx_0: assign controls = 15'b00_1_0_0_1_0_0_00_0_0_001; // add
            11'b0111_xxxx_xx_0: assign controls = 15'b00_1_0_0_1_0_0_01_0_0_001; // sub
            11'b1000_xxxx_xx_0: assign controls = 15'b00_1_0_0_1_0_0_00_0_0_011; // mul
            11'b1001_xxxx_xx_0: assign controls = {5'b00_1_0_0, ~DivBusy, 9'b0_0_10_0_0_010}; // div
            11'b1010_xxxx_xx_0: assign controls = {5'b00_1_0_0, ~DivBusy, 9'b0_0_11_0_0_010}; // mod
            11'b0001_xxxx_xx_0: assign controls = 15'b00_0_0_1_1_0_0_00_0_0_100; // setn
            11'b0101_xxxx_xx_0: assign controls = 15'b00_0_0_1_1_1_0_00_0_0_001; // addn
            11'b0011_xxxx_xx_0: assign controls = 15'b00_0_0_0_0_1_0_00_0_1_000; // storen
            11'b0010_xxxx_xx_0: assign controls = 15'b00_0_0_0_1_1_0_00_0_0_000; // loadn
            11'b0100_0001_xx_0: assign controls = 15'b00_0_0_0_0_0_0_00_0_1_000; // storer
            11'b0100_0000_xx_0: assign controls = 15'b00_0_0_0_1_0_0_00_0_0_000; // loadr
            11'b0100_0011_xx_0: assign controls = 15'b00_0_1_0_1_0_1_00_0_1_001; // pushr
            11'b0100_0010_xx_0: assign controls = {'3'b00_0, ~Popc2, 6'b0_1_0_1_01_, ~PopC2, 3'b0_00, ~PopC2} ; // popr
            11'b1100_xxxx_1x_0: assign controls = 15'b01_0_0_0_0_0_0_00_0_0_000; // jeqzn taken
            11'b1100_xxxx_0x_0: assign controls = 15'b00_0_0_0_0_0_0_00_0_0_000; // jeqzn not taken
            11'b1101_xxxx_0x_0: assign controls = 15'b01_0_0_0_0_0_0_00_0_0_000; // jnezn taken
            11'b1101_xxxx_1x_0: assign controls = 15'b00_0_0_0_0_0_0_00_0_0_000; // jnezn not taken
            11'b1110_xxxx_x1_0: assign controls = 15'b01_0_0_0_0_0_0_00_0_0_000; // jgtzn taken
            11'b1110_xxxx_x0_0: assign controls = 15'b00_0_0_0_0_0_0_00_0_0_000; // jgtzn not taken
            11'b1111_xxxx_00_0: assign controls = 15'b01_0_0_0_0_0_0_00_0_0_000; // jltzn taken
            11'b1111_xxxx_x1_0: assign controls = 15'b00_0_0_0_0_0_0_00_0_0_000; // jltzn not taken
            11'b1111_xxxx_1x_0: assign controls = 15'b00_0_0_0_0_0_0_00_0_0_000; // jltzn not taken
            11'b0000_0011_xx_0: assign controls = 15'b10_0_0_0_0_0_0_00_0_0_000; // jumpr
            11'b1011_xxxx_xx_0: assign controls = 15'b01_0_0_0_1_0_0_00_0_0_101; // calln
            11'b0000_0001_xx_0: assign controls = 15'b00_0_0_0_1_0_0_00_0_0_110; // read
            11'b0000_0010_xx_0: assign controls = 15'b00_0_0_0_0_0_0_00_0_0_000; // write
            11'bxxxx_xxxx_xx_1: assign controls = 15'b00_0_0_0_0_0_0_00_0_0_000; // FLASH
            default:            // shouldn't happen except on HALT instruction
        endcase

    assign {PCSrc, A2Src, A3Src, ExtType, RFWrite, ALUSrc1, ALUSrc2, OpCtrl, AdrSrc, DMWrite, ResultSrc} = controls;

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