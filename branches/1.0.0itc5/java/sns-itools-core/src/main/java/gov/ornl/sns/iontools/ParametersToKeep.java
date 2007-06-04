package gov.ornl.sns.iontools;

import java.awt.Color;

public class ParametersToKeep {

	static boolean bSaveSignalPidFileCheckBox 				      = IParameters.KEEP_SIGNAL_PID_FILE_NAME;
	static boolean bSaveBackPidFileCheckBox 				        = IParameters.KEEP_BACKGROUND_PID_FILE_NAME;
	static boolean bSaveMinWavelengthCheckBox				        = IParameters.KEEP_MIN_WAVELENGTH;
	static boolean bSaveMaxWavelengthCheckBox				        = IParameters.KEEP_MAX_WAVELENGTH;
	static boolean bSaveWidthWavelengthCheckBox				      = IParameters.KEEP_WIDTH_WAVELENGTH;
	static boolean bSaveDetectorAngleCheckBox		       		  = IParameters.KEEP_DETECTOR_ANGLE;
	static boolean bSaveDetectorAnglePMCheckBox				      = IParameters.KEEP_DETECTOR_ANGLE_PM;
	static boolean bSaveDetectorAngleUnitsCheckBox          = IParameters.KEEP_DETECTOR_ANGLE_UNITS;
	static boolean bSaveNormalizationCheckBox 			       	= IParameters.KEEP_NORMALIZATION;
	static boolean bSaveBackgroundCheckBox 					        = IParameters.KEEP_BACKGROUND;
	static boolean bSaveNormalizationBackgroundCheckBox 	  = IParameters.KEEP_NORMALIZATION_BACKGROUND;
	static boolean bSaveIntermediateFileOutputCheckBox 		  = IParameters.KEEP_INTERMEDIATE_FILE_OUTPUT;
	static boolean bSaveCombineDataSpectrumCheckBox 		    = IParameters.KEEP_COMBINE_DATA_SPECTRUM;
	static boolean bSaveOverwriteInstrumentGeometryCheckBox = IParameters.KEEP_OVERWRITE_INSTRUMENT_GEOMETRY;
	static boolean bSaveAddAndGoRunNumberCheckBox 		    	= IParameters.KEEP_ADD_NEXUS_AND_GO;
	static boolean bSaveGoSequentiallyCheckBox 				      = IParameters.KEEP_GO_SEQUENTIALLY;
	static boolean bFirstRunEver 							              = true;
  static String sSessionWorkingDirectory 				          = "";
  static boolean bThreadInProcess                         = false;
	static int     iNbrInfoLinesNotXmlToDisplayed           = IParameters.i_NO_RMD_NBR_LINE_DISPLAYED;
	static int     iNbrInfoLinesXmlToDisplayed              = IParameters.i_RMD_NBR_LINE_DISPLAYED;
  
