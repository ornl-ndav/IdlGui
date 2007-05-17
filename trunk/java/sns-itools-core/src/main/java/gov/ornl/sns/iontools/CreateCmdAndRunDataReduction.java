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

public class CreateCmdAndRunDataReduction {

	//retrieve all parameters
   static String  sSignalPidFileName;
   static String  sBackPidFileName;
   static String  sWavelengthMin;
   static String  sWavelengthMax;
   static String  sWavelengthWidth;
   static String  sDetectorAngle;
   static String  sDetectorAnglePM;
   static boolean bDetectorAngleRadians;
   static boolean bNormalization;
   static String  sNormalization;
   static boolean bBackground;
   static boolean bNormalizationBackground;
   static boolean bIntermediateFileOutput;
   static boolean bCombineDataSpectrum;
   static boolean bOverwriteInstrumentGeometry;
   static String  sInstrumentGeometry;
   static boolean bAddNexusAndGo;
   static String  sRunsNumber;
   static String  sInstrument;
   static String  cmd = "";
   static String  sDataReductionCmd = "";
   
   static void reinitializeLocalVariables() {
	   
	   sSignalPidFileName = DataReduction.liveParameters.getSignalPidFile();
	   sBackPidFileName = DataReduction.liveParameters.getBackPidFile();
	   sWavelengthMin = DataReduction.liveParameters.getWavelengthMin();
	   sWavelengthMax = DataReduction.liveParameters.getWavelengthMax(); 
	   sWavelengthWidth = DataReduction.liveParameters.getWavelengthWidth();
	   sDetectorAngle = DataReduction.liveParameters.getDetectorAngle();
	   sDetectorAnglePM = DataReduction.liveParameters.getDetectorAnglePM();
	   bNormalization = DataReduction.liveParameters.isNormalizationSwitch();
	   sNormalization = DataReduction.liveParameters.getNormalizationRunNumber();
	   bBackground = DataReduction.liveParameters.isBackgroundSwitch();
	   bNormalizationBackground = DataReduction.liveParameters.isNormalizationBackgroundSwitch();
	   bIntermediateFileOutput = DataReduction.liveParameters.isIntermediatePlotsSwitch();
	   bCombineDataSpectrum = DataReduction.liveParameters.isCombineDataSpectrum();
	   bOverwriteInstrumentGeometry = DataReduction.liveParameters.isOverwriteInstrumentGeometry();
	   sInstrumentGeometry = DataReduction.liveParameters.getInstrumentGeometry();
	   bAddNexusAndGo = DataReduction.liveParameters.isAddNexusAndGo();
	   sInstrument = DataReduction.liveParameters.getInstrument();
   }
   
	static String createDataReductionCmd () {
		
		reinitializeLocalVariables();
		
		if (sInstrument.compareTo(IParameters.REF_L) == 0) { //REF_L
			sDataReductionCmd = createReflDataReductionCmd();
		} else { //REF_M
			sDataReductionCmd = createRefmDataReductionCmd();
		}
		return cmd;
	}
	
	static String createReflDataReductionCmd() {

		//Add nexus and go
		if (bAddNexusAndGo) {
			sRunsNumber = DataReduction.liveParameters.getAddNexusAndGoString();		
			cmd = createReflAddNexusDataReductionCmd();
		} else { //Run Sequentially
			sRunsNumber = DataReduction.liveParameters.getGoSequentiallyString();
			cmd = createReflGoSequentiallyDataReductionCmd();
		}
		return cmd;
	}
	
	
	static String createReflAddNexusDataReductionCmd() {
		cmd = IParameters.REF_L_DATA_REDUCTION_CMD ;
		cmd += " " + sRunsNumber;
		
		if (bNormalization) {
			cmd += " " + IParameters.NORMALIZATION_FLAG + sNormalization;
		}
		
		if (bOverwriteInstrumentGeometry) {
			cmd += " " + IParameters.INSTRUMENT_GEOMETRY_FLAG + sInstrumentGeometry; 
		}
		
		if (bCombineDataSpectrum) {
			cmd += " " + IParameters.COMBINE_FLAG;
		}
		
		cmd += " " + IParameters.SIGNAL_ROI_FILE_FLAG + sSignalPidFileName;
		cmd += " " + IParameters.BKG_ROI_FILE_FLAG + sBackPidFileName;
		
		if (!bBackground) {
			cmd += " " + IParameters.NO_BKG_FLAG;
		}
		
		if (!bNormalizationBackground) {
			cmd += " " + IParameters.NO_NORM_BKG;
		}
		
		return cmd;
	}
	

	static String createReflGoSequentiallyDataReductionCmd() {
	
		return cmd;
		}

	
	static String createRefmDataReductionCmd() {

     	//Add nexus and go
		if (bAddNexusAndGo) {
			sRunsNumber = DataReduction.liveParameters.getAddNexusAndGoString();		
			cmd = createRefmAddNexusDataReductionCmd();
		} else { //Run Sequentially
			sRunsNumber = DataReduction.liveParameters.getGoSequentiallyString();
			cmd = createRefmGoSequentiallyDataReductionCmd();
		}
	
		return cmd;
	
		}

	
	static String createRefmAddNexusDataReductionCmd() {
		
		cmd = IParameters.REF_M_DATA_REDUCTION_CMD ;
		cmd += " " + sRunsNumber;
		
		if (bNormalization) {
			cmd += " " + IParameters.NORMALIZATION_FLAG + sNormalization;
		}
		
		if (bOverwriteInstrumentGeometry) {
			cmd += " " + IParameters.INSTRUMENT_GEOMETRY_FLAG + sInstrumentGeometry; 
		}
		
		/* not yet available
		if (bCombineDataSpectrum) {
			cmd += " " + IParameters.COMBINE_FLAG;
		}
		*/
		
		cmd += " " + IParameters.SIGNAL_ROI_FILE_FLAG + sSignalPidFileName;
		cmd += " " + IParameters.BKG_ROI_FILE_FLAG + sBackPidFileName;
		
		if (!bBackground) {
			cmd += " " + IParameters.NO_BKG_FLAG;
		}
		
		if (!bNormalizationBackground) {
			cmd += " " + IParameters.NO_NORM_BKG;
		}
		
		cmd += " " + IParameters.WAVELENGTH_BINS_FLAG;
		cmd += sWavelengthMin + "," + sWavelengthMax + "," + sWavelengthWidth;
		
		cmd += " " + IParameters.DET_ANGLE_FLAG;
		cmd += sDetectorAngle + "," + sDetectorAnglePM;
		
		return cmd;
	
	}
	
	static String createRefmGoSequentiallyDataReductionCmd() {
		return cmd;
	}
	
}
