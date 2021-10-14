module NPC(
    input   [31:0]  pc,
    input   [31:0]  pipe_pc,
    input   [31:0]  rD1,
    input   [31:0]  sext_ext,
    input           npc_op,     // 0:sext, 1:pc+4
    input           pc_sel,     // 0:pc+sext; 1:(rs1)+sext
    input           load_stall,
    input           branch_stall,
    output  reg [31:0]  npc
    );


    always @(*) begin
        if (load_stall)         npc = pc;
        else if (branch_stall)  npc = npc_op ? pipe_pc + 4 : (pc_sel ? (rD1 + sext_ext) : (pipe_pc + sext_ext));
        else                    npc = pc + 4;
    end

endmodule