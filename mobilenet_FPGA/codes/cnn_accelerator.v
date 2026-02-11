module cnn_accelerator (

    input  wire clk,
    input  wire rst_n,

    // Control
    input  wire start,
    output wire done,

    // IFM Stream
    input  wire [63:0] ifm_data,
    input  wire        ifm_valid,
    output wire        ifm_ready,

    // Weight Stream
    input  wire [63:0] weight_data,
    input  wire        weight_valid,
    output wire        weight_ready,

    // OFM Stream
    output wire [63:0] ofm_data,
    output wire        ofm_valid,
    input  wire        ofm_ready
);

endmodule