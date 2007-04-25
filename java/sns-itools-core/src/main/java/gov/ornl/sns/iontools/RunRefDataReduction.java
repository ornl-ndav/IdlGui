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

public class RunRefDataReduction {

	//retrieve all parameters
   static String sSignalPidFileName = CheckDataReductionButtonValidation.sSignalPidFile;
   static String sBackPidFileName = CheckDataReductionButtonValidation.sBackPidFile;
   static boolean bNormalization = CheckDataReductionButtonValidation.bNormalizationSwitch;
   static String sNormalization = CheckDataReductionButtonValidation.sNormalizationRunNumber;
   static boolean bBackground;
   static boolean bNormalizationBackground;
   static boolean bIntermediateFileOutput;
   static boolean bCombineDataSpectrum = CheckDataReductionButtonValidation.bCombineDataSpectrum;
   static boolean bOverwriteInstrumentGeometry = CheckDataReductionButtonValidation.bOverwriteInstrumentGeometry;
   static String sInstrumentGeometry = CheckDataReductionButtonValidation.sInstrumentGeometry;
   static boolean bAddNexusAndGo;
   static String sRunsNumber;
   static String sInstrument=CheckDataReductionButtonValidation.sInstrument;
   static String cmd = "";
   static String sDataReductionCmd = "";
   
   
   
	static String createDataReductionCmd () {
		
//		System.out.println("in createDataReductionCmd");
//		System.out.println("sSignalPidFileName: " + sSignalPidFileName);
		
		if (sInstrument.compareTo(IParameters.REF_L) == 0) { //REF_L
			sDataReductionCmd = createReflDataReductionCmd();
		} else {
			sDataReductionCmd = createRefmDataReductionCmd();
		}
		return cmd;
	}
	
	
	
	static String createReflDataReductionCmd() {
		//Add nexus and go
		if (CheckDataReductionButtonValidation.bAddNexusAndGo) {
			sRunsNumber = CheckDataReductionButtonValidation.sAddNexusAndGoString;
			cmd = createReflAddNexusDataReductionCmd();
		} else { //Run Sequentially
			sRunsNumber = CheckDataReductionButtonValidation.sGoSequentiallyString;
			cmd = createReflGoSequentiallyDataReductionCmd();
		}
		return cmd;
	}
	
	
	static String createReflAddNexusDataReductionCmd() {
		cmd = IParameters.REF_L_DATA_REDUCTION_CMD + " ";
		cmd += sRunsNumber + " ";
		
		if (bNormalization) {
			cmd += IParameters.REF_L_NORMALIZATION_FLAG + sNormalization + " ";
		}
		
		if (bOverwriteInstrumentGeometry) {
			cmd += IParameters.REF_L_INSTRUMENT_GEOMETRY_FLAG + sInstrumentGeometry + " "; 
		}
		
		if (bCombineDataSpectrum) {
			cmd += IParameters.REF_L_COMBINE_FLAG + " ";
		}
		
		cmd += IParameters.REF_L_SIGNAL_ROI_FILE_FLAG + sSignalPidFileName + " ";
		cmd += IParameters.REF_L_BKG_ROI_FILE_FLAG + sBackPidFileName + " ";
		
		if (!bBackground) {
			cmd += IParameters.REF_L_NO_BKG_FLAG + " ";
		}
		
		if (!bNormalizationBackground) {
			cmd += IParameters.REF_L_NO_NORM_BKG + " ";
		}
		
		//list of intermediate plots
	
		return cmd;
	}
	

	static String createReflGoSequentiallyDataReductionCmd() {
		
		return cmd;
	}







	static String createRefmDataReductionCmd() {
		return cmd;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
