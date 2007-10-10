/*
 * Copyright (c) 2007, J.-C. Bilheux <bilheuxjm@ornl.gov>
 * showpallation Neutron Source at Oak Ridge National Laboratory
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
package gov.ornl.sns.iontools;

import com.rsi.ion.*;

public class MouseSelection {

	private static int xmin;
	private static int ymin;
	private static int xmax;
	private static int ymax;
	static int infoX = 0;
	static int infoY = 0;
	
	private static IONVariable ionTmpHistoFile;
	private static IONVariable ionXmin;
	private static IONVariable ionXmax;
	private static IONVariable ionYmin;
	private static IONVariable ionYmax;
	private static IONVariable ionNx;
	private static IONVariable ionNy;
	private static IONVariable ionX;
	private static IONVariable ionY;
	
	//for selection
	private static String sSelectionHeight;
	private static String sSelectionWidth;
	private static String sNbrPixelInsideSelection;
	private static String sNbrPixelOutsideSelection;
	private static String sStartingPixelId;
	private static String sEndingPixelId;
	private static String sCountsStartingPixelId;
	private static String sCountsEndingPixelId;
	private static String sCountsInsideSelection;
	private static String sCountsOutsideSelection;
	private static String sAverageCountsInsideSelection;
	private static String sAverageCountsOutsideSelection;

	//for pixelInfo
	private static String sDistXBorder;
	private static String sDistXCenter;
	private static String sDistYBorder;
	private static String sDistYCenter;
	private static String sNbrCounts;
	private static String sPixelID;
	
	static void saveXY(String mode,int x_min, int y_min, int x_max, int y_max) {
    	
		xmin = x_min;
		ymin = y_min;
		xmax = x_max;
		ymax = y_max;
		
		if (mode.compareTo(IParameters.SIGNAL_STRING) == 0) {  //signal selection
			MouseSelectionParameters.signal_xmin = x_min;
			MouseSelectionParameters.signal_ymin = y_min;
			MouseSelectionParameters.signal_xmax = x_max;
			MouseSelectionParameters.signal_ymax = y_max;
    	} else if (mode.compareTo(IParameters.BACK1_STRING) == 0) { //background1 selection
    		MouseSelectionParameters.back1_xmin = x_min;
    		MouseSelectionParameters.back1_ymin = y_min;
    		MouseSelectionParameters.back1_xmax = x_max;
    		MouseSelectionParameters.back1_ymax = y_max;
    	} else if (mode.compareTo(IParameters.BACK2_STRING) == 0) { //background2 selection
    		MouseSelectionParameters.back2_xmin = x_min;
    		MouseSelectionParameters.back2_ymin = y_min;
    		MouseSelectionParameters.back2_xmax = x_max;
    		MouseSelectionParameters.back2_ymax = y_max;
    	}
		
		getFullSelectionInfo(mode, x_min, y_min, x_max, y_max);
    }	
	
	static void saveXYinfo(int x, int y) {
		infoX = x;
		infoY = y;
		getFullPixelInfo(infoX, infoY);
	}
	
	public static void RemovePixelInfoMessage() {
		String sMessage = "";
		DataReduction.pixelInfoTextArea.setText(sMessage);	
	}
	
	public static void RemoveSignalPidInfoMessage() {
		String sMessage = "";
		DataReduction.signalSelectionTextArea.setText(sMessage);
	}
	
	public static void RemoveBack1PidInfoMessage() {
		String sMessage = "";
		DataReduction.back1SelectionTextArea.setText(sMessage);
	}
	
	public static void RemoveBack2PidInfoMessage() {
		String sMessage = "";
		DataReduction.back1SelectionTextArea.setText(sMessage);
	}
	
	/*
	 * Function that produces the output
	 */
	private static void getFullSelectionInfo(String mode, int x_min, int y_min, int x_max, int y_max) {
		
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
		ProduceSelectionMessage(mode);
				
	}
	
	static void getFullPixelInfo(int x, int y) {
		
		ionTmpHistoFile = new com.rsi.ion.IONVariable(DataReduction.sTmpOutputFileName);
		ionX = new com.rsi.ion.IONVariable(x); 
		ionY = new com.rsi.ion.IONVariable(y);
		ionNx = new com.rsi.ion.IONVariable(ParametersConfiguration.Nx);
		ionNy = new com.rsi.ion.IONVariable(ParametersConfiguration.Ny);
				
	String cmd = "pixelInfo = pixel_info( ";
	cmd += ionNx + "," + ionNy;
	cmd += "," + ionTmpHistoFile;
	cmd += "," + ionX + "," + ionY;
	cmd += ")";
		
	IonUtils.executeCmd(cmd);
	
	IONVariable ionPixelInfo = IonUtils.queryVariable("pixelInfo");
	String[] sPixelInfo;
	sPixelInfo = ionPixelInfo.getStringArray();

	InitializePixelInfoStrings(sPixelInfo);
	ProducePixelInfoMessage();
	
	}

	private static void InitializeStrings(String[] sSelectionInfo) {
			
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
	
	private static void InitializePixelInfoStrings(String[] sPixelInfo) {
			
		int i=0;
		sDistXBorder = sPixelInfo[i++];
		sDistXCenter = sPixelInfo[i++];
		sDistYBorder = sPixelInfo[i++];
		sDistYCenter = sPixelInfo[i++];
		sNbrCounts = sPixelInfo[i++];
		sPixelID = sPixelInfo[i++];
			
	}
			
	private static void ProduceSelectionMessage(String mode){
		
		String sMessage = "* The two corners are defined by:\n";
		sMessage += "   - Bottom left corner:\n";
		sMessage += "     PixelID #: " + sStartingPixelId;
		sMessage += " (x= " + xmin + "; y= " + ymin + "; intensity= " + sCountsStartingPixelId + ")\n";
		sMessage += "   - Top right corner:\n";
		sMessage += "     PixelID #: " + sEndingPixelId;
		sMessage += " (x= " + xmax + "; y= " + ymax + "; intensity= " + sCountsEndingPixelId + ")\n\n";
		sMessage += "* General information about selection:\n";
		sMessage += "   - Number of pixelIDs inside the selection: " + sNbrPixelInsideSelection + "\n";
		sMessage += "   - Number of pixelIDs outiside the selection: " + sNbrPixelOutsideSelection + "\n";
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

	private static void ProducePixelInfoMessage() {
		String sMessage = " The pixel selected is defined by:\n\n";
		sMessage += "   - X: " + infoX + "\n";
		sMessage += "   - Y: " + infoY + "\n";
		sMessage += "\n";
		sMessage += "   - a: " + sDistXBorder + " mm\n";
		sMessage += "   - b: " + sDistXCenter + " mm\n";
		sMessage += "   - c: " + sDistYBorder + " mm\n";
		sMessage += "   - d: " + sDistYCenter + " mm\n";
		sMessage += "\n";
		sMessage += "   - Nbr counts: " + sNbrCounts + "\n";
		sMessage += "   - Pixel ID: " + sPixelID + "\n";
		
		DataReduction.pixelInfoTextArea.setText(sMessage);
	}
	
	
}
