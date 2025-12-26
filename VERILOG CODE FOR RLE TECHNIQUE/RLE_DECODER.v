// RLE_DECODER.v
// Run-Length Decoder: consumes token_value & token_run and outputs repeated 9-bit symbols
module RLE_DECODER(
    input clk,
    input rst,
    input valid_in,             // a token is available when this pulses
    input [8:0] token_value,
    input [7:0] token_run,
    output reg valid_out,
    output reg [8:0] data_out
);
    reg [7:0] rem;
    reg [8:0] curval;

    initial begin
        rem = 8'd0; curval = 9'd0; valid_out = 1'b0; data_out = 9'd0;
    end

    always @(posedge clk) begin
        if (rst) begin
            rem <= 8'd0;
            curval <= 9'd0;
            valid_out <= 1'b0;
            data_out <= 9'd0;
        end else begin
            valid_out <= 1'b0;
            if (rem > 0) begin
                data_out <= curval;
                rem <= rem - 1;
                valid_out <= 1'b1;
            end else if (valid_in && token_run > 0) begin
                curval <= token_value;
                rem <= token_run - 1;
                data_out <= token_value;
                valid_out <= 1'b1;
            end
        end
    end
endmodule


