# Makefile for SOS program
# Compile the necessary modules
# Create the VM programs 
# Copy the VM programs in their final location

all:
	cp SOS.cfg .SOS.cfg
	idl ./makefile.pro

install:
	cp .SOS.cfg /SNS/software/idltools/sav/
	cp SOS_instruments.cfg /SNS/software/idltools/sav/
	cp sos.sav /SNS/software/idltools/sav/
	cp SOS_images/* /SNS/software/idltools/sav/SOS_images/
	cp SOS /SNS/software/idltools/

test:
	idl ./make_and_run_test_unit
