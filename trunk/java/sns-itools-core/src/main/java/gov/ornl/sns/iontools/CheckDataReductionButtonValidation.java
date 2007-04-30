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

public class CheckDataReductionButtonValidation {

	private static boolean bValidateGoDataReductionButton = true;	
	
    //status of DataReduction tab widgets
    static String sInstrument = "";
	static String sSignalPidFile = "";
    static String sBackPidFile = "";
	static String sRunNumber = "";
	static boolean bSignalPidFileSaved = false;
    static boolean bBackPidFileSaved = false; 	
    static boolean bNormalizationSwitch = true;   
    static String  sNormalizationRunNumber = "";
    static boolean bBackgroundSwitch = true;
    static boolean bIntermediatePlotsSwitch = false;
    static boolean bCombineDataSpectrum = false;
    static boolean bOverwriteInstrumentGeometry = false;
    static String  sInstrumentGeometry = "";
    static boolean bAddNexusAndGo = true;           
    static String  sAddNexusAndGoString = "";
    static String  sGoSequentiallyString = "";
    
	static boolean checkDataReductionButtonStatus() {

//		System.out.println("in checkDataReductionButtonStatus()");
//		System.out.println("sSignaPidFile: " + sSignalPidFile);
//		System.out.println("bSignalPidFileSaved: " + bSignalPidFileSaved);
//		System.out.println("bBackPidFileSaved: " + bBackPidFileSaved);
//		System.out.println("bNormalizationSwitch: " + bNormalizationSwitch);
//		System.out.println("sNormalizationRunNumber: " + sNormalizationRunNumber);
//		System.out.println("bOverwriteInstrumentGeometry: " + bOverwriteInstrumentGeometry);
//		System.out.println("sInstrumentGeometry: " + sInstrumentGeometry);
//		System.out.println("bAddNexusAndGo: " + bAddNexusAndGo);
//		System.out.println("sAddNexusAndGoString: " + sAddNexusAndGoString);

		if (sRunNumber.compareTo("") == 0) {return false;}
		if (!bSignalPidFileSaved) {return false;}  //no signal pid file has been saved, we can leave now
		if (!bBackPidFileSaved) {return false;}    //no back pid file has been saved, we can leave now
		if (bNormalizationSwitch) {
			if (sNormalizationRunNumber.compareTo("") == 0) {return false;}
		}
		if (bOverwriteInstrumentGeometry) {return false;}
		if (bAddNexusAndGo) {
			if (sAddNexusAndGoString.compareTo("") == 0) {return false;}
		} else {
			if (sGoSequentiallyString.compareTo("") == 0) {return false;}
		}
		
		return bValidateGoDataReductionButton ;
	}

}
