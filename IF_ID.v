module IF_ID(
    input               clk     ,
    input               rst_n   ,
    input               load_stall,
    input               branch_stall,
    input       [31:0]  if_pc   ,
    input       [31:0]  if_inst ,
    output  reg [31:0]  id_pc   ,
    output  reg [31:0]  id_inst
    );

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n)             id_pc <= 32'hffff_fffc;
        else if (branch_stall)  id_pc <= id_pc;
        else if (load_stall)    id_pc <= id_pc;
        else                    id_pc <= if_pc; 
    end

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n)             id_inst <= 32'h00000000;
        else if (branch_stall)  id_inst <= 32'h00000000;
        else if (load_stall)    id_inst <= id_inst;
        else                    id_inst <= if_inst;
    end

endmodule
