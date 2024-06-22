# Makefile for running IIR filter testbench using GHDL and Cocotb

# Project-specific variables
TOPLEVEL_LANG ?= vhdl
SIM ?= ghdl
TOPLEVEL ?= iir_filter
MODULE ?= test_iir_filter

# Paths and file names
VHDL_SOURCES = $(wildcard ./*.vhd)

# Include the Cocotb makefile
include $(shell cocotb-config --makefiles)/Makefile.sim

# Clean up build and result files
clean::
	rm -rf sim_build results.xml waveform.ghw iir_filter __pycache__