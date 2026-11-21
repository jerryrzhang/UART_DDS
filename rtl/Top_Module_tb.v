`timescale 1ns / 1ps

module SinGen_FSM_tb;
    wire signed [15:0] sin;
    reg clk, rst;
    
    Top_Module DUT (
        .clk(clk), .rst(rst),
        .sin(sin)
    );

    initial begin
        // Add stimulus here
        clk = 0; rst = 1;
        #10 rst = 0;          // to INIT (0) state
    end

    always #5 clk = ~clk;

endmodule