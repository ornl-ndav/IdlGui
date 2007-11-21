package gov.ornl.sns.iontools;

import java.awt.Color;

public class InstrumentGeometryAction {

	static void yesInstrumentGeometry() {
	
		DataReduction.instrumentGeometryButton.setEnabled(true);
		DataReduction.instrumentGeometryTextField.setEnabled(true);
		CheckDataReductionButtonValidation.bOverwriteInstrumentGeometry = true;

		if (CheckDataReductionButtonValidation.sInstrumentGeometry.compareTo("")==0) {
			DataReduction.instrumentGeometryTextField.setBackground(Color.RED);
		} else {
			DataReduction.instrumentGeometryTextField.setBackground(Color.WHITE);
		}
		
	}
	
	static void noInstrumentGeometry() {
    	
    	DataReduction.instrumentGeometryButton.setEnabled(false);
    	DataReduction.instrumentGeometryTextField.setEnabled(false);
    	CheckDataReductionButtonValidation.bOverwriteInstrumentGeometry = false;
    	DataReduction.instrumentGeometryTextField.setBackground(Color.WHITE);
	}
	
	
	
	
	
}
