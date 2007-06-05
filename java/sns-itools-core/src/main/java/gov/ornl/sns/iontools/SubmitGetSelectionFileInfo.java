package gov.ornl.sns.iontools;

import java.util.Arrays;
import java.util.List;

/*
 * This class display the info about a particular file selected
 */
public class SubmitGetSelectionFileInfo implements Runnable {

  static String[] myResultArray;
  private String[] sFileName;
  private int iNbrOfFiles;
  
  public SubmitGetSelectionFileInfo(String[] sFileName, int iNbrOfFiles) {
    this.sFileName = sFileName;
    this.iNbrOfFiles = iNbrOfFiles;
  }
  
  public void run() {
  
    String[] sFilePreviewArray;
    for (int i=0; i<this.iNbrOfFiles; i++) {
        if (!SaveFilesTabAction.isFileDatFile(sFileName[i])) { 
          sFilePreviewArray = getFilePreviewStringArray(this.sFileName[i]);
          List<String> myListString = Arrays.asList(sFilePreviewArray);  //new
          SaveFilesTabAction.sHashtableOfFiles.put(this.sFileName[i],myListString);
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
  