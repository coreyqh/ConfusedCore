/*

extender.sv

Created by chickson@hmc.edu - 4 August, 2024

An 8->16 bit sign extender for the ConfusedCore hmmm processor 
https://github.com/coreyqh/ConfusedCore

*/

module extender (
    input  logic        ExtType, // 1 for sign, 0 for zero
    input  logic [7:0]  rawImm,
    output logic [15:0] extImm
);

    assign extImm = {{8{(ExtType ? rawImm[7] | 0)}}, rawImm};

endmodule