`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.05.2025 12:42:28
// Design Name: 
// Module Name: Mux_2a4
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


module Mux_2a4(
    input [31:0] A,
    input [31:0] B,
    input [31:0] C,
    input [1:0] sel,
    output reg [31:0] salida
    );
    always @(*) begin
        case(sel)
        2'd0: salida = A;
        
        2'd1: salida = B;
        
        2'd2: salida = C; 
        
        default: salida = 32'd0;    
        endcase
    end
    
endmodule
