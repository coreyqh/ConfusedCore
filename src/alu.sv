/*

alu.sv

Created by chickson@hmc.edu - 4 August, 2024

An ALU for the ConfusedCore hmmm processor 
https://github.com/coreyqh/ConfusedCore

*/

module alu (
    input  logic [15:0] a, b,
    input  logic        aluCtrl, // opCtrl[0]
    output logic [15:0] aluresult
);

    logic add, sub;

    assign add = a + b;
    assign sub = a - b;

    assign aluresult = aluCtrl ? sub : add;
    
endmodule