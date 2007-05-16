package gov.ornl.sns.iontools;

public class UpdateMainGUI {

	/*
	 * This function reinitialize display according to instrment selected
	 */
	static void prepareGUI() {
		
		if (DataReduction.instrument.compareTo(IParameters.REF_L)==0) { //REF_L
			
			//disable wavelength and detector angle panels
			DataReduction.wavelengthPanel.setVisible(false);
			DataReduction.detectorAnglePanel.setVisible(false);
			DataReduction.extraPlotsSRBCheckBox.setEnabled(true);
						
		} else { //REF_M
			
			//enable wavelength and detector angle panels
			DataReduction.wavelengthPanel.setVisible(true);
			DataReduction.detectorAnglePanel.setVisible(true);
			DataReduction.extraPlotsSRBCheckBox.setEnabled(false);
			DataReduction.noCombineSpectrumRadioButton.setEnabled(false);
			DataReduction.yesCombineSpectrumRadioButton.setSelected(true);
			
		}
	}
	
}
