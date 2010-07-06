# Makefile for REFscale_l (REF_L)
# Compile the necessary modules
# Create the VM program 
all:
	cp REFscale_l.cfg .REFscale_l.cfg
	idl ./makefile.pro

install: 
	cp .REFscale_l.cfg /SNS/software/idltools/sav/
	cp ref_scale_l.sav /SNS/software/idltools/sav/
	cp REFscale_l /SNS/software/idltools/

beta:
	cp .REFscale_l.cfg /SNS/software/idltools/beta/sav/
	cp ref_scale_l.sav /SNS/software/idltools/beta/sav/
	cp REFscale_l_beta /SNS/software/idltools/beta/
	
dev:
	cp .REFscale_l.cfg /SNS/software/idltools/dev/sav/
	cp ref_scale_l.sav /SNS/software/idltools/dev/sav/
	cp REFscale_l_dev /SNS/software/idltools/dev/
	