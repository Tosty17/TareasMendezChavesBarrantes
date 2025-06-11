`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025 09:10:34 PM
// Design Name: 
// Module Name: EXTEND_
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


module EXTEND_(
    input [11:0] Imm,
    input [19:0] Imm_U,
    input Imm_Src,
    output reg [31:0] out //inmediato con la extension a 32 bits realizada
);
    always @(*) begin
        if(Imm_Src) begin
            out = {Imm_U, 12'b0};
        end
        else begin
            out = {{20{Imm[11]}}, Imm};
        end
        
    end 
    //multiplica por 20 el bit de signo(ultimo bit) del inmediato y eso lo concatena con los 12 bits originales
endmodule
