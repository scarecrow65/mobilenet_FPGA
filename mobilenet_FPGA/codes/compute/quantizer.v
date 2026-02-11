module quantizer (
    input  wire clk,
    input  wire rst_n,

    input  wire signed [31:0] data_in,
    input  wire signed [15:0] scale,
    input  wire signed [7:0]  zero_point,

    output reg  signed [7:0]  data_out
);

    // FIX 1: Change to 'wire' because it is driven by a module output
    wire signed [47:0] product_wire;
    
    // Intermediate register to maintain the pipeline stages
    reg signed [47:0] product_reg;
    reg signed [31:0] shifted_result;

    // FIX 2: Move instantiation OUTSIDE the always block
    multiplier_32x16 inst1 (
        .inp1(data_in), 
        .inp2(scale), 
        .out1(product_wire)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product_reg    <= 48'd0;
            shifted_result <= 32'd0;
            data_out       <= 8'd0;
        end else begin
            // Pipeline Step 1: Capture the multiplier output
            product_reg <= product_wire;

            // Pipeline Step 2: Apply shift and add zero_point
            shifted_result <= (product_reg >>> 15) + zero_point;

            // Pipeline Step 3: Saturation logic
            if (shifted_result > 32'sd127)
                data_out <= 8'sd127;
            else if (shifted_result < -32'sd128)
                data_out <= -8'sd128;
            else
                data_out <= shifted_result[7:0];
        end
    end
endmodule