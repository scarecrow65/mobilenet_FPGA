module mac_unit (
    input  wire clk,
    input  wire rst_n,

    input  wire signed [7:0] data_in,
    input  wire signed [7:0] weight_in,
    input  wire signed [31:0] psum_in,

    output wire signed [31:0] psum_out
);

endmodule