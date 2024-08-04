/*

flop.sv

Created by chickson@hmc.edu - 4 August, 2024

A  generic flop for the ConfusedCore hmmm processor 
https://github.com/coreyqh/ConfusedCore

*/

module flop_en_r #(parameter W = 8) (
    input  logic         clk, reset, enable,
    input  logic [W-1:0] in,
    output logic [W-1:0] out
);

    always_ff @(posedge clk or posedge reset) begin
        if      (reset)  out <= 0;
        else if (enable) out <= in
    end

endmodule