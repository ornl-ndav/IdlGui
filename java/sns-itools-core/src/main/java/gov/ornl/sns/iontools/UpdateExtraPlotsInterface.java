package gov.ornl.sns.iontools;

import com.rsi.ion.*;

public class UpdateExtraPlotsInterface {

	static int iTabIndex;
	static String type;
	static String xScale;
	static String yScale;
	static String xmin;
	static String ymin;
	static String xmax;
	static String ymax;
	static String sExtension;
	static String sTitle;
	static String[] sExTi;
	static String cmd;
	
	static IONVariable ionXScale; 
	static IONVariable ionYScale;
	static IONVariable ionXmin;
	static IONVariable ionYmin;
	static IONVariable ionXmax;
	static IONVariable ionYmax;
	static IONVariable ionOutputPath;
	static IONVariable ionExtension;
	static IONVariable ionTitle;
	static IONVariable ionRunNumber;
	static IONVariable ionInstrument;
	
	static void updateExtraPlotsGUI() {
		
		getEPTabIndex();   	     //get index of current tab selected
		getExtensionTitle();     //get extension according to index
		getXYvalues();           //get x and y min and max from text boxes
		getXYscale();    	     //get x and y scale (log10 or linear)
		//debugOutput();
		cmd = createCMD();
		//debugOutput();
		replot();
		
		String[] xyMinMax = {xmin, ymin, xmax, ymax};
		String[] xyScale = {xScale, yScale};
		DataReduction.myEPinterface = new ExtraPlotInterface(
				type,
				xyMinMax,
				xyScale,
				DataReduction.bEPFirstTime);
		
		ExtraPlotsPopulateAxis.populateAxis(DataReduction.bEPFirstTime);
	}
	
	static void refreshExtraPlotsGUI() {
		
		getEPTabIndex();   	     //get index of current tab selected
		getXYvaluesFT();         //get x and y min and max from first plot
		getXYscale();    	     //get x and y scale (log10 or linear)
		getExtensionTitle();     //get extension according to index
		//debugOutput();
		cmd = createCMD();
		//debugOutput();
		replot();
		
		String[] xyMinMax = {xmin, ymin, xmax, ymax};
		String[] xyScale = {xScale, yScale};
		DataReduction.myEPinterface = new ExtraPlotInterface(
				type,
				xyMinMax,
				xyScale,
				DataReduction.bEPFirstTime);
		
		ExtraPlotsPopulateAxis.populateAxis(DataReduction.bEPFirstTime);
	}
	
	
	
	static void replot() {
		
		if (type.compareTo(IParameters.SR)==0) {
			DataReduction.c_ionCon.setDrawable(DataReduction.c_SRextraPlots);	
		}
		if (type.compareTo(IParameters.BS)==0) {
			DataReduction.c_ionCon.setDrawable(DataReduction.c_BSextraPlots);
		}
		if (type.compareTo(IParameters.SRB)==0) {
			DataReduction.c_ionCon.setDrawable(DataReduction.c_SRBextraPlots);
		}
		if (type.compareTo(IParameters.NR)==0) {
			DataReduction.c_ionCon.setDrawable(DataReduction.c_NRextraPlots);
		}
		if (type.compareTo(IParameters.BRN)==0) {
			DataReduction.c_ionCon.setDrawable(DataReduction.c_BRNextraPlots);
		}
		runCmd();
	}
	
	/*
	 * This function executes the command line
	 */
	static private void runCmd() {
		
		IonUtils.executeCmd(cmd);
	    		
	}
	
