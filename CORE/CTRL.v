`include "C:/Verilog/RISC-V/RTL/header/header.v"

module CTRL (
    input            rst_n      ,
    input      [6:0] opcode     ,
    input      [2:0] funct3     ,
    input      [6:0] funct7     ,
    input      [1:0] comp_result,
    output reg       pc_sel     ,
    output reg       regs_w_en  ,
    output reg       a_sel      ,
    output reg       b_sel      ,
    output reg       ram_en     ,
    output reg [1:0] rw_sel     ,
    output     [4:0] ex_op      ,
    output     [1:0] mem_ex_type 
);
//**************************************************//
//---------------- register define -----------------//
//**************************************************//
// instr_type
reg [5:0] type_reg;
//**************************************************//
//------------------- wire define ------------------//
//**************************************************//
// instr_type
wire r;
wire i;
wire s;
wire b;
wire u;
wire j;
// comp_result
wire COMP_EQ   ;
wire COMP_NEQ  ;
wire COMP_LE   ;
wire COMP_GE_EQ;
// instr
wire TYPE_COMP_R;
wire TYPE_COMP_I;
wire TYPE_JUMP  ;
wire TYPE_PC    ;
wire TYPE_MOVE  ;
wire TYPE_LOAD  ;
//**************************************************//
//-------------------- instr type ------------------//
//**************************************************//
assign {r, i, s, b, u, j} = type_reg;
//**************************************************//
//------------------- comp result ------------------//
//**************************************************//
assign COMP_EQ    = (comp_result == 2'b00) ? 1'b1 : 1'b0;
assign COMP_NEQ   = ~COMP_EQ                            ;
assign COMP_LE    = (comp_result == 2'b01) ? 1'b1 : 1'b0;
assign COMP_GE_EQ = ~COMP_LE                            ;
//**************************************************//
//---------------------- expand --------------------//
//**************************************************//
assign ex_op       = {i, s, b, j, u};
assign TYPE_COMP_R = (opcode[6:2] == 5'b01100 && funct3[2:1] == 2'b01) ? 1'b1 : 1'b0;
assign TYPE_COMP_I = (opcode[6:2] == 5'b00100 && funct3[2:1] == 2'b01) ? 1'b1 : 1'b0;
assign TYPE_JUMP   = (j || (opcode[6:2] == 5'b11001)) ? 1'b1 : 1'b0;
assign TYPE_PC     = ((j | b | TYPE_COMP_R | TYPE_COMP_I) == 1'b1 || (opcode[6:2] == 5'b00101));
assign TYPE_LOAD   = (opcode[6:2] == 5'b00000) ? 1'b1 : 1'b0;
//**************************************************//
//----------------- instr type sel -----------------//
//**************************************************//
always @(*) begin
    case (opcode[6:2])
        5'b01100 : type_reg = 6'b100000; // R_type
        5'b01000 : type_reg = 6'b001000; // S_type
        5'b11000 : type_reg = 6'b000100; // B_type
        5'b01101 : type_reg = 6'b000010; // U_type
        5'b00101 : type_reg = 6'b000010; // U_type
        5'b11011 : type_reg = 6'b000001; // J_type
        default  : type_reg = 6'b010000; // I_type
    endcase
end
//**************************************************//
//----------------- pc branch ctrl -----------------//
//**************************************************//
always @(*) begin
    if (b) begin
        casez (funct3)
            3'b000  : pc_sel = (COMP_EQ)    ? `PCSEL_JUMP : `PCSEL_PC4;
            3'b001  : pc_sel = (COMP_NEQ)   ? `PCSEL_JUMP : `PCSEL_PC4;
            3'b1?0  : pc_sel = (COMP_LE)    ? `PCSEL_JUMP : `PCSEL_PC4;
            3'b1?1  : pc_sel = (COMP_GE_EQ) ? `PCSEL_JUMP : `PCSEL_PC4;
            default : pc_sel = `PCSEL_PC4;
        endcase
    end
    else if (TYPE_JUMP)
        pc_sel = `PCSEL_JUMP;
    else
        pc_sel = `PCSEL_PC4;
end
//**************************************************//
//----------------- regs write ctrl ----------------//
//**************************************************//
always @(*) begin
    if (s | b | ~rst_n)
        regs_w_en = `REGWE_READ ;
    else
        regs_w_en = `REGWE_WRITE;
end
//**************************************************//
//------------------- alu op ctrl ------------------//
//**************************************************//
always @(*) begin
    if (TYPE_PC)
        a_sel = `ASEL_PC;
    else
        a_sel = `ASEL_REG;
end
always @(*) begin
    if (((r == 1'b1) && (TYPE_COMP_R == 1'b0)) || (TYPE_COMP_I == 1'b1))
        b_sel = `BSEL_REG;
    else
        b_sel = `BSEL_IMM;
end
//**************************************************//
//------------------- regs wb ctrl -----------------//
//**************************************************//
always @(*) begin
    if (TYPE_LOAD)
        rw_sel = `REGWD_DRAMRD;
    else if (TYPE_COMP_R | TYPE_COMP_I)
        rw_sel = `REGWD_COMPOUT;
    else if (TYPE_JUMP)
        rw_sel = `REGWD_PC;
    else
        rw_sel = `REGWD_ALUOUT;
end
//**************************************************//
//------------------ mem write ctrl ----------------//
//**************************************************//
always @(*) begin
    if (!rst_n)
        ram_en = `DRAM_READ;
    else if (s)
        ram_en = `DRAM_WRITE;
    else
        ram_en = `DRAM_READ;
end
//**************************************************//
//------------------ mem write ctrl ----------------//
//**************************************************//
assign mem_ex_type = funct3[1:0];

endmodule
