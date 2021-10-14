module SEXT(
    input           [31:7]  inst,
    input           [ 2:0]  sext_op,
    output  reg     [31:0]  ext
    );
    
    always @(*) begin
        case(sext_op)
            3'b000:     //I-type
                ext = {{20{inst[31]}}, inst[31:20]};
            3'b001:     //S-type
                ext = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            3'b010:     //B-type
                ext = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
            3'b011:     //J-type
                ext = {{12{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
            3'b100:     //U-type
                ext = {inst[31:12], 12'h0000};
            default: ext = 32'b00000000;
        endcase
    end

endmodule
