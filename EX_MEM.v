module EX_MEM(
    input               clk,
    input               rst_n,
    // from ID/EX.CU
    input               ex_dram_we,
    input               ex_rf_we,
    input       [1:0]   ex_wd_sel,

    // from ID/EX.ID
    input       [31:0]  ex_pc,
    input       [31:0]  ex_SEXT_ext,
    input       [31:0]  ex_rD2,
    input       [4:0]   ex_wR,
    // from EX
    input       [31:0]  ex_alu_c,

    input               ex_whi,

    // forward_unit
    input       [1:0]   forward_b,
    input       [31:0]  wb_wD,

    // to MEM
    output  reg         mem_dram_we,
    output  reg         mem_rf_we,
    output  reg [1:0]   mem_wd_sel,
    output  reg [4:0]   mem_wR,
    output  reg [31:0]  mem_pc,
    output  reg [31:0]  mem_sext,
    output  reg [31:0]  mem_rD2,
    output  reg [31:0]  mem_alu_c,
    output  reg         mem_whi
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     mem_dram_we <= 1'b0;
        else            mem_dram_we <= ex_dram_we;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     mem_rf_we <= 1'b0;
        else            mem_rf_we <= ex_rf_we;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     mem_wd_sel <= 2'b10;
        else            mem_wd_sel <= ex_wd_sel;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     mem_wR <= 5'b0;
        else            mem_wR <= ex_wR;
    end


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     mem_pc <= 32'b0;
        else            mem_pc <= ex_pc;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     mem_sext <= 32'b0;
        else            mem_sext <= ex_SEXT_ext;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     mem_rD2 <= 32'b0;
        else if(forward_b == 2'b10) mem_rD2 <= wb_wD    ;
        else if(forward_b == 2'b01) mem_rD2 <= mem_alu_c;
        else                        mem_rD2 <= ex_rD2  ;
    end


    // always @(posedge clk, posedge rst)
    // begin
    //     if(rst)                     mem_rD2 <= 32'h0    ;
    //     else if(forward_b == 2'b10) mem_rD2 <= wb_wD    ;
    //     else if(forward_b == 2'b01) mem_rD2 <= mem_alu_c;
    //     else                        mem_rD2 <= exe_rD2  ;
    // end


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     mem_alu_c <= 32'b0;
        else            mem_alu_c <= ex_alu_c;
    end


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)     mem_whi <= 1'b0;
        else            mem_whi <= ex_whi;
    end


endmodule
