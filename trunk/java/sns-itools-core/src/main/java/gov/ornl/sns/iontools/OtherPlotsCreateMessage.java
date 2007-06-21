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
      break;
    case 7:  //f( TOf, ---, ---)
      sMessage = "\n\n TOF : Integrated over full range";
      break;
    case 14 ://f( TOFo, ---, ---)
      sMessage = "\n\n  Min TOF is : " + OtherPlotsAction.tBinMin;
      sMessage += "\n  Max TOF is : " + OtherPlotsAction.tBinMax;
      break;
    case 1:  //f( ---, SumX, SumY)
      sMessage = "\n\n  X = Integrated over full range";
      sMessage += "\n  Y = Integrated over full range"; 
      break;
    case 8:  //f( TOF, SumX, SumY)
      sMessage = "\n\n  TOF : Integrated over full range";
      sMessage += "\n  X = Integrated over full range";
      sMessage += "\n  Y = Integrated over full range"; 
      break;
    case 15: //f( TOFo, SumX, SumY)
      sMessage = "\n\n  Min TOF is : " + OtherPlotsAction.tBinMin;
      sMessage += "\n  Max TOF is : " + OtherPlotsAction.tBinMax;
      sMessage += "\n  X = Integrated over full range";
      sMessage += "\n  Y = Integrated over full range"; 
      break;
    case 2:  //f( ---, Xo, SumY)
      sMessage = "\n\n  Xo = " + MouseSelection.infoX;
      sMessage += "\n  Y = Integrated over full range"; 
      break;
    case 9:  //f( TOF, Xo, SumY)
      sMessage = "\n\n  TOF : Integrated over full range";
      sMessage += "\n  Xo = " + MouseSelection.infoX;
      sMessage += "\n  Y : Integrated over full range";
      break;
    case 16: //f( TOFo, Xo, SumY)
      sMessage = "\n\n  Min TOF is : " + OtherPlotsAction.tBinMin;
      sMessage += "\n  Max TOF is : " + OtherPlotsAction.tBinMax;
      sMessage += "\n  Xo = " + MouseSelection.infoX;
      sMessage += "\n  Y = Integrated over full range"; 
      break;
    case 3:  //f( ---, SumX, Yo)
      sMessage = "\n\n  X : Integrated over full range";
      sMessage += "\n  Yo = " + MouseSelection.infoY;
      break;
    case 10: //f( TOF, SumX, Yo)
      sMessage = "\n\n  TOF : Integrated over full range";
      sMessage += "\n  X : Integrated over full range";
      sMessage += "\n  Yo = " + MouseSelection.infoY;
      break;
    case 17: //f( TOFo, SumX, Yo)
      sMessage = "\n\n  Min TOF is : " + OtherPlotsAction.tBinMin;
      sMessage += "\n  Max TOF is : " + OtherPlotsAction.tBinMax;
      sMessage += "\n  X : Integrated over full range";
      sMessage += "\n  Yo = " + MouseSelection.infoY;
      break;
    case 4:  //f( ---, SignalSelection)
    case 11: //f( TOF, SignalSelection)
    case 18: //f( TOFo, SignalSelection)
      if (index == 11) {
        sMessage = "\n\n  TOF : Integrated over full range";
      } else if (index == 18) {
        sMessage = "\n\n  Min TOF = " + OtherPlotsAction.tBinMin;
        sMessage += "\n  Max TOF = " + OtherPlotsAction.tBinMax;
      }
      if (CreateOtherPlotsPanel.saveSelectionRadioButton.isSelected()) {  
        int save_xmin = MouseSelectionParameters.save_signal_xmin;
        int save_xmax = MouseSelectionParameters.save_signal_xmax;
        int save_ymin = MouseSelectionParameters.save_signal_ymin;
        int save_ymax = MouseSelectionParameters.save_signal_ymax;
          sMessage += "\n\nSelection saved (signal):\n  Xmin = " + save_xmin;
          sMessage += "    Xmax = " + save_xmax;
          sMessage += "\n  Ymin = " + save_ymin;
          sMessage += "    Ymax = " + save_ymax;
          if (OtherPlotsUtils.isSelectionValid(save_xmin, save_xmax, save_ymin, save_ymax)) {
            sMessage += "\n\n Signal selection used : " + SaveSignalPidFileAction.pidSignalFileNameShortVersion;
          } else {
            sMessage += "\n\n Please select and save a signal region\n first.";
            OtherPlotsAction.bThreadSafe = false;
          }
        } else {
          int interactive_xmin = MouseSelectionParameters.interactive_signal_xmin;
          int interactive_xmax = MouseSelectionParameters.interactive_signal_xmax;
          int interactive_ymin = MouseSelectionParameters.interactive_signal_ymin;
          int interactive_ymax = MouseSelectionParameters.interactive_signal_ymax;
            sMessage += "\n\nSelection saved (signal):\n  Xmin = " + interactive_xmin;
            sMessage += "    Xmax = " + interactive_xmax;
            sMessage += "\n  Ymin = " + interactive_ymin;
            sMessage += "    Ymax = " + interactive_ymax;
            if (!OtherPlotsUtils.isSelectionValid(interactive_xmin, interactive_xmax, interactive_ymin, interactive_ymax)) {
              sMessage += "\n\n Please select a signal region first.";
              OtherPlotsAction.bThreadSafe = false;
            }
        }
        break;
    case 5:  //f( ---, BackSelection)
    case 12: //f( TOF, BackSelection)
    case 19: //f( TOFo, BackSelection)
      if (index == 12) {
        sMessage = "\n\n TOF : Integrated over full range";
      } else if (index == 19) {
        sMessage = "\n\n  Min TOF = " + OtherPlotsAction.tBinMin;
        sMessage += "\n  Max TOF = " + OtherPlotsAction.tBinMax;
      }
      sMessage += "\n\nSelection (background 1):\n  Xmin = " + MouseSelectionParameters.back1_xmin;
      sMessage += "    Xmax = " + MouseSelectionParameters.back1_xmax;
      sMessage += "\n  Ymin = " + MouseSelectionParameters.back1_ymin;
      sMessage += "    Ymax = " + MouseSelectionParameters.back1_ymax;
      break;
    case 6:  //f( ---, Back2Selection)
    case 13: //f( TOF, Back2Selection)
    case 20: //f( TOFo, Back2Selection)
      if (index == 13) {
        sMessage = "\n\n TOF : Integrated over full range";
      } else if (index == 20) {
        sMessage = "\n\n  Min TOF = " + OtherPlotsAction.tBinMin;
        sMessage += "\n  Max TOF = " + OtherPlotsAction.tBinMax;
      }
      sMessage += "\n\nSelection (background 2):\n  Xmin = " + MouseSelectionParameters.back2_xmin;
      sMessage += "    Xmax = " + MouseSelectionParameters.back2_xmax;
      sMessage += "\n  Ymin = " + MouseSelectionParameters.back2_ymin;
      sMessage += "    Ymax = " + MouseSelectionParameters.back2_ymax;
      break;
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
