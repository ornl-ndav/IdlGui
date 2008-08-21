# Makefile for SANSreduction
# Compile the necessary modules
# Create the VM programs 
# Copy the VM programs in their final location

all:
	idl ./makefile.pro;
install:
	cp sans_reduction.sav /SNS/software/idltools/sav/
	cp SANSreduction /SNS/software/idltools/
	cp images/*.bmp /SNS/software/idltools/sav/images/
	cp drversion /SNS/software/idltools/
	cp SANSreductionHelp/*.* /SNS/software/idltools/sav/SANSreductionHelp/
tar:
	./make_tar.sh sans_reduction.pro
