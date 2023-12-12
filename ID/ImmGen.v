`include "C:/Verilog/RISC-V/RTL/header/header.v"

module ImmGen (
    input  [31:7] imm       ,
    input  [4:0]  ex_op     ,
    output [31:0] imm_result  
);
//**************************************************//
//---------------- register define -----------------//
//**************************************************//
reg [31:0] imm_reg;
//**************************************************//
//------------------- wire define ------------------//
//**************************************************//
wire [31:0] imm_I;
wire [31:0] imm_S;
wire [31:0] imm_B;
wire [31:0] imm_J;
wire [31:0] imm_U;
//**************************************************//
//---------------------- decode --------------------//
//**************************************************//
assign imm_I = {{20{imm[31]}}, imm[31:20]};
assign imm_S = {{20{imm[31]}}, imm[31:25], imm[11:8], imm[7]};
assign imm_B = {{20{imm[31]}}, imm[7], imm[30:25], imm[11:8], 1'b0};
assign imm_J = {{12{imm[31]}}, imm[19:12], imm[20], imm[30:21], 1'b0};
assign imm_U = {imm[31:12], 12'd0};
//**************************************************//
//-------------------- imm result ------------------//
//**************************************************//
always @(*) begin
    case (ex_op)
        `IMM_I  : imm_reg = imm_I;
        `IMM_S  : imm_reg = imm_S;
        `IMM_B  : imm_reg = imm_B;
        `IMM_J  : imm_reg = imm_J;
        `IMM_U  : imm_reg = imm_U;
        default : imm_reg = 32'd0;
    endcase
end
assign imm_result = imm_reg;

endmodule