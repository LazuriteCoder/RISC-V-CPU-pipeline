module ID(
    //clk
    input           clk,
    //reset
    input           rst_n,
    //inst
    input   [31:7]  inst,
    //to WD
    input   [4:0]   wR,
    input   [31:0]  wD,
    //From control unit
    // input   [1:0]   wd_sel,
    input           rf_we,
    input   [2:0]   sext_op,
    
    //output
    output  [31:0]  RF_rD1,
    output  [31:0]  RF_rD2,
    output  [31:0]  SEXT_ext,
    output  [4:0]   id_wR

    );
        
    assign  id_wR = inst[11:7];

    regfile U_RF(
        .clk    (clk)           ,
        .rst_n  (rst_n)         ,
        .rR1    (inst[19:15])   ,
        .rR2    (inst[24:20])   ,
        .wR     (wR)            ,
        .wD     (wD)            ,
        .rf_we  (rf_we)         ,
        .rD1    (RF_rD1)        ,
        .rD2    (RF_rD2)
    );
    
    SEXT U_SEXT(
        .inst       (inst[31:7]),
        .sext_op    (sext_op)   ,
        .ext        (SEXT_ext)
    );
    
endmodule
