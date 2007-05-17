package gov.ornl.sns.iontools;

import com.rsi.ion.*;
import java.io.*;

public class UpdateDataReductionPlotCombineInterface {

	  	static boolean bLinearXAxis;
	    static boolean bLinearYAxis;
	    static String sXMax;
	    static String sXMin;
	    static String sYMax;
	    static String sYMin;
	
	    static IONVariable ionXScale;
	    static IONVariable ionXMin;
	    static IONVariable ionXMax;
	    static IONVariable ionYScale;
	    static IONVariable ionYMin;
	    static IONVariable ionYMax;
	    static IONVariable ionOutputPath;
	    static IONVariable ionRunNumber;
	    static IONVariable ionInstrument;
	    
	static void updateDataReductionPlotGUI() {
		
		DataReduction.xMinTextField.setText(ParametersConfiguration.sXMinInitial);
		DataReduction.xMaxTextField.setText(ParametersConfiguration.sXMaxInitial);
		DataReduction.yMinTextField.setText(ParametersConfiguration.sYMinInitial);
		DataReduction.yMaxTextField.setText(ParametersConfiguration.sYMaxInitial);
	}
	
	static void validateDataReductionPlotCombineXYAxis() {
				
		bLinearXAxis = ParametersConfiguration.bLinearXAxis;
		sXMax = ParametersConfiguration.sXMax;
		sXMin = ParametersConfiguration.sXMin;
		
		bLinearYAxis = ParametersConfiguration.bLinearYAxis;
		sYMax = ParametersConfiguration.sYMax;
		sYMin = ParametersConfiguration.sYMin;
		
		//outputData();
		
		String cmd = createDataReductionPlotCombineCmd();
		DataReduction.c_ionCon.setDrawable(DataReduction.c_dataReductionPlot);
		executeCmd(cmd);
	}
		
	static void resetDataReductionPlotCombineXAxis() {
				
		bLinearXAxis = ParametersConfiguration.bLinearXAxis;
		sXMax = ParametersConfiguration.sXMaxInitial;
		sXMin = ParametersConfiguration.sXMinInitial;
		
		bLinearYAxis = ParametersConfiguration.bLinearYAxis;
		sYMax = ParametersConfiguration.sYMax;
		sYMin = ParametersConfiguration.sYMin;
		
		//outputData();
		
		String cmd = createDataReductionPlotCombineCmd();
		DataReduction.c_ionCon.setDrawable(DataReduction.c_dataReductionPlot);
		executeCmd(cmd);
				
		resetDataReductionCombineXAxisGUI();
	}
	
	static void resetDataReductionPlotCombineYAxis() {
		
		bLinearXAxis = ParametersConfiguration.bLinearXAxis;
		sXMax = ParametersConfiguration.sXMax;
		sXMin = ParametersConfiguration.sXMin;
		
		bLinearYAxis = ParametersConfiguration.bLinearYAxis;
		sYMax = ParametersConfiguration.sYMaxInitial;
		sYMin = ParametersConfiguration.sYMinInitial;
	
		String cmd = createDataReductionPlotCombineCmd();
		DataReduction.c_ionCon.setDrawable(DataReduction.c_dataReductionPlot);
		executeCmd(cmd);
				
		resetDataReductionCombineYAxisGUI();
	}
	
	static String createDataReductionPlotCombineCmd() {
	
		String cmd = "";
		
		//x-axis
		if (bLinearXAxis) { 
			ionXScale = new IONVariable("linear");
		} else {
			ionXScale = new IONVariable("log10"); 
		}
		ionXMin = new IONVariable(sXMin);
		ionXMax = new IONVariable(sXMax);
		
		//y-axis
		if(bLinearYAxis) {
			ionYScale = new IONVariable("linear");
		} else {
			ionYScale = new IONVariable("log10");
		}
		ionYMin = new IONVariable(sYMin);
		ionYMax = new IONVariable(sYMax);
		    		    	
		//output path
		ionOutputPath = new com.rsi.ion.IONVariable(IParameters.WORKING_PATH + "/" + DataReduction.instrument);
		
		//run number
		ionRunNumber = new IONVariable(DataReduction.runNumberValue);
		
		//instrument
		ionInstrument = new IONVariable(DataReduction.instrument);
		
		cmd = "plot_data_reduction_combine, " + ionInstrument + "," + ionRunNumber + "," + ionOutputPath + ",";
    	    	
    	cmd += ionXScale + "," + ionXMin + "," + ionXMax + ",";
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
	
	static void resetDataReductionCombineXAxisGUI() {
		
		DataReduction.xMinTextField.setText(ParametersConfiguration.sXMinInitial);
		DataReduction.xMaxTextField.setText(ParametersConfiguration.sXMaxInitial);
		
	}
	
	static void resetDataReductionCombineYAxisGUI() {
		
		DataReduction.yMinTextField.setText(ParametersConfiguration.sYMinInitial);
		DataReduction.yMaxTextField.setText(ParametersConfiguration.sYMaxInitial);
	
	}
	
	static void outputData() {
	
		System.out.println("bLinearXAxis = " + bLinearXAxis);
		System.out.println("sXMax = " + sXMax);
		System.out.println("sXMin = " + sXMin);
		
		System.out.println("bLinearYAxis = " + bLinearYAxis);
		System.out.println("sYMax = " + sYMax);
		System.out.println("sYMin = " + sYMin);
	
	}
	
}
