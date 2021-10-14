module MEM(
    input           clk,
    input   [31:0]  addr,  // addr
    input   [31:0]  din, // din
    input           dram_we,

    output  [31:0]  ramdout
    );

wire    ram_clk = ~clk;

// dram U_dram (
//   .a(addr[17:2]),      // input wire [13 : 0] a
//   .d(rf_rd2),           // input wire [31 : 0] d
//   .clk(ram_clk),            // input wire clk
//   .we(dram_we),         // input wire we
//   .spo(dram_out)        // output wire [31 : 0] spo
// );
data_mem U_dram (
  .clk    (ram_clk)    ,     // input wire clka
  .a      (addr[17:2]) ,     // input wire [15:0] addra
  .spo    (ramdout)    ,     // output wire [31:0] douta
  .we     (dram_we)    ,     // input wire [0:0] wea
  .d      (din)              // input wire [31:0] dina
);


endmodule
