# Makefile for plotCNCS
# Compile the necessary modules
# Create the VM programs 
# Copy the VM programs in their final location

all:
	cp plotcncs.cfg .plotcncs.cfg
	idl ./makefile.pro;
install:
	cp plotcncs.cfg .plotcncs.cfg
	cp .plotcncs.cfg /SNS/software/idltools/sav/
	cp plot_cncs.sav /SNS/software/idltools/sav/
	cp plotCNCS /SNS/software/idltools/
	cp plotCNCS_images/*.png /SNS/software/idltools/sav/plotCNCS_images/
    
