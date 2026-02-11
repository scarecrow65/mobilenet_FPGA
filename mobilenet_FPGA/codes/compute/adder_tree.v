module adder_tree #(
    parameter PAR = 16
)(
    input  wire clk,
    input  wire rst_n,

    input  wire signed [PAR*32-1:0] in_vec,
    input  wire valid_in,

    output wire signed [31:0] sum_out,
    output wire valid_out
);


endmodule