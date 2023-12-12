`include "C:/Verilog/RISC-V/RTL/header/header.v"

module ALUop (
    input      [6:0] opcode ,
    input      [2:0] funct3 ,
    input      [6:0] funct7 ,
    output reg [2:0] op_type,
    output reg       unsig   
);
//**************************************************//
//-------------------- op type ---------------------//
//**************************************************//
always @(*) begin
    casez ({funct7[5], funct3, opcode[6:2]})
        // shift
        9'b11010?100 : op_type = `SRA;
        9'b01010?100 : op_type = `SRL;
        9'b00010?100 : op_type = `SLL;
        // logic
        9'b?10000100 : op_type = `XOR;
        9'b010001100 : op_type = `XOR;
        9'b?11000100 : op_type = `OR ;
        9'b011001100 : op_type = `OR ;
        9'b?11100100 : op_type = `AND;
        9'b011101100 : op_type = `AND;
        // lui
        9'b????01101 : op_type = `SLL;
        // algorithm
        9'b100001100 : op_type = `SUB;
        default      : op_type = `ADD;
    endcase
end
//**************************************************//
//------------------- unsig ctrl--------------------//
//**************************************************//
always @(*) begin
    casez ({funct3, opcode[6:2]})
        // bltu, bgeu
        8'b11?11000 : unsig = `UNSIGNED;
        // sltiu, sltu
        8'b0110?100 : unsig = `UNSIGNED;
        // lbu, lwu, lhu
        8'b1??00000 : unsig = `UNSIGNED;
        // lui
        8'b???01101 : unsig = `UNSIGNED;
        default     : unsig = `SIGNED  ;
    endcase
end

endmodule
