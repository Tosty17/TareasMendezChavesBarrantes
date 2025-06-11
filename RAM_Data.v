`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.04.2025 01:04:51
// Design Name: 
// Module Name: RAM_Data
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


module RAM_Data(
    input CLK,
    input RST,
    input Store_type,
    input Load_type,
    input [6:0] Address,
    input Mem_Write,
    input [31:0] Write_Data,
    output [31:0] Data_output
    );
    integer i; 
    integer file; 

   //(* ram_style="distributed" *)
   reg [7:0] RAM [79:0];
    
    //Crear el dump
    initial begin
        $readmemh("C:/Users/Hewlett Packard/Desktop/Semestre 5/Microprocesadores/Codigo_maquina/RAM_instructions.txt", RAM, 0, 79);
    end
    //Dump de memoria en un .txt
    always @(posedge CLK) begin
        file = $fopen("C:/Users/Hewlett Packard/Desktop/Semestre 5/Microprocesadores/Codigo_maquina/reg_dump.txt", "w");
        for (i = 32; i >= 0; i = i - 1) begin
            $fdisplay (file, "[%0d] : %0d", i, RAM[i]);
        end
    end
   always @(posedge CLK) begin
      if(RST) begin
        for(i=0 ; i < 32; i = i + 1) begin
            RAM[i] <= 8'd0;
        end
      end
      else begin
        if (Mem_Write) begin
         if(Store_type) begin //hacer sw
            RAM[Address] <= Write_Data[7:0];
            RAM[Address + 1] <= Write_Data[15:8];
            RAM[Address + 2] <= Write_Data[23:16];
            RAM[Address + 3] <= Write_Data[31:24];
            
         end
         else begin //hacer sb
            RAM[Address] <= Write_Data[7:0];
         end
      end
      end
    end
   assign Data_output = (Load_type) ? {24'd0, RAM[Address]}
            : {RAM[Address + 3], RAM[Address + 2], RAM[Address + 1], RAM[Address]};
endmodule
