`include "C:/Verilog/RISC-V/RTL/header/header.v"

module WB (
    input  [31:0] pc_add4       ,
    input  [31:0] comp_ex_result,
    input  [31:0] alu_result    ,
    input  [31:0] mem_data      ,
    input  [1:0]  rw_sel        ,
    output [31:0] rd_data        
);
//**************************************************//
//---------------- register define -----------------//
//**************************************************//
reg [31:0] rd_data_reg;
//**************************************************//
//----------------------- sel ----------------------//
//**************************************************//
always @(*) begin
    case (rw_sel)
        `REGWD_PC      : rd_data_reg = pc_add4       ;
        `REGWD_COMPOUT : rd_data_reg = comp_ex_result;
        `REGWD_ALUOUT  : rd_data_reg = alu_result    ;
        default        : rd_data_reg = mem_data      ;
    endcase
end
//**************************************************//
//------------------- data result ------------------//
//**************************************************//
assign rd_data = rd_data_reg;

endmodule