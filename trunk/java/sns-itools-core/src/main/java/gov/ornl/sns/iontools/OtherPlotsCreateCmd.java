package gov.ornl.sns.iontools;

public class OtherPlotsCreateCmd {

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
        OtherPlotsAction.bThreadSafe = false;
      }
      break;
    case 3: //Counts = f( TOF , Sum(X) , Yo )
      if (UtilsFunction.isInputValid(MouseSelection.infoY,0,DataReduction.Ny)) {
             cmd = IParameters.LIST_OF_PRO_FILES[index];
             com.rsi.ion.IONVariable ionYo = new com.rsi.ion.IONVariable(MouseSelection.infoY);
             cmd += "," + ionYo;
        } else {
          OtherPlotsAction.bThreadSafe = false;
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
      
      if (OtherPlotsUtils.isSelectionValid(xminS, xmaxS, yminS, ymaxS)) {
        cmd += "," + ionXminS;
        cmd += "," + ionXmaxS;
        cmd += "," + ionYminS;
        cmd += "," + ionYmaxS;
      } else {
        OtherPlotsAction.bThreadSafe = false;
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
      
      if (OtherPlotsUtils.isSelectionValid(xminB1, xmaxB1, yminB1, ymaxB1)) {
        cmd += "," + ionXminB1;
        cmd += "," + ionXmaxB1;
        cmd += "," + ionYminB1;
        cmd += "," + ionYmaxB1;
      } else {
        OtherPlotsAction.bThreadSafe = false;
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
      
      if (OtherPlotsUtils.isSelectionValid(xminB2, xmaxB2, yminB2, ymaxB2)) {
        cmd += "," + ionXminB2;
        cmd += "," + ionXmaxB2;
        cmd += "," + ionYminB2;
        cmd += "," + ionYmaxB2;
      } else {
        OtherPlotsAction.bThreadSafe = false;
      }
      break;
    case 7: //Counts = f( TOFo , Sum(X) , Sum(Y) )
      cmd = IParameters.LIST_OF_PRO_FILES[index];
      String sTbinMin = CreateOtherPlotsPanel.tBinMinTextField.getText();
      String sTbinMax = CreateOtherPlotsPanel.tBinMaxTextField.getText();
      if (UtilsFunction.isInputInteger(sTbinMin) &&
          UtilsFunction.isInputInteger(sTbinMax)) {
          OtherPlotsAction.tBinMin = Integer.parseInt(sTbinMin);
          OtherPlotsAction.tBinMax = Integer.parseInt(sTbinMax);
          if (OtherPlotsUtils.isTBinMinMaxCorrect(OtherPlotsAction.tBinMin, OtherPlotsAction.tBinMax)) {
            ParametersConfiguration.TBinMax = OtherPlotsAction.tBinMax;
            ParametersConfiguration.TBinMin = OtherPlotsAction.tBinMin;
            com.rsi.ion.IONVariable ionTBinMin = new com.rsi.ion.IONVariable(OtherPlotsAction.tBinMin);
            com.rsi.ion.IONVariable ionTBinMax = new com.rsi.ion.IONVariable(OtherPlotsAction.tBinMax);
            cmd += "," + ionTBinMin;
            cmd += "," + ionTBinMax;
          } else {
            OtherPlotsAction.bThreadSafe = false;
          }
        } else {
        OtherPlotsAction.bThreadSafe = false;
      }
      break;
    default:
    } 
    cmd += "," + ionTmpHistoFile + "," + ionNx + "," + ionNy;
    return cmd;
  }
  
}
