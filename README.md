LOSSLESS IMAGE COMPRESSION FOR MEDICAL APPLICATION

Project Overview
This project implements lossless image compression algorithms for medical applications. The project includes algorithm-level implementation and hardware realization, followed by verification to ensure exact image reconstruction without any data loss.

Project Description

• Designed Verilog-based architectures for Huffman Coding with corresponding testbenches and verification logs.

• Implemented Run-Length Encoding (RLE) and Differential Pulse Code Modulation (DPCM) using MATLAB.

• Verified compression accuracy by comparing original and reconstructed medical images.

• Performed performance comparison and analysis using MATLAB scripts and synthesis results.

Tools and Technology

Hardware Description Language : Verilog  
Synthesis and Analysis Tool   : Xilinx Vivado  
Verification Tool             : MATLAB  
Application Domain            : Medical Image Processing

Project Files Included

Loss-less Image Compression Algorithms for Medical Applications
|
|-- VERILOG CODE HUFFMAN TECHNIQUE
|   |-- huff_top_codec_synth.v
|   |-- tb_huff_codec_synth.v
|   |-- verification_log.txt
|
|-- MATLAB_MINIPRO
|   |-- Encoding and decoding scripts
|   |-- Original medical images
|   |-- Reconstructed output images
|   |-- Metric comparison files
|
|-- HUF README.txt
|-- RLE README.txt

How to Run the Project

1. Run MATLAB scripts for RLE and DPCM compression and verification.
2. Simulate Huffman Coding Verilog files using Vivado or ModelSim.
3. Verify reconstructed outputs with original medical images.

Author
PAVAN BG

License
This project is intended for academic and educational purposes only.
