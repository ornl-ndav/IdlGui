package gov.ornl.sns.iontools;

public class SubmitLoadListOfPidFiles implements Runnable{

   private String cmd = null;
   
   public SubmitLoadListOfPidFiles(String cmd) {
       this.cmd = cmd;
   }
  
   public void run() {

     IonUtils.executeCmd(this.cmd);     
     
     com.rsi.ion.IONVariable myIONresult;
     myIONresult = IonUtils.queryVariable("list_of_files");
     
     try {
       LoadSelectionPidFileAction.myResultArray = myIONresult.getStringArray();
       LoadSelectionPidFileAction.listOfPidFiles = new String[LoadSelectionPidFileAction.myResultArray.length];
       System.arraycopy(LoadSelectionPidFileAction.myResultArray, 
             0, 
             LoadSelectionPidFileAction.listOfPidFiles, 
             0, 
             LoadSelectionPidFileAction.myResultArray.length);        
       String[] lastPartResultArray = UtilsFunction.getLastPartOfStringArray(LoadSelectionPidFileAction.myResultArray);
       
       //Number of files to list
       int iNbrOfPidFiles = LoadSelectionPidFileAction.myResultArray.length;
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
   
