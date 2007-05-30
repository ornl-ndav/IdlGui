package gov.ornl.sns.iontools;

/*
 * This class run the data reduction jobs in another thread
 */
public class SubmitDataReduction implements Runnable {

	private String cmd = null;
	
	public SubmitDataReduction(String cmd) {
		
		this.cmd = cmd;
		
	}
	
	public void run() {
		
		ProcessingInterfaceWithGui.displayProcessingMessage("Running data reduction");

		String sMessage = "Running data reduction:\n";	 
		UtilsFunction.printInLogBook(sMessage);	
		
    DataReduction.c_ionCon.setDrawable(DataReduction.c_dataReductionPlot);
		DataReduction.ionOutputPath = new com.rsi.ion.IONVariable(ParametersToKeep.sSessionWorkingDirectory);
		DataReduction.ionRunNumberValue = new com.rsi.ion.IONVariable(DataReduction.runNumberValue);
	   		   	
		String[] cmdArray = this.cmd.split(" ");
		int cmdArraySize = cmdArray.length;
	   		   	
		int[] nx = {cmdArraySize};
		DataReduction.ionCmd = new com.rsi.ion.IONVariable(cmdArray,nx); 
		IonUtils.sendIDLVariable("IDLcmd", DataReduction.ionCmd);
    	
		String local_cmd;
	   		   	
		//if (CheckDataReductionButtonValidation.bCombineDataSpectrum) { //combine data
		if (DataReduction.liveParameters.isCombineDataSpectrum()) {
	    	
		  sMessage = "   Mode : Combine\n";
		  UtilsFunction.printInLogBook(sMessage);
		   	
	    local_cmd = "array_result = run_data_reduction_combine(IDLcmd, ";
	    local_cmd += DataReduction.ionOutputPath + "," + DataReduction.ionRunNumberValue + "," + DataReduction.ionInstrument + ")";
	   		
	   		sMessage = "   cmd  : " + this.cmd + "\n";
	   		UtilsFunction.printInLogBook(sMessage);
	   		sMessage = "   Processing.... ";
	   		UtilsFunction.printInLogBook(sMessage);
	   		
	   		IonUtils.executeCmd(local_cmd);
	   		
	   		sMessage = " done " + "\n";
	   		UtilsFunction.printInLogBook(sMessage);
	   			   		
    		com.rsi.ion.IONVariable myIONresult;
    		myIONresult = IonUtils.queryVariable("array_result");
	    	String[] myResultArray;
	    	myResultArray = myIONresult.getStringArray();
	    			    		
	    	CheckGUI.populateCheckDataReductionPlotCombineParameters(myResultArray);
	    	UpdateDataReductionPlotCombineInterface.updateDataReductionPlotGUI();

	    } else {
	    
	    	sMessage = "   Mode : Uncombine\n";
		   	UtilsFunction.printInLogBook(sMessage);
		   	
        DataReduction.ionNtof = new com.rsi.ion.IONVariable(ParametersConfiguration.iNtof);
		   	DataReduction.ionY12 = new com.rsi.ion.IONVariable(ParametersConfiguration.iY12);
		   	DataReduction.ionYmin = new com.rsi.ion.IONVariable(MouseSelectionParameters.signal_ymin);
		   	
		   	local_cmd = "array_result = run_data_reduction (IDLcmd, " + DataReduction.ionOutputPath + "," + DataReduction.runNumberValue + "," ;
		   	local_cmd += DataReduction.ionInstrument + "," + DataReduction.ionNtof + "," + DataReduction.ionY12 + "," + DataReduction.ionYmin + ")"; 
	    	
		   	sMessage = "   cmd  : " + this.cmd + "\n";
	   		UtilsFunction.printInLogBook(sMessage);
	   		sMessage = "   Processing.... ";
	   		UtilsFunction.printInLogBook(sMessage);
	   		
	   		IonUtils.executeCmd(local_cmd);
		   	
	   		sMessage = " done " + "\n";
	   		UtilsFunction.printInLogBook(sMessage);
	   		
    		com.rsi.ion.IONVariable myIONresult;
    		myIONresult = IonUtils.queryVariable("array_result");
	    	String[] myResultArray;
	    	myResultArray = myIONresult.getStringArray();
		   	
	    	CheckGUI.populateCheckDataReductionPlotParameters(myResultArray);
	    	UpdateDataReductionPlotUncombineInterface.updateDataReductionPlotGUI();
	    }
	    
	    //show data reductin plot tab
	   	DataReduction.dataReductionTabbedPane.setSelectedIndex(1);
	   	if (DataReduction.liveParameters.isIntermediatePlotsSwitch()) {  //we asked for intermediate plots
	   		ExtraPlots.plotExtraPlots();
	   	}
	   	
		ProcessingInterfaceWithGui.removeProcessingMessage();

	}
	
}
