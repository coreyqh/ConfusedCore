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
    // input = 0 if all zeros
    assign eq   = (a == 16'b0);
    // input > 0 if sign != 0 and eq != 0
    assign gt   = (!a[15] && !eq);
    // combine into 2 bit signal
    assign comp = {eq, gt};
endmodule