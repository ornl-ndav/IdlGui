# Makefile for FITStools
# Compile the necessary modules
# Create the VM programs 
# Copy the VM programs in their final location

all:
	cp FITStools.cfg .FITStools.cfg
	idl ./makefile.pro
install:
	cp fits_tools.sav /SNS/software/idltools/sav/
	cp FITStools /SNS/software/idltools/
	cp .FITStools.cfg /SNS/software/idltools/sav/
