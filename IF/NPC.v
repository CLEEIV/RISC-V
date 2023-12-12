module NPC (
    input  [31:0] current_pc,
    input  [31:0] branch_pc ,
    input         pc_sel    ,
    output [31:0] next_pc   ,
    output [31:0] pc_add4    
);
assign pc_add4 = current_pc + 32'd4;
assign next_pc = (pc_sel) ? branch_pc : pc_add4;

endmodule
