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
		
	}
		
	/*
	 * Append text into log book text box
	 */
	static void printInLogBook(String sMessage) {
	
		DataReduction.textAreaLogBook.append(sMessage);
		
	}
	
	/*
	 * append or replace log book text with/by sMessage
	 */
	static void printInLogBook(String sMessage, boolean bAppend) {
		
		if (bAppend) {
			DataReduction.textAreaLogBook.append(sMessage);
		} else {
			DataReduction.textAreaLogBook.setText(sMessage);
		}
		
	}
	
	
}


