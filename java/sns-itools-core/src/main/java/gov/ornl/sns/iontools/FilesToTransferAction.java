package gov.ornl.sns.iontools;

import java.util.Vector;
import com.rsi.ion.*;
import java.util.List;

public class FilesToTransferAction {

  static Vector      vListOfFiles;
  static Vector      vListOfFilesAdded;
  static String[]    sListOfFiles;
  static List        lListOfFilesAdded;
  static IONVariable ionUcams;
  static IONVariable ionTmpFolder;
  static IONVariable ionFileName;
  static IONVariable ionNbrLineDisplayed;
  
  /*
   * This function upate the list of files to transfered
   */
  static void updateListOfFilesToTransfer() {
  
    if (!ParametersToKeep.bThreadInProcess &&
        !ParametersToKeep.bFirstRunEver) {
      sListOfFiles = getListOfFiles();
//    for (String file:sListOfFiles) {
//      System.out.println(file);
//    }
      if (!DataReduction.transferPidFilesCheckBox.isSelected()) {
        removePidFilesFromList(sListOfFiles);
      }     
      if (!DataReduction.transferDataReductionFileCheckBox.isSelected()) {
        removeDataReductionFilesFromList(sListOfFiles);
      } 
      if (!DataReduction.transferExtraPlotsCheckBox.isSelected()) {
        removeExtraPlotsFilesFromList(sListOfFiles);
      } 
      if (!DataReduction.transferTmpHistoCheckBox.isSelected()) {
        removeTmpHistoFileFromList(sListOfFiles);
      }
      vListOfFiles = new Vector();
      vListOfFiles = getVectorListOfFiles(sListOfFiles);
      DataReduction.filesToTransferList.setListData(vListOfFiles);
      }
  }
  
  /*
   * Get list of files in String array
   */
  static String[] getListOfFiles() {
    return UtilsFunction.getListOfFiles();
  }
  
  /*
   * transfer string array into vector 
   */
  static Vector getVectorListOfFiles(String[] listFiles) {
  
    for (int i=0; i<(listFiles.length); i++) {
      vListOfFiles.add(listFiles[i]);
      }
    return vListOfFiles;
  }
  
  /*
   * transfer list array into vector 
   */
  static Vector getVectorListOfFiles(List listFiles) {
    
    for (int i=0; i<(listFiles.size()); i++) {
      vListOfFilesAdded.add(listFiles.get(i));
      }
    return vListOfFilesAdded;
  }

  /*
   * Function that call the IDL command to transfer the file
   */
  static void transferFile() {
    
    //get selected indeces
    int[] iSelection = DataReduction.filesToTransferList.getSelectedIndices();
    lListOfFilesAdded = new java.util.ArrayList();
    
    //list of files selected and transfer them one at a time
    for (int i=0; i<iSelection.length; i++) {
      String cmd = createCmd(sListOfFiles[iSelection[i]]);
      IonUtils.executeCmd(cmd);
      addFileInRightBox(sListOfFiles[iSelection[i]]); //add files into right box
    }
    
  }
  
  /*
   * Create the cmd that will be run through ION_JAVA
   */
  static String createCmd(String fileName) {
    
    ionUcams     = new IONVariable(DataReduction.remoteUser);
    ionTmpFolder = new IONVariable(DataReduction.sTmpFolder);
    ionFileName  = new IONVariable(fileName);
    
    String cmd = "MOVE_FILE, ";
    cmd += ionUcams + ",";
    cmd += ionTmpFolder + ",";
    cmd += ionFileName;
    return cmd;
    
  }
  
  /*
   * This function add the file name in the right box 
   */
  static void addFileInRightBox(String fileNameToAdd) {
    lListOfFilesAdded.add(fileNameToAdd);
    vListOfFilesAdded = new Vector();
    vListOfFilesAdded = getVectorListOfFiles(lListOfFilesAdded);
    DataReduction.filesTransferedList.setListData(vListOfFilesAdded);    
  }
  
/*
 * Function that remove the pid files from the list
 */  
  static void removePidFilesFromList(String[] sListOfFiles) {
    List tmpListOfFiles = new java.util.ArrayList();
    for (String file:sListOfFiles) {
      if (!file.endsWith(IParameters.PID_FILE_EXTENSION)) {
        tmpListOfFiles.add(file);
      } 
    }
    convertListIntoString(tmpListOfFiles);
}
 
  /*
   * Function that remove the data reduction files from list
   */
  static void removeDataReductionFilesFromList(String[] sListOfFiles) {
    List tmpListOfFiles = new java.util.ArrayList();
    for (String file:sListOfFiles) {
      if (!(file.endsWith(IParameters.TXT_FILE_EXTENSION) &&
          !file.endsWith(IParameters.PID_FILE_EXTENSION))) {
        tmpListOfFiles.add(file);
      } 
    }
    convertListIntoString(tmpListOfFiles);
  }
  
  /*
   * Function that remove the extra plots files from list
   */
  static void removeExtraPlotsFilesFromList(String[] sListOfFiles) {
    List tmpListOfFiles = new java.util.ArrayList();
    for (String file:sListOfFiles) {
      if (!file.endsWith(IParameters.SR_EXTENSION) &&
          !file.endsWith(IParameters.BS_EXTENSION) &&
          !file.endsWith(IParameters.SRB_EXTENSION) &&
          !file.endsWith(IParameters.NR_EXTENSION) &&
          !file.endsWith(IParameters.BRN_EXTENSION)) {
        tmpListOfFiles.add(file);
      } 
    }
    convertListIntoString(tmpListOfFiles);
  }
 
