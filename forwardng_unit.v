module forwardng_unit(
    input               mem_rf_we,
    input               wb_rf_we,
    input               alub_sel,
    input       [4:0]   ex_rs1,
    input       [4:0]   ex_rs2,
    input       [4:0]   mem_wR,
    input       [4:0]   wb_wR,
    output  reg [1:0]   forward_a,
    output  reg [1:0]   forward_b
    );

    always @(*) begin
        if (mem_rf_we && mem_wR && (ex_rs1 == mem_wR)) begin
            forward_a = 2'b01;
        end
        else if (wb_rf_we && wb_wR && (ex_rs1 == wb_wR)) begin
            forward_a = 2'b10;
        end
        else
            forward_a = 2'b00;
    end

    always @(*) begin
        if (mem_rf_we && mem_wR && (ex_rs2 == mem_wR) && ~alub_sel) begin
            forward_b = 2'b01;
        end
        else if (wb_rf_we && wb_wR && (ex_rs2 == wb_wR) && ~alub_sel) begin
            forward_b = 2'b10;
        end
        else
            forward_b = 2'b00;
    end


endmodule
