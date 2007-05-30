package gov.ornl.sns.iontools;

import java.util.Vector;
import com.rsi.ion.*;

public class FilesToTransferAction {

  static Vector vListOfFiles;
  static String[] sListOfFiles;
  static IONVariable ionUcams;
  static IONVariable ionTmpFolder;
  static IONVariable ionFileName;
  
  /*
   * This function upate the list of files to transfered
   */
  static void updateListOfFilesToTransfer() {
  
    sListOfFiles = getListOfFiles();
    for (String file:sListOfFiles) {
      System.out.println(file);
    }
    vListOfFiles = new Vector();
    getVectorListOfFiles(sListOfFiles);
    DataReduction.filesToTransferList.setListData(vListOfFiles);
    
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
  static void getVectorListOfFiles(String[] listFiles) {
  
    for (int i=0; i<(listFiles.length); i++) {
      vListOfFiles.add(listFiles[i]);
      }
  }
  
  /*
   * Function that call the IDL command to transfer the file
   */
  static void transferFile() {
    
    //get selected indeces
    int[] iSelection = DataReduction.filesToTransferList.getSelectedIndices();
    
    //list of files selected and transfer them one at a time
    for (int i=0; i<iSelection.length; i++) {
      String cmd = createCmd(sListOfFiles[i]);
      System.out.println("cmd is: " + cmd);
      IonUtils.executeCmd(cmd);
      //System.out.println(FilesToTransferAction.sListOfFiles[i]);
    }
    
  }
  
  /*
   * Create the cmd that will be run through ION_JAVA
   */
  static String createCmd(String fileName) {
    
    ionUcams = new IONVariable(DataReduction.remoteUser);
    ionTmpFolder = new IONVariable(DataReduction.sTmpFolder);
    ionFileName = new IONVariable(fileName);
    
    String cmd = "";
    
    cmd = "move_file, ";
    cmd += ionUcams + ",";
    cmd += ionTmpFolder + ",";
    cmd += ionFileName;
    return cmd;
    
  }
  
  
  
  
  
  
}
