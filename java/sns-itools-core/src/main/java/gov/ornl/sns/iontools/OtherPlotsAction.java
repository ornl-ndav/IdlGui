package gov.ornl.sns.iontools;

public class OtherPlotsAction {

  static boolean bThreadSafe;
  static int tBinMin = 0;
  static int tBinMax = 0;
  
  static void selectDesiredPlot() {
  
    bThreadSafe = true;
        
    int iTOFSelected = CreateOtherPlotsPanel.list1OfOtherPlotsComboBox.getSelectedIndex();
    int iXYSelected = CreateOtherPlotsPanel.list2OfOtherPlotsComboBox.getSelectedIndex();
    int iIndex = iTOFSelected * 10 + iXYSelected;
    
    switch (iIndex) {
      case 0: //do nothing
        break;
      case 1:  //f( ---, SumX, SumY)
      case 11: //f( TOF, SumX, SumY)
      case 21: //f( TOFo, SumX, SumY)
        plotTotalCountsFullDetectorRange(iIndex);
        break;
      case 2:  //f( ---, Xo, SumY)
      case 12: //f( TOF, Xo, SumY)
      case 22: //f( TOFo, Xo, SumY)
        plotTotalCountsRightClickX(iIndex);
        break;
      case 3:  //f( ---, SumX, Xo)
      case 13: //f( TOF, SumX, Xo)
      case 23: //f( TOFo, SumX, Xo)
        plotTotalCountsRightClickY(iIndex);
        break;
      case 4:  //f( ---, SignalSelection)
      case 14: //f( TOF, SignalSelection)
      case 24: //f( TOFo, SignalSelection)
        plotTotalCountsSelectedSignal(iIndex);
        break;
      case 5:  //f( ---, BackSelection)
      case 15: //f( TOF, BackSelection)
      case 25: //f( TOFo, BackSelection)
        plotTotalCountsSelectedBack1(iIndex);
        break;
      case 6:  //f( ---, Back2Selection)
      case 16: //f( TOF, Back2Selection)
      case 26: //f( TOFo, Back2Selection)
        plotTotalCountsSelectedBack2(iIndex);
        break;
      default:
      }
      
    //make various fields visible or invisible.
    OtherPlotsUpdateGui.updateGUI(iIndex); 
  }
  
  /*
   * This functions takes care of the multiThreading launching
   */
  static void startThread(String cmd) {
  
  //plot will run in another thread
  SubmitOtherPlots run = new SubmitOtherPlots(cmd);
  Thread runThread = new Thread(run,"plot in progress");
  runThread.start();
      
  }

    
  /*
   * This function clears the plot
   */
  static void clearPlot(int index) {
    OtherPlotsCreateMessage.displayInfoMessage(index);
    String cmd = OtherPlotsCreateCmd.createCmd(index);
    startThread(cmd);
  }
  
  /*
   * This function plots the total number of counts of the full detector area
   */
  static void plotTotalCountsFullDetectorRange(int index) {
    OtherPlotsCreateMessage.displayInfoMessage(index);
    String cmd = OtherPlotsCreateCmd.createCmd(index);
    startThread(cmd);
  }
  
  /*
   * This function plots the total number of counts of the right click X over
   * the full range of Y
   */
  static void plotTotalCountsRightClickX(int index) {
    OtherPlotsCreateMessage.displayInfoMessage(index);
    OtherPlotsCreateMessage.displayMoreInfo(index);
    String cmd = OtherPlotsCreateCmd.createCmd(index);
    if (bThreadSafe) {
      startThread(cmd);
    } else {
      OtherPlotsCreateMessage.displayErrorMessage();
    }
  }
  
  /*
   * This function plots the total number of counts of the right click Y over
   * the full range of X
   */
  static void plotTotalCountsRightClickY(int index) {
    OtherPlotsCreateMessage.displayInfoMessage(index);
    OtherPlotsCreateMessage.displayMoreInfo(index);
    String cmd = OtherPlotsCreateCmd.createCmd(index);
    if (bThreadSafe) {
      startThread(cmd);
    } else {
      OtherPlotsCreateMessage.displayErrorMessage();
    }
  }
  
  /*
   * This function plots the total number of counts of the signal selection
   */
  static void plotTotalCountsSelectedSignal(int index) {
    OtherPlotsCreateMessage.displayInfoMessage(index);
    OtherPlotsCreateMessage.displayMoreInfo(index);
    String cmd = OtherPlotsCreateCmd.createCmd(index);
    if (bThreadSafe) {
      startThread(cmd);
    } else {
      OtherPlotsCreateMessage.displayErrorMessage();
    }
  }
  
  /*
   * This function plots the total number of counts of the background 1 selection
   */
  static void plotTotalCountsSelectedBack1(int index) {
    OtherPlotsCreateMessage.displayInfoMessage(index);
    OtherPlotsCreateMessage.displayMoreInfo(index);
    String cmd = OtherPlotsCreateCmd.createCmd(index);
    if (bThreadSafe) {
      startThread(cmd);
    } else {
      OtherPlotsCreateMessage.displayErrorMessage();
    }
  }

  /*
   * This function plots the total number of counts of the background 2 selection
   */
  static void plotTotalCountsSelectedBack2(int index) {
    OtherPlotsCreateMessage.displayInfoMessage(index);
    OtherPlotsCreateMessage.displayMoreInfo(index);
    String cmd = OtherPlotsCreateCmd.createCmd(index);
    if (bThreadSafe) {
      startThread(cmd);
    } else {
      OtherPlotsCreateMessage.displayErrorMessage();
    }
  }

  /*
   * This function plots the total number of counts for a given range of Tbins
   */
  static void plotfull2dForGivenTbinRange(int index) {
    OtherPlotsCreateMessage.displayInfoMessage(index);
    String cmd = OtherPlotsCreateCmd.createCmd(index);
    OtherPlotsCreateMessage.displayMoreInfo(index);
    if (bThreadSafe) {
      startThread(cmd);
    } else {
      OtherPlotsCreateMessage.displayErrorMessage();
    }
  }
}