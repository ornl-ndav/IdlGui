# Makefile for REFscale
# Compile the necessary modules
# Create the VM program 
all:
	cp REFscale.cfg .REFscale.cfg
	idl ./makefile.pro

install: 
	cp .REFscale.cfg /SNS/software/idltools/sav/
	cp ref_scale.sav /SNS/software/idltools/sav/
	cp REFscale /SNS/software/idltools/

beta:
	cp .REFscale.cfg /SNS/software/idltools/beta/sav/
	cp ref_scale.sav /SNS/software/idltools/beta/sav/
	cp REFscale_beta /SNS/software/idltools/beta/
	
dev:
	cp .REFscale.cfg /SNS/software/idltools/dev/sav/
	cp ref_scale.sav /SNS/software/idltools/dev/sav/
	cp REFscale_dev /SNS/software/idltools/dev/
	