package gov.ornl.sns.iontools;

public class LoadSelectionPidFileAction {

  static com.rsi.ion.IONVariable ionPath;
  static com.rsi.ion.IONVariable ionExtension;
  static String[] listOfPidFiles;
  
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
        
        String[] myResultArray;
        myResultArray = myIONresult.getStringArray();
        listOfPidFiles = myResultArray;
        
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

  
}
