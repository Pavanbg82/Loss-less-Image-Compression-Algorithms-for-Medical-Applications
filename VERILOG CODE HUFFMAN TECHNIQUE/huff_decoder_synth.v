module huff_decoder_synth (
    input wire clk,
    input wire rst,
    input wire [15:0] encoded_data,
    input wire encoded_valid,
    output reg [7:0] data_out,
    output reg decoded_valid
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 0;
            decoded_valid <= 0;
        end else if (encoded_valid) begin
            case (encoded_data)
                16'b00 : data_out <= 8'd0;
                16'b01 : data_out <= 8'd1;
                16'b10 : data_out <= 8'd2;
                default: data_out <= encoded_data[7:0];
            endcase
            decoded_valid <= 1;
        end else begin
            decoded_valid <= 0;
        end
    end
endmodule
