module RAM (
    input         clk            ,
    input         ram_en         ,
    input  [31:0] rs2_addr       ,
    input  [31:0] rs2_data_result,
    output [31:0] ram_data        
);
//**************************************************//
//---------------------- module --------------------//
//**************************************************//
data_pool data_pool (
    .clk  ( clk             ),
    .we   ( ram_en          ),
    .a    ( rs2_addr[15:2]  ),
    .d    ( rs2_data_result ),
    .spo  ( ram_data        )
);

endmodule
