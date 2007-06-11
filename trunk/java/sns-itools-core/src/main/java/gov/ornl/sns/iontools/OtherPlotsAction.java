package gov.ornl.sns.iontools;

import java.awt.Graphics;

public class OtherPlotsAction {

  static void selectDesiredPlot() {
  
    Graphics g = DataReduction.c_otherPlots.getGraphics();
    
    int iPlotSelected = DataReduction.listOfOtherPlotsComboBox.getSelectedIndex();
    switch (iPlotSelected) {
    case 0:
         clearPlot();
         break;
    case 1:
         plotTotalCountsFullDetectorRange();
         break;
    case 2:
         plotTotalCountsRightClickX();
         break;
    case 3:
         plotTotalCountsRightClickY();
         break;
    case 4:
         plotTotalCountsSelectedSignal();
         break;
    case 5:
         plotTotalCountsSelectedBack1();
         break;
    case 6:
         plotTotalCountsSelectedBack2();
         break;
    case 7: 
      plotfull2dForGivenTbinRange();
         break;
    default:
    }
  }

  /*
   * This function clears the plot
   */
  static void clearPlot() {
    
  }
  
  /*
   * This function plots the total number of counts of the full detector area
   */
  static void plotTotalCountsFullDetectorRange() {
    System.out.println("  static void plotTotalCountsFullDetectorRange() ");
  }
  
  /*
   * This function plots the total number of counts of the right click X over
   * the full range of Y
   */
  static void plotTotalCountsRightClickX() {
    System.out.println("static void plotTotalCountsRightClickX()");
  }
  
  /*
   * This function plots the total number of counts of the right click Y over
   * the full range of X
   */
  static void plotTotalCountsRightClickY() {
    System.out.println("static void plotTotalCountsRightClickY() ");
  }
  
  /*
   * This function plots the total number of counts of the signal selection
   */
  static void plotTotalCountsSelectedSignal() {
    System.out.println("static void plotTotalCountsSelectedSignal() ");
  }
  
  /*
   * This function plots the total number of counts of the background 1 selection
   */
  static void plotTotalCountsSelectedBack1() {
    System.out.println("static void plotTotalCountsSelectedBack1() ");
  }

  /*
   * This function plots the total number of counts of the background 2 selection
   */
  static void plotTotalCountsSelectedBack2() {
    System.out.println("  static void plotTotalCountsSelectedBack2() ");
  }

  /*
   * This function plots the total number of counts for a given range of Tbins
   */
  static void plotfull2dForGivenTbinRange() {
    System.out.println("in static void plotfull2dForGivenTbinRange()");
  }

}
