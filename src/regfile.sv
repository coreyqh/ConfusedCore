/*

regfile.sv

Created by chickson@hmc.edu - 6 August, 2024

A 3 ported register file for the ConfusedCore hmmm processor 
https://github.com/coreyqh/ConfusedCore

*/

module regfile (
    input  logic        clk,
    input  logic [3:0]  ra1, ra2, wa3,
    input  logic        we3,
    input  logic [15:0] wd3,
    output logic [15:0] rd1, rd2 
);

    // instantiates 16 registers with 16 bits each
    logic [15:0] REGFILE[15:0];

    // asynchronous read
    assign rd1 = (ra1 == 0) ? 0 : REGFILE[ra1];
    assign rd2 = (ra2 == 0) ? 0 : REGFILE[ra2];
    //                        ^---------------- r0 hardwired to 0

    // synchronous write
    always_ff @(posedge clk)
        if (we3) REGFILE[wa3] <= wd3;

endmodule