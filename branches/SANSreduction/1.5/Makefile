# Makefile for SANSreduction
# Compile the necessary modules
# Create the VM programs 
# Copy the VM programs in their final location

all:
	idl ./makefile.pro;
	idl ./mini_makefile.pro
install:
	cp sans_reduction.sav /SNS/software/idltools/sav/
	cp mini_sans_reduction.sav /SNS/software/idltools/sav/
#	cp SANSreduction /SNS/software/idltools/
#	cp miniSANSreduction /SNS/software/idltools/
	cp SANSreduction_images/*.bmp /SNS/software/idltools/sav/SANSreduction_images/
	cp SANSreduction_images/*.png /SNS/software/idltools/sav/SANSreduction_images/
	cp drversion /SNS/software/idltools/
	cp SANSreductionHelp/*.* /SNS/software/idltools/sav/SANSreductionHelp/
	cp SANSreduction.cfg /SNS/software/idltools/sav/
tar:
	./make_tar.sh SANSreduction.cfg
test:
	cp sans_reduction.sav /usr/local/SNS/idltools/
	cp SANSreduction.cfg /usr/local/SNS/idltools/
	cp SANSreduction_images/*.bmp /usr/local/SNS/idltools/SANSreduction_images/
	cp SANSreduction_images/*.png /usr/local/SNS/idltools/SANSreduction_images/
	cp SANSreductionHelp/*.* /usr/local/SNS/idltools/SANSreductionHelp/
	cp mini_sans_reduction.sav /usr/local/SNS/idltools/

	
	
	