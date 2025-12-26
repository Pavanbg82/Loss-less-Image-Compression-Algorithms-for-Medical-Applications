`timescale 1ns/1ps
module tb_huff_codec_synth;
    reg clk, rst, data_valid;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire decoded_valid;

    integer fin, fout, flog;
    integer fenc;       // file handle for encoded output
    integer read_status;
    reg [7:0] expected;

    // Instantiate top-level codec
    huff_top_codec_synth uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .data_valid(data_valid),
        .data_out(data_out),
        .decoded_valid(decoded_valid)
    );

    // Log encoded Huffman stream to file
    always @(posedge clk) begin
        if (uut.encoded_valid) begin
            // Write 16-bit codeword in hex per line
            $fwrite(fenc, "%04h\n", uut.encoded_data);
        end
    end

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // 100 MHz clock
    end

    // Main process
    initial begin
        rst = 1;
        data_valid = 0;
        data_in = 0;
        #20 rst = 0;

        // open input/output files
        fin  = $fopen("pixels_huff_input1.txt", "r");
        fout = $fopen("decoded_output_verify.txt", "w");
        flog = $fopen("verification_log.txt", "w");
        fenc = $fopen("encoded_output.txt", "w");

        if (fenc == 0) begin
            $display("ERROR: Could not open encoded_output.txt for writing!");
            $stop;
        end

        if (fin == 0) begin
            $display("❌ ERROR: pixels_huff_input1.txt not found!");
            $finish;
        end

        // Main input loop
        while (!$feof(fin)) begin
            read_status = $fscanf(fin, "%d\n", expected);

            if (read_status == 1) begin
                data_in = expected;
                data_valid = 1;
                #10;
                data_valid = 0;
                #20; // allow encoder/decoder time to process

                $display("Processing Input = %0d, Decoded Output = %0d", expected, data_out);

                $fwrite(fout, "%0d\n", data_out);
                if (data_out !== expected)
                    $fwrite(flog, "Mismatch: expected %0d, got %0d\n", expected, data_out);
                else
                    $fwrite(flog, "Match: %0d\n", data_out);
            end
        end

        $display("✅ Simulation complete. Check decoded_output_verify.txt, verification_log.txt, and encoded_output.txt.");
        
        // close all files
        $fclose(fin);
        $fclose(fout);
        $fclose(flog);
        $fclose(fenc);
        $stop;
    end
endmodule
