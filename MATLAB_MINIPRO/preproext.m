% FAST image_to_pixels FOR RLE & Huffman (with image display + size info)
clc;
clear; close all;

% -------------------------------------------------------------
% 1) Read image and convert to grayscale  
% -------------------------------------------------------------
inJpeg = fullfile(pwd, 'myp.jpeg');   % input MRI or test image
I = imread(inJpeg);

if ndims(I) == 3
    I = rgb2gray(I);
end
I = uint8(I);
[H, W] = size(I);

% -------------------------------------------------------------
% 2) Display the original image
% -------------------------------------------------------------
figure('Name', 'Original MRI Image', 'NumberTitle', 'off');
imshow(I, []);
title(sprintf('Original Grayscale Image (%dx%d)', H, W));
drawnow;

% -------------------------------------------------------------
% 3) Save grayscale PNG version
% -------------------------------------------------------------
pngOut = fullfile(pwd, 'original_gray_by_RLE.png');
imwrite(I, pngOut);

% -------------------------------------------------------------
% 4) Write all pixel values to text (FAST method)
% -------------------------------------------------------------
pxTxt = fullfile(pwd, 'pixels.txt');
fid = fopen(pxTxt, 'w');

% Write dimensions first (H, W)
fprintf(fid, '%d\n%d\n', H, W);

% Write all pixel values in one go — vectorized (FAST)
fprintf(fid, '%d\n', I(:));

fclose(fid);
fprintf('Wrote %d x %d pixels to pixels.txt\n', H, W);

% -------------------------------------------------------------
% 5) File size information
% -------------------------------------------------------------
s_jpeg = dir(inJpeg);  size_jpeg_kb = s_jpeg.bytes / 1024;
s_png  = dir(pngOut);  size_png_kb  = s_png.bytes  / 1024;
s_txt  = dir(pxTxt);   size_txt_kb  = s_txt.bytes  / 1024;

fprintf('\n=== File Sizes ===\n');
fprintf('Input JPEG : %.2f KB (%.2f MB)\n', size_jpeg_kb, size_jpeg_kb/1024);
fprintf('Gray PNG   : %.2f KB (%.2f MB)\n', size_png_kb,  size_png_kb/1024);
fprintf('pixels.txt : %.2f KB (%.2f MB)\n', size_txt_kb,  size_txt_kb/1024);

fprintf('\n=== Compression Ratios (approx.) ===\n');
fprintf('JPEG → PNG : %.2fx smaller\n', size_jpeg_kb / size_png_kb);
fprintf('JPEG → TXT : %.2fx smaller\n', size_jpeg_kb / size_txt_kb);
