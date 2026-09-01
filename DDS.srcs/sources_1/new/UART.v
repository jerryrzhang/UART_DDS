`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2026 11:40:06 AM
// Design Name: 
// Module Name: UART
// Project Name
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


module UART(
    input rst, clk, data,
    output reg [7:0] rx_byte,
    output reg done,
    output reg [1:0] st,
    output reg [15:0] counter1,
    output reg [3:0] rx_bit
    );
    

    parameter IDLE = 2'd0, START = 2'd1, DATA = 2'd2, STOP = 2'd3; 
    
    
    
    reg ff1, ff2;
    
    
    always @(posedge clk) begin
        ff1 <= data;
        ff2 <= ff1;
    
        if (rst) begin
            st <= IDLE;
            counter1 <= 0;
            rx_bit <= 0;
            done <= 0;
            rx_byte <= 0;
        end else begin
        
            case (st)
                IDLE: begin
                    counter1 <= 0;
                    rx_bit <= 0;
                    if (ff2 == 0) st <= START;
                end
                START: begin
                    if (counter1 == 16'd433) begin //Sample again at the middle of the start bit
                        if (ff2 == 0) begin
                            st <= DATA;
                            counter1 <= 0;
                        end
                        else st <= IDLE;
                    end
                    else counter1 <= counter1 + 1;
                end
                DATA: begin
                    if (counter1 == 16'd867) begin
                        rx_byte[rx_bit] <= ff2;
                        rx_bit <= rx_bit + 1;
                        counter1 <= 0;
                        
                        if (rx_bit == 4'd8) st <= STOP;
                        
                    end else counter1 <= counter1 + 1 ;
                end
                STOP: begin
                    if (counter1 == 16'd867) begin
                        if (ff2) begin
                            done <= 1;
                            st <= IDLE;
                        end else st <= IDLE;
                    end else counter1 <= counter1 + 1;
                end
            endcase
        end
    end
    
endmodule
