package gov.ornl.sns.iontools;

public class ExtraPlotsPopulateAxis {

	private static String sEPtype;
	private static int index;
	
	public static void enabledOrNotAxis() {
		index = getTabIndex();
		boolean bEnabledAxis = isPlotAvailable();
		refreshAxisGUI(bEnabledAxis);
	}
	
	public static boolean isPlotAvailable() {
		boolean bPlotAvailable = false;
		if (index==0) {return ExtraPlotInterface.bSRBplot;}
		if (index==1) {return ExtraPlotInterface.bBSplot;}
		if (index==2) {return ExtraPlotInterface.bSRBplot;}
		if (index==3) {return ExtraPlotInterface.bNRplot;}
		if (index==4) {return ExtraPlotInterface.bBRNplot;}
		return bPlotAvailable;
	}
	
	public static void refreshAxisGUI(boolean bEnabledAxis) {
		DataReduction.xMaxTextFieldEP.setEnabled(bEnabledAxis);
		DataReduction.xMinTextFieldEP.setEnabled(bEnabledAxis);
		DataReduction.yMaxTextFieldEP.setEnabled(bEnabledAxis);
		DataReduction.yMinTextFieldEP.setEnabled(bEnabledAxis);
		DataReduction.linLogComboBoxXEP.setEnabled(bEnabledAxis);
		DataReduction.linLogComboBoxYEP.setEnabled(bEnabledAxis);
		DataReduction.xValidateButtonEP.setEnabled(bEnabledAxis);
		DataReduction.xResetButtonEP.setEnabled(bEnabledAxis);
		DataReduction.yValidateButtonEP.setEnabled(bEnabledAxis);
		DataReduction.yResetButtonEP.setEnabled(bEnabledAxis);
	}
		
	public static void populateAxis(boolean bFirstTime) {
		if (index == 0) {sEPtype = IParameters.SR;}
		if (index == 1) {sEPtype = IParameters.BS;}
		if (index == 2) {sEPtype = IParameters.SRB;}
		if (index == 3) {sEPtype = IParameters.NR;}
		if (index == 4) {sEPtype = IParameters.BRN;}
		populateXaxis(bFirstTime);
		populateYaxis(bFirstTime);
		populateXYScales(bFirstTime);
	}
	
	private static int getTabIndex() {
		int index = DataReduction.extraPlotsTabbedPane.getSelectedIndex();
		return index;
	}
	
	public static void populateXaxis(boolean bFirstTime) {
		String xmin = DataReduction.myEPinterface.getXMin(sEPtype, bFirstTime);
		DataReduction.xMinTextFieldEP.setText(xmin);

		String ymin = DataReduction.myEPinterface.getYMin(sEPtype, bFirstTime);
		DataReduction.yMinTextFieldEP.setText(ymin);
	}

	public static void populateYaxis(boolean bFirstTime) {
		String xmax = DataReduction.myEPinterface.getXMax(sEPtype, bFirstTime);
		DataReduction.xMaxTextFieldEP.setText(xmax);

		String ymax = DataReduction.myEPinterface.getYMax(sEPtype, bFirstTime);
		DataReduction.yMaxTextFieldEP.setText(ymax);
	}
	
	public static void populateXYScales(boolean bFirstTime) {
		String xScale = DataReduction.myEPinterface.getxScale(sEPtype, bFirstTime);
		if (xScale.compareTo(IParameters.LINEAR)==0) {
			DataReduction.linLogComboBoxXEP.setSelectedItem(IParameters.LINEAR);
		} else {
			DataReduction.linLogComboBoxXEP.setSelectedItem(IParameters.LOG10);
		}
		
		String yScale = DataReduction.myEPinterface.getyScale(sEPtype, bFirstTime);
		if (yScale.compareTo(IParameters.LINEAR)==0) {
			DataReduction.linLogComboBoxYEP.setSelectedItem(IParameters.LINEAR);
		} else {
			DataReduction.linLogComboBoxYEP.setSelectedItem(IParameters.LOG10);
		}
	}
}
