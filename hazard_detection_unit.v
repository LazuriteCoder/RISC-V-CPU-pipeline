module hazard_detection_unit(
    input       [6:0]   id_opcode,
    input       [6:0]   ex_opcode,
    input       [4:0]   ex_wR,
    input       [4:0]   id_rs1,
    input       [4:0]   id_rs2,
    output  reg         load_stall
    );

    always @(*) begin
        if (ex_opcode == 7'b0000011) begin
            case (id_opcode)
                7'b0110011: begin   // R-type
                    if ((ex_wR == id_rs1) || (ex_wR == id_rs2)) load_stall = 1'b1;
                    else                                        load_stall = 1'b0;
                end
                7'b0010011: begin   // I-type
                    if (ex_wR == id_rs1)                        load_stall = 1'b1;
                    else                                        load_stall = 1'b0;
                end
                7'b1100111: begin   // jalr
                    if (ex_wR == id_rs1)                        load_stall = 1'b1;
                    else                                        load_stall = 1'b0;
                end
                7'b0100011: begin   // S-type
                    if ((ex_wR == id_rs1) || (ex_wR == id_rs2)) load_stall = 1'b1;
                    else                                        load_stall = 1'b0;
                end
                7'b1100011: begin   // B-type
                    if ((ex_wR == id_rs1) || (ex_wR == id_rs2)) load_stall = 1'b1;
                    else                                        load_stall = 1'b0;
                end
                7'b0110011: load_stall = 1'b0;  // U-type
                7'b1101111: load_stall = 1'b0;  // J-type
                default:    load_stall = 1'b0;
            endcase
        end
        else
            load_stall = 1'b0;
    end
endmodule
