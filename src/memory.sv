/*

memory.sv

Created by chickson@hmc.edu - 10 August, 2024

A 256 16-bit word memory for the ConfusedCore hmmm processor 
https://github.com/coreyqh/ConfusedCore

*/


module memory (
    input  logic        clk,
    input  logic        we,
    input  logic [7:0]  addr,
    input  logic [15:0] wd,
    output logic [15:0] rd
);

    // instantiate 256 16-bit words of memory
    logic [15:0] MEM[255:0];

    // asynchronous read
    assign rd = MEM[addr];

    // synchronous write
    always_ff @(posedge clk)
        if (we) MEM[addr] <= wd;

endmodule