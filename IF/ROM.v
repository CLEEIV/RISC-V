module ROM (
    input  [31:0] current_pc,
    output [31:0] instr            
);
//**************************************************//
//---------------------- module --------------------//
//**************************************************//
instr_pool instr_pool (
    .a   ( current_pc[15:2] ),
    .spo ( instr            )
);

endmodule