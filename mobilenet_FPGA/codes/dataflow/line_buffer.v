module line_buffer_3x3 #(
    parameter DATA_WIDTH = 16,
    parameter IMG_WIDTH  = 64
)(
    input  wire                     clk,
    input  wire                     rst_n,

    // Input stream
    input  wire [DATA_WIDTH-1:0]    in_pixel,
    input  wire                     in_valid,
    output wire                     in_ready,

    // Output 3x3 window
    output reg  [DATA_WIDTH-1:0]    w00, w01, w02,
    output reg  [DATA_WIDTH-1:0]    w10, w11, w12,
    output reg  [DATA_WIDTH-1:0]    w20, w21, w22,

    output reg                      out_valid,
    input  wire                     out_ready
);


endmodule