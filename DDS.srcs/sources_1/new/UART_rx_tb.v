`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2026 04:56:13 PM
// Design Name: 
// Module Name: UART_rx_tb
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


module UART_rx_tb();
    reg rst, clk, data;
    wire [7:0] rx_byte;
    wire done;
    wire [1:0] st;
    wire [7:0] counter1;
    wire [3:0] rx_bit;
    
        
    UART DUT (
        .data(data),
        .clk(clk),
        .rst(rst),
        .rx_byte(rx_byte),
        .done(done),
        .st(st),
        .counter1(counter1),
        .rx_bit(rx_bit)
    );
    
    initial begin
        rst = 1; clk = 0; data = 1;
        #20 rst = 0;
        #8681 data = 0;
        #8681 data = 0;
        #8681 data = 0;
        #8681 data = 0;
        #8681 data = 1;
        #8681 data = 1;
        #8681 data = 0;
        #8681 data = 1;
        #8681 data = 0;
        #8681 data = 1;
        
        #(8681*2) $finish();
    end
    always #5 clk = ~clk;
    
    
endmodule
