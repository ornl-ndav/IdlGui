package gov.ornl.sns.iontools;

public class StoreFilesToSavePreview {

  static String[] sResultArray;
    
  public StoreFilesToSavePreview(String[] sMessage) {
      this.sResultArray= sMessage;
  }
  
  /*
   * This function return the string array
   */
  public String[] getStringArray () {
    return this.sResultArray;
  }
  
}
