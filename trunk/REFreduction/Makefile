#$Id$

# Makefile for REFreduction and miniREFreduction
# Compile the necessary modules
# Create the VM programs 
# Copy the VM programs in their final location

all:
	idl ./makefile.pro;
	idl ./mini_makefile.pro;
install:
	cp ref_reduction.sav /SNS/software/idltools/sav/
	cp ref_reduction /SNS/software/idltools/
	cp mini_ref_reduction.sav /SNS/software/idltools/sav/
	cp mini_ref_reduction /SNS/software/idltools/
	cp REFreductionHELP/*.* /SNS/software/idltools/help/REFreduction/

