package gov.ornl.sns.iontools;

import java.util.Hashtable;
import java.util.List;

public class StoreFilesToSavePreview {

  static int iNbrOfFiles;
  static String[] sCompleteListOfFiles;
  static String[] myResultArray;
  
  static void createHashtableOfFilesToSave() {
    
    //SaveFilesTabAction.sHashtableOfFiles = new Hashtable<String, String[]>();
    SaveFilesTabAction.sHashtableOfFiles = new Hashtable<String, List<String>>();
    
    sCompleteListOfFiles = SaveFilesTabAction.sCompleteListOfFiles;
    iNbrOfFiles = SaveFilesTabAction.iNbrOfFiles;  
    populateHashtable();
    
  }
  
  static void populateHashtable() {
    
    SubmitGetSelectionFileInfo runInfo = new SubmitGetSelectionFileInfo(sCompleteListOfFiles, iNbrOfFiles);
    Thread runThread = new Thread(runInfo,"Get info about file in progress");
    runThread.start();
  } 
  
}
