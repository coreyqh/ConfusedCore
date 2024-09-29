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

    signed [31:0] product;
    assign product = signed'(a) * signed'(b);
    assign out = product[15:0];

endmodule