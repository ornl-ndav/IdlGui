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
	cp REFscale_images/*.png /SNS/software/idltools/sav/REFscale_images/

beta:
	cp .REFscale_l.cfg /SNS/software/idltools/beta/sav/
	cp ref_scale_l.sav /SNS/software/idltools/beta/sav/
	cp REFscale_l_beta /SNS/software/idltools/beta/
	cp REFscale_images/*.png /SNS/software/idltools/beta/sav/REFscale_images/

dev:
	cp .REFscale_l.cfg /SNS/software/idltools/dev/sav/
	cp ref_scale_l.sav /SNS/software/idltools/dev/sav/
	cp REFscale_l_dev /SNS/software/idltools/dev/
	cp REFscale_images/*.png /SNS/software/idltools/dev/sav/REFscale_images/

