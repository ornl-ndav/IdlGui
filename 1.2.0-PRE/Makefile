# Makefile for DGSreduction Application

all:
	# Dump the current time into a file.
	date +%s > build_seconds
	# build the IDL procedure that contains the static build data/time
	echo function get_build_time > get_build_time.pro
	echo return, `cat build_seconds`L >> get_build_time.pro
	echo end >> get_build_time.pro
	idl ./makefile.pro;
install-dev:
	cp build_seconds /SNS/software/idltools/sav/DGSreduction/dev
	cp dgsreduction.sav /SNS/software/idltools/sav/DGSreduction/dev 
install:
	cp dgsreduction.sav /SNS/software/idltools/sav/
	cp DGSreduction /SNS/software/idltools/
