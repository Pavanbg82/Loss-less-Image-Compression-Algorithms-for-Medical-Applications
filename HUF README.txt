Huffman Encoder-Decoder   Project
---------------------------------------------
Simulation: ModelSim / QuestaSim
Synthesis:  Xilinx Vivado (RTL schematic supported)

Files:
 - huff_encoder_synth.v        : Synthesizable encoder
 - huff_decoder_synth.v        : Synthesizable decoder
 - huff_top_codec_synth.v      : Top-level codec
 - tb_huff_codec_synth.v       : Testbench (simulation only)
 - pixel_input.txt             : Input pixel samples
 - decoded_output_verify.txt   : Generated decoded output
 - verification_log.txt        : Auto-verification results

Simulation Steps:
 1. vlog *.v
 2. vsim tb_huff_codec_synth
 3. run -all

Vivado RTL:
 1. Add encoder, decoder, top files.
 2. Set huff_top_codec_synth as top.
 3. Run synthesis and view RTL schematic.
