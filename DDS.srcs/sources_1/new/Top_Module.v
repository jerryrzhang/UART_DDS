`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2026 09:23:56 PM
// Design Name: 
// Module Name: Top_Module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Top_Module(
    input clk, rst,
    input [15:0] sw
    );
    reg signed [15:0] sin;
    reg signed [15:0] LUT [0:1023];
    integer i;    

    ila_0 my_ila (
        .clk    (clk),           // MUST be your 100 MHz design clock
        .probe0 (sin),           // 16-bit
        .probe1 (phase),         // 32-bit
        .probe2 (LUTIndex)       // 12-bit
    );
    
    
    

    initial begin

        for (i = 0; i < 1024; i = i + 1) begin
            // each step is pi/2^11
            // i * pi/2^11 is the angle in rads
            // $sin(i * pi/2^11) is the sin value
            // we should generate from 0 -> pi/2 over the 1024 entries of the array
            
            // pi we can use 2*$acos(0)
            
            
            //we take pi/2^10, step size
            // multiply it by i, the current step
            // sine it
            // multpily that real value by the range (2^15), and add 0.5
            // floor it
            LUT[i] = $rtoi( $sin(($acos(0)/(2**10)) * i) * (2**15 - 1) + 0.5 );
            
        end
        
    end
    
    wire [31:0] FTW;

    //assign FTW = 32'd42949673;   // ≈ 1 MHz  (round(1e6 × 2^32 / 100e6))
    
    assign FTW = {sw[15:0], {16'd0}};
    
    
    reg [31:0] phase;
    wire [11:0] LUTIndex;
    
    assign LUTIndex = phase[31:20];
    
    always @(posedge clk) begin
        if (rst) phase <= 32'd0;
        else phase <= phase + FTW;
        
        case (LUTIndex[11:10])
            2'd0: sin <= LUT[LUTIndex[9:0]];
            2'd1: sin <= LUT[1023 - LUTIndex[9:0]];
            2'd2: sin <= -LUT[LUTIndex[9:0]];
            2'd3: sin <= -LUT[1023 - LUTIndex[9:0]];
        endcase
        
    end
    
//    always @(*) begin
//        // assign output to sin value from LUT depending on first two bits
//        case (LUTIndex[11:10])
//            2'd0: sin = LUT[LUTIndex[9:0]];
//            2'd1: sin = LUT[1023 - LUTIndex[9:0]];
//            2'd2: sin = -LUT[LUTIndex[9:0]];
//            2'd3: sin = -LUT[1023 - LUTIndex[9:0]];
//        endcase
//    end
    
    
    
endmodule
