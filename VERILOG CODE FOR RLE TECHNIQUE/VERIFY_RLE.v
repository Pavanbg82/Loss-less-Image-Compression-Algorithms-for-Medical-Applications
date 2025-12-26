`timescale 1ns / 1ps
module VERIFY_RLE;

    integer orig_file, dec_file;
    integer orig_pix, dec_pix;
    integer total, match, mismatch;
    real accuracy;

    initial begin
        orig_file = $fopen("pixels.txt", "r");
        dec_file  = $fopen("reconstructed.txt", "r");

        if (orig_file == 0 || dec_file == 0) begin
            $display("Error: Missing input or decoded file!");
            $finish;
        end

        total = 0;
        match = 0;
        mismatch = 0;

        while (!$feof(orig_file) && !$feof(dec_file)) begin
            $fscanf(orig_file, "%d\n", orig_pix);
            $fscanf(dec_file, "%d\n", dec_pix);
            total = total + 1;

            if (orig_pix == dec_pix)
                match = match + 1;
            else
                mismatch = mismatch + 1;
        end

        if (total > 0)
            accuracy = (match * 100.0) / total;
        else
            accuracy = 0.0;

        $display("=============================================");
        $display("  COMBINED RLE+DPCM Report");
        $display("=============================================");
        $display(" Total Pixels Compared  : %0d", total);
        $display(" Matching Pixels        : %0d", match);
        $display(" Mismatched Pixels      : %0d", mismatch);
        $display(" Verification Accuracy  : %0.2f %%", accuracy);
        $display("=============================================");

        $fclose(orig_file);
        $fclose(dec_file);
        #10 $finish;
    end

endmodule



