module PC (
    input             clk       ,
    input             rst_n     ,
    input      [31:0] next_pc   ,
    output reg [31:0] current_pc      
);
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        current_pc <= -4;
    else
        current_pc <= next_pc;
end

endmodule