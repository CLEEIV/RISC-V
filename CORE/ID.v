module ID (
    input         clk       ,
    input         rst_n     ,
    input  [31:0] instr     ,
    input  [4:0]  ex_op     ,
    input         regs_w_en ,
    input  [31:0] rd_data   ,
    output [31:0] rs1_data  ,
    output [31:0] rs2_data  ,
    output [31:0] imm_result,
    output [2:0]  op_type   ,
    output        unsig      
);
//**************************************************//
//------------------- wire define ------------------//
//**************************************************//
wire [5:0]  rs1_addr;
wire [5:0]  rs2_addr;
wire [5:0]  rd_addr ;
wire [6:0]  opcode  ;
wire [2:0]  funct3  ;
wire [6:0]  funct7  ;
wire [31:7] imm     ;
//**************************************************//
//---------------------- decode --------------------//
//**************************************************//
assign rs1_addr = instr[19:15];
assign rs2_addr = instr[24:20];
assign rd_addr  = instr[11:7] ;
assign opcode   = instr[6:0]  ;
assign funct3   = instr[14:12];
assign funct7   = instr[31:25];
assign imm      = instr[31:7] ;
//**************************************************//
//---------------------- module --------------------//
//**************************************************//
RegFile RegFile (
    // input
    .clk       ( clk       ),
    .rst_n     ( rst_n     ),
    .regs_w_en ( regs_w_en ),
    .rs1_addr  ( rs1_addr  ),
    .rs2_addr  ( rs2_addr  ),
    .rd_addr   ( rd_addr   ),
    .rd_data   ( rd_data   ),
    // output
    .rs1_data  ( rs1_data  ),
    .rs2_data  ( rs2_data  ) 
);
ImmGen ImmGen (
    // input
    .imm        ( imm        ),
    .ex_op      ( ex_op      ),
    // output
    .imm_result ( imm_result ) 
);
ALUop ALUop (
    // input
    .opcode   ( opcode  ),
    .funct3   ( funct3  ),
    .funct7   ( funct7  ),
    // output
    .op_type  ( op_type ),
    .unsig    ( unsig   ) 
);

endmodule