package gov.ornl.sns.iontools;

public class CheckGUI {

	  static void populateCheckDataReductionButtonValidationParameters() {
	    	
		  	CheckDataReductionButtonValidation.sRunNumber = DataReduction.runNumberTextField.getText();
	    	CheckDataReductionButtonValidation.sNormalizationRunNumber = DataReduction.normalizationTextField.getText(); 	    	
	    	CheckDataReductionButtonValidation.sAddNexusAndGoString = DataReduction.runsAddTextField.getText();     
	    	CheckDataReductionButtonValidation.sGoSequentiallyString = DataReduction.runsSequenceTextField.getText();    	
	    	CheckDataReductionButtonValidation.sInstrumentGeometry = DataReduction.instrumentGeometryTextField.getText();
	    	CheckDataReductionButtonValidation.sInstrument = DataReduction.instrument;   	
	    	
	    	if (DataReduction.runsTabbedPane.getSelectedIndex() == 0) {
	    		CheckDataReductionButtonValidation.bAddNexusAndGo = true;
	    	} else {
	    		CheckDataReductionButtonValidation.bAddNexusAndGo = false;
	    	}
	    	
	    }
	  
	  /*
	   * initialize the parameters when running the data reduction in combine mode
	   */
	  static void populateCheckDataReductionPlotCombineParameters(String[] myResultArray) {
		 
		  //x-axis
		 if (DataReduction.linLogComboBoxX.getSelectedIndex() == 0) {
			 ParametersConfiguration.bLinearXAxis = true;
		 } else {
			 ParametersConfiguration.bLinearXAxis = false;
		 }
		 ParametersConfiguration.sXMinInitial = myResultArray[0];
  		 ParametersConfiguration.sXMaxInitial = myResultArray[1];
  		  
		 //y-axis
		 if (DataReduction.linLogComboBoxY.getSelectedIndex() == 0) {
			 ParametersConfiguration.bLinearYAxis = true;
		 } else {
			 ParametersConfiguration.bLinearYAxis = false;
		 }
		 ParametersConfiguration.sYMinInitial = myResultArray[2];
  		 ParametersConfiguration.sYMaxInitial = myResultArray[3];
  		 
	  }
	
	  
	  /*
	   * initialize the parameters when running the data reduction in uncombine mode
	   */
	  static void populateCheckDataReductionPlotParameters(String[] myResultArray) {
		 
		  //y-axis
		 if (DataReduction.linLogComboBoxY.getSelectedIndex() == 0) {
			 ParametersConfiguration.bLinearYAxis = true;
		 } else {
			 ParametersConfiguration.bLinearYAxis = false;
		 }
		 ParametersConfiguration.sYMinInitial = myResultArray[0];
  		 ParametersConfiguration.sYMaxInitial = myResultArray[1];
  		 
	  }
	
	  
	  
	  
	  
	  
	  
	  /*
	   * initialize all the parameters for each event 
	   */
	  static void populateCheckDataReductionPlotParameters() {
		  
		  if (DataReduction.linLogComboBoxX.getSelectedIndex() == 0) {
				 ParametersConfiguration.bLinearXAxis = true;
			 } else {
				 ParametersConfiguration.bLinearXAxis = false;
			 }
			 ParametersConfiguration.sXMin = DataReduction.xMinTextField.getText();
	  		 ParametersConfiguration.sXMax = DataReduction.xMaxTextField.getText();
	  		  
			 //y-axis
			 if (DataReduction.linLogComboBoxY.getSelectedIndex() == 0) {
				 ParametersConfiguration.bLinearYAxis = true;
			 } else {
				 ParametersConfiguration.bLinearYAxis = false;
			 }
			 ParametersConfiguration.sYMin = DataReduction.yMinTextField.getText();
	  		 ParametersConfiguration.sYMax = DataReduction.yMaxTextField.getText();
	  		 
		  }

	  /*
	   * enabled x-axis of Data Reduction plot for combine data only
	   */
	  static void enableDataReductionPlotXAxis() {
		
		  DataReduction.xMaxTextField.setVisible(true);
		  DataReduction.xMinTextField.setVisible(true);
		  DataReduction.xResetButton.setVisible(true);
		  DataReduction.xValidateButton.setVisible(true);
		  DataReduction.labelXaxis.setVisible(true);
		  DataReduction.linLogComboBoxX.setVisible(true);
		  DataReduction.maxLabel.setVisible(true);
		  DataReduction.minLabel.setVisible(true);
		  
	  }
	  
	  /*
	   * disable x-axis of Data Reduction plot for uncombine data
	   */
	  static void disableDataReductionPlotXAxis() {
		  
		  DataReduction.xMaxTextField.setVisible(false);
		  DataReduction.xMinTextField.setVisible(false);
		  DataReduction.xResetButton.setVisible(false);
		  DataReduction.xValidateButton.setVisible(false);
		  DataReduction.labelXaxis.setVisible(false);
		  DataReduction.linLogComboBoxX.setVisible(false);
		  DataReduction.maxLabel.setVisible(false);
		  DataReduction.minLabel.setVisible(false);
		  
	  }



}
