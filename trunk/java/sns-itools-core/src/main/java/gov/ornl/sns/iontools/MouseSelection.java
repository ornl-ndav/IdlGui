package gov.ornl.sns.iontools;

import com.rsi.ion.*;
import javax.swing.*;

public class MouseSelection {

	static int xmin;
	static int ymin;
	static int xmax;
	static int ymax;
	
	static String[] sSelectionInfo;
	static IONVariable ionTmpHistoFile;
	static IONVariable ionXmin;
	static IONVariable ionXmax;
	static IONVariable ionYmin;
	static IONVariable ionYmax;
	static IONVariable ionNx;
	static IONVariable ionNy;
	
	static String sSelectionHeight;
	static String sSelectionWidth;
	static String sNbrPixelInsideSelection;
	static String sNbrPixelOutsideSelection;
	static String sStartingPixelId;
	static String sEndingPixelId;
	static String sCountsStartingPixelId;
	static String sCountsEndingPixelId;
	static String sCountsInsideSelection;
	static String sCountsOutsideSelection;
	static String sAverageCountsInsideSelection;
	static String sAverageCountsOutsideSelection;
		
	static void saveXY(String mode,int x_min, int y_min, int x_max, int y_max) {
    	
		xmin = x_min;
		ymin = y_min;
		xmax = x_max;
		ymax = y_max;
		
		if (mode.compareTo(IParameters.SIGNAL_STRING) == 0) {  //signal selection
    		DataReduction.signal_xmin = x_min;
    		DataReduction.signal_ymin = y_min;
    		DataReduction.signal_xmax = x_max;
    		DataReduction.signal_ymax = y_max;
    	} else if (mode.compareTo(IParameters.BACK1_STRING) == 0) { //background1 selection
    		DataReduction.back1_xmin = x_min;
    		DataReduction.back1_ymin = y_min;
    		DataReduction.back1_xmax = x_max;
    		DataReduction.back1_ymax = y_max;
    	} else if (mode.compareTo(IParameters.BACK2_STRING) == 0) { //background2 selection
    		DataReduction.back2_xmin = x_min;
    		DataReduction.back2_ymin = y_min;
    		DataReduction.back2_xmax = x_max;
    		DataReduction.back2_ymax = y_max;
    	}
		
		getFullSelectionInfo(mode, x_min, y_min, x_max, y_max);
    }	
	
	/*
	 * Function that produces the output
	 */
	static void getFullSelectionInfo(String mode, int x_min, int y_min, int x_max, int y_max) {
		
		ionTmpHistoFile = new com.rsi.ion.IONVariable(DataReduction.sTmpOutputFileName);
		ionXmin = new com.rsi.ion.IONVariable(x_min); 
		ionXmax = new com.rsi.ion.IONVariable(x_max);
		ionYmin = new com.rsi.ion.IONVariable(y_min);
		ionYmax = new com.rsi.ion.IONVariable(y_max);
		ionNx = new com.rsi.ion.IONVariable(ParametersConfiguration.Nx);
		ionNy = new com.rsi.ion.IONVariable(ParametersConfiguration.Ny);
		
		String cmd = "selectionInfo = get_selection_info( "; 
		cmd += ionNx + "," + ionNy;
		cmd += "," + ionTmpHistoFile;
		cmd += "," + ionXmin + "," + ionYmin; 
		cmd += "," + ionXmax + "," + ionYmax;
		cmd += ")";

		IonUtils.executeCmd(cmd);
		
		IONVariable ionSelectionInfo = IonUtils.queryVariable("selectionInfo");
		String[] sSelectionInfo;
		sSelectionInfo = ionSelectionInfo.getStringArray();
	
		InitializeStrings(sSelectionInfo);
		ProduceSelectionInfoMessage(mode);
				
	}
	
		static void InitializeStrings(String[] sSelectionInfo) {
			
			int i=0;
			sSelectionHeight = sSelectionInfo[i++];
			sSelectionWidth = sSelectionInfo[i++];
			sNbrPixelInsideSelection = sSelectionInfo[i++];
			sNbrPixelOutsideSelection = sSelectionInfo[i++];
			sStartingPixelId = sSelectionInfo[i++];
			sEndingPixelId = sSelectionInfo[i++];
			sCountsStartingPixelId = sSelectionInfo[i++];
			sCountsEndingPixelId = sSelectionInfo[i++];
			sCountsInsideSelection = sSelectionInfo[i++];
			sCountsOutsideSelection = sSelectionInfo[i++];
			sAverageCountsInsideSelection = sSelectionInfo[i++];
			sAverageCountsOutsideSelection = sSelectionInfo[i++];
						
		}
	
		static void ProduceSelectionInfoMessage(String mode){
		
			String sMessage = "* The two corners are defined by:\n";
			sMessage += "   - Bottom left corner:\n";
			sMessage += "     PixelID #: " + sStartingPixelId;
			sMessage += " (x= " + xmin + "; y= " + ymin + "; intensity= " + sCountsStartingPixelId + ")\n";
			sMessage += "   - Top right corner:\n";
			sMessage += "     PixelID #: " + sEndingPixelId;
			sMessage += " (x= " + xmax + "; y= " + ymax + "; intensity= " + sCountsEndingPixelId + ")\n\n";
			sMessage += "* General information about selection:\n";
			sMessage += "   - Number of pixelIDs inside the selection: " + sNbrPixelInsideSelection + "\n";
			sMessage += "   - Selection width: " + sSelectionWidth + "\n";
			sMessage += "   - Selection height: " + sSelectionHeight + "\n";
			sMessage += "   - Total counts inside selection: " + sCountsInsideSelection + "\n";
			sMessage += "   - Total counts outside selection: " + sCountsOutsideSelection + "\n";
			sMessage += "   - Average counts inside selection: " + sAverageCountsInsideSelection + "\n";
			sMessage += "   - Average counts outside selection: " + sAverageCountsOutsideSelection + "\n";
			
			if (mode.compareTo(IParameters.SIGNAL_STRING) == 0) {  //signal selection
				DataReduction.signalSelectionTextArea.setText(sMessage);
			} else if (mode.compareTo(IParameters.BACK1_STRING) == 0) { //background1 selection
				DataReduction.back1SelectionTextArea.setText(sMessage);
			} else if (mode.compareTo(IParameters.BACK2_STRING) == 0) { //background2 selection
				DataReduction.back2SelectionTextArea.setText(sMessage);
			}
			
		}
		
}
