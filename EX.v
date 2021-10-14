module EX(
    input       [31:0]  RF_rD1,
    input       [31:0]  RF_rD2,
    input       [31:0]  SEXT_ext,
    input       [31:0]  mem_alu_c,
    input       [31:0]  wb_wD,
    input               ALUB_sel,
    input       [3:0]   ALU_sel,
    input       [1:0]   forward_a,
    input       [1:0]   forward_b,
    output              alu_bran,
    output  reg [31:0]  alu_a,
    output  reg [31:0]  alu_b,
    output      [31:0]  ALU_C
    );
    
    // reg [31:0] alu_a,alu_b;

    always @(*) begin
        case (forward_a)
            2'b00:   alu_a = RF_rD1;
            2'b01:   alu_a = mem_alu_c;
            2'b10:   alu_a = wb_wD;
            default: alu_a = 32'h0;
        endcase
    end

    always @(*) begin
        if (ALUB_sel) begin
            alu_b = SEXT_ext;
        end
        else begin
            case (forward_b)
                2'b00:   alu_b = RF_rD2;
                2'b01:   alu_b = mem_alu_c;
                2'b10:   alu_b = wb_wD;
                default: alu_b = 32'h0;
            endcase
        end
    end

    //assign alu_b = ALUB_sel ? SEXT_ext : RF_rD2;

    ALU U_ALU(
        .ALU_A(alu_a),
        .ALU_B(alu_b),
        .ALU_sel(ALU_sel),
        .ALU_C(ALU_C),
        .outputBranch(alu_bran)
    );
endmodule