	static String createCMD() {
		
		ionXScale = new IONVariable(xScale);
		ionYScale = new IONVariable(yScale);
		ionXmin = new IONVariable(xmin);
		ionYmin = new IONVariable(ymin);
		ionXmax = new IONVariable(xmax);
		ionYmax = new IONVariable(ymax);
		ionOutputPath = new IONVariable(IParameters.WORKING_PATH + "/" + DataReduction.instrument);
		ionRunNumber = new IONVariable(DataReduction.runNumberValue);
		ionInstrument = new IONVariable(DataReduction.instrument);
		ionExtension = new IONVariable(sExtension);
		ionTitle = new IONVariable(sTitle); 
		
		String cmd;
		cmd = "replot_extra_plots, ";
		cmd += ionInstrument + ",";
		cmd += ionRunNumber + ",";
		cmd += ionOutputPath + ",";
		cmd += ionExtension + ",";
		cmd += ionTitle + ",";
		cmd += ionXScale + ",";
		cmd += ionXmin + "," + ionXmax + ",";
		cmd += ionYScale + ",";
		cmd += ionYmin + "," + ionYmax;
		
		return cmd;
		
	}
	
	static void getEPTabIndex() {
		iTabIndex = DataReduction.extraPlotsTabbedPane.getSelectedIndex();
	}
	
	static void getXYvalues() {
		xmin = DataReduction.xMinTextFieldEP.getText();
		ymin = DataReduction.yMinTextFieldEP.getText();
		xmax = DataReduction.xMaxTextFieldEP.getText();
		ymax = DataReduction.yMaxTextFieldEP.getText();
	}
	
	static void getXYvaluesFT() {
		xmin = DataReduction.myEPinterface.getXMin(type, true);
		ymin = DataReduction.myEPinterface.getYMin(type, true);
		xmax = DataReduction.myEPinterface.getXMax(type, true);
		ymax = DataReduction.myEPinterface.getYMax(type, true);
	}
	
	static void getXYscale() {
		int iXScaleIndex, iYScaleIndex;
		iXScaleIndex = getXScaleIndex();
		iYScaleIndex = getYScaleIndex();
		if (iXScaleIndex==0) {
			xScale = IParameters.LINEAR;
		} else {
			xScale = IParameters.LOG10;
		}
		if (iYScaleIndex==0) {
			yScale = IParameters.LINEAR;
		} else {
			yScale = IParameters.LOG10;
		}
		
	}
	
	static int getXScaleIndex() {
		return DataReduction.linLogComboBoxXEP.getSelectedIndex();
	}
	
	static int getYScaleIndex() {
		return DataReduction.linLogComboBoxYEP.getSelectedIndex();
	}
	
	
	
	static void getExtensionTitle() {
		if (iTabIndex==0) {
			sExtension = IParameters.SR_EXTENSION;
			sTitle = IParameters.SR_TITLE;
			type = IParameters.SR;
		}
		if (iTabIndex==1) {
			sExtension = IParameters.BS_EXTENSION;
			sTitle = IParameters.BS_TITLE;
			type = IParameters.BS;
		}
		if (iTabIndex==2) {
			sExtension = IParameters.SRB_EXTENSION;
			sTitle = IParameters.SRB_EXTENSION;
			type = IParameters.SRB;
		}
		if (iTabIndex==3) {
			sExtension = IParameters.NR_EXTENSION;
			sTitle = IParameters.NR_TITLE;
			type = IParameters.NR;
		}
		if (iTabIndex==4) {
			sExtension = IParameters.BRN_EXTENSION;
			sTitle = IParameters.BRN_TITLE;
			type = IParameters.BRN;
		}
	}

	static void debugOutput() {
		System.out.println("iTabIndex: " + iTabIndex);
		System.out.println("type     : " + type);
		System.out.println("xScale   : " + xScale);
		System.out.println("yScale   : " + yScale);
		System.out.println("xmin     : " + xmin);
		System.out.println("ymin     : " + ymin);
		System.out.println("xmax     : " + xmax);
		System.out.println("ymax     : " + ymax);
		System.out.println("sExtension: " + sExtension);
		System.out.println("sTitle   : " + sTitle);
		System.out.println("cmd: " + cmd);
	}
	
	
	
}
