module ofm_buffer (
    input  wire clk,
    input  wire rst_n,

    input  wire [7:0]  data_in,
    input  wire        wr_en,
    input  wire [9:0]  wr_addr,

    output wire [63:0] axi_out_data
);

endmodule