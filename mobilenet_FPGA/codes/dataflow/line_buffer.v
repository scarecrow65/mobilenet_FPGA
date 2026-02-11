module line_buffer #(
    parameter WIDTH = 416
)(
    input  wire clk,
    input  wire rst_n,

    input  wire [7:0] pixel_in,
    input  wire       valid_in,

    output wire [7:0] row0,
    output wire [7:0] row1,
    output wire [7:0] row2
);

endmodule