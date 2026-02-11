module quantizer (
    input  wire clk,
    input  wire rst_n,

    input  wire signed [31:0] data_in,
    input  wire signed [15:0] scale,
    input  wire signed [7:0]  zero_point,

    output wire signed [7:0] data_out
);

endmodule