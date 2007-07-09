/*
 * Copyright (c) 2007, J.-C. Bilheux <bilheuxjm@ornl.gov>
 * Spallation Neutron Source at Oak Ridge National Laboratory
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
package gov.ornl.sns.iontools;

import gov.ornl.sns.iontools.IParameters;

public class IontoolsFile {

	static String outputFolder;
	static String outputPidFileName;
	static String pidFileExtension;

	static String createPidFileName(String ucams, String instrument, String runNumber, String selectionType) {
		
		outputFolder = ParametersToKeep.sSessionWorkingDirectory;
		
		outputPidFileName = instrument + "_" + runNumber + "_";
		//get the extenstion according to the selection type (signal or back)
		pidFileExtension = getPidFileExtenstion(selectionType);
		outputPidFileName += pidFileExtension;
				
		return outputFolder + outputPidFileName;
	}
	
	static String getPidFileExtenstion(String selectionType) {
		String extension;
		if (selectionType.compareTo(IParameters.SIGNAL_STRING) == 0) {
			extension = "signal_Pid.txt";
		} else {	
			extension = "background_Pid.txt";
		}
		return extension;
	}
	
	
}
