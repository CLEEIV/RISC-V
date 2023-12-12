// sig
`define UNSIGNED             1'b1
`define SIGNED               1'b0
// op_type
`define ADD                  3'b000
`define SUB                  3'b010
`define AND                  3'b110
`define OR                   3'b100
`define XOR                  3'b101
`define SLL                  3'b001
`define SRL                  3'b011
`define SRA                  3'b111
// imm
`define IMM_I                5'b10000
`define IMM_S                5'b01000
`define IMM_B                5'b00100
`define IMM_J                5'b00010
`define IMM_U                5'b00001
// compare
`define COMP_EQ              2'b00
`define COMP_LE              2'b01
`define COMP_GE              2'b10
// expand
`define DRAM_EX_W            2'00
`define DRAM_EX_H            2'01
`define DRAM_EX_B            2'11
// branch
`define PCSEL_PC4            1'b0    // sequence
`define PCSEL_JUMP           1'b1    // branch
// regs_en
`define REGWE_READ           1'b0    // read
`define REGWE_WRITE          1'b1    // write
// alu_ctrl
`define ASEL_REG             1'b0    // sel_reg_A
`define ASEL_PC              1'b1    // sel_pc_A
`define BSEL_REG             1'b0    // sel_reg_B
`define BSEL_IMM             1'b1    // sel_imm_b
// Mem_ctrl
`define DRAM_READ            1'b0    // read
`define DRAM_WRITE           1'b1    // write
// wb_regs_ctrl
`define REGWD_PC             2'b00   // wb_pc+4
`define REGWD_COMPOUT        2'b01   // wb_compare
`define REGWD_ALUOUT         2'b11   // wb_alu_result
`define REGWD_DRAMRD         2'b10   // wb_Mem_data
// port
`define IO_INTERFACE_NUM     3
// bus
`define IO_BUS_WIDTH_ADDR    32  // addr
`define IO_BUS_WIDTH_DATA    32  // data
`define IO_BUS_WIDTH_CTRL    4   // ctrl
`define IO_BUS_WIDTH_STATU   2   // states
// bus_spec
`define IO_BUS_CTRL_WE       0
`define IO_BUS_CTRL_TYPE_B   1
`define IO_BUS_CTRL_TYPE_HB  2 
`define IO_BUS_CTRL_UNSIGNED 3
// bus_write_read
`define IO_CTRL_READ         1'b0    // read
`define IO_CTRL_WRITE        1'b1    // write
// addr_shift
`define IO_CALL_HIGHERADDR   3
`define IO_CALL_LOWERADDR    2 
`define IO_CALL_WIDTH        `IO_CALL_HIGHERADDR - `IO_CALL_LOWERADDR + 1
`define IO_CALL_CTRL         2'b00    // ctrl
`define IO_CALL_INOUT        2'b01    // data_trans
`define IO_CALL_STATU        2'b10    // states
// peripherals
`define DEVICE_NUM_LED       24
`define DEVICE_NUM_SWITCH    24
`define DEVICE_NUM_NUMLED    8
`define DEVICE_NUM_NUMLED_EN 8
`define DEVICE_NUM_KB_ROW    4
`define DEVICE_NUM_KB_COL    4
