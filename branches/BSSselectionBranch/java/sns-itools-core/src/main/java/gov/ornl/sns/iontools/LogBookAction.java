package gov.ornl.sns.iontools;

public class LogBookAction {

  static void displayMessageInLogBook(String sMessage, boolean bAppend) {
    if (isRemoteUserDeveloper()) { //display message only for developer
      if (bAppend) {
        DataReduction.textAreaLogBook.append(sMessage);
      } else {
        DataReduction.textAreaLogBook.setText(sMessage);
      }
    } 
 }
  
  static boolean isRemoteUserDeveloper() {
    String remoteUser = DataReduction.remoteUser;
    boolean remoteUserIsDeveloper = true;
    if (remoteUser.compareTo(IParameters.DEVELOPER_UCAMS)!=0) {
      remoteUserIsDeveloper = false;
    }
    return remoteUserIsDeveloper;
  }
 
   }
