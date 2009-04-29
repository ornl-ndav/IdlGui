# Makefile for SANSreduction
# Compile the necessary modules
# Create the VM programs 
# Copy the VM programs in their final location

all:
	idl ./makefile.pro;
	idl ./mini_makefile.pro;
install:
	cp sans_calibration.sav /SNS/software/idltools/sav/
#	cp SANScalibration /SNS/software/idltools/
	cp SANScalibration_images/*.bmp /SNS/software/idltools/sav/SANScalibration_images/
	cp SANScalibration_images/*.png /SNS/software/idltools/sav/SANScalibration_images/
	cp drversion /SNS/software/idltools/
	cp SANScalibration.cfg /SNS/software/idltools/sav/
tar:
	./make_tar.sh
test:
	cp sans_calibration.sav /usr/local/SNS/idltools/
	cp mini_sans_calibration.sav /usr/local/SNS/idltools/
	cp SANScalibration_images/*.bmp /usr/local/SNS/idltools/SANScalibration_images
	cp SANScalibration_images/*.png /usr/local/SNS/idltools/SANScalibration_images
	cp drversion /usr/local/SNS/idltools/
	cp SANScalibration.cfg /usr/local/SNS/idltools/
