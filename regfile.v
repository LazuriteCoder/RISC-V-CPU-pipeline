module regfile(
    input               clk     ,
    input               rst_n   ,
    input       [4:0]   rR1     ,
    input       [4:0]   rR2     ,
    input       [4:0]   wR      ,
    input       [31:0]  wD      ,
    input               rf_we   ,
    
    output      [31:0]  rD1    ,
    output      [31:0]  rD2
    );
    

    reg [31:0]  register[1:31];

    // 组合读
    assign  rD1 = (rR1 == 'd0) ? 0 : register[rR1];
    assign  rD2 = (rR2 == 'd0) ? 0 : register[rR2];
    
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            register[1] = 32'h0;
            register[2] = 32'h0;
            register[3] = 32'h0;
            register[4] = 32'h0;
            register[5] = 32'h0;
            register[6] = 32'h0;
            register[7] = 32'h0;
            register[8] = 32'h0;
            register[9] = 32'h0;
            register[10] = 32'h0;
            register[11] = 32'h0;
            register[12] = 32'h0;
            register[13] = 32'h0;
            register[14] = 32'h0;
            register[15] = 32'h0;
            register[16] = 32'h0;
            register[17] = 32'h0;
            register[18] = 32'h0;
            register[19] = 32'h0;
            register[20] = 32'h0;
            register[21] = 32'h0;
            register[22] = 32'h0;
            register[23] = 32'h0;
            register[24] = 32'h0;
            register[25] = 32'h0;
            register[26] = 32'h0;
            register[27] = 32'h0;
            register[28] = 32'h0;
            register[29] = 32'h0;
            register[30] = 32'h0;
            register[31] = 32'h0;
        end
        else if(rf_we) begin
            register[wR] = wD;
        end
    end
    
endmodule
