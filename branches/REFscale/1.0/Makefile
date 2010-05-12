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

backup: 
	cp ref_scale.sav /SNS/software/idltools/sav_backup/
	cp REFscale_backup /SNS/software/idltools/
	cp .REFscale.cfg /SNS/software/idltools/sav_backup/
	
dev:
	cp .REFscale.cfg /SNS/software/idltools/dev/sav/
	cp ref_scale.sav /SNS/software/idltools/dev/sav/
	cp REFscale_dev /SNS/software/idltools/dev/
	
