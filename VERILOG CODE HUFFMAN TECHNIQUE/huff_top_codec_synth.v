module huff_top_codec_synth (
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    input wire data_valid,
    output wire [7:0] data_out,
    output wire decoded_valid
);
    wire [15:0] encoded_data;
    wire encoded_valid;

    huff_encoder_synth u_encoder (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .data_valid(data_valid),
        .encoded_data(encoded_data),
        .encoded_valid(encoded_valid)
    );

    huff_decoder_synth u_decoder (
        .clk(clk),
        .rst(rst),
        .encoded_data(encoded_data),
        .encoded_valid(encoded_valid),
        .data_out(data_out),
        .decoded_valid(decoded_valid)
    );
endmodule
