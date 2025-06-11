`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025 09:00:24 PM
// Design Name: 
// Module Name: REGISTER_FILE
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


module REGISTER_FILE(    
    input clk,
    input reg_write,         //indicador de escritura de dato
    input [4:0] rs1,
    input [4:0] rs2,    //rs1 y rs2, son la direccion de los regitros donde se va a leer dato
    input [4:0] rd,          //rd es la direccion del resgistro donde se va a escribir el dato que presenta "write_data"
    input [31:0] write_data, //dato que se va a almcenar en la direccion indicada por rd
    
    output [31:0] read_data1, read_data2  //valor actual luego del clk que se encuentra en los registros rs1 y rs2
);
    reg [31:0] registros[0:31];
     
    initial begin
        $readmemh("C:/Users/Hewlett Packard/Desktop/Semestre 5/Microprocesadores/Codigo_maquina/Register_file.txt", registros, 0, 31);
    end

    assign read_data1 = registros[rs1];  //Se asigna en read_data1 lo que tenga la direccion de rs1
    assign read_data2 = registros[rs2];  //Se asigna en read_data2 lo que tenga la direccion de rs2

    always @(posedge clk) begin
        if (reg_write && rd != 0)
            registros[rd] <= write_data;  //se asigna en la direccion rd lo que indique write_data
    end
endmodule
