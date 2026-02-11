module relu6 (
    input  wire signed [31:0] data_in,
    output wire signed [31:0] data_out
);

    // The integer representation of '6.0' in your quantized space.
    // Example: If using Q16.16, this would be 6 << 16.
    parameter signed [31:0] SIX_QUANTIZED = 32'd6; 

    assign data_out = (data_in < 32'sd0)          ? 32'sd0 :         // Lower bound (0)
                      (data_in > SIX_QUANTIZED)   ? SIX_QUANTIZED :  // Upper bound (6)
                                                    data_in;         // Pass through
endmodule