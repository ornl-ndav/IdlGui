package gov.ornl.sns.iontools;

import java.util.Hashtable;
import java.util.List;
import java.util.Arrays;

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
    
    String[] sFilePreviewArray;
    for (int i=0; i<iNbrOfFiles; i++) {
      if (!SaveFilesTabAction.isFileDatFile(sCompleteListOfFiles[i])) { 
        sFilePreviewArray = getFilePreviewStringArray(sCompleteListOfFiles[i]);
        List<String> myListString = Arrays.asList(sFilePreviewArray);  //new
        SaveFilesTabAction.sHashtableOfFiles.put(sCompleteListOfFiles[i],myListString);

        
        
      }
    }
  }

  /*
   * This function returns the preview of the file name given as an
   * argument
   */
  static String[] getFilePreviewStringArray(String sFileName) {
    if (SaveFilesTabAction.isFileRmdFile(sFileName)) { //xml file (.rmd file)
      return getPreviewOfXmlFile(sFileName);
    } else { //not xml file
      return getPreviewOfNotXmlFile(sFileName);
    }
  }
  
  /*
   * This function returns the preview of the xml file name given
   * as an argument
   */
  static String[] getPreviewOfXmlFile(String sFileName) {
   
    String message = "The first ";
    message += ParametersToKeep.iNbrInfoLinesXmlToDisplayed;
    message += "  lines of the selected file are displayed";
    SaveFilesTabAction.displayedInfoMessage(message);
    
    String cmd = SaveFilesTabAction.createSaveXmlFileInfoCmd(sFileName);
    IonUtils.executeCmd(cmd);
    com.rsi.ion.IONVariable myIONresult;
    myIONresult = IonUtils.queryVariable("result");

    myResultArray = myIONresult.getStringArray();
    return myResultArray;
    
  }
  
  /*
   * This function returns the preview of the non-xml file name given
   * as an argument
   */
  static String[] getPreviewOfNotXmlFile(String sFileName) {
   
    String message = "The first ";
    message += ParametersToKeep.iNbrInfoLinesNotXmlToDisplayed;
    message += "  lines of the selected file are displayed";
    SaveFilesTabAction.displayedInfoMessage(message);
    
    String cmd = SaveFilesTabAction.createSaveFileInfoCmd(sFileName);
    IonUtils.executeCmd(cmd);
    com.rsi.ion.IONVariable myIONresult;
    myIONresult = IonUtils.queryVariable("result");
    
    myResultArray = myIONresult.getStringArray();
    return myResultArray;
    
  }
  
}
