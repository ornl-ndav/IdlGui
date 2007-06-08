package gov.ornl.sns.iontools;

import java.util.Hashtable;

public class StoreFilesToRename {

  /*
   * This function will create the hashtable using the
   * file name as key and value for now.
   */
  static void createHashtableOfFilesToRename() {
    
  SaveFilesTabAction.sHashtableOldNewFileNames = new Hashtable<String, String>();  
  
  String[] sCompleteListOfFiles = SaveFilesTabAction.sCompleteListOfFiles;
  int iNbrOfFiles = SaveFilesTabAction.iNbrOfFiles;  
  populateHashtable(sCompleteListOfFiles, iNbrOfFiles);
  }
  
  /*
   * This function populate the hashtable of files to rename
   */
    static void populateHashtable(String[] sCompleteListOfFiles, int iNbrOfFiles) {
      
      int iCompleteListOfFilesSize = sCompleteListOfFiles.length;
      for (int i=0; i<iCompleteListOfFilesSize; ++i) {
      SaveFilesTabAction.sHashtableOldNewFileNames.put(sCompleteListOfFiles[i], sCompleteListOfFiles[i]);
      }
  } 
  
}
