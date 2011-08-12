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

beta:
	cp .SOS.cfg /SNS/software/idltools/beta/sav
	cp .SOS.cfg /SNS/software5/idltools/beta/sav
	cp SOS_instruments.cfg /SNS/software/idltools/beta/sav
	cp SOS_instruments.cfg /SNS/software5/idltools/beta/sav
	cp sos.sav /SNS/software/idltools/beta/sav
	cp sos.sav /SNS/software5/idltools/beta/sav
	cp SOS_images/* /SNS/software/idltools/beta/sav/SOS_images/
	cp SOS_images/* /SNS/software5/idltools/beta/sav/SOS_images/
	cp SOS_beta /SNS/software/idltools/beta
	cp SOS_beta /SNS/software5/idltools/beta

test:
	idl ./make_and_run_test_unit
