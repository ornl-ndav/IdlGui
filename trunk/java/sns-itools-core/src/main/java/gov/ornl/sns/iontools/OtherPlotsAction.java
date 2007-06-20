package gov.ornl.sns.iontools;

public class OtherPlotsAction {

  static boolean bThreadSafe;
  static int tBinMin = 0;
  static int tBinMax = 0;
  
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
      
      int xminS = MouseSelectionParameters.signal_xmin;
      int xmaxS = MouseSelectionParameters.signal_xmax;
      int yminS = MouseSelectionParameters.signal_ymin;
      int ymaxS = MouseSelectionParameters.signal_ymax;
      
      com.rsi.ion.IONVariable ionXminS = new com.rsi.ion.IONVariable(xminS);
      com.rsi.ion.IONVariable ionXmaxS = new com.rsi.ion.IONVariable(xmaxS);
      com.rsi.ion.IONVariable ionYminS = new com.rsi.ion.IONVariable(yminS);
      com.rsi.ion.IONVariable ionYmaxS = new com.rsi.ion.IONVariable(ymaxS);
      
      if (isSelectionValid(xminS, xmaxS, yminS, ymaxS)) {
        cmd += "," + ionXminS;
        cmd += "," + ionXmaxS;
        cmd += "," + ionYminS;
        cmd += "," + ionYmaxS;
      } else {
        bThreadSafe = false;
      }
      break;
    case 5: //Counts = f( TOF , back1_selection )
      cmd = IParameters.LIST_OF_PRO_FILES[index];
      
      int xminB1 = MouseSelectionParameters.back1_xmin;
      int xmaxB1 = MouseSelectionParameters.back1_xmax;
      int yminB1 = MouseSelectionParameters.back1_ymin;
      int ymaxB1 = MouseSelectionParameters.back1_ymax;
      
      com.rsi.ion.IONVariable ionXminB1 = new com.rsi.ion.IONVariable(xminB1);
      com.rsi.ion.IONVariable ionXmaxB1 = new com.rsi.ion.IONVariable(xmaxB1);
      com.rsi.ion.IONVariable ionYminB1 = new com.rsi.ion.IONVariable(yminB1);
      com.rsi.ion.IONVariable ionYmaxB1 = new com.rsi.ion.IONVariable(ymaxB1);
      
      if (isSelectionValid(xminB1, xmaxB1, yminB1, ymaxB1)) {
        cmd += "," + ionXminB1;
        cmd += "," + ionXmaxB1;
        cmd += "," + ionYminB1;
        cmd += "," + ionYmaxB1;
      } else {
        bThreadSafe = false;
      }
      break;
    case 6: //Counts = f( TOF , back2_selection )
      cmd = IParameters.LIST_OF_PRO_FILES[index];
      
      int xminB2 = MouseSelectionParameters.back2_xmin;
      int xmaxB2 = MouseSelectionParameters.back2_xmax;
      int yminB2 = MouseSelectionParameters.back2_ymin;
      int ymaxB2 = MouseSelectionParameters.back2_ymax;
      
      com.rsi.ion.IONVariable ionXminB2 = new com.rsi.ion.IONVariable(xminB2);
      com.rsi.ion.IONVariable ionXmaxB2 = new com.rsi.ion.IONVariable(xmaxB2);
      com.rsi.ion.IONVariable ionYminB2 = new com.rsi.ion.IONVariable(yminB2);
      com.rsi.ion.IONVariable ionYmaxB2 = new com.rsi.ion.IONVariable(ymaxB2);
      
      if (isSelectionValid(xminB2, xmaxB2, yminB2, ymaxB2)) {
        cmd += "," + ionXminB2;
        cmd += "," + ionXmaxB2;
        cmd += "," + ionYminB2;
        cmd += "," + ionYmaxB2;
      } else {
        bThreadSafe = false;
      }
      break;
    case 7: //Counts = f( TOFo , Sum(X) , Sum(Y) )
      cmd = IParameters.LIST_OF_PRO_FILES[index];
      String sTbinMin = CreateOtherPlotsPanel.tBinMinTextField.getText();
      String sTbinMax = CreateOtherPlotsPanel.tBinMaxTextField.getText();
      if (UtilsFunction.isInputInteger(sTbinMin) &&
          UtilsFunction.isInputInteger(sTbinMax)) {
          tBinMin = Integer.parseInt(sTbinMin);
          tBinMax = Integer.parseInt(sTbinMax);
          if (isTBinMinMaxCorrect(tBinMin, tBinMax)) {
            ParametersConfiguration.TBinMax = tBinMax;
            ParametersConfiguration.TBinMin = tBinMin;
            com.rsi.ion.IONVariable ionTBinMin = new com.rsi.ion.IONVariable(tBinMin);
            com.rsi.ion.IONVariable ionTBinMax = new com.rsi.ion.IONVariable(tBinMax);
            cmd += "," + ionTBinMin;
            cmd += "," + ionTBinMax;
          } else {
            bThreadSafe = false;
          }
        } else {
        bThreadSafe = false;
      }
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
    displayMoreInfo(index);
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
    displayMoreInfo(index);
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
    displayMoreInfo(index);
    if (bThreadSafe) {
      startThread(cmd);
    } else {
      displayErrorMessage();
    }
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
        sMessage = "\n\n  Min Tbin is : " + tBinMin;
        sMessage += "\n  Max Tbin is : " + tBinMax;
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
  
  /*
   * Checks that 0 <= TBinMin <= Ntof and TBinMin <= TBinMax <= Ntof
   */
  static boolean isTBinMinMaxCorrect(int TBinMin, int TBinMax) {
    
    int NTof = Integer.parseInt(DataReduction.sNtof);
    if (0 <= TBinMin &&
        TBinMin <= NTof &&
        TBinMin <= TBinMax &&
        TBinMax <= NTof) {
      return true;
    } else {
      return false;
    }
          
  }
}