module top (

    // Clock & Reset
    input  wire clk,
    input  wire rst_n,

    // AXI4-Lite Control Interface (from ARM)
    input  wire [31:0] s_axi_awaddr,
    input  wire        s_axi_awvalid,
    output wire        s_axi_awready,
    input  wire [31:0] s_axi_wdata,
    input  wire        s_axi_wvalid,
    output wire        s_axi_wready,
    output wire [1:0]  s_axi_bresp,
    output wire        s_axi_bvalid,
    input  wire        s_axi_bready,
    input  wire [31:0] s_axi_araddr,
    input  wire        s_axi_arvalid,
    output wire        s_axi_arready,
    output wire [31:0] s_axi_rdata,
    output wire [1:0]  s_axi_rresp,
    output wire        s_axi_rvalid,
    input  wire        s_axi_rready,

    // AXI Master Ports to DDR
    // IFM
    output wire [31:0] m_axi_ifm_araddr,
    output wire        m_axi_ifm_arvalid,
    input  wire        m_axi_ifm_arready,
    input  wire [63:0] m_axi_ifm_rdata,
    input  wire        m_axi_ifm_rvalid,
    output wire        m_axi_ifm_rready,

    // WEIGHTS
    output wire [31:0] m_axi_wgt_araddr,
    output wire        m_axi_wgt_arvalid,
    input  wire        m_axi_wgt_arready,
    input  wire [63:0] m_axi_wgt_rdata,
    input  wire        m_axi_wgt_rvalid,
    output wire        m_axi_wgt_rready,

    // OFM
    output wire [31:0] m_axi_ofm_awaddr,
    output wire        m_axi_ofm_awvalid,
    input  wire        m_axi_ofm_awready,
    output wire [63:0] m_axi_ofm_wdata,
    output wire        m_axi_ofm_wvalid,
    input  wire        m_axi_ofm_wready
);

endmodule
