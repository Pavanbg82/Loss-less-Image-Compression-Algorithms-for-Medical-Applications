RLE IMAGE COMPRESSION USING VERILOG

PROJECT OVERVIEW
This project implements Run-Length Encoding (RLE), a lossless data compression
technique, using Verilog HDL. The design reduces redundancy in image pixel data
by encoding consecutive repeated values as a single value with a count.

OBJECTIVES
- Implement RLE compression and decompression in Verilog
- Reduce storage requirements for image pixel data
- Verify correctness using simulation and waveform analysis

TOOLS & TECHNOLOGIES
- Verilog HDL
- ModelSim / Vivado Simulator
- Xilinx FPGA Tools

PROJECT STRUCTURE
src      : Verilog source files
tb       : Testbench files
outputs  : Encoded and decoded outputs
images   : Input and reconstructed images

METHODOLOGY
1. Read image pixel values sequentially
2. Detect consecutive repeated values
3. Encode data as (pixel value, count)
4. Decode encoded data to reconstruct image
5. Compare output with original input

VERIFICATION & RESULTS
Functional verification is performed using Verilog testbenches.
Simulation waveforms confirm correct encoding and decoding.
Decoded output matches original input data.

APPLICATIONS
- Image compression
- Embedded systems
- FPGA-based image processing
- Memory optimization

LICENSE & ATTRIBUTION
This project is based on Apache License 2.0 licensed open-source
implementations. Original authors are credited in the source files.

 
