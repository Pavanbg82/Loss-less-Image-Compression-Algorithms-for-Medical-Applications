`timescale 1ns/1ps
// File-to-file verifier without tasks or 'break' (pure Verilog-2001 compatible)
module verify_tb_huffman;

    integer orig_file, dec_file, log_file;
    integer orig_pix, dec_pix;
    integer rs1, rs2;
    integer total, match, mismatch, extra_orig, extra_dec;
    real    accuracy;
    reg     done;

    initial begin
        total = 0; match = 0; mismatch = 0; extra_orig = 0; extra_dec = 0; accuracy = 0.0; done = 0;

        // Match your project filenames
        orig_file = $fopen("pixels_huff_input1.txt", "r");      // original inputs
        dec_file  = $fopen("decoded_output_verify.txt", "r");   // decoder outputs
        log_file  = $fopen("verification_mismatches.txt", "w");

        if (orig_file == 0) begin
            $display("ERROR: Could not open pixels_huff_input1.txt"); $finish;
        end
        if (dec_file == 0) begin
            $display("ERROR: Could not open decoded_output_verify.txt"); $finish;
        end
        if (log_file == 0) begin
            $display("ERROR: Could not open verification_mismatches.txt"); $finish;
        end

        // Compare line-by-line; exit conditions handled without 'break'
        while (!done) begin
            rs1 = $fscanf(orig_file, "%d\n", orig_pix);
            rs2 = $fscanf(dec_file,  "%d\n", dec_pix);

            if (rs1 == 1 && rs2 == 1) begin
                total = total + 1;
                if (dec_pix === orig_pix) begin
                    match = match + 1;
                end else begin
                    mismatch = mismatch + 1;
                    $fwrite(log_file, "Mismatch @%0d: expected=%0d got=%0d\n", total, orig_pix, dec_pix);
                end
            end
            else if (rs1 == 1 && rs2 != 1) begin
                // decoded file ended early ? count remaining originals
                extra_orig = extra_orig + 1;
                while ($fscanf(orig_file, "%d\n", orig_pix) == 1)
                    extra_orig = extra_orig + 1;
                done = 1;
            end
            else if (rs1 != 1 && rs2 == 1) begin
                // decoded file has extra values
                extra_dec = extra_dec + 1;
                while ($fscanf(dec_file, "%d\n", dec_pix) == 1)
                    extra_dec = extra_dec + 1;
                done = 1;
            end
            else begin
                // both files ended
                done = 1;
            end
        end

        if (total > 0) accuracy = (match * 100.0) / total;

        $display("\n=============================================");
        $display("         Huffman Verification Report         ");
        $display("=============================================");
        $display(" Total Compared          : %0d", total);
        $display(" Matches                 : %0d", match);
        $display(" Mismatches              : %0d", mismatch);
        $display(" Accuracy                : %0.2f %%", accuracy);
        $display("=============================================\n");
        $fclose(orig_file);
        $fclose(dec_file);
        $fclose(log_file);
        #10 $finish;
    end

endmodule
