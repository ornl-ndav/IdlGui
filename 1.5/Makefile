# Makefile for REFoffSpecapplication
# Compile the necessary modules
# Create the VM programs 
# Copy the VM programs in their final location

all:
	cp REFoffSpec.cfg .REFoffSpec.cfg
	idl ./makefile.pro;
install:
	cp ref_off_spec.sav /SNS/software/idltools/sav/
	cp REFoffSpec /SNS/software/idltools/
	cp REFoffSpec_images/*.* /SNS/software/idltools/sav/REFoffSpec_images/
	cp .REFoffSpec.cfg /SNS/software/idltools/sav/
beta:
        cp REFoffSpec.cfg .REFoffScpec.cfg
        cp ref_off_spec.sav /SNS/software/idltools/beta/sav/
        cp REFoffSpec_beta /SNS/software/idltools/beta/
        cp -r REFoffSpec_images/*.* /SNS/software/idltools/beta/sav/REFoffSpec_images/
        cp .REFoffSpec.cfg /SNS/software/idltools/beta/sav/
