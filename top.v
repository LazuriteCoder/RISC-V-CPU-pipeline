module top(
    input clk,
    input rst_n,
    output        debug_wb_have_inst,   // WB阶段是否有指令 (对单周期CPU，此flag恒为1)
    output [31:0] debug_wb_pc,          // WB阶段的PC (若wb_have_inst=0，此项可为任意值)
    output        debug_wb_ena,         // WB阶段的寄存器写使能 (若wb_have_inst=0，此项可为任意值)
    output [4:0]  debug_wb_reg,         // WB阶段写入的寄存器号 (若wb_ena或wb_have_inst=0，此项可为任意值)
    output [31:0] debug_wb_value        // WB阶段写入寄存器的值 (若wb_ena或wb_have_inst=0，此项可为任意值)
);


// pipeline wires:
    wire [31:0] if_inst, id_inst, ex_inst;
    wire [31:0] if_pc, id_pc, ex_pc, mem_pc, wb_pc;

    wire        cu_pc_sel;
    wire [1:0]  cu_wd_sel;
    wire        cu_rf_we;
    wire [2:0]  cu_sext_op;
    wire        cu_ALUB_sel;
    wire [3:0]  cu_ALU_sel;
    wire        cu_dram_we;

    wire        ex_pc_sel;
    wire [1:0]  ex_wd_sel, mem_wd_sel, wb_wd_sel;
    wire        ex_rf_we,  mem_rf_we,  wb_rf_we;
    wire        ex_dram_we, mem_dram_we;
    wire [31:0] mem_dram_rd, wb_dram_rd;

    wire        ex_ALUB_sel;
    wire [3:0]  ex_ALU_sel;


    wire [31:0] id_rD1, ex_rD1;
    wire [31:0] id_rD2, ex_rD2, mem_rD2, wb_rD2;
    wire [31:0] id_SEXT_ext, ex_SEXT_ext, mem_SEXT_ext, wb_sext;

    wire [4:0]  id_wR, ex_wR, mem_wR, wb_wR;

    wire [31:0] ex_alu_c, mem_alu_c, wb_alu_c;
    wire [31:0] ex_alu_a, ex_alu_b;

    wire [31:0] wb_wD;

    wire        load_stall, bran_stall;
    wire [1:0]  forward_a, forward_b;

    wire        cu_whi, ex_whi, mem_whi, wb_whi;

    // clk
    wire cpu_clk;
    // wire clk_lock;
    // wire pll_clk;

    wire    alu_bran;
    assign  debug_wb_have_inst = wb_whi;

    assign  debug_wb_pc =  wb_pc;
    assign  debug_wb_ena = wb_rf_we;
    assign  debug_wb_reg = wb_wR;
    assign  debug_wb_value = wb_wD;


    // // clk
    // cpuclk U_CLK_0 (
    //     .clk_in1    (clk),
    //     .locked     (clk_lock),
    //     .clk_out1   (pll_clk)
    // );
    // assign cpu_clk = pll_clk & clk_lock;

    assign  cpu_clk = clk;

    branch_staller U_bran_staller_0 (
        .rst_n(rst_n),
        .ex_opcode(ex_inst[6:0]),
        .bran_stall(bran_stall)
    );

    // IF
    IF U_IF_0 (
        .clk        (cpu_clk)       ,
        .rst_n      (rst_n)         ,
        .pc_sel     (ex_pc_sel)     ,
        .npc_op     (~alu_bran)     ,
        .pipe_pc    (ex_pc)         ,
        .rD1        (ex_alu_a)      ,
        .sext_ext   (ex_SEXT_ext)   ,
        .load_stall (load_stall)    ,
        .branch_stall(bran_stall)   ,
        .pc         (if_pc)         ,
        .inst       (if_inst)
    );

    // IF/ID
    IF_ID U_IF_ID_0 (
        .clk        (cpu_clk)       ,
        .rst_n      (rst_n)         ,
        .load_stall (load_stall)    ,
        .branch_stall(bran_stall)   ,
        .if_pc      (if_pc)         ,
        .if_inst    (if_inst)       ,
        .id_pc      (id_pc)         ,
        .id_inst    (id_inst)
    );

    // ID
    ID U_ID_0 (
        .clk        (cpu_clk)       ,
        .rst_n      (rst_n)         ,
        .inst       (id_inst[31:7]) ,
        .rf_we      (wb_rf_we)      ,
        .sext_op    (cu_sext_op)    ,
        .RF_rD1     (id_rD1)        ,
        .RF_rD2     (id_rD2)        ,
        .SEXT_ext   (id_SEXT_ext)   ,
        .id_wR      (id_wR)         ,
        .wR         (wb_wR)         ,
        .wD         (wb_wD)
    );


    // CU
    CU U_CU_0 (
        .rst_n      (rst_n)         ,
        .inst       (id_inst)       ,
        .alu_bran   (alu_bran)      ,
        .pc_sel     (cu_pc_sel)     ,
        .wd_sel     (cu_wd_sel)     ,
        .rf_we      (cu_rf_we)      ,
        .sext_op    (cu_sext_op)    ,
        .ALUB_sel   (cu_ALUB_sel)   ,
        .ALU_sel    (cu_ALU_sel)    ,
        .dram_we    (cu_dram_we)    ,
        .cu_whi     (cu_whi)
    );

    // harzard detect
    hazard_detection_unit U_haz_dect_0 (
        .id_opcode  (id_inst[6:0])  ,
        .ex_opcode  (ex_inst[6:0])  ,
        .ex_wR      (ex_wR)         ,
        .id_rs1     (id_inst[19:15]),
        .id_rs2     (id_inst[24:20]),
        .load_stall (load_stall)
    );

    // ID/EX
    ID_EX U_ID_EX_0 (
        .clk        (cpu_clk)       ,
        .rst_n      (rst_n)         ,
        .stall      (load_stall || bran_stall),
        .cu_pc_sel  (cu_pc_sel)     ,
        .cu_wd_sel  (cu_wd_sel)     ,
        .cu_rf_we   (cu_rf_we)      ,
        .cu_ALUB_sel(cu_ALUB_sel)   ,
        .cu_ALU_sel (cu_ALU_sel)    ,
        .cu_dram_we (cu_dram_we)    ,
        .cu_whi     (cu_whi)        ,
        .ex_pc_sel  (ex_pc_sel)     ,
        .ex_wd_sel  (ex_wd_sel)     ,
        .ex_rf_we   (ex_rf_we)      ,
        .ex_ALUB_sel(ex_ALUB_sel)   ,
        .ex_ALU_sel (ex_ALU_sel)    ,
        .ex_dram_we (ex_dram_we)    ,
        .id_RF_rD1  (id_rD1)        ,
        .id_RF_rD2  (id_rD2)        ,
        .id_SEXT_ext(id_SEXT_ext)   ,
        .id_inst    (id_inst)       ,
        .id_pc      (id_pc)         ,
        .id_wR      (id_wR)         ,
        .ex_RF_rD1  (ex_rD1)        ,
        .ex_RF_rD2  (ex_rD2)        ,
        .ex_SEXT_ext(ex_SEXT_ext)   ,
        .ex_pc      (ex_pc)         ,
        .ex_inst    (ex_inst)       ,
        .ex_wR      (ex_wR)         ,
        .ex_whi     (ex_whi)    
    );

    // forwarding unit
    forwardng_unit U_forw_0 (
        .mem_rf_we  (mem_rf_we)     ,
        .wb_rf_we   (wb_rf_we)      ,
        .alub_sel   (ex_ALUB_sel && !(ex_inst[6:0] == 7'b0100011))   ,
        .ex_rs1     (ex_inst[19:15]),
        .ex_rs2     (ex_inst[24:20]),
        .mem_wR     (mem_wR)        ,
        .wb_wR      (wb_wR)         ,
        .forward_a  (forward_a)     ,
        .forward_b  (forward_b)
    );

    // EX
    EX U_EX_0 (
        .RF_rD1     (ex_rD1)        ,
        .RF_rD2     (ex_rD2)        ,
        .SEXT_ext   (ex_SEXT_ext)   ,
        .mem_alu_c  (mem_alu_c)     ,
        .wb_wD      (wb_wD)         ,
        .ALUB_sel   (ex_ALUB_sel)   ,
        .ALU_sel    (ex_ALU_sel)    ,
        .forward_a  (forward_a)     ,
        .forward_b  (forward_b)     ,
        .alu_bran   (alu_bran)      ,
        .alu_a      (ex_alu_a)      ,
        .alu_b      (ex_alu_b)      ,
        .ALU_C      (ex_alu_c)
    );

    // EX/MEM
    EX_MEM U_EX_MEM_0 (
        .clk        (cpu_clk)       ,
        .rst_n      (rst_n)         ,
        .ex_dram_we (ex_dram_we)    ,
        .ex_rf_we   (ex_rf_we)      ,
        .ex_wd_sel  (ex_wd_sel)     ,
        .ex_pc      (ex_pc)         ,
        .ex_SEXT_ext(ex_SEXT_ext)   ,
        .ex_rD2     (ex_rD2)        ,
        .ex_wR      (ex_wR)         ,
        .ex_alu_c   (ex_alu_c)      ,
        .ex_whi     (ex_whi)        ,
        .forward_b  (forward_b)     ,
        .wb_wD      (wb_wD)         ,
        .mem_dram_we(mem_dram_we)   ,
        .mem_rf_we  (mem_rf_we)     ,
        .mem_wd_sel (mem_wd_sel)    ,
        .mem_wR     (mem_wR)        ,
        .mem_pc     (mem_pc)        ,
        .mem_sext   (mem_SEXT_ext)  ,
        .mem_rD2    (mem_rD2)       ,
        .mem_alu_c  (mem_alu_c)     ,
        .mem_whi    (mem_whi)
    );

    // MEM
    MEM U_dmem_0 (
        .clk        (cpu_clk)       ,
        .addr       (mem_alu_c)     ,
        .dram_we    (mem_dram_we)   ,
        .din        (mem_rD2)       ,
        .ramdout    (mem_dram_rd)
    );

    // MEM/WB
    MEM_WB U_MEM_WB_0 (
        .clk        (cpu_clk)       ,
        .rst_n      (rst_n)         ,
        .mem_rf_we  (mem_rf_we)     ,
        .mem_wd_sel (mem_wd_sel)    ,
        .mem_wR     (mem_wR)        ,
        .mem_pc     (mem_pc)        ,
        .mem_sext   (mem_SEXT_ext)  ,
        .mem_rD2    (mem_rD2)       ,
        .mem_alu_c  (mem_alu_c)     ,
        .mem_dram_rd(mem_dram_rd)   ,
        .mem_whi    (mem_whi)       ,
        .wb_rf_we   (wb_rf_we)      ,
        .wb_wd_sel  (wb_wd_sel)     ,
        .wb_sext    (wb_sext)       ,
        .wb_rD2     (wb_rD2)        ,
        .wb_alu_c   (wb_alu_c)      ,
        .wb_dram_rd (wb_dram_rd)    ,
        .wb_wR      (wb_wR)         ,
        .wb_pc      (wb_pc)         ,
        .wb_whi     (wb_whi)
    );

    // WB
    WB U_WB_0(
        .ALU_C      (wb_alu_c)      ,
        .DRAM_rd    (wb_dram_rd)    ,
        .pc         (wb_pc)         ,
        .wd_sel     (wb_wd_sel)     ,
        .wD         (wb_wD)
    );


endmodule
