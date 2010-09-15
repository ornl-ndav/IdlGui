# Makefile for REFscale (REF_M)
# Compile the necessary modules
# Create the VM program 
all:
	cp REFscale_m.cfg .REFscale_m.cfg
	idl ./makefile.pro

install: 
	cp .REFscale_m.cfg /SNS/software/idltools/sav/
	cp ref_scale_m.sav /SNS/software/idltools/sav/
	cp REFscale_m /SNS/software/idltools/

beta:
	cp .REFscale_m.cfg /SNS/software/idltools/beta/sav/
	cp ref_scale_m.sav /SNS/software/idltools/beta/sav/
	cp REFscale_m_beta /SNS/software/idltools/beta/
	
dev:
	cp .REFscale_m.cfg /SNS/software/idltools/dev/sav/
	cp ref_scale_m.sav /SNS/software/idltools/dev/sav/
	cp REFscale_m_dev /SNS/software/idltools/dev/
	