module MEM_WB(
    input               clk,
    input               rst_n,

    input               mem_rf_we,
    input       [1:0]   mem_wd_sel,
    input       [4:0]   mem_wR,
    input       [31:0]  mem_sext,
    input       [31:0]  mem_rD2,
    input       [31:0]  mem_alu_c,
    input       [31:0]  mem_dram_rd,
    input       [31:0]  mem_pc,
    input               mem_whi,

    output  reg         wb_rf_we,
    output  reg [1:0]   wb_wd_sel,
    output  reg [4:0]   wb_wR,
    output  reg [31:0]  wb_sext,
    output  reg [31:0]  wb_rD2,
    output  reg [31:0]  wb_alu_c,
    output  reg [31:0]  wb_dram_rd,
    output  reg [31:0]  wb_pc,
    output  reg         wb_whi
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     wb_rf_we <= 1'b0;
        else            wb_rf_we <= mem_rf_we;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     wb_wd_sel <= 2'b10;
        else            wb_wd_sel <= mem_wd_sel;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     wb_wR <= 5'b00000;
        else            wb_wR <= mem_wR;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     wb_sext <= 32'b0;
        else            wb_sext <= mem_sext;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     wb_rD2 <= 32'b0;
        else            wb_rD2 <= mem_rD2;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     wb_alu_c <= 32'b0;
        else            wb_alu_c <= mem_alu_c;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     wb_dram_rd <= 32'b0;
        else            wb_dram_rd <= mem_dram_rd;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     wb_pc <= 32'b0;
        else            wb_pc <= mem_pc;
    end


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     wb_whi <= 1'b0;
        else            wb_whi <= mem_whi;
    end


endmodule
