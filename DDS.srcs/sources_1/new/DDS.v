`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/02/2026 11:09:53 AM
// Design Name: 
// Module Name: DDS
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


module DDS(
        input clk, rst,
        input [31:0] FTW,
        output reg signed [15:0] sin,
        output reg [31:0] phase,
        output [7:0] rx_byte,
        output rx_done
    );
    
    
//    wire FTW1; 
//    assign FTW1 = 32'd42949673; 
    
    reg signed [15:0] LUT [0:1023];
    integer i;    
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
