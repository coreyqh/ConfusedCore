/*

registerfile.sv

Created by chickson@hmc.edu - 6 August, 2024

A 3 ported register file for the ConfusedCore hmmm processor 
https://github.com/coreyqh/ConfusedCore

*/

module registerfile (
    input  logic        clk,
    input  logic        we3,
    input  logic [4:0]  a1, a2, a3,
    input  logic [15:0] wd3,
    output logic [15:0] rd1, rd2 
);

    

endmodule