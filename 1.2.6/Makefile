# Makefile for CLoopES
# Compile the necessary modules
# Create the VM programs 
# Copy the VM programs in their final location

all:
	cp cloopes.cfg .cloopes.cfg
	idl ./makefile.pro;
install:
	cp cloopes.cfg .cloopes.cfg
	cp cloopes.sav /SNS/software/idltools/sav/
	cp CLoopES /SNS/software/idltools/
	cp .cloopes.cfg /SNS/software/idltools/sav/
	cp -r CLoopES_images/*.png /SNS/software/idltools/sav/CLoopES_images/
	cp slurm.xml /SNS/software/idltools/sav/
