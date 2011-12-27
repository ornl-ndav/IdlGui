# Makefile for REFreduction and miniREFreduction
# Compile the necessary modules
# Create the VM programs 
# Copy the VM programs in their final location

# make : builds the executable via the idl virtual machine
# make install : deploys the program as main version
# make backup  : deploys the program as backup

all:
	cp REFreduction.cfg .REFreduction.cfg
	idl ./makefile.pro;
	idl ./mini_makefile.pro;

install:
	cp ref_reduction.sav /SNS/software/idltools/sav/
	cp ref_reduction.sav /SNS/software5/idltools/sav/
	cp ref_reduction /SNS/software/idltools/
	cp mini_ref_reduction.sav /SNS/software/idltools/sav/
	cp mini_ref_reduction.sav /SNS/software5/idltools/sav/
	cp mini_ref_reduction /SNS/software/idltools/
	cp REFreductionHELP/*.* /SNS/software/idltools/help/REFreduction/
	cp REFreduction_images/*.* /SNS/software/idltools/sav/REFreduction_images/
	cp .REFreduction.cfg /SNS/software/idltools/sav/
	cp .REFreduction.cfg /SNS/software5/idltools/sav/
	cp REFreductionHELP/* /SNS/software/idltools/help/REFreduction/

backup:
	cp ref_reduction.sav /SNS/software/idltools/sav_backup/
	cp ref_reduction_backup /SNS/software/idltools/
	cp mini_ref_reduction.sav /SNS/software/idltools/sav_backup/
	cp mini_ref_reduction_backup /SNS/software/idltools/
	cp -rf REFreduction_images /usr/local/SNS/idltools/
	cp .REFreduction.cfg /SNS/software/idltools/sav_backup/
	cp REFreductionHELP/* /SNS/software/idltools/sav_backup/help/REFreduction/

beta: 
	cp ref_reduction.sav /SNS/software/idltools/beta/sav/
	cp REFreduction_v13_beta /SNS/software/idltools/beta/
	cp mini_ref_reduction.sav /SNS/software/idltools/beta/sav/
	cp miniREFreduction_v13_beta /SNS/software/idltools/beta/
	cp REFreduction_images/*.* /SNS/software/idltools/beta/sav/REFreduction_images/
	cp .REFreduction.cfg /SNS/software/idltools/beta/sav/

