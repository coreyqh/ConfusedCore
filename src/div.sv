/*

mult.sv

Created by chickson@hmc.edu - 4 August, 2024

A mulitcycle divider for the ConfusedCore hmmm processor 
https://github.com/coreyqh/ConfusedCore

*/

module div (
    input  logic        clk, reset,
    input  logic [15:0] dividend, divisor,
    input  logic        OpCtrl,
    output logic [15:0] out,
    output logic        DivBusy
);

    // temporary values of quotient and remainder between cycles
    logic [15:0] quotient, remainder, nextquot, nextrem;
    // count of bits left to process
    logic  [4:0] bitsleft;

    // state definitions 
    typedef enum logic [1:0] {idle, busy, done} statetype;
    statetype state, nextstate;

    // state and temporary values registers
    always_ff @(posedge clk, posedge reset)
        if (reset) begin
            state     <= idle;
            quotient  <= 0;
            remainder <= 0;
        end else begin
            state     <= nextstate;
            quotient  <= nextquot;
            remainder <= nextrem; 
        end


    // next state and value update logic
    always_comb
        case (state) 
            idle: begin
                if (OpCtrl[1]) begin
                    // divison by zero
                    if (divisor == 0) begin
                        nextstate = done;
                        nextquot  = 16'hXXXX;
                        nextrem   = 16'hXXXX;
                    // begin new division
                    end else begin
                        nextstate = busy;
                        nextquot  = 0;
                        nextrem   = dividend;
                        bitsleft  = 16;
                    end
                end
            end

            busy: begin
                // division is done
                if (bitsleft == 0) begin
                    nextstate = done;
                    nextquot  = quotient;
                    nextrem   = remainder;
                end else begin
                    // TODO: Update intermediate values while in the busy state
                end
            end

            done: begin
                nextstate = idle;
                nextquot  = 16'hXXXX;
                nextrem   = 16'hXXXX;
            end
        endcase
        

    // output logic
    if (state == done) assign out = OpCtrl[0] ? remainder : quotient;
    else               assign out = 16'hXXXX; // invalid until ready

    assign DivBusy = (state == busy) | ((state == idle) & OpCtrl[1]);
                                        

endmodule