package gov.ornl.sns.iontools;

import com.rsi.ion.*;

public class ExtraPlots {
	
	static String sExtraPlotsCmd;
	static private String cmd;
	static private boolean bPlotFound;
	private static boolean bExtraPlotsSR;
	//private static boolean bExtraPlotsBS;
	private static boolean bExtraPlotsSRB;
	private static boolean bExtraPlotsNR;
	private static boolean bExtraPlotsBRN;
		
	static String createIDLcmd() {
		
		if (DataReduction.yesIntermediateRadioButton.isSelected()) { //we want some extra plots

			bExtraPlotsSR = DataReduction.liveParameters.isExtraPlotsSRselected();
		//	bExtraPlotsBS = DataReduction.liveParameters.isExtraPlotsBSselected();
			bExtraPlotsSRB = DataReduction.liveParameters.isExtraPlotsSRBselected();
			bExtraPlotsNR = DataReduction.liveParameters.isExtraPlotsNRselected();
			bExtraPlotsBRN = DataReduction.liveParameters.isExtraPlotsBRNselected();
			
			sExtraPlotsCmd = produceIDLcmd();
			
		} else {
			sExtraPlotsCmd = "";
		}
		
		return sExtraPlotsCmd;
	}
	
	/*
	 * Create the Command Line
	 */
	static String produceIDLcmd() {

		String result = "";
		if (bExtraPlotsSR) { result += " " + IParameters.DUMP_SPECULAR;}
		if (bExtraPlotsSRB) { result += " " + IParameters.DUMP_SUB;}
		if (bExtraPlotsNR) { result += " " + IParameters.DUMP_NORM;}
		if (bExtraPlotsBRN) { result += " " + IParameters.DUMP_NORM_BKG;}
				
		return result;
	}

	/*
	 * Function that output the extra plots required
	 */
	static void plotExtraPlots() {

		boolean bPlotFile;
		
		//Signal Region summed vs TOF
		if (DataReduction.liveParameters.isExtraPlotsSRBselected()) {
			cmd = createCmd(IParameters.SR_EXTENSION,
							IParameters.SR_TITLE);
			DataReduction.c_ionCon.setDrawable(DataReduction.c_SRextraPlots);	
			bPlotFile = runCmd(cmd);
		}
		
		//Background summed vs TOF
		if (DataReduction.liveParameters.isExtraPlotsBSselected()) {
			cmd = createCmd(IParameters.BS_EXTENSION,
							IParameters.BS_TITLE);
			DataReduction.c_ionCon.setDrawable(DataReduction.c_BSextraPlots);
			bPlotFile = runCmd(cmd);
		}
		
		//Signal region with background summed vs TOF
		if (DataReduction.liveParameters.isExtraPlotsSRBselected()) {
			cmd = createCmd(IParameters.SRB_EXTENSION,
							IParameters.SRB_TITLE);
			DataReduction.c_ionCon.setDrawable(DataReduction.c_SRBextraPlots);
			bPlotFile = runCmd(cmd);
		}
		
		//Normalization region summed vs TOF
		if (DataReduction.liveParameters.isExtraPlotsNRselected()) {
			cmd = createCmd(IParameters.NR_EXTENSION,
							IParameters.NR_TITLE);
			DataReduction.c_ionCon.setDrawable(DataReduction.c_NRextraPlots);
			bPlotFile = runCmd(cmd);
		}
		
		//Background region from normalization summed TOF
		if (DataReduction.liveParameters.isExtraPlotsBRNselected()) {
			cmd = createCmd(IParameters.BRN_EXTENSION,
							IParameters.BRN_TITLE);
			DataReduction.c_ionCon.setDrawable(DataReduction.c_BRNextraPlots);
			bPlotFile = runCmd(cmd);
		}
	}
	
	/*
	 * This function creates the command line for each extra plots
	 */
	static private String createCmd(String extension, String title) {
			
		String cmd;
		IONVariable ionTitle = new IONVariable(title);
		IONVariable ionExtension = new IONVariable(extension);
		
		cmd = "result = plot_extra_plots(" + DataReduction.ionInstrument;
		cmd += "," + DataReduction.runNumberValue;
		cmd += "," + DataReduction.ionOutputPath;
		cmd += "," + ionExtension;
		cmd += "," + ionTitle + ")";
		
		return cmd;
	}
	
	/*
	 * This function executes the command line
	 */
	static private boolean runCmd(String cmd) {
		
		IonUtils.executeCmd(cmd);
	    		
		IONVariable myIONresult;
		myIONresult = IonUtils.queryVariable("result");
		String[] myResultArray;
		myResultArray = myIONresult.getStringArray();

		System.out.println("myResultArray[0]= " + myResultArray[0]);
		
		if (myResultArray[0].compareTo("0") == 0) {
			bPlotFound = false;
		} else {
			bPlotFound = true;
		}
		return bPlotFound;
	}
	
}
