module TB_FULL_PIPELINE_FILE;

    reg clk, rst;
    reg valid_in;
    reg [7:0] pixel_in;

    wire [7:0] dpcm_out;
    wire       dpcm_valid;

    wire       rle_valid_out;
    wire [8:0] rle_token_value;
    wire [7:0] rle_token_run;
    reg        flush;

    wire       rle_dec_valid;
    wire [8:0] rle_dec_pixel;

    wire       final_valid;
    wire [7:0] final_pixel;

    integer infile, outfile, pixel, status;


    // CLOCK
    always #5 clk = ~clk;


    // --------------------------------------------
    // DPCM ENCODER
    // --------------------------------------------
    DPCM_ENCODER DPCM_E (
        .clk(clk),
        .reset(rst),
        .pixel_in(pixel_in),
        .valid_in(valid_in),
        .encoded_out(dpcm_out),
        .valid_out(dpcm_valid)
    );


    // --------------------------------------------
    // RLE ENCODER
    // --------------------------------------------
    RLE_ENCODER RLE_E (
        .clk(clk),
        .rst(rst),
        .flush(flush),
        .valid_in(dpcm_valid),
        .data_in({1'b0, dpcm_out}),   // 9-bit input
        .valid_out(rle_valid_out),
        .token_value(rle_token_value),
        .token_run(rle_token_run)
    );


    // --------------------------------------------
    // RLE DECODER
    // --------------------------------------------
    RLE_DECODER RLE_D (
        .clk(clk),
        .rst(rst),
        .valid_in(rle_valid_out),
        .token_value(rle_token_value),
        .token_run(rle_token_run),
        .valid_out(rle_dec_valid),
        .data_out(rle_dec_pixel)
    );


    // --------------------------------------------
    // DPCM DECODER
    // --------------------------------------------
    DPCM_DECODER DPCM_D (
        .clk(clk),
        .reset(rst),
        .encoded_in(rle_dec_pixel[7:0]),
        .valid_in(rle_dec_valid),
        .pixel_out(final_pixel),
        .valid_out(final_valid)
    );


    // --------------------------------------------
    // FILE I/O
    // --------------------------------------------
    initial begin
        clk = 0;
        rst = 1;
        valid_in = 0;
        pixel_in = 0;
        flush = 0;

        #20 rst = 0;

        infile  = $fopen("pixels.txt", "r");
        outfile = $fopen("reconstructed.txt", "w");

        if (infile == 0) begin
            $display("ERROR: Cannot open pixels.txt");
            $finish;
        end

        while (!$feof(infile)) begin
            status = $fscanf(infile, "%d\n", pixel);
            @(posedge clk);
            pixel_in = pixel[7:0];
            valid_in = 1;
        end

        @(posedge clk);
        valid_in = 0;

        flush = 1;
        @(posedge clk);
        flush = 0;

        repeat(2000) @(posedge clk);

        $fclose(infile);
        $fclose(outfile);

        $display("=== PROCESSING DONE ===");
        $finish;
    end


    // Write output file
    always @(posedge clk) begin
        if (final_valid)
            $fwrite(outfile, "%0d\n", final_pixel);
    end

endmodule
