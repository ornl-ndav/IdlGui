# Makefile for REFscaleOFF
# Compile the necessary modules
# Create the VM program 

all:
	cp REFscaleOFF.cfg .REFscaleOFF.cfg
	idl ./makefile.pro

install: 
	cp REFscaleOFF_images/*.bmp /SNS/software/idltools/sav/REFscaleOFF_images/
	cp .REFscaleOFF.cfg /SNS/software/idltools/sav/
	cp ref_scale_off.sav /SNS/software/idltools/sav/
	cp REFscaleOFF /SNS/software/idltools/

beta:
	cp .REFscaleOFF.cfg /SNS/software/idltools/beta/sav/
	cp ref_scale_off.sav /SNS/software/idltools/beta/sav/
	cp REFscale_off_beta /SNS/software/idltools/beta/
	
dev:
	cp .REFscaleOFF.cfg /SNS/software/idltools/dev/sav/
	cp ref_scale_off.sav /SNS/software/idltools/dev/sav/
	cp REFscale_off_dev /SNS/software/idltools/dev/
	