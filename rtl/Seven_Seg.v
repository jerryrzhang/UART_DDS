`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2026 09:51:04 PM
// Design Name: 
// Module Name: Seven_Seg
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
module Seven_Seg(
    input clk,
    input rst,
    input [1:0] offset,
    output reg [6:0] seg,
    output reg [3:0] an
    );

    reg [16:0] refresh;
    always @(posedge clk) begin
        if (rst) refresh <= 0;
        else refresh <= refresh + 1;
    end
    wire [1:0] digit_sel = refresh[16:15];
    reg [6:0] digits [0:3];
    
    initial begin
    digits[0] = 7'b1111110;
    digits[1] = 7'b0101101;
    digits[2] = 7'b1110111;
    digits[3] = 7'b0011011;
    end
    
    always @(*) begin
        case (digit_sel)
            2'd0: begin 
                an = 4'b1110; 
                seg = digits[2'd0 + offset];   
            end
            2'd1: begin 
                an = 4'b1101; 
                seg = digits[2'd1 + offset];   
            end
            2'd2: begin 
                an = 4'b1011; 
                seg = digits[2'd2 + offset];   
            end
            2'd3: begin 
                an = 4'b0111; 
                seg = digits[2'd3 + offset];   
            end
        endcase
    end

endmodule