  /*
   * Function that remove the tmp histo file from list
   */
  static void removeTmpHistoFileFromList(String[] sListOfFiles) {
    List tmpListOfFiles = new java.util.ArrayList();
    for (String file:sListOfFiles) {
      if (!file.endsWith(IParameters.TMP_HISTO_FILE_EXTENSION)) {
        tmpListOfFiles.add(file);
      } 
    }
    convertListIntoString(tmpListOfFiles);
  }
  
  /*
   * this function converts a list into a String[]
   */
  static void convertListIntoString(List tmpListOfFiles) {
    int tmpSize = tmpListOfFiles.size();
    String[] tmpArray = new String[tmpSize];
    for (int i=0; i<tmpSize; i++) {
      tmpArray[i]=tmpListOfFiles.get(i).toString();
    }
    sListOfFiles = tmpArray;
  }
  
  /*
   * this function tells if the mode is automatic or not
   */
  static boolean isTransferModeAutomatic() {
    return DataReduction.automaticFilesTransferRadioButton.isSelected();
  }
  
  /*
   * This function copy all the files created during the current session 
   * to the home directory when the automatic mode is selected
   */
  static void transferAllFilesFromCurrentSession() {
    if (isTransferModeAutomatic()) { //mode is automatic
      sListOfFiles = getListOfFiles();
      for (int i=0; i<sListOfFiles.length; i++) {
        String cmd = createCmd(sListOfFiles[i]);
        IonUtils.executeCmd(cmd);
      }
    }
  }

  /*
   * This function output in the info text box the first lines
   * of the selected file to save
   */
  static void getSelectedFileInfo() {
    if (!DataReduction.filesToTransferList.isSelectionEmpty()) {
      int[] iSelection = DataReduction.filesToTransferList.getSelectedIndices();
      String sFileName = sListOfFiles[iSelection[0]];
      if (isFileRmdFile(sFileName)) { //xml file (.rmd file)
        
        String message = "The first ";
        message += IParameters.i_RMD_NBR_LINE_DISPLAYED;
        message += "  lines of the selected file are displayed";
        displayedInfoMessage(message);
        
        String cmd = createSaveXmlFileInfoCmd(sFileName);
        IonUtils.executeCmd(cmd);
        com.rsi.ion.IONVariable myIONresult;
        myIONresult = IonUtils.queryVariable("result");
        String[] myResultArray;
        myResultArray = myIONresult.getStringArray();
        displayMessageInInfoBox(myResultArray);
      } else {
        
        String message = "The first ";
        message += IParameters.i_NO_RMD_NBR_LINE_DISPLAYED;
        message += "  lines of the selected file are displayed";
        displayedInfoMessage(message);
        
        String cmd = createSaveFileInfoCmd(sFileName);
        IonUtils.executeCmd(cmd);
        com.rsi.ion.IONVariable myIONresult;
        myIONresult = IonUtils.queryVariable("result");
        String[] myResultArray;
        myResultArray = myIONresult.getStringArray();
        displayMessageInInfoBox(myResultArray);
        }
    }
  }

  /*
   * This function create the cmd for the xml (.rmd) file through IDL.
   * The full contains of the file will be displayed
   */
  static String createSaveXmlFileInfoCmd(String sFileName) {
  
    ionTmpFolder = new IONVariable(DataReduction.sTmpFolder);
    ionFileName  = new IONVariable(sFileName);
    ionNbrLineDisplayed = new IONVariable(IParameters.i_RMD_NBR_LINE_DISPLAYED);
    
    String cmd = "result = DISPLAY_XML_FILE_INFO( ";
    cmd += ionFileName + ",";
    cmd += ionTmpFolder + ",";
    cmd += ionNbrLineDisplayed + ")";
    
    return cmd;
  }
    
   /*
   * This function creates the cmd that will be run through IDL to get
   * the first line of the given file
   */
  static String createSaveFileInfoCmd(String sFileName) {
   
    ionTmpFolder = new IONVariable(DataReduction.sTmpFolder);
    ionFileName  = new IONVariable(sFileName);
    ionNbrLineDisplayed = new IONVariable(IParameters.i_NO_RMD_NBR_LINE_DISPLAYED);
    
    String cmd = "result = DISPLAY_FILE_INFO( ";
    cmd += ionFileName + ",";
    cmd += ionTmpFolder + ",";
    cmd += ionNbrLineDisplayed + ")";
    
    return cmd;
  }
  
  /*
   * this function displays the message in the text area box
   */
   static void displayMessageInInfoBox(String[] myResultArray) {
 
     int myResultArrayLength = myResultArray.length;
     myResultArray[0] += "\n";
       DataReduction.saveFileInfoTextArea.setText(myResultArray[0]);
       for (int i=1; i<myResultArrayLength; i++) {
         if (i != myResultArrayLength-1) {
             myResultArray[i]+="\n";
         }  
         DataReduction.saveFileInfoTextArea.append(myResultArray[i]);
       }
   }
   
   /*
    * Checks if the file selected is an xml (.rmd file)
    */
   static boolean isFileRmdFile(String sFileName) {
     if (sFileName.endsWith(IParameters.RMD_EXTENSION)) {
       return true;
     } else {
       return false;
     }
   }
   
   /*
    * Displayed the message in the save file info message box
    */
    static void displayedInfoMessage(String sInfoMessage) {
      DataReduction.saveFileInfoMessageTextfield.setText(sInfoMessage);      
    }
    
    /*
     * This function clears the save file info message box
     */
    static void clearInfoMessage() {
      DataReduction.saveFileInfoMessageTextfield.setText("");
    }
}