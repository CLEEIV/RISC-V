`include "C:/Verilog/RISC-V/RTL/header/header.v"

module ALU (
    input  [31:0] a_alu     ,
    input  [31:0] b_alu     ,
    input  [2:0]  op_type   ,
    input         unsig     ,
    output [31:0] alu_result 
);
//**************************************************//
//---------------- register define -----------------//
//**************************************************//
reg [31:0] result_reg;
//**************************************************//
//------------------- wire define ------------------//
//**************************************************//
wire [31:0] add_result;
wire [31:0] sub_result;
wire [31:0] xor_result;
wire [31:0] or_result ;
wire [31:0] and_result;
wire [31:0] sll_result;
wire [31:0] srl_result;
wire [31:0] sra_result;
wire        trash_bit ;
wire [32:0] adda      ;
wire [32:0] addb      ;
wire        sub_flg   ;
//**************************************************//
//----------------------- OP -----------------------//
//**************************************************//
assign sub_flg = (op_type == `SUB);
assign adda = {a_alu, sub_flg};
assign addb = (sub_flg) ? {(~b_alu), 1'b1} : {b_alu, 1'b0};
assign {add_result, trash_bit} = adda + addb; // ADD & SUB
assign xor_result = a_alu ^ b_alu; // xor
assign or_result  = a_alu | b_alu; // OR
assign and_result = a_alu & b_alu; // AND
assign sll_result = (unsig == `UNSIGNED) ? b_alu : (a_alu << $unsigned(b_alu[4:0])); // SLL
assign srl_result = a_alu >> $unsigned(b_alu[4:0]); // SRL
assign sra_result = $signed(a_alu) >>> $unsigned(b_alu[4:0]); // SRA
//**************************************************//
//----------------------- sel ----------------------//
//**************************************************//
always @(*) begin
    case (op_type)
        `XOR    : result_reg = xor_result;
        `OR     : result_reg = or_result ;
        `AND    : result_reg = and_result;
        `SLL    : result_reg = sll_result;
        `SRL    : result_reg = srl_result;
        `SRA    : result_reg = sra_result;
        default : result_reg = add_result;
    endcase
end
//**************************************************//
//------------------- alu result -------------------//
//**************************************************//
assign alu_result = result_reg;
endmodule
