package gov.ornl.sns.iontools;

import java.awt.Color;

public class ParametersToKeep {

	static boolean bSaveSignalPidFileCheckBox 				= IParameters.KEEP_SIGNAL_PID_FILE_NAME;
	static boolean bSaveBackPidFileCheckBox 				= IParameters.KEEP_BACKGROUND_PID_FILE_NAME;
	static boolean bSaveNormalizationCheckBox 				= IParameters.KEEP_NORMALIZATION;
	static boolean bSaveBackgroundCheckBox 					= IParameters.KEEP_BACKGROUND;
	static boolean bSaveNormalizationBackgroundCheckBox 	= IParameters.KEEP_NORMALIZATION_BACKGROUND;
	static boolean bSaveIntermediateFileOutputCheckBox 		= IParameters.KEEP_INTERMEDIATE_FILE_OUTPUT;
	static boolean bSaveCombineDataSpectrumCheckBox 		= IParameters.KEEP_COMBINE_DATA_SPECTRUM;
	static boolean bSaveOverwriteInstrumentGeometryCheckBox = IParameters.KEEP_OVERWRITE_INSTRUMENT_GEOMETRY;
	static boolean bSaveAddAndGoRunNumberCheckBox 			= IParameters.KEEP_ADD_NEXUS_AND_GO;
	static boolean bSaveGoSequentiallyCheckBox 				= IParameters.KEEP_GO_SEQUENTIALLY;
	static boolean bFirstRunEver 							= true;
    static String sSessionWorkingDirectory 				    = "";
	
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
	
	static void refreshGuiWithParametersToKeep() {
	
		//initialize parameters to keep or not
		initializeParametersToKeep();
		//outputData();
		
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
