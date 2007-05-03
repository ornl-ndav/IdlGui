package gov.ornl.sns.iontools;

import com.rsi.ion.*;
import java.io.*;

public class IonUtils {

	static IONVariable ionVar;
	
	static IONVariable queryVariable(String sVariable) {
		try {
		    ionVar = DataReduction.c_ionCon.getIDLVariable(sVariable);
		} catch (Exception e) {}
		return ionVar;
	    }

	/*
	 ************************************************
	 * executeCmd()
	 *
	 * Purpose:
	 *  Try executing IDL command.
	 */
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
