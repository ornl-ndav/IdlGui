package gov.ornl.sns.iontools;

public class SettingsPanelAction {

	static boolean bSelected;
	
	/*
	 * This function makes sure that all the tabs
	 * of the 'parameters to keep between runs'
	 * are checked 
	 */
	static void selectAllSettingsTab() {
		
		bSelected = true;
		checkCheckBoxesStates(bSelected);
		
			}
	
	/*
	 * This function makes sure that all the tabs
	 * of the 'parameters to keep between runs'
	 * are unchecked 
	 */
	static void unselectAllSettingsTab() {

		bSelected = false;
		checkCheckBoxesStates(bSelected);

	}
	
	/*
	 * Function that actives or not the checkboxes of the settings tab
	 */
	static void checkCheckBoxesStates(boolean bSelected) {

		DataReduction.saveBackgroundCheckBox.setSelected(bSelected);
		DataReduction.saveAddAndGoRunNumberCheckBox.setSelected(bSelected);
		DataReduction.saveBackPidFileCheckBox.setSelected(bSelected);
		DataReduction.saveCombineDataSpectrumCheckBox.setSelected(bSelected);
		DataReduction.saveDetectorAngleCheckBox.setSelected(bSelected);
		DataReduction.saveDetectorAnglePMCheckBox.setSelected(bSelected);
		DataReduction.saveDetectorAngleUnitsCheckBox.setSelected(bSelected);
		DataReduction.saveGoSequentiallyCheckBox.setSelected(bSelected);
		DataReduction.saveIntermediateFileOutputCheckBox.setSelected(bSelected);
		DataReduction.saveMaxWavelengthCheckBox.setSelected(bSelected);
		DataReduction.saveMinWavelengthCheckBox.setSelected(bSelected);
		DataReduction.saveNormalizationBackgroundCheckBox.setSelected(bSelected);
		DataReduction.saveNormalizationCheckBox.setSelected(bSelected);
		DataReduction.saveOverwriteInstrumentGeometryCheckBox.setSelected(bSelected);
		DataReduction.saveSignalPidFileCheckBox.setSelected(bSelected);
		DataReduction.saveWidthWavelengthCheckBox.setSelected(bSelected);

	}
	
}
