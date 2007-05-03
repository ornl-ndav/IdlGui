package gov.ornl.sns.iontools;

import java.awt.Color;
import com.rsi.ion.*;
import java.io.*;

public class SaveSignalPidFileAction {

	static void signalPidFileButton() {
	
		String cmd="";
		
		DataReduction.pidSignalFileName = IontoolsFile.createPidFileName(DataReduction.ucams, 
				DataReduction.instrument, 
				DataReduction.runNumberValue, 
				IParameters.SIGNAL_STRING);
		
		DataReduction.signalPidFileTextField.setBackground(Color.WHITE);
		DataReduction.signalPidFileTextField.setText(DataReduction.pidSignalFileName);	
		
		int[] xarr = {MouseSelectionParameters.signal_xmin, 
				MouseSelectionParameters.signal_xmax, 
				MouseSelectionParameters.signal_ymin, 
				MouseSelectionParameters.signal_ymax};
		
		int[] nx = {4};
		
		IONVariable IONxvals = new IONVariable(xarr,nx);
		IONVariable fullFileName = new IONVariable(DataReduction.pidSignalFileName);
		
		try {
			DataReduction.c_ionCon.setIDLVariable("XY", IONxvals);
			cmd = "CREATE_SIGNAL_PID_FILE, XY, " + fullFileName;
		} catch (Exception e) {
		}
		
		executeCmd(cmd);		
		DataReduction.clearSignalPidFileButton.setEnabled(true);
		CheckDataReductionButtonValidation.bSignalPidFileSaved = true;
		CheckDataReductionButtonValidation.sSignalPidFile = DataReduction.pidSignalFileName;
		
	}
	
	static void clearSignalPidFileAction() {
		
		DataReduction.signalPidFileTextField.setBackground(Color.RED);
		DataReduction.signalPidFileTextField.setText("");	
		MouseSelection.saveXY(IParameters.SIGNAL_STRING,0,0,0,0);
		MouseSelectionParameters.signal_x1 = 0;
		MouseSelectionParameters.signal_y1 = 0;
		MouseSelectionParameters.signal_x2 = 0;
		MouseSelectionParameters.signal_y2 = 0;
		DataReduction.clearSignalPidFileButton.setEnabled(false);
		DataReduction.signalPidFileButton.setEnabled(false);
		CheckDataReductionButtonValidation.bSignalPidFileSaved = false;
		CheckDataReductionButtonValidation.sSignalPidFile = "";

	}
	
	
	static void executeCmd(String cmd) {
	    try{
	  	  DataReduction.c_ionCon.setIDLVariable("instrument",DataReduction.instr);
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
	
}
  
