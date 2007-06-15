package gov.ornl.sns.iontools;

public class OtherPlotsAction {

  static boolean bThreadSafe;

  static void selectDesiredPlot() {
  
    bThreadSafe = true;
    
    int iPlotSelected = DataReduction.listOfOtherPlotsComboBox.getSelectedIndex();
    switch (iPlotSelected) {
    case 0:
         clearPlot(iPlotSelected);
         break;
    case 1:
         plotTotalCountsFullDetectorRange(iPlotSelected);
         break;
    case 2:
         plotTotalCountsRightClickX(iPlotSelected);
         break;
    case 3:
         plotTotalCountsRightClickY(iPlotSelected);
         break;
    case 4:
         plotTotalCountsSelectedSignal(iPlotSelected);
         break;
    case 5:
         plotTotalCountsSelectedBack1(iPlotSelected);
         break;
    case 6:
         plotTotalCountsSelectedBack2(iPlotSelected);
         break;
    case 7: 
        plotfull2dForGivenTbinRange(iPlotSelected);
         break;
    default:
    }
    //make various fields visible or invisible.
    OtherPlotsUpdateGui.updateGUI(iPlotSelected); 
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
   * This functions creates the cmd to run
   */
  static String createCmd(int index) {
    
    String cmd = "";
    DataReduction.c_ionCon.setDrawable(DataReduction.c_otherPlots);
    
    com.rsi.ion.IONVariable ionTmpHistoFile = new com.rsi.ion.IONVariable(DataReduction.sTmpOutputFileName);
    com.rsi.ion.IONVariable ionNx = new com.rsi.ion.IONVariable(DataReduction.Nx);
    com.rsi.ion.IONVariable ionNy = new com.rsi.ion.IONVariable(DataReduction.Ny);
    
    switch (index) {
    
    case 0: //clear
      cmd = IParameters.LIST_OF_PRO_FILES[index]; 
      break;
    case 1: //Counts = f( TOF , Sum(X) , Sum(Y) )
      cmd = IParameters.LIST_OF_PRO_FILES[index];
      break;
    case 2: //Counts = f( TOF , Xo , Sum(Y) )
      if (UtilsFunction.isInputValid(MouseSelection.infoX,0,DataReduction.Nx)) {
        cmd = IParameters.LIST_OF_PRO_FILES[index];
        com.rsi.ion.IONVariable ionXo = new com.rsi.ion.IONVariable(MouseSelection.infoX);
        cmd += "," + ionXo;
      } else {
        bThreadSafe = false;
      }
      break;
    case 3: //Counts = f( TOF , Sum(X) , Yo )
      if (UtilsFunction.isInputValid(MouseSelection.infoY,0,DataReduction.Ny)) {
             cmd = IParameters.LIST_OF_PRO_FILES[index];
             com.rsi.ion.IONVariable ionYo = new com.rsi.ion.IONVariable(MouseSelection.infoY);
             cmd += "," + ionYo;
        } else {
          bThreadSafe = false;
        }
      break;
    case 4: //Counts = f( TOF , signal_selection )
      cmd = IParameters.LIST_OF_PRO_FILES[index];
      
      int xmin = MouseSelectionParameters.signal_xmin;
      int xmax = MouseSelectionParameters.signal_xmax;
      int ymin = MouseSelectionParameters.signal_ymin;
      int ymax = MouseSelectionParameters.signal_ymax;
      
      com.rsi.ion.IONVariable ionXmin = new com.rsi.ion.IONVariable(xmin);
      com.rsi.ion.IONVariable ionXmax = new com.rsi.ion.IONVariable(xmax);
      com.rsi.ion.IONVariable ionYmin = new com.rsi.ion.IONVariable(ymin);
      com.rsi.ion.IONVariable ionYmax = new com.rsi.ion.IONVariable(ymax);
      
      if (isSelectionValid(xmin, xmax, ymin, ymax)) {
        cmd += "," + ionXmin;
        cmd += "," + ionXmax;
        cmd += "," + ionYmin;
        cmd += "," + ionYmax;
      } else {
        bThreadSafe = false;
      }
      break;
    case 5: //Counts = f( TOF , back1_selection )
      cmd = IParameters.LIST_OF_PRO_FILES[index];
      break;
    case 6: //Counts = f( TOF , back2_selection )
      cmd = IParameters.LIST_OF_PRO_FILES[index];
      break;
    case 7: //Counts = f( TOFo , Sum(X) , Sum(Y) )
      cmd = IParameters.LIST_OF_PRO_FILES[index];
      break;
    default:
    } 
    
    cmd += "," + ionTmpHistoFile + "," + ionNx + "," + ionNy;

    return cmd;
    
  }
    
  /*
   * This function clears the plot
   */
  static void clearPlot(int index) {
    displayInfoMessage(index);
    String cmd = createCmd(index);
    startThread(cmd);
  }
  
  /*
   * This function plots the total number of counts of the full detector area
   */
  static void plotTotalCountsFullDetectorRange(int index) {
    displayInfoMessage(index);
    String cmd = createCmd(index);
    startThread(cmd);
  }
  
  /*
   * This function plots the total number of counts of the right click X over
   * the full range of Y
   */
  static void plotTotalCountsRightClickX(int index) {
    displayInfoMessage(index);
    displayMoreInfo(index);
    String cmd = createCmd(index);
    if (bThreadSafe) {
      startThread(cmd);
      } else {
        displayErrorMessage();
      }
  }
  
  /*
   * This function plots the total number of counts of the right click Y over
   * the full range of X
   */
  static void plotTotalCountsRightClickY(int index) {
    displayInfoMessage(index);
    displayMoreInfo(index);
    String cmd = createCmd(index);
    if (bThreadSafe) {
      startThread(cmd);
    } else {
      displayErrorMessage();
    }
  }
  
  /*
   * This function plots the total number of counts of the signal selection
   */
  static void plotTotalCountsSelectedSignal(int index) {
    displayInfoMessage(index);
    displayMoreInfo(index);
    String cmd = createCmd(index);
    if (bThreadSafe) {
      startThread(cmd);
    } else {
      displayErrorMessage();
    }
  }
  
  /*
   * This function plots the total number of counts of the background 1 selection
   */
  static void plotTotalCountsSelectedBack1(int index) {
    displayInfoMessage(index);
    String cmd = createCmd(index);
    if (bThreadSafe) {
      startThread(cmd);
    } else {
      displayErrorMessage();
    }
  }

  /*
   * This function plots the total number of counts of the background 2 selection
   */
  static void plotTotalCountsSelectedBack2(int index) {
    displayInfoMessage(index);
    String cmd = createCmd(index);
    if (bThreadSafe) {
      startThread(cmd);
    } else {
      displayErrorMessage();
    }
  }

  /*
   * This function plots the total number of counts for a given range of Tbins
   */
  static void plotfull2dForGivenTbinRange(int index) {
    displayInfoMessage(index);
    String cmd = createCmd(index);
    startThread(cmd);
  }

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
        sMessage = "\n\nSelection:\n  Xmin = " + MouseSelectionParameters.signal_xmin;
        sMessage += "  Xmax = " + MouseSelectionParameters.signal_xmax;
        sMessage += "\n  Ymin = " + MouseSelectionParameters.signal_ymin;
        sMessage += "  Ymax = " + MouseSelectionParameters.signal_ymax;
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
  
  /*
   * This functions checks that the selection is valid 
   */
  static boolean isSelectionValid(int xmin, int xmax, int ymin, int ymax) {
    if (xmin == 0 && xmax == 0 && ymin == 0 && ymax ==0) {
      return false;
    } else {
      return true;
    }
  }
}