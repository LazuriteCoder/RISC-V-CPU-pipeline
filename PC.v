module PC(
    input               clk,
    input               rst_n,
    input       [31:0]  npc,
    output  reg [31:0]  pc
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     pc <= 32'hffff_fffc;
        else            pc <= npc;
    end


endmodule
