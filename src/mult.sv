/*

mult.sv

Created by chickson@hmc.edu - 4 August, 2024

A combinational multiplier for the ConfusedCore hmmm processor 
https://github.com/coreyqh/ConfusedCore

*/

module mult (
    input  logic [15:0] a, b,
    output logic [15:0] out
);

    assign out = a * b;

endmodule