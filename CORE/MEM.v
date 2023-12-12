module MEM (
    input         clk        ,
    input         ram_en     ,
    input  [31:0] rs2_data   ,
    input  [31:0] alu_result ,
    input         unsig      ,
    input  [1:0]  mem_ex_type,
    output [31:0] mem_data    
);
//**************************************************//
//---------------- register define -----------------//
//**************************************************//
reg [31:0] mem_data_reg ;
reg [31:0] read_data_reg;
reg [31:0] rs2_data_reg ;
//**************************************************//
//------------------- wire define ------------------//
//**************************************************//
wire        type_b         ;
wire        type_h         ;
wire [31:0] ram_data       ;
wire [31:0] rs2_data_result;
//**************************************************//
//--------------------- ex ctrl --------------------//
//**************************************************//
assign type_b = ~(mem_ex_type[0]  | mem_ex_type[1]);
assign type_h = (~mem_ex_type[1]) | type_b         ;
//**************************************************//
//---------------------- READ ----------------------//
//**************************************************//
always @(*) begin
    case (alu_result[1:0])
        2'b00   : read_data_reg = ram_data;
        2'b01   : read_data_reg = {8'd0 , ram_data[31:8]};
        2'b10   : read_data_reg = {16'd0, ram_data[31:16]};
        default : read_data_reg = {24'd0, ram_data[31:24]};
    endcase
end
always @(*) begin
    mem_data_reg[7:0] = read_data_reg[7:0];
    if (type_b)
        mem_data_reg[15:8] = (unsig) ? 8'd0 : {8{mem_data_reg[7]}};
    else
        mem_data_reg[15:8] = read_data_reg[15:8];
    if (type_h)
        mem_data_reg[31:16] = (unsig) ? 16'd0 : {16{mem_data_reg[15]}};
    else
        mem_data_reg[31:16] = read_data_reg[31:16];
end
//**************************************************//
//--------------------- WRITE ----------------------//
//**************************************************//
always @(*) begin
    rs2_data_reg = ram_data;
    case (alu_result[1:0])
        2'b00   : begin
            rs2_data_reg[7:0]   = rs2_data[7:0];
            rs2_data_reg[15:8]  = (type_b) ? ram_data[15:8]  : rs2_data[15:8];
            rs2_data_reg[31:16] = (type_h) ? ram_data[31:16] : rs2_data[31:16];
        end
        2'b01   : begin
            rs2_data_reg[7:0]   = ram_data[7:0];
            rs2_data_reg[15:8]  = rs2_data[7:0];
            rs2_data_reg[23:16] = (type_b) ? ram_data[23:16] : rs2_data[15:8];
            rs2_data_reg[31:24] = (type_h) ? ram_data[31:24] : rs2_data[23:16];
        end
        2'b10   : begin
            rs2_data_reg[15:0]  = ram_data[15:0];
            rs2_data_reg[23:16] = rs2_data[7:0];
            rs2_data_reg[31:24] = (type_b) ? ram_data[31:24] : rs2_data[15:8];
        end
        default : begin
            rs2_data_reg[23:0]  = ram_data[23:0];
            rs2_data_reg[31:24] = rs2_data[7:0] ;
        end
    endcase
end
//**************************************************//
//------------------- data result ------------------//
//**************************************************//
assign mem_data        = mem_data_reg;
assign rs2_data_result = rs2_data_reg;
//**************************************************//
//---------------------- module --------------------//
//**************************************************//
RAM RAM (
    .clk             ( clk             ),
    .ram_en          ( ram_en          ),
    .rs2_addr        ( alu_result      ),
    .rs2_data_result ( rs2_data_result ),
    .ram_data        ( ram_data        )
);

endmodule