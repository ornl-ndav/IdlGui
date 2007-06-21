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
    case 0:  //f( ---, ---, ---)
    case 7:  //f( TOf, ---, ---)
    case 14 ://f( TOFo, ---, ---)
    case 1:  //f( ---, SumX, SumY)
    case 8:  //f( TOF, SumX, SumY)
    case 15: //f( TOFo, SumX, SumY)
      sMessage = "\n\n  Min Tbin is : " + OtherPlotsAction.tBinMin;
      sMessage += "\n  Max Tbin is : " + OtherPlotsAction.tBinMax;
      break;
    case 2:  //f( ---, Xo, SumY)
    case 9:  //f( TOF, Xo, SumY)
      sMessage = "\n\n  Xo = " + MouseSelection.infoX;
      break;
    case 16: //f( TOFo, Xo, SumY)
    case 3:  //f( ---, SumX, Yo)
    case 10: //f( TOF, SumX, Yo)
      sMessage = "\n\n  Yo = " + MouseSelection.infoY;
      break;
    case 17: //f( TOFo, SumX, Yo)
    case 4:  //f( ---, SignalSelection)
    case 11: //f( TOF, SignalSelection)
      sMessage = "\n\nSelection (signal):\n  Xmin = " + MouseSelectionParameters.signal_xmin;
      sMessage += "  Xmax = " + MouseSelectionParameters.signal_xmax;
      sMessage += "\n  Ymin = " + MouseSelectionParameters.signal_ymin;
      sMessage += "  Ymax = " + MouseSelectionParameters.signal_ymax;
      break;
    case 18: //f( TOFo, SignalSelection)
    case 5:  //f( ---, BackSelection)
    case 12: //f( TOF, BackSelection)
      sMessage = "\n\nSelection (background 1):\n  Xmin = " + MouseSelectionParameters.back1_xmin;
      sMessage += "  Xmax = " + MouseSelectionParameters.back1_xmax;
      sMessage += "\n  Ymin = " + MouseSelectionParameters.back1_ymin;
      sMessage += "  Ymax = " + MouseSelectionParameters.back1_ymax;
      break;
    case 19: //f( TOFo, BackSelection)
    case 6:  //f( ---, Back2Selection)
    case 13: //f( TOF, Back2Selection)
      sMessage = "\n\nSelection (background 2):\n  Xmin = " + MouseSelectionParameters.back2_xmin;
      sMessage += "  Xmax = " + MouseSelectionParameters.back2_xmax;
      sMessage += "\n  Ymin = " + MouseSelectionParameters.back2_ymin;
      sMessage += "  Ymax = " + MouseSelectionParameters.back2_ymax;
      break;
    case 20: //f( TOFo, Back2Selection)
    default:
    }
    
    CreateOtherPlotsPanel.infoTextArea.append(sMessage);
  }
  
  /*
   * This function lets the user know that a field is missing
   */
  static void displayErrorMessage(int index) {
    String message = "\n\n ***** INVALID INPUT *****";
    CreateOtherPlotsPanel.infoTextArea.append(message);
  }
  
  /*
   * This function lets the user know that the input is invalid
   */
  static void displayErrorInputMessage() {
    String message = "\n\n ***** INVALID INPUT *****";
    CreateOtherPlotsPanel.infoTextArea.append(message);
  }
  
}
