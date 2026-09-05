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
    input clk, rst, data,
    input [15:0] sw,
    output reg temp,
    output [6:0] seg,
    output [3:0] an
    );
    wire signed [15:0] sin;
    reg [15:0] SevSeg; 
    wire [7:0] rx_byte;
    wire rx_done;
    wire [31:0] phase;


    reg [31:0] FTW;
    
    initial begin
        FTW = 32'd42949673; 
    end
    
    
    ila_0 my_ila (
        .clk(clk),           // design clock
        .probe0(sin),           // 16-bit
        .probe1(phase),         // 32-bit
        .probe2(LUTIndex)       // 12-bit
    );
    
    seg7_debug display (
        .clk(clk),
        .rst(rst),
        .value(SevSeg),
        .seg(seg),
        .an(an)
    );    
    
    UART rx (
        .data(data),
        .clk(clk),
        .rst(rst),
        .rx_byte(rx_byte),
        .done(rx_done)
    );
    
    DDS synth (
        .clk(clk),
        .rst(rst),
        .sin(sin),
        .phase(phase),
        .rx_byte(rx_byte),
        .rx_done(rx_done),
        .FTW(FTW)
    );
    
    reg [1:0] byte_num;
    reg process_done;
    always @(posedge clk) begin
        process_done <= 0;
        if (rx_done) begin
            case (byte_num)
                2'd0: FTW[7:0] <= rx_byte;
                2'd1: FTW[15:8] <= rx_byte;
                2'd2: FTW[23:16] <= rx_byte;
                2'd3: begin
                    FTW[31:24] <= rx_byte;
                    process_done <= 1;
                end
            endcase
            byte_num <= byte_num + 1;
        end
        
        if (count1 == 25'd9000000) begin
            count1 <= 0;
            temp <= 0;
        end else count1 <= count1 + 1;
        if (process_done == 1) begin
            count1 <= 0;
            temp <= 1;
        end
        
        if (rx_done) SevSeg[7:0] <= rx_byte;
        
        
    end 
    
    reg  [25:0] count1;

endmodule
