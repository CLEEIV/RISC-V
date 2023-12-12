module IF (
    input         clk      ,
    input         rst_n    ,
    input  [31:0] branch_pc,
    input         pc_sel   ,
    output [31:0] instr    ,
    output [31:0] pc       ,
    output [31:0] pc_add4   
);
//**************************************************//
//------------------- wire define ------------------//
//**************************************************//
wire [31:0] next_pc   ;
wire [31:0] current_pc;
//**************************************************//
//------------------------ PC ----------------------//
//**************************************************//
assign pc = current_pc;
//**************************************************//
//---------------------- module --------------------//
//**************************************************//
NPC NPC (
    // input
    .current_pc ( current_pc ),
    .branch_pc  ( branch_pc  ),
    .pc_sel     ( pc_sel     ),
    // output
    .next_pc    ( next_pc    ),
    .pc_add4    ( pc_add4    )
);
PC PC (
    // input
    .clk        ( clk        ),
    .rst_n      ( rst_n      ),
    .next_pc    ( next_pc    ),
    // output
    .current_pc ( current_pc )
);
ROM ROM (
    // input
    .current_pc ( current_pc ),
    // output
    .instr      ( instr      )
);
endmodule