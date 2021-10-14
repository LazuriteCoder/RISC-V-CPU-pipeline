module ID_EX(
    input               clk,
    input               rst_n,
    input               stall,
    // from CU:
    // to IF:
    input               cu_pc_sel,
    // to ID
    input       [1:0]   cu_wd_sel,
    input               cu_rf_we,
    input       [2:0]   cu_sext_op,
    // to EX
    input               cu_ALUB_sel,
    input       [3:0]   cu_ALU_sel,
    // to MEM
    input               cu_dram_we,
    input               cu_whi,
    // to next pipe-regs:
    // to next IF
    output  reg         ex_pc_sel,
    // to ID
    output  reg [1:0]   ex_wd_sel,
    output  reg         ex_rf_we,
    output  reg [2:0]   ex_sext_op,
    // to EX
    output  reg         ex_ALUB_sel,
    output  reg [3:0]   ex_ALU_sel,
    // to MEM
    output  reg         ex_dram_we,



    // from ID:
    input       [31:0]  id_RF_rD1,
    input       [31:0]  id_RF_rD2,
    input       [31:0]  id_SEXT_ext,
    input       [31:0]  id_inst,
    input       [31:0]  id_pc,
    input       [4:0]   id_wR,
    // to EX:
    output  reg [31:0]  ex_RF_rD1,
    output  reg [31:0]  ex_RF_rD2,
    output  reg [31:0]  ex_SEXT_ext,
    output  reg [31:0]  ex_pc,
    output  reg [31:0]  ex_inst,
    
    output  reg [4:0]   ex_wR,
    output  reg         ex_whi
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     ex_pc_sel <= 1'b0;
        else if (stall) ex_pc_sel <= 1'b0;
        else            ex_pc_sel <= cu_pc_sel;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     ex_wd_sel <= 2'b10;
        else if (stall) ex_wd_sel <= 2'b10;
        else            ex_wd_sel <= cu_wd_sel;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     ex_rf_we <= 1'b0;
        else if (stall) ex_rf_we <= 1'b0;
        else            ex_rf_we <= cu_rf_we;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     ex_sext_op <= 3'b000;
        else if (stall) ex_sext_op <= 3'b000;
        else            ex_sext_op <= cu_sext_op;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     ex_ALUB_sel <= 1'b0;
        else if (stall) ex_ALUB_sel <= 1'b0;
        else            ex_ALUB_sel <= cu_ALUB_sel;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     ex_ALU_sel <= 4'h0;
        else if (stall) ex_ALU_sel <= 4'h0;
        else            ex_ALU_sel <= cu_ALU_sel;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     ex_dram_we <= 4'h0;
        else if (stall) ex_dram_we <= 4'h0;
        else            ex_dram_we <= cu_dram_we;
    end


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     ex_RF_rD1 <= 32'h00000000;
        else if (stall) ex_RF_rD1 <= 32'h00000000;
        else            ex_RF_rD1 <= id_RF_rD1;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     ex_RF_rD2 <= 32'h00000000;
        else if (stall) ex_RF_rD2 <= 32'h00000000;
        else            ex_RF_rD2 <= id_RF_rD2;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     ex_SEXT_ext <= 32'h00000000;
        else if (stall) ex_SEXT_ext <= 32'h00000000;
        else            ex_SEXT_ext <= id_SEXT_ext;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     ex_inst <= 32'h00000000;
        else if (stall) ex_inst <= 32'h00000000;
        else            ex_inst <= id_inst;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     ex_pc <= 32'h00000000;
        else if (stall) ex_pc <= ex_pc;
        else            ex_pc <= id_pc;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     ex_wR <= 5'b0;
        else if (stall) ex_wR <= 5'b0;
        else            ex_wR <= id_wR;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     ex_whi <= 1'b0;
        else if (stall) ex_whi <= 1'b0;
        else            ex_whi <= cu_whi;
    end

endmodule
