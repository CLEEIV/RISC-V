# RISC-V

#### 工程結構
Top.v
  - CLK_Gen (Vivado IP : Clocking Wizard)
  - RISCV
    - CTRL
    - IF
      - NPC
      - PC
      - ROM
        - instr_pool (Vivado IP : Distributed Memory Generator)
    - ID
      - RegFile
      - ImmGen
      - ALUop
    - EX
      - ALU
      - COMP
    - MEM
      - RAM
        - data_pool (Vivado IP : Distributed Memory Generator)
    - WB
