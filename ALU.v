module ALU(
    input         [31:0]  ALU_A,
    input         [31:0]  ALU_B,
    input         [3:0]   ALU_sel,
    
    output   reg  [31:0]  ALU_C,
    output   reg          outputBranch
    );
    
    wire            subsel;
    wire    [1:0]   shiftSel;
    wire    [1:0]   logicSel;
    wire    [1:0]   ALUop_sel;    
    
    reg     [31:0]  outputAdder;
    reg     [31:0]  outputLogic;
    wire    [31:0]  outputShift;
    
    ALU_decoder U_decoder(
        .ALU_sel(ALU_sel),
        .subsel(subsel),
        .logicSel(logicSel),
        .shiftSel(shiftSel),
        .ALUop_sel(ALUop_sel)
    );
    
    always @ (*) begin
        case(ALUop_sel)
            2'b00:  ALU_C = outputAdder;
            2'b01:  ALU_C = outputLogic;
            2'b10:  ALU_C = outputShift;
            2'b11:  ALU_C = ALU_B;          // lui
            default outputAdder = 32'b0;
        endcase
    end    
    
    // Adder:
    always @ (*) begin
        case(subsel)
            1'b0:    outputAdder = ALU_A + ALU_B;
            1'b1:    outputAdder = ALU_A + ~ALU_B + 1;
            default  outputAdder = 32'b0;
        endcase
    end
    
    // Logic:
    always @ (*) begin
        case(logicSel)      // 01:AND,10:OR,11:XOR
            2'b01:   outputLogic = ALU_A & ALU_B;
            2'b10:   outputLogic = ALU_A | ALU_B;
            2'b11:   outputLogic = ALU_A ^ ALU_B;
            default  outputLogic = 32'b0;
        endcase
    end
    
    // Shifter:
    barrelshifter U_Shifter(
        .shiftSel   (shiftSel)   ,
        .alu_a      (ALU_A)      ,
        .alu_b      (ALU_B)      ,
        .outputShift(outputShift)
    );

    reg [31:0] cmp_num;
    // branch
    always @(*) begin
        cmp_num = ALU_A + ~ALU_B + 1;
        case (ALU_sel)
            4'b1001:  begin     // BEQ
                if (cmp_num[30:0] != 'd0)   outputBranch = 1'b0;
                else                        outputBranch = 1'b1;
            end
            4'b1010: begin      // BNE
                if (cmp_num[30:0] != 'd0)   outputBranch = 1'b1;
                else                        outputBranch = 1'b0;
            end
            4'b1011: begin      // BLT
                if (cmp_num[30:0] == 'd0)   outputBranch = 1'b0;
                else if (cmp_num[31])       outputBranch = 1'b1;
                else                        outputBranch = 1'b0;
            end
            4'b1100: begin      // BGE
                if (cmp_num[30:0] == 'd0)   outputBranch = 1'b1;
                else if (cmp_num[31])       outputBranch = 1'b0;
                else                        outputBranch = 1'b1;
            end
            4'b1101: begin      // JAL
                outputBranch = 1'b1;
            end
            4'b1110: begin      // JALR
                outputBranch = 1'b1;
            end
            default: outputBranch = 1'b0;
        endcase
    end

endmodule
