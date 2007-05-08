package gov.ornl.sns.iontools;

import java.awt.Color;

public class NormalizationAction {

	static void yesNormalization() {
	
		DataReduction.normalizationTextField.setEnabled(true);
		DataReduction.normalizationTextBoxLabel.setEnabled(true);
		CheckDataReductionButtonValidation.bNormalizationSwitch = true;
		if (CheckDataReductionButtonValidation.sNormalizationRunNumber.compareTo("")==0) {
			DataReduction.normalizationTextField.setBackground(Color.RED);
		} else {
			DataReduction.normalizationTextField.setBackground(Color.WHITE);
		}
		DataReduction.extraPlotsNRCheckBox.setEnabled(true);
	}

	static void noNormalization() {
		
		DataReduction.normalizationTextField.setEnabled(false);
		DataReduction.normalizationTextBoxLabel.setEnabled(false);
		DataReduction.normalizationTextField.setBackground(Color.WHITE);
		CheckDataReductionButtonValidation.bNormalizationSwitch = false;
	   	DataReduction.extraPlotsNRCheckBox.setEnabled(false);
	}
		
}
