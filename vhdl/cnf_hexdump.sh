#!/bin/bash

# Adopted from Usage in https://github.com/ghdl/ghdl-yosys-plugin
# Modify as necessary for your project, specifically replacing 'blank'
# with your 'top' file, and adding source files to be analyzed

rm -rf *.asc *.bin *.json work-obj93.cf

# Analyse all vhdl sources
ghdl -a top_hexdump.vhdl
ghdl -a uart.vhdl
ghdl -a spram.vhdl
#ghdl -a other_source_files.vhdl

# Synthesize the design
yosys -m ghdl -p 'ghdl top_hexdump; synth_ice40 -json top_hexdump.json'

# P&R specifically for upduino
nextpnr-ice40 --up5k --package sg48 --pcf top.pcf \
--asc top_hexdump.asc --json top_hexdump.json

# Generate bitstream
icepack top_hexdump.asc top_hexdump.bin

# Flash FPGA, may need to be run with sudo depending on user permissions
sudo iceprog top_hexdump.bin
