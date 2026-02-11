module sliding_window (
    input  wire clk,
    input  wire rst_n,

    input  wire [7:0] row0,
    input  wire [7:0] row1,
    input  wire [7:0] row2,
    input  wire       valid_in,

    output wire [8*9-1:0] window_out,
    output wire           valid_out
);

endmodule