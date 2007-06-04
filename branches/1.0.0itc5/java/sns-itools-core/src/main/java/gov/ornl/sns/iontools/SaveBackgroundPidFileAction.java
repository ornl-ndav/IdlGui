package gov.ornl.sns.iontools;

import java.awt.Color;
import com.rsi.ion.*;
import java.io.*;

public class SaveBackgroundPidFileAction {

	static void backgroundPidFileButton() {
		
		String cmd = "";
		
		DataReduction.pidBackFileName = IontoolsFile.createPidFileName(
				DataReduction.ucams, 
				DataReduction.instrument, 
				DataReduction.runNumberValue, 
				IParameters.BACK_STRING);
		
		DataReduction.backgroundPidFileTextField.setBackground(Color.WHITE);
		DataReduction.backgroundPidFileTextField.setText(DataReduction.pidBackFileName);
	
		IONVariable fullFileName = new IONVariable(DataReduction.pidBackFileName);
		
		int[] xarrSignal = {MouseSelectionParameters.signal_xmin, 
				MouseSelectionParameters.signal_xmax, 
				MouseSelectionParameters.signal_ymin, 
				MouseSelectionParameters.signal_ymax};
		
		int[] xarrBack1 = {MouseSelectionParameters.back1_xmin, 
				MouseSelectionParameters.back1_xmax, 
				MouseSelectionParameters.back1_ymin, 
				MouseSelectionParameters.back1_ymax};
		
		int[] xarrBack2 = {MouseSelectionParameters.back2_xmin, 
				MouseSelectionParameters.back2_xmax, 
				MouseSelectionParameters.back2_ymin, 
				MouseSelectionParameters.back2_ymax};
		
		int[] nx = {4};
		IONVariable IONxvalsSignal = new IONVariable(xarrSignal,nx);
		IONVariable IONxvalsBack1 = new IONVariable(xarrBack1, nx);
		IONVariable IONxvalsBack2 = new IONVariable(xarrBack2, nx);
		IONVariable ionBack2Selected = new IONVariable(DataReduction.iBack2SelectionExist);
		IONVariable ionNx = new IONVariable(ParametersConfiguration.Nx);
		IONVariable ionNy = new IONVariable(ParametersConfiguration.Ny);
		
		try {
			DataReduction.c_ionCon.setIDLVariable("back2Selected", ionBack2Selected);
			DataReduction.c_ionCon.setIDLVariable("Nx", ionNx);
			DataReduction.c_ionCon.setIDLVariable("Ny", ionNy);
			DataReduction.c_ionCon.setIDLVariable("XY_signal", IONxvalsSignal);
			DataReduction.c_ionCon.setIDLVariable("XY_back1", IONxvalsBack1);
			DataReduction.c_ionCon.setIDLVariable("XY_back2", IONxvalsBack2);
			cmd = "CREATE_BACKGROUND_PID_FILE, Nx, Ny, XY_signal, XY_back1, XY_back2, back2Selected, " + fullFileName;
		} catch (Exception e) {
		}
		executeCmd(cmd);		
		DataReduction.clearBackPidFileButton.setEnabled(true);
		CheckDataReductionButtonValidation.bBackPidFileSaved = true;
		CheckDataReductionButtonValidation.sBackPidFile = DataReduction.pidBackFileName;
		
	}

	
	static void clearBackgroundPidFileAction() {
	
		DataReduction.backgroundPidFileTextField.setBackground(Color.RED);
		DataReduction.backgroundPidFileTextField.setText("");	
		MouseSelection.saveXY(IParameters.BACK1_STRING,0,0,0,0);
		MouseSelection.saveXY(IParameters.BACK2_STRING,0,0,0,0);
		
		MouseSelectionParameters.back1_x1 = 0;
		MouseSelectionParameters.back1_y1 = 0;
		MouseSelectionParameters.back1_x2 = 0;
		MouseSelectionParameters.back1_y2 = 0;
		
		MouseSelectionParameters.back2_x1 = 0;
		MouseSelectionParameters.back2_y1 = 0;
		MouseSelectionParameters.back2_x2 = 0;
		MouseSelectionParameters.back2_y2 = 0;
		
		DataReduction.clearBackPidFileButton.setEnabled(false);
		DataReduction.backgroundPidFileButton.setEnabled(false);
		CheckDataReductionButtonValidation.bBackPidFileSaved = false;
		CheckDataReductionButtonValidation.sBackPidFile = "";
		
		MouseSelection.RemoveBack1PidInfoMessage();
		MouseSelection.RemoveBack2PidInfoMessage();
	
		TabUtils.removeForegroundColor(DataReduction.selectionTab,1);
		TabUtils.removeForegroundColor(DataReduction.selectionTab,2);
	}
	
		
	static void executeCmd(String cmd) {
	    try{
	  	  DataReduction.c_ionCon.setIDLVariable("instrument",DataReduction.ionInstrument);
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
