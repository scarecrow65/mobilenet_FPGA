module mac_array #(
    parameter PAR = 16
)(
    input  wire clk,
    input  wire rst_n,

    input  wire signed [PAR*8-1:0] data_vec,
    input  wire signed [PAR*8-1:0] weight_vec,
    input  wire signed [31:0] psum_in,

    output wire signed [PAR*32-1:0] mac_out
);

endmodule