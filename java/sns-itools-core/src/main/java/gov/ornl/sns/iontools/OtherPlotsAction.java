package gov.ornl.sns.iontools;

import java.awt.Graphics;

public class OtherPlotsAction {

  static void selectDesiredPlot() {
  
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
    Graphics g = DataReduction.c_otherPlots.getGraphics();
    DataReduction.c_ionCon.setDrawable(DataReduction.c_otherPlots);
    
    com.rsi.ion.IONVariable ionTmpFolder = new com.rsi.ion.IONVariable(DataReduction.sTmpOutputFileName);
    com.rsi.ion.IONVariable ionNx = new com.rsi.ion.IONVariable(DataReduction.Nx);
    com.rsi.ion.IONVariable ionNy = new com.rsi.ion.IONVariable(DataReduction.Ny);
        
    switch (index) {
    case 0:  //clear
         g.clearRect(0, 0, IParameters.OTHER_PLOTS_X, IParameters.OTHER_PLOTS_Y);
         break;
    case 1: //Counts = f( TOF , Sum(X) , Sum(Y) )
         cmd = IParameters.LIST_OF_PRO_FILES[index] + "," + ionTmpFolder;
         break;
    case 2: //Counts = f( TOF , Xo , Sum(Y) )
         cmd = IParameters.LIST_OF_PRO_FILES[index] + "," + ionTmpFolder;
         break;
    case 3: //Counts = f( TOF , Sum(X) , Yo )
         cmd = IParameters.LIST_OF_PRO_FILES[index] + "," + ionTmpFolder;
         break;
    case 4: //Counts = f( TOF , signal_selection )
         cmd = IParameters.LIST_OF_PRO_FILES[index] + "," + ionTmpFolder;
         break;
    case 5: //Counts = f( TOF , back1_selection )
         cmd = IParameters.LIST_OF_PRO_FILES[index] + "," + ionTmpFolder;
         break;
    case 6: //Counts = f( TOF , back2_selection )
         cmd = IParameters.LIST_OF_PRO_FILES[index] + "," + ionTmpFolder;
         break;
    case 7: //Counts = f( TOFo , Sum(X) , Sum(Y) )
         cmd = IParameters.LIST_OF_PRO_FILES[index] + "," + ionTmpFolder;
         break;
    default:
    }
    cmd += "," + ionNx + "," + ionNy;
    return cmd;
    
  }
    
  /*
   * This function clears the plot
   */
  static void clearPlot(int index) {
    displayInfoMessage(index);
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
    String cmd = createCmd(index);
    startThread(cmd);
  }
  
  /*
   * This function plots the total number of counts of the right click Y over
   * the full range of X
   */
  static void plotTotalCountsRightClickY(int index) {
    displayInfoMessage(index);
    String cmd = createCmd(index);
    startThread(cmd);
  }
  
  /*
   * This function plots the total number of counts of the signal selection
   */
  static void plotTotalCountsSelectedSignal(int index) {
    displayInfoMessage(index);
    String cmd = createCmd(index);
    startThread(cmd);
  }
  
  /*
   * This function plots the total number of counts of the background 1 selection
   */
  static void plotTotalCountsSelectedBack1(int index) {
    displayInfoMessage(index);
    String cmd = createCmd(index);
    startThread(cmd);
  }

  /*
   * This function plots the total number of counts of the background 2 selection
   */
  static void plotTotalCountsSelectedBack2(int index) {
    displayInfoMessage(index);
    String cmd = createCmd(index);
    startThread(cmd);
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

}
