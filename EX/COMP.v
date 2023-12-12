`include "C:/Verilog/RISC-V/RTL/header/header.v"

module COMP (
    input [31:0] a_comp     ,
    input [31:0] b_comp     ,
    input        unsig      ,
    output [1:0] comp_result 
);
//**************************************************//
//---------------- register define -----------------//
//**************************************************//
reg [1:0] result_reg;
//**************************************************//
//------------------- wire define ------------------//
//**************************************************//
wire [31:0] a_temp;
wire [31:0] b_temp;
wire        equal ;
wire        less  ;
//**************************************************//
//----------------------- OP -----------------------//
//**************************************************//
assign a_temp[30:0] = a_comp[30:0];
assign a_temp[31] = (unsig == `UNSIGNED) ? a_comp[31] : ~a_comp[31];
assign b_temp[30:0] = b_comp[30:0];
assign b_temp[31] = (unsig == `UNSIGNED) ? b_comp[31] : ~b_comp[31];
assign equal = ($unsigned(a_temp) == $unsigned(b_temp)) ? 1'b1 : 1'b0;
assign less  = ($unsigned(a_temp) < $unsigned(b_temp))  ? 1'b1 : 1'b0;
//**************************************************//
//----------------------- sel ----------------------//
//**************************************************//
always @(*) begin
    if (equal)
        result_reg = `COMP_EQ;
    else if (less)
        result_reg = `COMP_LE;
    else
        result_reg = `COMP_GE;
end
//**************************************************//
//------------------- alu_result -------------------//
//**************************************************//
assign comp_result = result_reg;

endmodule