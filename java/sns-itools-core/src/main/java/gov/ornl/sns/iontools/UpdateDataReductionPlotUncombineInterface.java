package gov.ornl.sns.iontools;

import com.rsi.ion.*;
import java.io.*;

public class UpdateDataReductionPlotUncombineInterface {

	static boolean bLinearYAxis;
	static String sYMax;
    static String sYMin;

    static IONVariable ionYScale;
    static IONVariable ionYMin;
    static IONVariable ionYMax;
    static IONVariable ionNtof;
    static IONVariable ionY12;
    static IONVariable ionSignalYMin;
    
    static IONVariable ionOutputPath;
    static IONVariable ionRunNumber;
    static IONVariable ionInstrument;
	
	
    static void validateDataReductionPlotUncombineXYAxis() {
		
		bLinearYAxis = ParametersConfiguration.bLinearYAxis;
		sYMax = ParametersConfiguration.sYMax;
		sYMin = ParametersConfiguration.sYMin;

		//outputData();
		
		String cmd = createDataReductionPlotUncombineCmd();
		DataReduction.c_ionCon.setDrawable(DataReduction.c_dataReductionPlot);
		executeCmd(cmd);
		
    }
	
    static void resetDataReductionPlotUncombineYAxis() {
		
		bLinearYAxis = ParametersConfiguration.bLinearYAxis;
		sYMax = ParametersConfiguration.sYMax;
		sYMin = ParametersConfiguration.sYMin;
		
		//outputData();
		
		String cmd = createDataReductionPlotUncombineCmd();
		DataReduction.c_ionCon.setDrawable(DataReduction.c_dataReductionPlot);
		executeCmd(cmd);
    }
	
    static void updateDataReductionPlotGUI() {
		
		DataReduction.yMinTextField.setText(ParametersConfiguration.sYMinInitial);
		DataReduction.yMaxTextField.setText(ParametersConfiguration.sYMaxInitial);
    }

    static String createDataReductionPlotUncombineCmd() {
    	
		String cmd = "";
		
		//y-axis
		if(bLinearYAxis) {
			ionYScale = new IONVariable("linear");
		} else {
			ionYScale = new IONVariable("log10");
		}
		ionYMin = new IONVariable(sYMin);
		ionYMax = new IONVariable(sYMax);
		ionSignalYMin = new IONVariable(MouseSelectionParameters.signal_ymin);
		ionNtof = new IONVariable(ParametersConfiguration.iNtof);
		ionY12 = new IONVariable(ParametersConfiguration.iY12);
		
		//output path
		ionOutputPath = new com.rsi.ion.IONVariable(IParameters.WORKING_PATH + "/" + DataReduction.instrument);
		
		//run number
		ionRunNumber = new IONVariable(DataReduction.runNumberValue);
		
		//instrument
		ionInstrument = new IONVariable(DataReduction.instrument);
		
    	cmd = "plot_data_reduction, " + ionOutputPath + "," + ionInstrument + "," + ionRunNumber + ",";
    	cmd += ionNtof + "," + ionY12 + "," + ionSignalYMin + ",";
    	cmd += ionYScale + "," + ionYMin + "," + ionYMax;
    				
    	return cmd;
	}
	
   	static  void executeCmd(String cmd) {
	
   		try{
	    	  DataReduction.c_ionCon.executeIDLCommand(cmd);
	      } catch(Exception e) { 
		  String smsg;
		  if(e instanceof IOException)
		      smsg = "Communication error:"+e.getMessage(); 
		  else if(e instanceof IONSecurityException )
		      smsg = "ION Java security error"; 
		  else if(e instanceof IONIllegalCommandException )
		      smsg = "Illegal IDL Command detected on server."; 
		  else 
		      smsg = "Unknown error: "+e.getMessage();
		  System.err.println("Error: "+smsg);
	      }
	  }
	
    static void outputData() {
    		
    	System.out.println("bLinearYAxis = " + bLinearYAxis);
    	System.out.println("sYMax = " + sYMax);
    	System.out.println("sYMin = " + sYMin);
   	}
    		
}	
