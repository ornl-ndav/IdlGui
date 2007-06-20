package gov.ornl.sns.iontools;

public class OtherPlotsCreateMessage {

  /*
   * This function displays the description of the function selected
   */
  static void displayInfoMessage(int index) {
    CreateOtherPlotsPanel.infoTextArea.setText(IParameters.MESSAGE_LIST_OF_OTHER_PLOTS[index]);
  }

  /*
   * This function displays more info according to plot selected
   */
  static void displayMoreInfo(int index) {
    String sMessage = "";
    switch(index) {
      case 2: //Counts = f( TOF , Xo , Sum(Y) )
        sMessage = "\n\n  Xo = " + MouseSelection.infoX;
        break;
      case 3: //Counts = f( TOF , Sum(X) , Yo )
        sMessage = "\n\n  Yo = " + MouseSelection.infoY;
        break;
      case 4: //Counts = f( TOF , signal_selection )
        sMessage = "\n\nSelection (signal):\n  Xmin = " + MouseSelectionParameters.signal_xmin;
        sMessage += "  Xmax = " + MouseSelectionParameters.signal_xmax;
        sMessage += "\n  Ymin = " + MouseSelectionParameters.signal_ymin;
        sMessage += "  Ymax = " + MouseSelectionParameters.signal_ymax;
        break;
      case 5: //Counts = f( TOF , back1_selection )
        sMessage = "\n\nSelection (background 1):\n  Xmin = " + MouseSelectionParameters.back1_xmin;
        sMessage += "  Xmax = " + MouseSelectionParameters.back1_xmax;
        sMessage += "\n  Ymin = " + MouseSelectionParameters.back1_ymin;
        sMessage += "  Ymax = " + MouseSelectionParameters.back1_ymax;
        break;
      case 6: //Counts = f( TOF , back2_selection )
        sMessage = "\n\nSelection (background 2):\n  Xmin = " + MouseSelectionParameters.back2_xmin;
        sMessage += "  Xmax = " + MouseSelectionParameters.back2_xmax;
        sMessage += "\n  Ymin = " + MouseSelectionParameters.back2_ymin;
        sMessage += "  Ymax = " + MouseSelectionParameters.back2_ymax;
        break;
      case 7: //Counts = f( TOFo , Sum(X) , Sum(Y) )
        sMessage = "\n\n  Min Tbin is : " + OtherPlotsAction.tBinMin;
        sMessage += "\n  Max Tbin is : " + OtherPlotsAction.tBinMax;
        break;
    }
    CreateOtherPlotsPanel.infoTextArea.append(sMessage);
  }
  
  /*
   * This function lets the user know that the input is invalid
   */
  static void displayErrorMessage() {
    String message = "\n\n ***** INVALID INPUT *****";
    CreateOtherPlotsPanel.infoTextArea.append(message);
  }
  
  
}
