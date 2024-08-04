/*

compzero.sv

Created by chickson@hmc.edu - 4 August, 2024

A comparator against zero for the ConfusedCore hmmm processor 
https://github.com/coreyqh/ConfusedCore

*/

module compzero (
    input  logic [15:0] a, 
    output logic  [1:0] comp // {A==0, A>0}
);

    logic eq, gt;

    assign eq   = (a == 0);
    assign gt   = (a > 0);
    assign comp = {eq, gt};

endmodule