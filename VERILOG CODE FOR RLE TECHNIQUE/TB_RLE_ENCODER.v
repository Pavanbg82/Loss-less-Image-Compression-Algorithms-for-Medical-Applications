//======================================================
// Testbench: TB_RLE_ENCODER.v
// Description: Testbench for RLE Encoder (9-bit input)
//======================================================
`timescale 1ns / 1ps

module TB_RLE_ENCODER;

    reg clk, rst, valid_in, flush;
    reg [8:0] data_in;

    wire valid_out;
    wire [8:0] token_value;
    wire [7:0] token_run;

    integer infile, outfile;
    integer value, status;

    // Instantiate DUT
    RLE_ENCODER dut (
        .clk(clk),
        .rst(rst),
        .flush(flush),
        .valid_in(valid_in),
        .data_in(data_in),
        .valid_out(valid_out),
        .token_value(token_value),
        .token_run(token_run)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1; valid_in = 0; flush = 0; data_in = 0;
        #20; rst = 0;

        infile = $fopen("pixels.txt", "r");
        outfile = $fopen("encoded.txt", "w");

        if (infile == 0) begin
            $display("ERROR: Cannot open pixels.txt!");
            $finish;
        end
        if (outfile == 0) begin
            $display("ERROR: Cannot create encoded.txt!");
            $finish;
        end

        $display("=== RLE Encoding Started ===");

        while (!$feof(infile)) begin
            status = $fscanf(infile, "%d\n", value);
            @(posedge clk);
            valid_in = 1;
            data_in = value[8:0];
        end

        @(posedge clk);
        valid_in = 0;
        flush = 1;
        @(posedge clk);
        flush = 0;

        $display("Waiting for encoder flush...");
        repeat(10) @(posedge clk);

        $display("Encoding Complete! Writing tokens...");
        $fclose(infile);
        $fclose(outfile);
        $finish;
    end

    // Write encoded output
    always @(posedge clk) begin
        if (valid_out)
            $fwrite(outfile, "%0d %0d\n", token_value, token_run);
    end

endmodule
