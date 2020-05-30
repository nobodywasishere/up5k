#!/bin/bash

# Adopted from Usage in https://github.com/ghdl/ghdl-yosys-plugin
# Modify as necessary for your project, specifically replacing 'blank'
# with your 'top' file, and adding source files to be analyzed

# Analyse all vhdl sources
ghdl -a top_echo.vhdl
ghdl -a uart.vhdl
#ghdl -a other_source_files.vhdl

# Synthesize the design
yosys -m ghdl -p 'ghdl top_echo; synth_ice40 -json top_echo.json'

# P&R specifically for upduino
nextpnr-ice40 --up5k --package sg48 --pcf top.pcf \
--asc top_echo.asc --json top_echo.json

# Generate bitstream
icepack top_echo.asc top_echo.bin

# Flash FPGA, may need to be run with sudo depending on user permissions
sudo iceprog top_echo.bin
