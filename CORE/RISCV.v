module RISCV (
    input clk  ,
    input rst_n 
);
//**************************************************//
//------------------- wire define ------------------//
//**************************************************//
// addr
wire [31:0] pc     ;
wire [31:0] pc_add4;
// instr
wire [31:0] instr                ;
wire [6:0]  opcode = instr[6:0]  ;
wire [2:0]  funct3 = instr[14:12];
wire [6:0]  funct7 = instr[31:25];
// read write data
wire [31:0] rs1_data;
wire [31:0] rs2_data;
wire [31:0] rd_data ;
wire [31:0] mem_data;
// op result
wire [1:0]  comp_result   ;
wire [31:0] alu_result    ;
wire [31:0] imm_result    ;
wire [31:0] comp_ex_result;
// ctrl
wire       pc_sel     ;
wire       regs_w_en  ;
wire       a_sel      ;
wire       b_sel      ;
wire       ram_en     ;
wire [4:0] ex_op      ;
wire [1:0] mem_ex_type;
wire [2:0] op_type    ;
wire       unsig      ;
wire [1:0] rw_sel     ;
//**************************************************//
//-------------------- sub_system ------------------//
//**************************************************//
CTRL CTRL (
    .rst_n       ( rst_n       ),
    .opcode      ( opcode      ),
    .funct3      ( funct3      ),
    .funct7      ( funct7      ),
    .comp_result ( comp_result ),
    .pc_sel      ( pc_sel      ),
    .regs_w_en   ( regs_w_en   ),
    .a_sel       ( a_sel       ),
    .b_sel       ( b_sel       ),
    .ram_en      ( ram_en      ),
    .rw_sel      ( rw_sel      ),
    .ex_op       ( ex_op       ),
    .mem_ex_type ( mem_ex_type ) 
);
IF IF (
    .clk       ( clk        ),
    .rst_n     ( rst_n      ),
    .branch_pc ( alu_result ),
    .pc_sel    ( pc_sel     ),
    .instr     ( instr      ),
    .pc        ( pc         ),
    .pc_add4   ( pc_add4    ) 
);
ID ID (
    .clk        ( clk        ),
    .rst_n      ( rst_n      ),
    .instr      ( instr      ),
    .ex_op      ( ex_op      ),
    .regs_w_en  ( regs_w_en  ),
    .rd_data    ( rd_data    ),
    .rs1_data   ( rs1_data   ),
    .rs2_data   ( rs2_data   ),
    .imm_result ( imm_result ),
    .op_type    ( op_type    ),
    .unsig      ( unsig      ) 
);
EX EX (
    .rs1_data       ( rs1_data       ),
    .rs2_data       ( rs2_data       ),
    .imm_result     ( imm_result     ),
    .pc             ( pc             ),
    .a_sel          ( a_sel          ),
    .b_sel          ( b_sel          ),
    .op_type        ( op_type        ),
    .unsig          ( unsig          ),
    .comp_result    ( comp_result    ),
    .comp_ex_result ( comp_ex_result ),
    .alu_result     ( alu_result     ) 
);
MEM MEM (
    .clk         ( clk         ),
    .ram_en      ( ram_en      ),
    .rs2_data    ( rs2_data    ),
    .alu_result  ( alu_result  ),
    .unsig       ( unsig       ),
    .mem_ex_type ( mem_ex_type ),
    .mem_data    ( mem_data    ) 
);
WB WB (
    .pc_add4        ( pc_add4        ),
    .comp_ex_result ( comp_ex_result ),
    .alu_result     ( alu_result     ),
    .mem_data       ( mem_data       ),
    .rw_sel         ( rw_sel         ),
    .rd_data        ( rd_data        ) 
);

endmodule