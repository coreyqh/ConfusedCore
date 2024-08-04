/*

adder.sv

Created by chickson@hmc.edu - 4 August, 2024

A  generic adder for the ConfusedCore hmmm processor 
https://github.com/coreyqh/ConfusedCore

*/

module adder #(parameter W = 8) (
    input  logic [W-1:0] a, b, 
    output logic [W-1:0] out
);

    assign out = a + b;

endmodule