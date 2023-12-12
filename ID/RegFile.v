`include "C:/Verilog/RISC-V/RTL/header/header.v"

module RegFile (
    input         clk      ,
    input         rst_n    ,
    input         regs_w_en,
    input  [4:0]  rs1_addr ,
    input  [4:0]  rs2_addr ,
    input  [4:0]  rd_addr  ,
    input  [31:0] rd_data  ,
    output [31:0] rs1_data ,
    output [31:0] rs2_data  
);
//**************************************************//
//---------------- register define -----------------//
//**************************************************//
reg [31:0] regs[31:0];
//**************************************************//
//---------------------- READ ----------------------//
//**************************************************//
assign rs1_data = (rs1_addr == 5'd0) ? 32'd0 : regs[$unsigned(rs1_addr)];
assign rs2_data = (rs2_addr == 5'd0) ? 32'd0 : regs[$unsigned(rs2_addr)];
//**************************************************//
//--------------------- WRITE ----------------------//
//**************************************************//
integer i;
always @(posedge clk or negedge rst_n) begin
    regs[0][31:0] <= 32'd0;
    if (!rst_n) begin
        for (i = 0; i < 32; i = i + 1) begin
            regs[i][31:0] <= 32'd0;
        end
    end
    else if ((regs_w_en == `REGWE_WRITE) && (rd_addr != 5'd0)) begin
        regs[$unsigned(rd_addr)] <= rd_data;
    end
end

endmodule