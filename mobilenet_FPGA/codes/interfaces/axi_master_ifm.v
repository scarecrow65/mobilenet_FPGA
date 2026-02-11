module axi_master_ifm (
    input  wire clk,
    input  wire rst_n,

    input  wire start_read,
    input  wire [31:0] base_addr,

    output wire [31:0] araddr,
    output wire        arvalid,
    input  wire        arready,

    input  wire [63:0] rdata,
    input  wire        rvalid,
    output wire        rready
);

endmodule