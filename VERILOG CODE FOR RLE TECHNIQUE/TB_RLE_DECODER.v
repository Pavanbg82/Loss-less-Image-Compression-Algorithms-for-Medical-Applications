//======================================================
// Testbench: TB_RLE_DECODER_fixed.v
// Description: Corrected testbench for your RLE_DECODER
//======================================================
`timescale 1ns / 1ps

module TB_RLE_DECODER_fixed;

    reg clk, rst, valid_in;
    reg [8:0] token_value;
    reg [7:0] token_run;

    wire valid_out;
    wire [8:0] data_out;

    integer infile, outfile;
    integer value, run, status;

    // Instantiate your actual RLE_DECODER (matching uploaded module)
    RLE_DECODER dut (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .token_value(token_value),
        .token_run(token_run),
        .valid_out(valid_out),
        .data_out(data_out)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        valid_in = 0;
        token_value = 0;
        token_run = 0;
        #20 rst = 0;

        infile = $fopen("encoded.txt", "r");
        outfile = $fopen("reconstructed.txt", "w");

        if (infile == 0) begin
            $display("ERROR: Cannot open encoded.txt!");
            $finish;
        end
        if (outfile == 0) begin
            $display("ERROR: Cannot create reconstructed.txt!");
            $finish;
        end

        $display("=== RLE Decoding Started ===");

        while (!$feof(infile)) begin
            status = $fscanf(infile, "%d %d\n", value, run);
            @(posedge clk);
            valid_in = 1;
            token_value = value[8:0];
            token_run = run[7:0];
            @(posedge clk);
            valid_in = 0;

            // Wait while decoder expands run
            repeat(run + 2) @(posedge clk);
        end

        $fclose(infile);
        $fclose(outfile);
        $display("=== RLE Decoding Complete ===");
        $finish;
    end

    // Write reconstructed output
    always @(posedge clk) begin
        if (valid_out)
            $fwrite(outfile, "%0d\n", data_out);
    end

endmodule
