package gov.ornl.sns.iontools;

public class NormalizationAction {

	static void yesNormalization() {
	
		DataReduction.normalizationTextField.setEnabled(true);
		DataReduction.normalizationTextBoxLabel.setEnabled(true);
		CheckDataReductionButtonValidation.bNormalizationSwitch = true;
		if (CheckDataReductionButtonValidation.sNormalizationRunNumber.compareTo("")==0) {
			DataReduction.normalizationTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_EMPTY);
		} else {
			DataReduction.normalizationTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_FULL);
		}
		DataReduction.extraPlotsNRCheckBox.setEnabled(true);
	}

	static void noNormalization() {
		
		DataReduction.normalizationTextField.setEnabled(false);
		DataReduction.normalizationTextBoxLabel.setEnabled(false);
		DataReduction.normalizationTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_FULL);
		CheckDataReductionButtonValidation.bNormalizationSwitch = false;
	   	DataReduction.extraPlotsNRCheckBox.setEnabled(false);
	}
		
}
