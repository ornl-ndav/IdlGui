#$Id$

# Makefile for TS_rebin_GUI
# Compile the necessary modules
# Create the VM programs 
# Copy the VM programs in its final location

all:
	idl ./makefile.pro;

install:
	cp ts_rebin.sav /SNS/software/idltools/sav/
	cp TS_rebin_GUI /SNS/software/idltools/

