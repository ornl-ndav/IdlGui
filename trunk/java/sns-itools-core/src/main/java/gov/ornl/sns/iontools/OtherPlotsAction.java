package gov.ornl.sns.iontools;

import java.awt.Graphics;

public class OtherPlotsAction {

  static void selectDesiredPlot() {
  
    Graphics g = DataReduction.c_otherPlots.getGraphics();
    
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
  }
  
  /*
   * This function plots the total number of counts of the right click X over
   * the full range of Y
   */
  static void plotTotalCountsRightClickX(int index) {
    displayInfoMessage(index);
  }
  
  /*
   * This function plots the total number of counts of the right click Y over
   * the full range of X
   */
  static void plotTotalCountsRightClickY(int index) {
    displayInfoMessage(index);
  }
  
  /*
   * This function plots the total number of counts of the signal selection
   */
  static void plotTotalCountsSelectedSignal(int index) {
    displayInfoMessage(index);
  }
  
  /*
   * This function plots the total number of counts of the background 1 selection
   */
  static void plotTotalCountsSelectedBack1(int index) {
    displayInfoMessage(index);
  }

  /*
   * This function plots the total number of counts of the background 2 selection
   */
  static void plotTotalCountsSelectedBack2(int index) {
    displayInfoMessage(index);
  }

  /*
   * This function plots the total number of counts for a given range of Tbins
   */
  static void plotfull2dForGivenTbinRange(int index) {
    displayInfoMessage(index);
    System.out.println("in static void plotfull2dForGivenTbinRange()");
  }

  /*
   * This function displays the description of the function selected
   */
  static void displayInfoMessage(int index) {
    CreateOtherPlotsPanel.infoTextArea.setText(IParameters.MESSAGE_LIST_OF_OTHER_PLOTS[index]);
  }

}
