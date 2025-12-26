clc; clear; close all;
fprintf('\n=== MRI COMPRESSION FULL ANALYSIS (RLE vs HUFFMAN) ===\n');

% ==============================================================
% STEP 1 — Auto path setup
% ==============================================================
base = pwd;  % current MATLAB Drive folder

rle_input   = fullfile(base,'myp.jpeg');
rle_output  = fullfile(base,'reconstructed_image by  RLE.png');
huf_input   = fullfile(base,'myp.jpeg');
huf_output  = fullfile(base,'reconstructed_image by hufsche.png');

rle_encoded_file  = fullfile(base,'encoded.txt');
huff_encoded_file = fullfile(base,'encoded_output.txt');

rle_bin_file  = fullfile(base,'rle_encoded_output.bin');
huff_bin_file = fullfile(base,'huffman_encoded_output.bin');

files = {rle_input,rle_output,huf_input,huf_output,rle_encoded_file,huff_encoded_file};
for i=1:length(files)
    if ~isfile(files{i})
        error('❌ Missing file: %s', files{i});
    end
end

% ==============================================================
% STEP 2 — Read and prepare images
% ==============================================================
orig_rle = im2double(imread(rle_input));
rec_rle  = im2double(imread(rle_output));
orig_huf = im2double(imread(huf_input));
rec_huf  = im2double(imread(huf_output));

if size(orig_rle,3)==3, orig_rle = rgb2gray(orig_rle); end
if size(rec_rle,3)==3,  rec_rle  = rgb2gray(rec_rle);  end
if size(orig_huf,3)==3, orig_huf = rgb2gray(orig_huf); end
if size(rec_huf,3)==3,  rec_huf  = rgb2gray(rec_huf);  end

rec_rle = imresize(rec_rle,[size(orig_rle,1) size(orig_rle,2)]);
rec_huf = imresize(rec_huf,[size(orig_huf,1) size(orig_huf,2)]);

% ==============================================================
% STEP 3 — PSNR + SSIM
% ==============================================================
mse_rle  = mean((orig_rle(:)-rec_rle(:)).^2);
psnr_rle = 10*log10(1/mse_rle);
ssim_rle = simple_ssim(rec_rle,orig_rle);

mse_huf  = mean((orig_huf(:)-rec_huf(:)).^2);
psnr_huf = 10*log10(1/mse_huf);
ssim_huf = simple_ssim(rec_huf,orig_huf);

% ==============================================================
% STEP 4 — Compression ratio (Image)
% ==============================================================
info_in  = dir(rle_input);
info_out_rle = dir(rle_output);
info_out_huf = dir(huf_output);

size_in_kb   = info_in.bytes/1024;
size_rle_kb  = info_out_rle.bytes/1024;
size_huf_kb  = info_out_huf.bytes/1024;

cr_rle_img  = size_in_kb / size_rle_kb;
cr_huf_img  = size_in_kb / size_huf_kb;

% ==============================================================
% STEP 5 — Encoded text file comparison
% ==============================================================
info_enc_rle  = dir(rle_encoded_file);
info_enc_huff = dir(huff_encoded_file);

size_enc_rle_kb  = info_enc_rle.bytes/1024;
size_enc_huff_kb = info_enc_huff.bytes/1024;

cr_rle_txt  = size_in_kb / size_enc_rle_kb;
cr_huf_txt  = size_in_kb / size_enc_huff_kb;

% ==============================================================
% STEP 6 — Convert .txt → .bin and compute true CR
% ==============================================================
convert_to_binary(rle_encoded_file, rle_bin_file);
convert_to_binary(huff_encoded_file, huff_bin_file);

info_bin_rle  = dir(rle_bin_file);
info_bin_huff = dir(huff_bin_file);
size_bin_rle_kb  = info_bin_rle.bytes/1024;
size_bin_huff_kb = info_bin_huff.bytes/1024;

cr_rle_bin  = size_in_kb / size_bin_rle_kb;
cr_huf_bin  = size_in_kb / size_bin_huff_kb;

% ==============================================================
% STEP 7 — Display Results
% ==============================================================
fprintf('\n=== Image-Level Metrics ===\n');
fprintf('Method       PSNR(dB)   SSIM     Input(KB)  Output(KB)   CR\n');
fprintf('--------------------------------------------------------------\n');
fprintf('RLE        %10.2f  %8.4f  %8.2f  %8.2f  %6.2f\n', ...
    psnr_rle, ssim_rle, size_in_kb, size_rle_kb, cr_rle_img);
fprintf('Huffman    %10.2f  %8.4f  %8.2f  %8.2f  %6.2f\n', ...
    psnr_huf, ssim_huf, size_in_kb, size_huf_kb, cr_huf_img);

fprintf('\n=== Encoded (Text) Files ===\n');
fprintf('Method       Input(KB)  Encoded(KB)   CR\n');
fprintf('-------------------------------------------\n');
fprintf('RLE        %10.2f  %10.2f  %6.2f\n', size_in_kb, size_enc_rle_kb, cr_rle_txt);
fprintf('Huffman    %10.2f  %10.2f  %6.2f\n', size_in_kb, size_enc_huff_kb, cr_huf_txt);

fprintf('\n=== True Binary Compression ===\n');
fprintf('Method       Input(KB)  Binary(KB)   True CR\n');
fprintf('-------------------------------------------\n');
fprintf('RLE        %10.2f  %10.2f  %6.2f\n', size_in_kb, size_bin_rle_kb, cr_rle_bin);
fprintf('Huffman    %10.2f  %10.2f  %6.2f\n', size_in_kb, size_bin_huff_kb, cr_huf_bin);

% ==============================================================
% STEP 8 — Graphs
% ==============================================================
methods = {'RLE','Huffman'};
figure('Name','MRI Compression Comparison','NumberTitle','off');
subplot(3,1,1); bar([cr_rle_img cr_huf_img]); set(gca,'xticklabel',methods);
title('Image Compression Ratio (PNG)');
subplot(3,1,2); bar([cr_rle_txt cr_huf_txt]); set(gca,'xticklabel',methods);
title('Encoded Text File CR');
subplot(3,1,3); bar([cr_rle_bin cr_huf_bin]); set(gca,'xticklabel',methods);
title('True Binary Compression Ratio');
sgtitle('MRI Compression Comparison (RLE vs Huffman)');
grid on;

% ==============================================================
% === Helper Functions ===
% ==============================================================

% SSIM without toolbox
function s = simple_ssim(A,B)
A = double(A)*255; B = double(B)*255;
C1 = (0.01*255)^2; C2 = (0.03*255)^2;
muA = mean(A(:)); muB = mean(B(:));
sigmaA = var(A(:)); sigmaB = var(B(:));
sigmaAB = cov(A(:),B(:)); sigmaAB = sigmaAB(1,2);
s = ((2*muA*muB + C1)*(2*sigmaAB + C2)) / ...
    ((muA^2 + muB^2 + C1)*(sigmaA + sigmaB + C2));
end

% Convert text bits to binary
function convert_to_binary(txt_path, bin_path)
bits = fileread(txt_path);
bits = regexprep(bits,'\s','');
num = uint8(bits=='1')';   % ensure row vector
num = num(:);               % reshape as column
pad_len = mod(8 - mod(length(num),8),8);
if pad_len > 0
    num = [num; zeros(pad_len,1,'uint8')];
end
bytes = reshape(num,8,[])';
dec = uint8(bin2dec(num2str(bytes)));
fid = fopen(bin_path,'w'); fwrite(fid,dec,'uint8'); fclose(fid);
end
