package gov.ornl.sns.iontools;

public class OtherPlotsCreateCmd {

  /*
   * This functions creates the cmd to run
   */
  static String createCmd(int index) {
    
    String cmd = "";
    String sTbinMin;
    String sTbinMax;
    int iTbinMin;
    int iTbinMax;
    com.rsi.ion.IONVariable ionTOFmin;
    com.rsi.ion.IONVariable ionTOFmax;
    com.rsi.ion.IONVariable ionTOFo;
        
    DataReduction.c_ionCon.setDrawable(DataReduction.c_otherPlots);
    
    com.rsi.ion.IONVariable ionTmpHistoFile = new com.rsi.ion.IONVariable(DataReduction.sTmpOutputFileName);
    com.rsi.ion.IONVariable ionNx = new com.rsi.ion.IONVariable(DataReduction.Nx);
    com.rsi.ion.IONVariable ionNy = new com.rsi.ion.IONVariable(DataReduction.Ny);
    
    switch (index) {
    
    case 0: //I=f(?,?,?)
    case 1: //I=f(?,sumx,sumy)
    case 2: //I=f(?,Xo,sumy)
    case 3: //I=f(?,sumx,Yo)
    case 4: //I=f(?,Xo,Yo)
    case 5: //I=f(?,signal selection)
    case 6: //I=f(?,back selection)
    case 7: //I=f(?,back2 selection)
    case 8: //I=f(tof,?,?)
      break;
    case 9:  //I=f(TOF,sum(X),sum(Y))
    case 17: //I=f(TOFo,sum(X),sum(Y))
      cmd = IParameters.LIST_OF_PRO_FILES[1];
      sTbinMin = CreateOtherPlotsPanel.tBinMinTextField.getText();
      sTbinMax = CreateOtherPlotsPanel.tBinMaxTextField.getText();
      if (UtilsFunction.isInputInteger(sTbinMin) &&
          UtilsFunction.isInputInteger(sTbinMax)) {
          OtherPlotsAction.tBinMin = Integer.parseInt(sTbinMin);
          OtherPlotsAction.tBinMax = Integer.parseInt(sTbinMax);
          if (OtherPlotsUtils.isTBinMinMaxCorrect(OtherPlotsAction.tBinMin, OtherPlotsAction.tBinMax)) {
            ParametersConfiguration.TBinMax = OtherPlotsAction.tBinMax;
            ParametersConfiguration.TBinMin = OtherPlotsAction.tBinMin;
            com.rsi.ion.IONVariable ionTBinMin = new com.rsi.ion.IONVariable(OtherPlotsAction.tBinMin);
            com.rsi.ion.IONVariable ionTBinMax = new com.rsi.ion.IONVariable(OtherPlotsAction.tBinMax);
            if (CreateOtherPlotsPanel.list1OfOtherPlotsComboBox.getSelectedIndex() == 1) {
              ionTOFo = new com.rsi.ion.IONVariable(0);
            } else {
              ionTOFo = new com.rsi.ion.IONVariable(1);
            }             
            cmd += "," + ionTBinMin;
            cmd += "," + ionTBinMax;
            cmd += "," + ionTOFo;
          } else {
            OtherPlotsAction.bThreadSafe = false;
          }
        } else {
        OtherPlotsAction.bThreadSafe = false;
      }
      break;
    case 16: //I=f(tofo,?,?)
      break;
    case 10:  //I=f(TOF,Xo,Sum(Y))
    case 18: //I=f(TOFo, Xo, Sum(Y))
      if (UtilsFunction.isInputValid(MouseSelection.infoX,0,DataReduction.Nx)) {
        cmd = IParameters.LIST_OF_PRO_FILES[2];
        ionTOFmin = new com.rsi.ion.IONVariable(CreateOtherPlotsPanel.tBinMinTextField.getText());
        ionTOFmax = new com.rsi.ion.IONVariable(CreateOtherPlotsPanel.tBinMaxTextField.getText());
        if (CreateOtherPlotsPanel.list1OfOtherPlotsComboBox.getSelectedIndex() == 1) {
          ionTOFo = new com.rsi.ion.IONVariable(0);
        } else {
          ionTOFo = new com.rsi.ion.IONVariable(1);
        }
        cmd += "," + ionTOFmin;
        cmd += "," + ionTOFmax;
        cmd += "," + ionTOFo;
        com.rsi.ion.IONVariable ionXo = new com.rsi.ion.IONVariable(MouseSelection.infoX);
        cmd += "," + ionXo;
      } else {
        OtherPlotsAction.bThreadSafe = false;
      }
      break;
    case 11: //I=f(TOF,Sum(X),Yo)
    case 19: //I=f(TOFo,Sum(X),Yo)
      if (UtilsFunction.isInputValid(MouseSelection.infoY,0,DataReduction.Ny)) {
             cmd = IParameters.LIST_OF_PRO_FILES[3];
             ionTOFmin = new com.rsi.ion.IONVariable(CreateOtherPlotsPanel.tBinMinTextField.getText());
             ionTOFmax = new com.rsi.ion.IONVariable(CreateOtherPlotsPanel.tBinMaxTextField.getText());
             if (CreateOtherPlotsPanel.list1OfOtherPlotsComboBox.getSelectedIndex() == 1) {
               ionTOFo = new com.rsi.ion.IONVariable(0);
             } else {
               ionTOFo = new com.rsi.ion.IONVariable(1);
             }
             cmd += "," + ionTOFmin;
             cmd += "," + ionTOFmax;
             cmd += "," + ionTOFo;
             com.rsi.ion.IONVariable ionYo = new com.rsi.ion.IONVariable(MouseSelection.infoY);
             cmd += "," + ionYo;
        } else {
          OtherPlotsAction.bThreadSafe = false;
        }
      break;
    case 12: //I=f(TOF,Xo,Yo)
    case 20: //I=f(TOFo,Xo,Yo)
      if (UtilsFunction.isInputValid(MouseSelection.infoX,0,DataReduction.Nx) &&
          UtilsFunction.isInputValid(MouseSelection.infoY,0,DataReduction.Ny)) {
          cmd = IParameters.LIST_OF_PRO_FILES[4];
          ionTOFmin = new com.rsi.ion.IONVariable(CreateOtherPlotsPanel.tBinMinTextField.getText());
          ionTOFmax = new com.rsi.ion.IONVariable(CreateOtherPlotsPanel.tBinMaxTextField.getText());
          if (CreateOtherPlotsPanel.list1OfOtherPlotsComboBox.getSelectedIndex() == 1) {
            ionTOFo = new com.rsi.ion.IONVariable(0);
          } else {
            ionTOFo = new com.rsi.ion.IONVariable(1);
          }
          cmd += "," + ionTOFmin;
          cmd += "," + ionTOFmax;
          cmd += "," + ionTOFo;
          com.rsi.ion.IONVariable ionXo = new com.rsi.ion.IONVariable(MouseSelection.infoX);
          com.rsi.ion.IONVariable ionYo = new com.rsi.ion.IONVariable(MouseSelection.infoY);
          cmd += "," + ionXo;
          cmd += "," + ionYo;
       } else {
          OtherPlotsAction.bThreadSafe = false;
       }
      break;
    case 13: //I=f(TOF,signal_selection)
    case 21: //I=f(TOFo,Signal selection)
      cmd = IParameters.LIST_OF_PRO_FILES[5];
      if (CreateOtherPlotsPanel.list1OfOtherPlotsComboBox.getSelectedIndex() == 1) {
        ionTOFo = new com.rsi.ion.IONVariable(0);
      } else {
        ionTOFo = new com.rsi.ion.IONVariable(1);
        sTbinMin = CreateOtherPlotsPanel.tBinMinTextField.getText();
        sTbinMax = CreateOtherPlotsPanel.tBinMaxTextField.getText();
        if (UtilsFunction.isInputInteger(sTbinMin) &&
            UtilsFunction.isInputInteger(sTbinMax)) {
          iTbinMin = Integer.parseInt(sTbinMin);
          iTbinMax = Integer.parseInt(sTbinMax);
          if (!OtherPlotsUtils.isTBinMinMaxCorrect(iTbinMin, iTbinMax)) {
            OtherPlotsAction.bThreadSafe = false;
          }
        }
      }
      ionTOFmin = new com.rsi.ion.IONVariable(CreateOtherPlotsPanel.tBinMinTextField.getText());
      ionTOFmax = new com.rsi.ion.IONVariable(CreateOtherPlotsPanel.tBinMaxTextField.getText());
      
      cmd += "," + ionTOFmin;
      cmd += "," + ionTOFmax;
      cmd += "," + ionTOFo;
      
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
    case 14: //Counts = f( TOF , back1_selection )
    case 22: //Counts = f(TOFo, back selection)
      cmd = IParameters.LIST_OF_PRO_FILES[5];
      ionTOFmin = new com.rsi.ion.IONVariable(CreateOtherPlotsPanel.tBinMinTextField.getText());
      ionTOFmax = new com.rsi.ion.IONVariable(CreateOtherPlotsPanel.tBinMaxTextField.getText());
      if (CreateOtherPlotsPanel.list1OfOtherPlotsComboBox.getSelectedIndex() == 1) {
        ionTOFo = new com.rsi.ion.IONVariable(0);
      } else {
        ionTOFo = new com.rsi.ion.IONVariable(1);
      }
      cmd += "," + ionTOFmin;
      cmd += "," + ionTOFmax;
      cmd += "," + ionTOFo;
      
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
    case 15: //Counts = f( TOF , back2_selection )
    case 23: //Counts = f(TOFo, back2 selection)
      cmd = IParameters.LIST_OF_PRO_FILES[5];
      
      ionTOFmin = new com.rsi.ion.IONVariable(CreateOtherPlotsPanel.tBinMinTextField.getText());
      ionTOFmax = new com.rsi.ion.IONVariable(CreateOtherPlotsPanel.tBinMaxTextField.getText());
      if (CreateOtherPlotsPanel.list1OfOtherPlotsComboBox.getSelectedIndex() == 1) {
        ionTOFo = new com.rsi.ion.IONVariable(0);
      } else {
        ionTOFo = new com.rsi.ion.IONVariable(1);
      }
      cmd += "," + ionTOFmin;
      cmd += "," + ionTOFmax;
      cmd += "," + ionTOFo;
      
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
    case 24: //clear
      cmd = IParameters.LIST_OF_PRO_FILES[0];
      break;
    default:
    } 
    cmd += "," + ionTmpHistoFile + "," + ionNx + "," + ionNy;
    return cmd;
  }
}
