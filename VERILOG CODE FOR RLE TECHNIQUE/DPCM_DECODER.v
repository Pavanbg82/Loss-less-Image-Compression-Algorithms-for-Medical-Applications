//======================================================
// DPCM DECODER  Corrected & Verified
//======================================================
module DPCM_DECODER(
    input clk,
    input reset,
    input [7:0] encoded_in,
    input valid_in,
    output reg [7:0] pixel_out,
    output reg valid_out
);
    reg [7:0] prev_pixel;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            prev_pixel <= 8'd0;
            pixel_out  <= 8'd0;
            valid_out  <= 1'b0;
        end else begin
            if (valid_in) begin
                pixel_out  <= prev_pixel + encoded_in; // reconstruct pixel
                prev_pixel <= prev_pixel + encoded_in;
                valid_out  <= 1'b1;
            end else begin
                valid_out <= 1'b0;
            end
        end
    end
endmodule



