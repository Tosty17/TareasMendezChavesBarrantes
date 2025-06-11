`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025 09:13:13 PM
// Design Name: 
// Module Name: Cont_UNIT
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


module Cont_UNIT (
    input CLK,
    input RST,
    input [6:0] PC,
    input [6:0] opcode,
    input [2:0] funct3,
    output reg Reg_Write, 
    output reg [1:0] Alu_Control,
    output reg Address_Src,
    output reg PC_Write,
    output reg Inst_Write,
    output reg Imm_Src,
    output reg Mem_Write,
    output reg Imm_selector,
    output reg [1:0] Result_selector,
    output reg Store_type,
    output reg Load_type
);
    // Tipo S, opcode 0100011, secuencia:
    // 0, Ins_Write = 1
    // 1, Imm_selector = 1
    // 2, 
    // 3, Address_Src = 1, Mem_Write = 1, Store_type = 1 (solo para sw)
    
    //Tipo U, opcode 0110111, secuencia:
    // 0, Ins_Write = 1
    // 1, Imm_Src = 1
    // 5, PC_Write = 1, Reg_Write = 1, Result_selector = 2
    
    //Tipo I (Addi, Andi), opcode 0010011, funct3: Addi (000), Andi(111), secuencia:
    // 0, Ins_Write = 1
    // 1,
    // 2, Alu_Control = 1 (solo para andi)
    // 5, 
    
    //Tipo I (lw, lbu), opcode 0000011, funct3: lbu (100), lw (010)
    // 0, Ins_Write = 1
    // 1,
    // 2,
    // 4, Address_Src = 1, Load_type = 1 (solo para lbu)
    // 5, PC_Write = 1, Reg_Write = 1, Result_selector = 1
    
    //Todas las instrucciones regresan a 0, en 0 se revisa si PC == 80 (fin del codigo)
    
    reg [2:0] Estado_Actual;
    reg [2:0] Estado_Siguiente;
    //Actualizacion de FF
    always @(posedge CLK) begin
        if(RST) begin
            //Arreglar Reset, al mandar a estado 0, PC va aumentando 
            Estado_Siguiente <= 3'd0;
            Estado_Actual <= 3'd0;
            Address_Src <= 1'd0;
            PC_Write <= 1'd1;
            Inst_Write <= 1'd1;
            Imm_selector <= 1'd0;
            Imm_Src <= 1'd0;
            Alu_Control <= 2'd0;  
            Store_type <= 1'd0; 
            Mem_Write <= 1'd0; 
            Result_selector <= 2'd0;
            Reg_Write <= 1'd0;
            Load_type <= 1'd0;
        end
        else begin
            Estado_Actual <= Estado_Siguiente;
        end
    end
    //Logica de combinacional de estado Siguiente
    always @(*) begin
        case(Estado_Actual)
            3'd0: begin //Fetch
                if(PC == 7'd84) begin
                    Estado_Siguiente = 3'd0;
                end
                else begin
                    Estado_Siguiente = 3'd1;
                end
            end
            3'd1: begin //Decode
                Estado_Siguiente = 3'd2;   
            end
            3'd2: begin //Execute
                if(opcode == 7'b0000011) begin //lw, lbu
                    Estado_Siguiente = 3'd3;
                end
                else begin
                    Estado_Siguiente = 3'd4;
                end
            end
            3'd3: begin //Memory
                Estado_Siguiente = 3'd4;
            end
            3'd4: begin //Write Back
                Estado_Siguiente = 3'd0;
            end
            default: begin
                Estado_Siguiente = 3'd0;
            end
        endcase
    
    end
    //Control de extensor de signo
                // Tipo S ---> Imm_selector = 1, Imm_Src = 0
                // Tipo I ---> Imm_selector = 0, Imm_Src = 0
                // Tipo U ---> Imm_selector = 0, Imm_Src = 1
     //Logica combinacional de salidas
    always @(*) begin
        case (Estado_Actual)
            3'd0: //Fetch
            begin
                if(opcode == 7'b0100011) begin //Tipo S
                    Imm_Src = 1'd0;
                    Imm_selector = 1'd1;
                end
                if(opcode == 7'b0110111) begin //Tipo U
                    Imm_Src = 1'd1;
                    Imm_selector = 1'd0;
                end
                if(opcode == 7'b0010011) begin //Addi, andi
                    Imm_Src = 1'd0;
                    Imm_selector = 1'd0;
                end
                if(opcode == 7'b0000011) begin //lw, lbu
                    Imm_Src = 1'd0;
                    Imm_selector = 1'd0;
                end
            end
            3'd1: //Decode
            begin
                if(opcode == 7'b0100011) begin //Tipo S
                    Imm_Src = 1'd0;
                    Imm_selector = 1'd1;
                    Alu_Control = 2'd0;
                end
                if(opcode == 7'b0110111) begin //Tipo U
                    Imm_Src = 1'd1;
                    Imm_selector = 1'd0;
                    Alu_Control = 2'd2;
                end
                if(opcode == 7'b0010011) begin //Addi, andi
                    Imm_Src = 1'd0;
                    Imm_selector = 1'd0;
                    if(funct3 == 3'b111) begin //Andi
                        Alu_Control = 2'd1;
                    end
                    else begin //Addi
                        Alu_Control = 2'd0;
                    end
                end
                if(opcode == 7'b0000011) begin //lw, lbu
                    Imm_Src = 1'd0;
                    Imm_selector = 1'd0;
                    Alu_Control = 2'd0;
                end
                
                
            end
            3'd2: // Execute
            begin
                if(opcode == 7'b0100011) begin //Tipo S
                    Imm_Src = 1'd0;
                    Imm_selector = 1'd1;
                    Alu_Control = 2'd0;
                    Result_selector = 2'd0;
                    Mem_Write = 1'd1;
                    if(funct3 == 3'b010) begin //sw
                        Store_type = 1'd1;
                    end
                    else begin //sb
                        Store_type = 1'd0;
                    end
                    Address_Src = 1'd1;
                end
                if(opcode == 7'b0110111) begin //Tipo U
                    Imm_Src = 1'd1;
                    Imm_selector = 1'd0;
                    Alu_Control = 2'd2;
                    Result_selector = 2'd0;
                    Reg_Write = 1'd1;
                end
                if(opcode == 7'b0010011) begin //Addi, andi
                    Imm_Src = 1'd0;
                    Imm_selector = 1'd0;
                    if(funct3 == 3'b111) begin //Andi
                        Alu_Control = 2'd1;
                    end
                    else begin //Addi
                        Alu_Control = 2'd0;
                    end
                    Result_selector = 2'd0;
                    Reg_Write = 1'd1;
                end
                if(opcode == 7'b0000011) begin //lw, lbu
                    Imm_Src = 1'd0;
                    Imm_selector = 1'd0;
                    Alu_Control = 2'd0;
                    Result_selector = 2'd0;
                    if(funct3 == 3'b100) begin //lbu
                        Load_type = 1'd1;
                    end
                    else begin
                        Load_type = 1'd0; //lw
                    end
                    Address_Src = 1'd1;
                end
            end 
            3'd3: //Memory
            begin
                Imm_Src = 1'd0;
                Imm_selector = 1'd0;
                Alu_Control = 2'd0;
                if(funct3 == 3'b100) begin //lbu
                    Load_type = 1'd1;
                end
                else begin
                    Load_type = 1'd0; //lw
                end
                Address_Src = 1'd0;
                Result_selector = 2'd1;
                Reg_Write = 1'd1;   
                      
            end          
            3'd4: //Write back
            begin
                Reg_Write = 1'd0;
                Mem_Write = 1'd0;
                Result_selector = 2'd0;
                Address_Src = 1'd0;
                Store_type = 1'd0; 
                Load_type = 1'd0;
                Alu_Control = 2'd0;
                if(opcode == 7'b0100011) begin //Tipo S
                    Imm_Src = 1'd0;
                    Imm_selector = 1'd1;
                    if(PC == 7'd84) begin
                        PC_Write = 1'd0;
                        Inst_Write = 1'd0;
                    end
                    else begin
                        PC_Write = 1'd1;
                        Inst_Write = 1'd1;
                    end
                end
                if(opcode == 7'b0110111) begin //Tipo U
                    Imm_Src = 1'd1;
                    Imm_selector = 1'd0;
                    PC_Write = 1'd1;
                    Inst_Write = 1'd1;
                end
                if(opcode == 7'b0010011) begin //Addi, andi
                    Imm_Src = 1'd0;
                    Imm_selector = 1'd0;
                    PC_Write = 1'd1;
                    Inst_Write = 1'd1;
                end
                if(opcode == 7'b0000011) begin //lw, lbu
                    Imm_Src = 1'd0;
                    Imm_selector = 1'd0;
                    PC_Write = 1'd1;
                    Inst_Write = 1'd1;
                end      
            end
            default: 
            begin
                Address_Src = 1'd0;
                PC_Write = 1'd1;
                Inst_Write = 1'd1;
                Imm_selector = 1'd0;
                Imm_Src = 1'd0;
                Alu_Control = 2'd0;  
                Store_type = 1'd0; 
                Mem_Write = 1'd0; 
                Result_selector = 2'd0;
                Reg_Write = 1'd0;
                Load_type = 1'd0;
            end
            endcase     
    end
    //Salidas que no son usadas 
    always @(*) begin
        case(Estado_Actual)
        3'd0: begin
            Address_Src = 1'd0;
            PC_Write = 1'd0;
            Inst_Write = 1'd0;
            Alu_Control = 2'd0;  
            Store_type = 1'd0; 
            Mem_Write = 1'd0; 
            Result_selector = 2'd0;
            Reg_Write = 1'd0;
            Load_type = 1'd0;
        end
        3'd1: begin
            Address_Src = 1'd0;
            PC_Write = 1'd0;
            Inst_Write = 1'd0;  
            Store_type = 1'd0; 
            Mem_Write = 1'd0; 
            Result_selector = 2'd0;
            Reg_Write = 1'd0;
            Load_type = 1'd0;
        end
        3'd2: begin
            if(opcode == 7'b0100011) begin //Tipo S
                PC_Write = 1'd0;
                Inst_Write = 1'd0;
                Reg_Write = 1'd0;
                Load_type = 1'd0;
            end
            if(opcode == 7'b0110111) begin //Tipo U
                Address_Src = 1'd0;
                PC_Write = 1'd0;
                Inst_Write = 1'd0;  
                Store_type = 1'd0; 
                Mem_Write = 1'd0; 
                Load_type = 1'd0;
            end
            if(opcode == 7'b0010011)begin //Addi, Andi
                Address_Src = 1'd0;
                PC_Write = 1'd0;
                Inst_Write = 1'd0;  
                Store_type = 1'd0; 
                Mem_Write = 1'd0; 
                Load_type = 1'd0;
            end
            if(opcode == 7'b0000011) begin //lw, lbu
                PC_Write = 1'd0;
                Inst_Write = 1'd0;
                Store_type = 1'd0; 
                Mem_Write = 1'd0; 
                Reg_Write = 1'd0;
            end
        end
        3'd3: begin
            PC_Write = 1'd0;
            Inst_Write = 1'd0;  
            Store_type = 1'd0; 
            Mem_Write = 1'd0; 
        end
        endcase
    end
endmodule
