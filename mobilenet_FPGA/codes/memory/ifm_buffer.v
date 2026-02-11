module ifm_buffer (
    input  wire clk,
    input  wire rst_n,

    input  wire [63:0] wr_data,
    input  wire        wr_en,
    input  wire [9:0]  wr_addr,

    input  wire [9:0]  rd_addr,
    output wire [63:0] rd_data
);

endmodule