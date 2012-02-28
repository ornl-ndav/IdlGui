#$Id$

# Makefile for BSSreduction
# Compile the necessary modules
# Create the VM programs 
# Copy the VM programs in their final location

all:
	idl ./makefile.pro;

install:
	cp bss_reduction.sav /SNS/software/idltools/sav/
	cp BSSreduction.cfg /SNS/software/idltools/sav/
	cp BSSreduction /SNS/software/idltools/
	cp BSSreduction_images/*.bmp /SNS/software/idltools/sav/BSSreduction_images/
	cp bss_reduction.sav /SNS/software5/idltools/sav/
	cp BSSreduction.cfg /SNS/software5/idltools/sav/
	cp BSSreduction_images/*.bmp /SNS/software5/idltools/sav/BSSreduction_images/

test:
	cp bss_reduction.sav /SNS/software/idltools/tmp/sav/
	cp BSSreduction.cfg /SNS/software/idltools/tmp/sav/
	cp BSSreduction_test /SNS/software/idltools/tmp
	cp BSSreduction_images/*.bmp /SNS/software/idltools/tmp/sav/BSSreduction_images/


