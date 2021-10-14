module branch_staller(
    input               rst_n,
    input       [6:0]   ex_opcode,
    output  reg         bran_stall
    );

    always @(*) begin
        if (!rst_n) begin
            bran_stall = 1'b0;
        end
        else begin
            case (ex_opcode)
                7'b1100011: bran_stall = 1'b1;
                7'b1101111: bran_stall = 1'b1;
                7'b1100111: bran_stall = 1'b1;
                default:    bran_stall = 1'b0;
            endcase
        end
    end
endmodule
