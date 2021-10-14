module IF(
    input               clk     ,
    input               rst_n   ,
    input               pc_sel  ,
    input               npc_op  ,
    input       [31:0]  pipe_pc ,
    input       [31:0]  rD1     ,
    input       [31:0]  sext_ext,
    input               load_stall,
    input               branch_stall,

    output      [31:0]  pc      ,
    //output  wire [31:0] npc     ,
    output      [31:0]  inst
    );

    wire [31:0] npc;

    PC U_pc(
        .clk(clk),
        .rst_n(rst_n),
        .npc(npc),
        .pc(pc)
    );

    NPC U_npc(
        .pc(pc),
        .pipe_pc(pipe_pc),
        .rD1(rD1),
        .sext_ext(sext_ext),
        .npc_op(npc_op),
        .pc_sel(pc_sel),
        .load_stall(load_stall),
        .branch_stall(branch_stall),
        .npc(npc)
    );

    inst_mem U0_irom
    (
        .a   (pc[15:2])    ,
        .spo   (inst)
    );

endmodule
