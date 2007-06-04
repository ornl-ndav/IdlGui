package gov.ornl.sns.iontools;

/*
 * This class display the info about a particular file selected
 */
public class SubmitGetSelectionFileInfo implements Runnable {

  public SubmitGetSelectionFileInfo() {
  }
  
  public void run() {

    if (!DataReduction.filesToTransferList.isSelectionEmpty()) {

      int[] iSelection = DataReduction.filesToTransferList.getSelectedIndices();
      String sFileName = SaveFilesTabAction.sListOfFiles[iSelection[0]];
      
      if (SaveFilesTabAction.isFileRmdFile(sFileName)) { //xml file (.rmd file)
        
        String message = "The first ";
        message += ParametersToKeep.iNbrInfoLinesXmlToDisplayed;
        message += "  lines of the selected file are displayed";
        SaveFilesTabAction.displayedInfoMessage(message);
        
        String cmd = SaveFilesTabAction.createSaveXmlFileInfoCmd(sFileName);
        IonUtils.executeCmd(cmd);
        com.rsi.ion.IONVariable myIONresult;
        myIONresult = IonUtils.queryVariable("result");
        String[] myResultArray;
        myResultArray = myIONresult.getStringArray();
        SaveFilesTabAction.displayMessageInInfoBox(myResultArray);
      
      } else {
        
        String message = "The first ";
        message += ParametersToKeep.iNbrInfoLinesNotXmlToDisplayed;
        message += "  lines of the selected file are displayed";
        SaveFilesTabAction.displayedInfoMessage(message);
        
        String cmd = SaveFilesTabAction.createSaveFileInfoCmd(sFileName);
        IonUtils.executeCmd(cmd);
        com.rsi.ion.IONVariable myIONresult;
        myIONresult = IonUtils.queryVariable("result");
        String[] myResultArray;
        myResultArray = myIONresult.getStringArray();
        SaveFilesTabAction.displayMessageInInfoBox(myResultArray);
      }
      IonUtils.executeCmd(".reset");
    }

  }
  
}
  