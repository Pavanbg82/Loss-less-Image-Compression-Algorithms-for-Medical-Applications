//======================================================
// DPCM ENCODER Corrected & Verified
//======================================================
module DPCM_ENCODER(
    input clk,
    input reset,
    input [7:0] pixel_in,
    input valid_in,
    output reg [7:0] encoded_out,
    output reg valid_out
);
    reg [7:0] prev_pixel;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            prev_pixel  <= 8'd0;
            encoded_out <= 8'd0;
            valid_out   <= 1'b0;
        end else begin
            if (valid_in) begin
                encoded_out <= pixel_in - prev_pixel;  // difference encoding
                prev_pixel  <= pixel_in;
                valid_out   <= 1'b1;
            end else begin
                valid_out <= 1'b0;
            end
        end
    end
endmodule



