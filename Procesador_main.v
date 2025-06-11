`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025 09:09:03 PM
// Design Name: 
// Module Name: Procesador_main
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


module Procesador_main(
    input CLK,
    input reset,
    output reg dump_signal
);     
    
    //wires
    wire [6:0] address;
    wire [6:0] opcode;    
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [11:0] Imm;
    wire [19:0] Imm_U;
    wire [31:0] Imm_extended_w; 
    wire [31:0] Read_data1_w, Read_data2_w;
    wire [31:0] Resultado;
    wire [31:0] Alu_Result_w;
    wire [31:0] Data_RAM; //salida de la RAM
    
    //Registros multiciclo
    reg [31:0] Instruction_reg;
    reg [31:0] Dato_escritura;
    reg [31:0] Read_data1;
    reg [31:0] Read_data2;
    reg [31:0] Alu_Result;
    reg [6:0] PC;
    
    initial begin
        PC <= 7'd32;
        dump_signal <= 1'd1;
        Instruction_reg <= 32'd0;
        Dato_escritura <= 32'd0;
        Read_data1 <= 32'd0;
        Read_data2 <= 32'd0;
        Alu_Result <= 32'd0;
    end
    
    
    //Salidas del control Unit    
    wire Reg_Write; 
    wire [1:0] Alu_Control;
    wire Address_Src;
    wire PC_Write;
    wire Inst_Write;
    wire Imm_Src;
    wire Mem_Write;
    wire Imm_selector;
    wire [1:0] Result_selector;
    wire Store_type; 
    wire Load_type;
    
    
    //Submodulos
    RAM_Data RAM_data_inst (
        .CLK(CLK),
        .RST(reset),
        .Store_type(Store_type),
        .Load_type(Load_type),
        .Address(address),
        .Mem_Write(Mem_Write),
        .Write_Data(Read_data2),
        .Data_output(Data_RAM)
    );
    Cont_UNIT CU (
        .CLK(CLK),
        .RST(reset),
        .PC(PC),
        .opcode(opcode),
        .funct3(funct3),
        .Reg_Write(Reg_Write),
        .Alu_Control(Alu_Control),
        .Address_Src(Address_Src),
        .PC_Write(PC_Write),
        .Inst_Write(Inst_Write),
        .Imm_Src(Imm_Src),
        .Mem_Write(Mem_Write),
        .Imm_selector(Imm_selector),
        .Result_selector(Result_selector),
        .Store_type(Store_type),
        .Load_type(Load_type)
   );     
    EXTEND_ SE(Imm, Imm_U, Imm_Src, Imm_extended_w);
    REGISTER_FILE RF(CLK, Reg_Write, rs1, rs2, rd, Resultado, Read_data1_w, Read_data2_w);
    ALU ALU(Read_data1, Imm_extended_w, Alu_Control, Alu_Result_w);
    Mux_2a4 Multiplexor(Alu_Result, Dato_escritura, Imm_extended_w, Result_selector, Resultado);
    
    //Asignaciones
    assign opcode = Instruction_reg [6:0];
    assign rd = Instruction_reg [11:7];
    assign funct3 = Instruction_reg [14:12];
    assign rs1 = Instruction_reg [19:15];
    assign rs2 = Instruction_reg [24:20];
    assign Imm = Imm_selector ? {Instruction_reg[31:25], Instruction_reg[11:7]}: //Imm tipo S
    Instruction_reg[31:20];  // Imm tipo I
    assign Imm_U = Instruction_reg[31:12]; //Imm tipo U
    assign address = Address_Src ? Resultado [6:0] : PC;
 
    

    always @(posedge CLK)
        case(reset)
            1'b0: 
            begin
                //Etapa Fetch
                if(Inst_Write) begin
                    Instruction_reg <= Data_RAM;
                end
                Dato_escritura <= Data_RAM;
                if(PC_Write) begin
                    PC <= PC + 7'd4;
                end
                //Etapa Decode
                Read_data1 <= Read_data1_w;
                Read_data2 <= Read_data2_w;
                Alu_Result <= Alu_Result_w; 
                //Variable del dump
               dump_signal <= 1'd1;
                
            end
            1'b1:
            begin
                PC <= 7'd32;
                dump_signal <= 1'd1;
                Instruction_reg <= 32'd0;
                Dato_escritura <= 32'd0;
                Read_data1 <= 32'd0;
                Read_data2 <= 32'd0;
                Alu_Result <= 32'd0;
                
            end
            default: 
            begin
                PC <= 7'd32;
                dump_signal <= 1'd1;
                Instruction_reg <= 32'd0;
                Dato_escritura <= 32'd0;
                Read_data1 <= 32'd0;
                Read_data2 <= 32'd0;
                Alu_Result <= 32'd0;
            end
        endcase
endmodule
