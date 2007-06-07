package gov.ornl.sns.iontools;

public class UtilsFunction {

	static String convertDegresToRadians(String sAngleDegree) {
		
		double dAngleDegree = Double.valueOf(sAngleDegree.trim());
		double dAngleRadians = dAngleDegree * IParameters.DEGRES_TO_RADIANS_FACTOR;
		return Double.toString(dAngleRadians);
	}

	/*
	 * This function creates a tmp folder name that will be created
	 * in the ionuser folder and that will contain all the data
	 * created during the current session of DataReduction.
	 */
	static void createTmpFolder() {
		
		String sTmpFolder= "";
		int iRandom = (int)(Math.random()*100);
		String sTime = String.valueOf(System.currentTimeMillis());
		sTmpFolder = String.valueOf(iRandom) + sTime;
		
		ParametersToKeep.sSessionWorkingDirectory = IParameters.WORKING_PATH;
		ParametersToKeep.sSessionWorkingDirectory += sTmpFolder;
		
		com.rsi.ion.IONVariable ionFullTmpFolderName = new com.rsi.ion.IONVariable(ParametersToKeep.sSessionWorkingDirectory);
		
		String cmd = "create_tmp_folder, " + ionFullTmpFolderName;
		IonUtils.executeCmd(cmd);
		
    ParametersToKeep.sSessionWorkingDirectory += "/";
    DataReduction.sTmpFolderRelativePath = sTmpFolder;
    DataReduction.sTmpFolder = ParametersToKeep.sSessionWorkingDirectory;
        
	}
		
	
  /*
   * Get list of files in temporary directory
   */
	static String[] getListOfFiles() {
  
    String[] files;
	  
    /* only works on heater
    File dir = new File(ParametersToKeep.sSessionWorkingDirectory);
	  if (dir.exists()) {
	    files = dir.list();
	    //to display list of files
      //for (String file:files) {
      //System.out.println(file);
	    //}
	  } else {
	    files = null; 
    }
	  */
        
    com.rsi.ion.IONVariable ionTmpFolder = new com.rsi.ion.IONVariable(DataReduction.sTmpFolder);
    String cmd = "sList = LIST_OF_FILES(" + ionTmpFolder + ")";
    IonUtils.executeCmd(cmd);
    
    com.rsi.ion.IONVariable myIONresult;
    myIONresult = IonUtils.queryVariable("sList");
    //String[] myResultArray;
    files = myIONresult.getStringArray();
    
    return files;
	}
	
  /*
   * Remove tmp folder before leaving program
   */
  static void removeTmpFolder() {
    
    com.rsi.ion.IONVariable ionTmpFolderRelativePath = new com.rsi.ion.IONVariable(DataReduction.sTmpFolderRelativePath);
    String cmd = "remove_tmp_folder, ";
    cmd += ionTmpFolderRelativePath;
    IonUtils.executeCmd(cmd);
    
  }
  
  
  
}


