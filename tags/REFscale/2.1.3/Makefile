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
	cp REFscale_images/*.png /SNS/software/idltools/sav/REFscale_images/

beta:
	cp .REFscale_m.cfg /SNS/software/idltools/beta/sav/
	cp ref_scale_m.sav /SNS/software/idltools/beta/sav/
	cp REFscale_m_beta /SNS/software/idltools/beta/
	cp REFscale_images/*.png /SNS/software/idltools/beta/sav/REFscale_images/
		
dev:
	cp .REFscale_m.cfg /SNS/software/idltools/dev/sav/
	cp ref_scale_m.sav /SNS/software/idltools/dev/sav/
	cp REFscale_m_dev /SNS/software/idltools/dev/
	cp REFscale_images/*.png /SNS/software/idltools/dev/sav/REFscale_images/	