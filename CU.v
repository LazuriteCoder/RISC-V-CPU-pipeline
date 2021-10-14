module CU(
    input       [31:0]  inst    ,
    input               rst_n   ,
    input               alu_bran,   // for B-type

    // to IF
    output  reg         pc_sel  ,   // 0: pc + sext(imm); 1:(rs1) + sext
    // to ID
    output  reg [1:0]   wd_sel  ,   // 0: ALU.C; 1: Dram.rd; 2: NPC.npc
    output  reg         rf_we   ,   // enable of rf
    output  reg [2:0]   sext_op ,   // 0: I; 1: S; 2: B; 3: J; 4: U
    // to EX
    output  reg         ALUB_sel,   // 0: RF.rD2; 1: SEXT.ext
    output  reg [3:0]   ALU_sel ,   // ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, BRAN
    // to MEM
    output  reg         dram_we,
    output  reg         cu_whi
    );

    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;

    assign  opcode = inst[6:0];
    assign  funct3 = inst[14:12];
    assign  funct7 = inst[31:25];

    always @(*) begin
        case (opcode)
            7'b0110011:   // R-type
            begin
                cu_whi   = 1'b1;
                pc_sel   = 1'b0;
                wd_sel   = 2'b00;
                rf_we    = 1'b1;
                sext_op  = 3'h0;
                ALUB_sel = 1'b0;
                dram_we  = 1'b0;
                case (funct3)
                    3'b000: // ADD,SUB
                    begin
                        if (!inst[30])   ALU_sel = 4'h0;     // ADD
                        else             ALU_sel = 4'h1;     // SUB
                    end
                    3'b111: // AND
                        ALU_sel = 4'h2;
                    3'b110: // OR
                        ALU_sel = 4'h3;
                    3'b100: // XOR
                        ALU_sel = 4'h4;
                    3'b001: // SLL
                        ALU_sel = 4'h5;
                    3'b101: // SRL,SRA
                        if (inst[30])   ALU_sel = 4'h7;     // SRA
                        else            ALU_sel = 4'h6;     // SRL
                    default: ALU_sel = 4'h0;
                endcase
            end 
            7'b0010011:   // I-type
            begin
                cu_whi   = 1'b1;
                pc_sel   = 1'b0;
                wd_sel   = 2'b00;
                rf_we    = 1'b1;
                sext_op  = 3'h0;
                ALUB_sel = 1'b1;
                dram_we  = 1'b0;
                case (funct3)
                    3'b000: // addi
                        ALU_sel = 4'h0;
                    3'b111: // AND
                        ALU_sel = 4'h2;
                    3'b110: // OR
                        ALU_sel = 4'h3;
                    3'b100: // XOR
                        ALU_sel = 4'h4;
                    3'b001: // SLL
                        ALU_sel = 4'h5;
                    3'b101: // SRL,SRA
                        if (inst[30])   ALU_sel = 4'h7;     // SRA
                        else            ALU_sel = 4'h6;     // SRL
                    default:
                        ALU_sel = 4'h0;
                endcase
            end
            7'b0100011:   // S-type
            begin
                cu_whi   = 1'b1;
                pc_sel   = 1'b0;
                wd_sel   = 2'b00;
                rf_we    = 1'b0;
                sext_op  = 3'h1;
                ALUB_sel = 1'b1;
                dram_we  = 1'b1;
                ALU_sel  = 4'h0;    // ADD
            end
            7'b1100011:   // B-type
            begin
                cu_whi   = 1'b1;
                pc_sel   = 1'b0;
                wd_sel   = 2'b00;
                rf_we    = 1'b0;
                sext_op  = 3'h2;
                ALUB_sel = 1'b0;
                dram_we  = 1'b0;
                case (funct3)
                    3'b000:  ALU_sel = 4'b1001;
                    3'b001:  ALU_sel = 4'b1010;
                    3'b100:  ALU_sel = 4'b1011;
                    3'b101:  ALU_sel = 4'b1100;
                    default: ALU_sel = 4'h0;
                endcase
            end
            7'b1101111:   // J-type
            begin
                cu_whi   = 1'b1;
                pc_sel   = 1'b0;
                wd_sel   = 2'b10;
                rf_we    = 1'b1;
                sext_op  = 3'h3;
                ALUB_sel = 1'b1;
                dram_we  = 1'b0;
                ALU_sel  = 4'hd;
            end
            7'b0110111:   // lui
            begin
                cu_whi   = 1'b1;
                pc_sel   = 1'b0;
                wd_sel   = 2'b00;
                rf_we    = 1'b1;
                sext_op  = 3'h4;
                ALUB_sel = 1'b1;
                dram_we  = 1'b0;
                ALU_sel  = 4'h8;
            end
            7'b1100111:   // jalr
            begin
                cu_whi   = 1'b1;
                pc_sel   = 1'b1;
                wd_sel   = 2'b10;
                rf_we    = 1'b1;
                sext_op  = 3'h0;
                ALUB_sel = 1'b1;
                dram_we  = 1'b0;
                ALU_sel  = 4'he;
            end
            7'b0000011:   // lw
            begin
                cu_whi   = 1'b1;
                pc_sel   = 1'b0;
                wd_sel   = 2'b01;
                rf_we    = 1'b1;
                sext_op  = 3'h0;
                ALUB_sel = 1'b1;
                dram_we  = 1'b0;
                ALU_sel  = 4'h0;
            end
            default: begin
                cu_whi   = 1'b0;
                pc_sel   = 1'b0;
                wd_sel   = 2'b10;
                rf_we    = 1'b0;
                sext_op  = 3'h0;
                ALUB_sel = 1'b0;
                ALU_sel  = 4'h0;
                dram_we  = 1'b0;
            end
        endcase
        // end
    end


endmodule
