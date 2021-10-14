module barrelshifter(
    input   [1:0]   shiftSel,
    input   [31:0]  alu_a,
    input   [31:0]  alu_b,
    output  reg [31:0]  outputShift
    );

    reg [31:0] temp;
    reg [4:0]  shifter;
    always @(*) begin
        shifter = alu_b[4:0];
        case(shiftSel)
            //SLL
            2'b01:  begin
                temp = shifter[0] ? {alu_a[30:0],  1'b0   } : alu_a;
                temp = shifter[1] ? { temp[29:0],  2'b00  } : temp;
                temp = shifter[2] ? { temp[27:0],  4'h0   } : temp;
                temp = shifter[3] ? { temp[23:0],  8'h00  } : temp;
                temp = shifter[4] ? { temp[15:0], 16'h0000} : temp;
            end
            //SRL
            2'b10:  begin
                temp = shifter[0] ? { 1'b0   , alu_a[31:1]} : alu_a;
                temp = shifter[1] ? { 2'b00  , temp[31:2] } : temp;
                temp = shifter[2] ? { 4'h0   , temp[31:4] } : temp;
                temp = shifter[3] ? { 8'h00  , temp[31:8] } : temp;
                temp = shifter[4] ? {16'h0000, temp[31:16]} : temp;
            end
            //SRA
            2'b11:  begin
                temp = shifter[0] ? {    alu_a[31]  , alu_a[31:1]} : alu_a;
                temp = shifter[1] ? {{ 2{alu_a[31]}}, temp[31:2] } : temp;
                temp = shifter[2] ? {{ 4{alu_a[31]}}, temp[31:4] } : temp;
                temp = shifter[3] ? {{ 8{alu_a[31]}}, temp[31:8] } : temp;
                temp = shifter[4] ? {{16{alu_a[31]}}, temp[31:16]} : temp;
            end
        endcase
        outputShift = temp;
    end

endmodule
