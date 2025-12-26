clc;
clear;
close all;

% -------------------------------------------------------------
% STEP 1: Read pixel values
% -------------------------------------------------------------
txtPath = fullfile(pwd, 'decoded_output_verify.txt');
fileID = fopen(txtPath, 'r');
if fileID == -1
    error('Cannot open reconstructed.txt from %s', pwd);
end
pixels = fscanf(fileID, '%d');
fclose(fileID);

% -------------------------------------------------------------
% STEP 2: Auto calculate possible image size
% -------------------------------------------------------------
N = length(pixels);
side = sqrt(N);

if mod(side, 1) == 0
    rows = side;
    cols = side;
else
    rows = 630;
    cols = floor(N / rows);
end

fprintf('Total pixels: %d → Image size: %d x %d\n', N, rows, cols);

% -------------------------------------------------------------
% STEP 3: Reshape into image
% -------------------------------------------------------------
img = reshape(pixels(1:rows*cols), [cols, rows])';  % reshape & transpose

% -------------------------------------------------------------
% STEP 4: Display reconstructed image
% -------------------------------------------------------------
figure;
imshow(uint8(img), []);
title(sprintf('Reconstructed Image (%dx%d)', rows, cols));

% -------------------------------------------------------------
% STEP 5: Save result + report compressed file size
% -------------------------------------------------------------
outFile = fullfile(pwd, 'reconstructed_image by  HUF TEC.png');
imwrite(uint8(img), outFile);

info = dir(outFile);
size_bytes = info.bytes;
size_kb = size_bytes / 1024;
size_mb = size_kb / 1024;

fprintf('Compressed image written to:\n  %s\n', outFile);
fprintf('File size: %.2f KB (%.2f MB)\n', size_kb, size_mb);

% Optional: append size to the figure title
title(sprintf('Reconstructed Image (%dx%d) — %.2f KB (%.2f MB)', ...
    rows, cols, size_kb, size_mb));
