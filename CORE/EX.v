`include "C:/Verilog/RISC-V/RTL/header/header.v"

module EX (
    input  [31:0] rs1_data      ,
    input  [31:0] rs2_data      ,
    input  [31:0] imm_result    ,
    input  [31:0] pc            ,
    input         a_sel         ,
    input         b_sel         ,
    input  [2:0]  op_type       ,
    input         unsig         ,
    output [1:0]  comp_result   ,
    output [31:0] comp_ex_result,
    output [31:0] alu_result     
);
//**************************************************//
//------------------- wire define ------------------//
//**************************************************//
wire [31:0] a_alu ;
wire [31:0] b_alu ;
wire [31:0] a_comp;
wire [31:0] b_comp;
//**************************************************//
//----------------------- mux ----------------------//
//**************************************************//
assign a_alu  = (a_sel == `ASEL_PC)  ? pc       : rs1_data  ;
assign a_comp = (a_sel == `ASEL_PC)  ? rs1_data : pc        ;
assign b_alu  = (b_sel == `BSEL_IMM) ? imm_result : rs2_data;
assign b_comp = (b_sel == `BSEL_IMM) ? rs2_data : imm_result;
//**************************************************//
//---------------------- expand --------------------//
//**************************************************//
assign comp_ex_result = {31'd0, comp_result[0]};
//**************************************************//
//---------------------- module --------------------//
//**************************************************//
ALU ALU (
    .a_alu      ( a_alu      ),
    .b_alu      ( b_alu      ),
    .op_type    ( op_type    ),
    .unsig      ( unsig      ),
    .alu_result ( alu_result ) 
);
COMP COMP (
    .a_comp      ( a_comp      ),
    .b_comp      ( b_comp      ),
    .unsig       ( unsig       ),
    .comp_result ( comp_result ) 
);
endmodule