  /*
	 * Reinitialize all the parameters
	 */
	static void initializeParametersToKeep() {
	
		//keep or not Signal Pid file check box
		if (DataReduction.saveSignalPidFileCheckBox.isSelected()) {
			bSaveSignalPidFileCheckBox = true;
		} else {
			bSaveSignalPidFileCheckBox = false;
		}
		
		//keep or not Back Pid file check box
		if (DataReduction.saveBackPidFileCheckBox.isSelected()) {
			bSaveBackPidFileCheckBox = true;
		} else {
			bSaveBackPidFileCheckBox = false;
		}
	
		//keep or not min wavelength 
		if (DataReduction.saveMinWavelengthCheckBox.isSelected()) {
			bSaveMinWavelengthCheckBox = true;
		} else {
			bSaveMinWavelengthCheckBox = false;
		}
		
		//keep or not max wavelength
		if (DataReduction.saveMaxWavelengthCheckBox.isSelected()) {
			bSaveMaxWavelengthCheckBox = true;
		} else {
			bSaveMaxWavelengthCheckBox = false;
		}
		
		//keep or not width wavelength
		if (DataReduction.saveWidthWavelengthCheckBox.isSelected()) {
			bSaveWidthWavelengthCheckBox = true;
		} else {
			bSaveWidthWavelengthCheckBox = false;
		}
		
		//keep or not detector angle
		if (DataReduction.saveDetectorAngleCheckBox.isSelected()) {
			bSaveDetectorAngleCheckBox = true;
		} else {
			bSaveDetectorAngleCheckBox = false;
		}
		
		//keep or not detector angle incertitude
		if (DataReduction.saveDetectorAnglePMCheckBox.isSelected()) {
			bSaveDetectorAnglePMCheckBox = true;
		} else {
			bSaveDetectorAnglePMCheckBox = false;
		}
		
		//keep or not detector angle units
		if (DataReduction.saveDetectorAngleUnitsCheckBox.isSelected()) {
			bSaveDetectorAngleUnitsCheckBox = true;
		} else {
			bSaveDetectorAngleUnitsCheckBox = false;
		}
		
		//keep or not status of Normalization flag
		if (DataReduction.saveNormalizationCheckBox.isSelected()) {
			bSaveNormalizationCheckBox = true;
		} else {
			bSaveNormalizationCheckBox = false;
		}
		
		//keep or not status of backgorund flag
		if (DataReduction.saveBackgroundCheckBox.isSelected()) {
			bSaveBackgroundCheckBox = true;
		} else {
			bSaveBackgroundCheckBox = false;
		}
		
		//keep or not background normalization flag
		if (DataReduction.saveNormalizationBackgroundCheckBox.isSelected()) {
			bSaveNormalizationBackgroundCheckBox = true;
		} else {
			bSaveNormalizationBackgroundCheckBox = false;
		}
		
		//keep or not intermediate file flag
		if (DataReduction.saveIntermediateFileOutputCheckBox.isSelected()) {
			bSaveIntermediateFileOutputCheckBox = true;
		} else {
			bSaveIntermediateFileOutputCheckBox = false;
		}
		
		//keep or not combine data flag
		if (DataReduction.saveCombineDataSpectrumCheckBox.isSelected()) {
			bSaveCombineDataSpectrumCheckBox = true;
		} else {
			bSaveCombineDataSpectrumCheckBox = false;
		}
		
		//keep or not overwrite geometry flag
		if (DataReduction.saveOverwriteInstrumentGeometryCheckBox.isSelected()) {
			bSaveOverwriteInstrumentGeometryCheckBox = true;
		} else {
			bSaveOverwriteInstrumentGeometryCheckBox = false;
		}
		
		//keep or not add and run flag
		if (DataReduction.saveAddAndGoRunNumberCheckBox.isSelected()) {
			bSaveAddAndGoRunNumberCheckBox = true;
		} else {
			bSaveAddAndGoRunNumberCheckBox = false;
		}
		
		//keep or not go sequentially flag
		if (DataReduction.saveGoSequentiallyCheckBox.isSelected()) {
			bSaveGoSequentiallyCheckBox = true;
		} else {
			bSaveGoSequentiallyCheckBox = false;
		}
	}
	
  /*
   * This function tells the system that nothing has to be conserved
   */
  static void initializeNoParametersToKeep() {
    
    bSaveSignalPidFileCheckBox               = false;
    bSaveBackPidFileCheckBox                 = false;
    bSaveMinWavelengthCheckBox               = false;
    bSaveMaxWavelengthCheckBox               = false;
    bSaveWidthWavelengthCheckBox             = false;
    bSaveDetectorAngleCheckBox               = false;
    bSaveDetectorAnglePMCheckBox             = false;
    bSaveDetectorAngleUnitsCheckBox          = false;
    bSaveNormalizationCheckBox               = false;
    bSaveBackgroundCheckBox                  = false;
    bSaveNormalizationBackgroundCheckBox     = false;
    bSaveIntermediateFileOutputCheckBox      = false;
    bSaveCombineDataSpectrumCheckBox         = false;
    bSaveOverwriteInstrumentGeometryCheckBox = false;
    bSaveAddAndGoRunNumberCheckBox           = false;
    bSaveGoSequentiallyCheckBox              = false;
      
  }
  
