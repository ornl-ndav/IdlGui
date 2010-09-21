# Makefile for REFreduction and miniREFreduction
# Compile the necessary modules
# Create the VM programs 
# Copy the VM programs in their final location

# make : builds the executable via the idl virtual machine
# make install : deploys the program as main version
# make backup  : deploys the program as backup

all:
	cp REFreduction_v15.cfg .REFreduction_v15.cfg
	idl ./makefile.pro;
	idl ./mini_makefile.pro;

install:
	cp ref_reduction_v15.sav /SNS/software/idltools/sav/
	cp REFreduction_v15 /SNS/software/idltools/
	cp miniREFreduction_v15 /SNS/software/idltools/
	cp mini_ref_reduction_v15.sav /SNS/software/idltools/sav/
	cp REFreductionHELP/*.* /SNS/software/idltools/help/REFreduction/
	cp REFreduction_images/*.* /SNS/software/idltools/sav/REFreduction_images/
	cp .REFreduction_v15.cfg /SNS/software/idltools/sav/
	
test: 
	cp ref_reduction_v15.sav /usr/local/SNS/idltools/
	cp mini_ref_reduction_v15.sav /usr/local/SNS/idltools/
	cp .REFreduction.cfg /usr/local/SNS/idltools/
	cp -rf REFreductionHELP /usr/local/SNS/idltools/
	cp -rf REFreduction_images /usr/local/SNS/idltools/



