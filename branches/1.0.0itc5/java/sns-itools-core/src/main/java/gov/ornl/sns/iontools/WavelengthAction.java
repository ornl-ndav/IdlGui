package gov.ornl.sns.iontools;

public class WavelengthAction {

	/*
	 * This function checks if the min wavelength text field is empty or not and 
	 * changes the background or not according to the instrument selected
	 */
	static void validatingWavelengthMinText() {
	
		if (DataReduction.instrument.compareTo(IParameters.REF_M)==0) {
			if (DataReduction.wavelengthMinTextField.getText().compareTo("")==0) {
				DataReduction.wavelengthMinTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_EMPTY);
			} else {	
				DataReduction.wavelengthMinTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_FULL);
			}
		} else {
			DataReduction.wavelengthMinTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_FULL);
		}
	}

	/*
	 * This function checks if the max wavelength text field is empty or not and 
	 * changes the background or not according to the instrument selected.
	 */
	static void validatingWavelengthMaxText() {
		
		if (DataReduction.instrument.compareTo(IParameters.REF_M)==0) {
			if (DataReduction.wavelengthMaxTextField.getText().compareTo("")==0) {
				DataReduction.wavelengthMaxTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_EMPTY);
			} else {	
				DataReduction.wavelengthMaxTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_FULL);
			}
		} else {
			DataReduction.wavelengthMaxTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_FULL);
		}
	}
	
	/*
	 * This functions checks if the width wavelength text field is empty or not and
	 * changes the background color or not according to the instrument selected
	 */
	static void validatingWavelengthWidthText() {
		
		if (DataReduction.instrument.compareTo(IParameters.REF_M)==0) {
			if (DataReduction.wavelengthWidthTextField.getText().compareTo("")==0) {
				DataReduction.wavelengthWidthTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_EMPTY);
			} else {	
				DataReduction.wavelengthWidthTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_FULL);
			}
		} else {
			DataReduction.wavelengthWidthTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_FULL);
		}
	}

	
}