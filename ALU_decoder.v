module ALU_decoder(
    input       [3:0] ALU_sel,
    output  reg       subsel,
    //output  reg       CarryIn,
    output  reg [1:0] shiftSel,
    output  reg [1:0] logicSel,
    output  reg [1:0] ALUop_sel
    );
    
    localparam  ADD  = 4'b0000;
    localparam  SUB  = 4'b0001;
    localparam  AND  = 4'b0010;
    localparam  OR   = 4'b0011;
    localparam  XOR  = 4'b0100;
    localparam  SLL  = 4'b0101;
    localparam  SRL  = 4'b0110;
    localparam  SRA  = 4'b0111;
    localparam  LUI  = 4'b1000;
    localparam  BEQ  = 4'b1001;
    localparam  BNE  = 4'b1010;
    localparam  BLT  = 4'b1011;
    localparam  BGE  = 4'b1100;
    localparam  JAL  = 4'b1101;
    localparam  JALR = 4'b1110;

always @ (*) begin
    case(ALU_sel)
        ADD: begin
            subsel    = 1'b0;
            shiftSel  = 2'b00;
            logicSel  = 2'b00;
            ALUop_sel = 2'b00;
        end
        SUB: begin
            subsel    = 1'b1;
            shiftSel  = 2'b00;
            logicSel  = 2'b00;
            ALUop_sel = 2'b00;
        end
        AND: begin
            subsel    = 1'b0;
            shiftSel  = 2'b00;
            logicSel  = 2'b01;
            ALUop_sel = 2'b01;
        end
        OR:  begin
            subsel    = 1'b0;
            shiftSel  = 2'b00;
            logicSel  = 2'b10;
            ALUop_sel = 2'b01;
        end
        XOR: begin
            subsel    = 1'b0;
            shiftSel  = 2'b00;
            logicSel  = 2'b11;
            ALUop_sel = 2'b01;
        end
        SLL: begin
            subsel    = 1'b0;
            shiftSel  = 2'b01;
            logicSel  = 2'b00;
            ALUop_sel = 2'b10;
        end
        SRL: begin
            subsel    = 1'b0;
            shiftSel  = 2'b10;
            logicSel  = 2'b00;
            ALUop_sel = 2'b10;
        end
        SRA: begin
            subsel    = 1'b0;
            shiftSel  = 2'b11;
            logicSel  = 2'b00;
            ALUop_sel = 2'b10;
        end
        LUI: begin
            subsel    = 1'b0;
            shiftSel  = 2'b00;
            logicSel  = 2'b00;
            ALUop_sel = 2'b11;
        end
        default: begin
            subsel    = 1'b1;
            shiftSel  = 2'b00;
            logicSel  = 2'b00;
            ALUop_sel = 2'b00;
        end
    endcase
end

    
endmodule
