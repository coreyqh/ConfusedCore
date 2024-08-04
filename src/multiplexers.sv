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

module mux4 #(parameter W) (
    input  logic [W-1:0] in0, in1, in2, in3,
    input  logic [1:0]   sel,
    output logic [W-1:0] out
);

    assign out = sel[1] ? (sel[0] ? in3 : in2) : (sel[0] ? in1 : in0);

endmodule

module mux5 #(parameter W) (
    input  logic [W-1:0] in0, in1, in2, in3, in4,
    input  logic [2:0]   sel,
    output logic [W-1:0] out
);

    assign out = sel[2] ? in4 : (sel[1] ? (sel[0] ? in3 : in2) : (sel[0] ? in1 : in0));

endmodule