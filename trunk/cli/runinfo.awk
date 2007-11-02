#
# runinfo.awk
#
# Parse the DAS runinfo.xml file to extract necessary values...
#

#
# Combine All Output Onto One Line...
#
BEGIN {
	ORS = " "
}

#
# Get the Number of States
#
/<States/ {
	for ( i=1 ; i <= NF ; i++ ) {
		nf = split( $i, attr, "=" )
		if ( attr[1] == "number" ) {
			split( attr[2], nsVal, "\"" )
			numStates = nsVal[2]
		}
	}
	# print "numStates = " numStates
	print "-ns " numStates
}

#
# Get the State Pixel Offsets
#
/<State / {
	for ( i=1 ; i <= NF ; i++ ) {
		split( $i, attr, "=" )
		if ( attr[1] == "index" ) {
			split( attr[2], siVal, "\"" )
			stateIndex = siVal[2]
		}
		else if ( attr[1] == "pixel_offset" ) {
			split( attr[2], soVal, "\"" )
			pixelOffset = soVal[2]
		}
	}
	# print "pixel_offset[" stateIndex "]=" pixelOffset
	# omit stateIndex from output, just dump out in order and hope
	# that the XML specifies the states sanely in order, too!  :-D
	# (this is way easier to parse...! :-)
	# print "-po " stateIndex " " pixelOffset
	print "-po " pixelOffset
}

#
# Get Total Number of Pixels
#

/<NumPixels>/ {
	nf = split( $1, npVal, "[<>,]" )
	numPixels = npVal[3]
	print "-p " numPixels
}

#
# Get Time Channel Information
#

/<NumTimeChannels/ {
	for ( i=1 ; i <= NF ; i++ ) {
		nf = split( $i, attr, "=" )
		if ( attr[1] == "width" ) {
			split( attr[2], bwVal, "\"" )
			binWidth = bwVal[2]
			# print "binWidth=" binWidth
		}
		else if ( attr[1] == "scale" ) {
			split( attr[2], tsVal, "\"" )
			timeScale = tsVal[2]
			# print "timeScale=" timeScale
		}
		else if ( attr[1] == "startbin" ) {
			split( attr[2], toVal, "\"" )
			timeOffset = toVal[2]
			# print "timeOffset=" timeOffset
		}
		else if ( attr[1] == "endbin" ) {
			split( attr[2], mtVal, "\"" )
			timeMax = mtVal[2]
			# print "timeMax=" timeMax
		}
	}
	# Linear vs Log Binning...
	if ( timeScale == "linear" )
		print "-l " binWidth
	else
		print "-L " binWidth
	# Time Offset and Max...
	print "-O " timeOffset " -M " timeMax
}