  /*
   * This function is used when switching from one instrument to another
   * all the parameters have to be removed
   */
  static void refreshGuiWithNoParametersToKeep() {
    
    //tell the sytem that we don't want to keep anything
    initializeNoParametersToKeep();
    refreshGui();
    bFirstRunEver = true;
    
  }
  
  
  /*
   * This function checks which parameters we want to keep
   */
	static void refreshGuiWithParametersToKeep() {
	
		//initialize parameters to keep or not
		initializeParametersToKeep();
		//outputData();
		refreshGui();
    
  }
  
  /*
   * This function reset or not all the fields of the applet
   */
  static void refreshGui() {
    
		if (!bFirstRunEver) { //refresh GUI only if it's not the first run ever
			if (!bSaveSignalPidFileCheckBox) { //remove pid signal
				DataReduction.signalPidFileButton.setEnabled(false);
				DataReduction.signalPidFileTextField.setText("");
				DataReduction.signalSelectionTextArea.setText("");
				DataReduction.clearSignalPidFileButton.setEnabled(false);
				DataReduction.signalPidFileTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_EMPTY);
				MouseSelectionParameters.signal_x1 = 0;
				MouseSelectionParameters.signal_x2 = 0;
				MouseSelectionParameters.signal_y1 = 0;
				MouseSelectionParameters.signal_y2 = 0;
			}
			if (!bSaveBackPidFileCheckBox) { //remove pid background
				DataReduction.backgroundPidFileButton.setEnabled(false);
				DataReduction.backgroundPidFileTextField.setText("");
				DataReduction.back1SelectionTextArea.setText("");
				DataReduction.back2SelectionTextArea.setText("");
				DataReduction.clearBackPidFileButton.setEnabled(false);
				DataReduction.backgroundPidFileTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_EMPTY);
				MouseSelectionParameters.back1_x1 = 0;
				MouseSelectionParameters.back1_x2 = 0;
				MouseSelectionParameters.back2_x1 = 0;
				MouseSelectionParameters.back2_x2 = 0;
				MouseSelectionParameters.back1_y1 = 0;
				MouseSelectionParameters.back1_y2 = 0;
				MouseSelectionParameters.back2_y1 = 0;
				MouseSelectionParameters.back2_y2 = 0;
			}
			if (!bSaveMinWavelengthCheckBox) { //min wavelength
				DataReduction.wavelengthMinTextField.setText("");
				DataReduction.wavelengthMinTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_EMPTY);
			}
			if (!bSaveMaxWavelengthCheckBox) { //max wavelength
				DataReduction.wavelengthMaxTextField.setText("");
				DataReduction.wavelengthMaxTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_EMPTY);
			}
			if (!bSaveWidthWavelengthCheckBox) { //width wavelength
				DataReduction.wavelengthWidthTextField.setText("");
				DataReduction.wavelengthWidthTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_EMPTY);
			}
			if (!bSaveDetectorAngleCheckBox) { //detector angle
				DataReduction.detectorAngleTextField.setText("");
				DataReduction.detectorAngleTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_EMPTY);
			}
			if (!bSaveDetectorAnglePMCheckBox) { //detector angle incertitude
				DataReduction.detectorAnglePMTextField.setText("");
				DataReduction.detectorAnglePMTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_EMPTY);
			}
			if (!bSaveDetectorAngleUnitsCheckBox) { //detector angle units
				DataReduction.detectorAngleUnuitsComboBox.setSelectedIndex(0);
			}
			if (!bSaveNormalizationCheckBox) { //normalizaiton check box
				DataReduction.yesNormalizationRadioButton.setSelected(IParameters.YES_NORMALIZATION_CHECK_BOX);
				DataReduction.normalizationLabel.setEnabled(IParameters.YES_NORMALIZATION_CHECK_BOX);
				DataReduction.normalizationTextField.setText("");
				DataReduction.normalizationTextField.setEnabled(IParameters.YES_NORMALIZATION_CHECK_BOX);
				if (IParameters.YES_NORMALIZATION_CHECK_BOX) {
					DataReduction.normalizationTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_EMPTY);
				} else {
					DataReduction.normalizationTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_FULL);
				}
			}
			if (!bSaveBackgroundCheckBox) { //background check box
				DataReduction.yesBackgroundRadioButton.setSelected(IParameters.YES_BACKGROUND_CHECK_BOX);
			}
			if (!bSaveNormalizationBackgroundCheckBox) { //normalization background check box
				DataReduction.yesNormBackgroundRadioButton.setSelected(IParameters.YES_NORMALIZATION_BACKGROUND_CHECK_BOX);
			}
			if (!bSaveIntermediateFileOutputCheckBox) { //remove intermediate file output
				DataReduction.intermediateButton.setEnabled(IParameters.YES_INTERMEDIATE_FILE_CHECK_BOX);
				DataReduction.yesIntermediateRadioButton.setSelected(IParameters.YES_INTERMEDIATE_FILE_CHECK_BOX);
				DataReduction.extraPlotsSRCheckBox.setSelected(IParameters.YES_INTERMEDIATE_SR);
				DataReduction.extraPlotsBSCheckBox.setSelected(IParameters.YES_INTERMEDIATE_BS);
				DataReduction.extraPlotsSRBCheckBox.setSelected(IParameters.YES_INTERMEDIATE_SRB);
				DataReduction.extraPlotsNRCheckBox.setSelected(IParameters.YES_INTERMEDIATE_NR);
				DataReduction.extraPlotsBRNCheckBox.setSelected(IParameters.YES_INTERMEDIATE_BRN);
				DataReduction.intermediateButton.setEnabled(IParameters.YES_INTERMEDIATE_FILE_CHECK_BOX);
			}
			if (!bSaveCombineDataSpectrumCheckBox) { //combine data spectrum
				DataReduction.yesCombineSpectrumRadioButton.setSelected(IParameters.YES_COMBINE_DATA_SPECTRUM);
			}
			if (!bSaveOverwriteInstrumentGeometryCheckBox) { //overwrite instrument geometry
				DataReduction.yesInstrumentGeometryRadioButton.setSelected(IParameters.YES_OVERWRITE_INSTRUMENT_GEOMETRY);
				DataReduction.instrumentGeometryButton.setEnabled(IParameters.YES_OVERWRITE_INSTRUMENT_GEOMETRY);
				DataReduction.instrumentGeometryTextField.setText("");
				DataReduction.instrumentGeometryTextField.setEnabled(IParameters.YES_OVERWRITE_INSTRUMENT_GEOMETRY);
				if (IParameters.YES_OVERWRITE_INSTRUMENT_GEOMETRY) {
					DataReduction.instrumentGeometryTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_EMPTY);
				} else {
					DataReduction.instrumentGeometryTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_FULL);
				}
			}
			if (!bSaveAddAndGoRunNumberCheckBox) { //Add NeXus and Go
				DataReduction.runsAddTextField.setText("");
			}
			if (!bSaveAddAndGoRunNumberCheckBox) { //Go Sequentially
				DataReduction.runsSequenceTextField.setText("");
			}
			
		}
	}
		
	static void outputData() {
		
		System.out.println("In Parameters to keep:\n");
		System.out.println("bSaveSignalPidFileCheckBox: " + bSaveSignalPidFileCheckBox);
		System.out.println("bSaveBackPidFileCheckBox: " + bSaveBackPidFileCheckBox);
		System.out.println("bSaveNormalizationCheckBox: " + bSaveNormalizationCheckBox);
		System.out.println("bSaveBackgroundCheckBox: " + bSaveBackgroundCheckBox);
		System.out.println("bSaveNormalizationBackgroundCheckBox" + bSaveNormalizationBackgroundCheckBox);
		System.out.println("bSaveIntermediateFileOutputCheckBox: " + bSaveIntermediateFileOutputCheckBox);
		System.out.println("bSaveCombineDataSpectrumCheckBox: " + bSaveCombineDataSpectrumCheckBox);
		System.out.println("bSaveOverwriteInstrumentGeometryCheckBox: " + bSaveOverwriteInstrumentGeometryCheckBox);
		System.out.println("bSaveAddAndGoRunNumberCheckBox: " + bSaveAddAndGoRunNumberCheckBox);
		System.out.println("bSaveGoSequentiallyCheckBox: " + bSaveGoSequentiallyCheckBox);
		System.out.println("bFirstRunEver: " + bFirstRunEver);
	}
		
}
