/*

mult.sv

Created by chickson@hmc.edu - 4 August, 2024

A mulitcycle divider for the ConfusedCore hmmm processor 
https://github.com/coreyqh/ConfusedCore

*/

module div (
    input  logic        clk, reset,
    input  logic        a, b,
    input  logic        divCtrl // opCtrl[1]
    output logic [15:0] out,
    output logic        divBusy
);

    //TODO: implement multicycle division and modulo


endmodule