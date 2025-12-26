 // RLE_ENCODER.v
// Run-Length Encoder: input 9-bit symbols, output token_value (9-bit) and token_run (8-bit)
module RLE_ENCODER(
    input clk,
    input rst,
    input flush,             // pulse after last input to force emission of last run
    input valid_in,
    input [8:0] data_in,
    output reg valid_out,
    output reg [8:0] token_value,
    output reg [7:0] token_run
);
    reg [8:0] run_val;
    reg [7:0] run_len;
    reg started;

    initial begin
        run_val = 9'd0; run_len = 8'd0; started = 1'b0; valid_out = 1'b0;
    end

    always @(posedge clk) begin
        if (rst) begin
            run_val <= 9'd0;
            run_len <= 8'd0;
            started <= 1'b0;
            valid_out <= 1'b0;
            token_value <= 9'd0;
            token_run <= 8'd0;
        end else begin
            valid_out <= 1'b0;
            // incoming data
            if (valid_in) begin
                if (!started) begin
                    run_val <= data_in;
                    run_len <= 8'd1;
                    started <= 1'b1;
                end else if (data_in == run_val && run_len != 8'hFF) begin
                    run_len <= run_len + 1;
                end else begin
                    // emit current run
                    token_value <= run_val;
                    token_run <= run_len;
                    valid_out <= 1'b1;
                    // start new run with current symbol
                    run_val <= data_in;
                    run_len <= 8'd1;
                end
            end
            // flush final run when input finished
            else if (flush && started) begin
                token_value <= run_val;
                token_run <= run_len;
                valid_out <= 1'b1;
                started <= 1'b0;
                run_len <= 8'd0;
            end
        end
    end
endmodule

