module WB(
    input       [31:0]  ALU_C,
    input       [31:0]  DRAM_rd,
    input       [31:0]  pc,
    input       [1:0]   wd_sel,
    output  reg [31:0]  wD    
    );

    always @ (*) begin
        case(wd_sel)
            2'b00:  wD = ALU_C;
            2'b01:  wD = DRAM_rd;
            2'b10:  wD = pc+4;
            default wD = 32'b0;
        endcase
    end

endmodule
