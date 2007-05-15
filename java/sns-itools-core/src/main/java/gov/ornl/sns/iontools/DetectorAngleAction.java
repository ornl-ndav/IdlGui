package gov.ornl.sns.iontools;

public class DetectorAngleAction {

	/*
	 * This function checks if the detector angle text field is empty or not and 
	 * changes the background or not according to the instrument selected
	 */
	static void validatingDetectorAngleText() {
	
		if (DataReduction.instrument.compareTo(IParameters.REF_M)==0) {
			if (DataReduction.detectorAngleTextField.getText().compareTo("")==0) {
				DataReduction.detectorAngleTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_EMPTY);
			} else {	
				DataReduction.detectorAngleTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_FULL);
			}
		} else {
			DataReduction.detectorAngleTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_FULL);
		}
	}

	/*
	 * This function checks if the detector angle error text field is empty or not and 
	 * changes the background or not according to the instrument selected
	 */
	static void validatingDetectorAnglePMText() {
	
		if (DataReduction.instrument.compareTo(IParameters.REF_M)==0) {
			if (DataReduction.detectorAnglePMTextField.getText().compareTo("")==0) {
				DataReduction.detectorAnglePMTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_EMPTY);
			} else {	
				DataReduction.detectorAnglePMTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_FULL);
			}
		} else {
			DataReduction.detectorAnglePMTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_FULL);
		}
	}
	
	
}
