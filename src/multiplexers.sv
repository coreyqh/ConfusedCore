/*

multiplexers.sv

Created by chickson@hmc.edu - 4 August, 2024

A collection of generic muxes for the ConfusedCore hmmm processor 
https://github.com/coreyqh/ConfusedCore

*/

module mux2 #(parameter W) (
    input  logic [W-1:0] in0, in1,
    input  logic         sel,
    output logic [W-1:0] out
);

    assign out = sel ? in1 : in0;

endmodule

module mux3 #(parameter W) (
    input  logic [W-1:0] in0, in1, in2,
    input  logic [1:0]   sel,
    output logic [W-1:0] out
);

    assign out = sel[1] ? in2 : (sel[0] ? in1 : in0);

endmodule

module mux7 #(parameter W) (
    input  logic [W-1:0] in0, in1, in2, in3, in4, in5, in6
    input  logic [2:0]   sel,
    output logic [W-1:0] out
);

    always_comb begin
        case (sel)
            3'b000:  out = in0;
            3'b001:  out = in1;
            3'b010:  out = in2;
            3'b011:  out = in3;
            3'b100:  out = in4;
            3'b101:  out = in5;
            3'b110:  out = in6;
            default: out = 'X;

        endcase
    end

endmodule