package gov.ornl.sns.iontools;

public class LoadSelectionPidFileAction {

  static com.rsi.ion.IONVariable ionPath;
  static com.rsi.ion.IONVariable ionExtension;
  static com.rsi.ion.IONVariable ionFullFileName;
  static String[] listOfPidFiles;
  static String[] myResultArray;
  
  static void getListOfPidFilesInHomeDirectory() {
   
    String sPidDirectory = getPidDirectory();
    String sPidExtension = CreateSettingsPanel.pidFileExtensionTextField.getText();
    
    if (sPidExtension.compareTo("")!=0 && sPidDirectory.compareTo("")!=0) {
      ionPath = new com.rsi.ion.IONVariable(sPidDirectory);
      ionExtension = new com.rsi.ion.IONVariable(sPidExtension);
      String cmd = "list_of_files = get_list_of_pid_files (" + ionPath;
      cmd += "," + ionExtension + ")";
      IonUtils.executeCmd(cmd);
      
      com.rsi.ion.IONVariable myIONresult;
      myIONresult = IonUtils.queryVariable("list_of_files");
      
      try {
        myResultArray = myIONresult.getStringArray();
        listOfPidFiles = new String[myResultArray.length];
        System.arraycopy(myResultArray, 0, listOfPidFiles, 0, myResultArray.length);        
        String[] lastPartResultArray = UtilsFunction.getLastPartOfStringArray(myResultArray);
        
        //Number of files to list
        int iNbrOfPidFiles = myResultArray.length;
        if (iNbrOfPidFiles > 0) {
          CreateDataReductionInputGUI.listOfPidFileToLoadComboBox.removeAllItems();
            for (int i=0; i<iNbrOfPidFiles; ++i) {
              CreateDataReductionInputGUI.listOfPidFileToLoadComboBox.addItem(lastPartResultArray[i]);
            }
        }
      } catch (Exception e) {
        CreateDataReductionInputGUI.listOfPidFileToLoadComboBox.removeAllItems(); 
      }
      
    }
    
  }

  /*
   * This function retrieve the path to the PID files
   */
  static String getPidDirectory() {
    
    //current tmp folder or home directory
    int iPathSelected = CreateDataReductionInputGUI.homeOrCurrentSessionComboBox.getSelectedIndex();
    String sPidDirectory;
    if (iPathSelected == 0) { //Home directory
      sPidDirectory = CreateSettingsPanel.pidFileHomeDirectoryTextField.getText();
      return sPidDirectory;
    } else { //tmp folder
      return DataReduction.sTmpFolder;
    }
  }

  /*
   * This function loads the desired pid file
   */
  static void loadPidFile() {
    
    try {
      boolean bSignalPid = isSignalSelected();
      String  sPidFileFullName = getPidFileFullName();
      if (bSignalPid) {
        getSignalXYMinMax(sPidFileFullName);
      } else {
        getBackXYMinMax(sPidFileFullName);
      }
    } catch (Exception e) {}
  }
  
  /*
   * This functions returns true if the signal PID file is selected
   * false if background is selected
   */
   static boolean isSignalSelected() {
     int iSelectedIndex = CreateDataReductionInputGUI.typeOfSelectionComboBox.getSelectedIndex();
     if (iSelectedIndex == 0) {
       return true;
     } else {
       return false;
     }
   }
     
   /*
    * Get the full path to the pid file name
    */
   static String getPidFileFullName() {
     int indexSelected = CreateDataReductionInputGUI.listOfPidFileToLoadComboBox.getSelectedIndex();
     return listOfPidFiles[indexSelected];
   }
   
   /*
    * This function will retrive the Xmin, Xmax, Ymin and Ymax from the
    * signal pid file
    */
   static void getSignalXYMinMax(String sFullFileName) {
   ionFullFileName = new com.rsi.ion.IONVariable(sFullFileName);
   String cmd = "xyMinMax = get_signal_xy_min_max( " + ionFullFileName + ")";
   IonUtils.executeCmd(cmd);
   try {
     com.rsi.ion.IONVariable myIONresult;
     myIONresult = IonUtils.queryVariable("xyMinMax");
     String[] XYMinMax = myIONresult.getStringArray();
     
     System.out.println("Xmin: " + XYMinMax[0]);
     System.out.println("Xmax: " + XYMinMax[1]);
     System.out.println("Ymin: " + XYMinMax[2]);
     System.out.println("Ymax: " + XYMinMax[3]);
   
    } catch (Exception e) {};
   }
 
   /*
    * This function will retrive the Xmin, Xmax, Ymin and Ymax from the
    * back pid file
    */
   static void getBackXYMinMax(String sFullFileName) {
   }
 
}
