`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025 08:55:49 PM
// Design Name: 
// Module Name: ALU
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


module ALU(input [31:0] A, B,        //Variables de entrada 
           input [1:0] alu_control,  // Es el apuntador de que operaciòn se va a realizar; 000 = ADD, 001 = AND
           output reg [31:0] result);//resultado de 32 bits de la operaciòn realizada en ALU

  always @(*) begin
  // Alu Control
    case (alu_control)
      
      2'd0: result = A + B;   
      
      2'd1: result = A & B;
      
      2'd2: result = B;
      
      default: result = 32'b0;
    endcase
  end
    
endmodule
