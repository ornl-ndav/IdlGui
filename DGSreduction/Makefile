# Makefile for DGSreduction Application

all:
	# build the IDL procedure that contains the static build data/time
	echo function get_build_time > get_build_time.pro
	echo return, `date +%s` >> get_build_time.pro
	echo end >> get_build_time.pro
	idl ./makefile.pro;
install-dev:
	cp dgsreduction.sav /SNS/software/idltools/sav/DGSreduction/dev 
install:
	cp dgsreduction.sav /SNS/software/idltools/sav/
	cp DGSreduction /SNS/software/idltools/
