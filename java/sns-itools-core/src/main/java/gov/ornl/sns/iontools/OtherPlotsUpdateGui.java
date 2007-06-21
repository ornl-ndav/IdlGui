package gov.ornl.sns.iontools;

public class OtherPlotsUpdateGui {

  /*
   * This function updates the gui according to the plot selected
   */
  static void updateGUI(int index) {
    
    boolean bMakeXoVisible = false;
    boolean bMakeYoVisible = false;
    boolean bMakeTbinVisible = false;
    boolean bMakeSelectionVisible = false;
    
    switch (index) {
    
    case 0: //I=f(?,?,?)
      break;
    case 1: //I=f(?,sumx,sumy)
      break;
    case 2: //I=f(?,xo,sumy)
      bMakeXoVisible = true;
      break;
    case 3: //I=f(?,sumx,yo)
      bMakeYoVisible = true;
      break;
    case 4: //I=f(?,signal selection)
      bMakeSelectionVisible = true;
      break;
    case 5: //I=f(?,back selection)
      break;
    case 6: //I=f(?,back2 selection)
      break;
    case 7: //I=f(tof,?,?)
      break;
    case 8: //I=f(tof,sumx,sumy)
      break;
    case 14: //I=f(tofo,?,?)
      bMakeTbinVisible = true;
      break;
    case 9: //I=f(tof,xo,sumy)
      bMakeXoVisible = true;
      break;
    case 10: //Counts = f( TOF , Sum(X) , Yo )
      bMakeYoVisible = true;
      break;
    case 11: //Counts = f( TOF , signal_selection )
      bMakeSelectionVisible = true;
      break;
    case 12: //Counts = f( TOF , back1_selection )
      break;
    case 13: //Counts = f( TOF , back2_selection )
      break;
    case 15: //Counts = f( TOFo , Sum(X) , Sum(Y) )
      bMakeTbinVisible = true;
      break;
    case 16: //Counts = f(TOFo, Xo, Sum(Y))
      bMakeXoVisible = true;
      bMakeTbinVisible = true;
      break;
    case 17: //Counts = f(TOFo, Sum(X), Yo)
      bMakeYoVisible = true;
      bMakeTbinVisible = true;
      break;
    case 18: //Counts = f(TOFo, Signal selection)
      bMakeSelectionVisible = true;
      bMakeTbinVisible = true;
      break;
    case 19: //Counts = f(TOFo, back selection)
      bMakeTbinVisible = true;
      break;
    case 20: //Counts = f(TOFo, back2 selection)
      bMakeTbinVisible = true;
      break;
    default:
    } 
    makeXoVisible(bMakeXoVisible);
    makeYoVisible(bMakeYoVisible);
    makeTbinVisible(bMakeTbinVisible);
    makeSelectionModeVisible(bMakeSelectionVisible);
  }    

  /*
   * Make visible or invisible xo (label, text-field, xoyoRange label)
   */
  static void makeXoVisible(boolean bVisible) {
      CreateOtherPlotsPanel.xoLabel.setVisible(bVisible);
      CreateOtherPlotsPanel.xoTextField.setVisible(bVisible);
      CreateOtherPlotsPanel.xoRangeLabel.setVisible(bVisible);
      if (bVisible) {
        boolean bIsXo = true;
        String sRangeLabel = getXoYoRangeLabel(bIsXo);
        CreateOtherPlotsPanel.xoRangeLabel.setText(sRangeLabel);
        String sXoTextField = getXoYoTextField(bIsXo);
        CreateOtherPlotsPanel.xoTextField.setText(sXoTextField);
      }
  }

  /*
   * Make visible or invisible yo (label, text-field, xoyoRange label)
   */
  static void makeYoVisible(boolean bVisible) {
    CreateOtherPlotsPanel.yoLabel.setVisible(bVisible);
    CreateOtherPlotsPanel.yoTextField.setVisible(bVisible);
    CreateOtherPlotsPanel.yoRangeLabel.setVisible(bVisible);
    if (bVisible) {
      boolean bIsXo = false;
      String sRangeLabel = getXoYoRangeLabel(bIsXo);
      CreateOtherPlotsPanel.yoRangeLabel.setText(sRangeLabel);
      String sYoTextField = getXoYoTextField(bIsXo);
      CreateOtherPlotsPanel.yoTextField.setText(sYoTextField);
    }
  }

  /*
   * This function will display all the Tbin (min and max)
   * related widgets
   */
  static void makeTbinVisible(boolean bVisible) {
    CreateOtherPlotsPanel.tBinMinLabel.setVisible(bVisible);
    CreateOtherPlotsPanel.tBinMaxLabel.setVisible(bVisible);
    CreateOtherPlotsPanel.tBinMinTextField.setVisible(bVisible);
    CreateOtherPlotsPanel.tBinMaxTextField.setVisible(bVisible);
    CreateOtherPlotsPanel.tBinMinRangeLabel.setVisible(bVisible);
    CreateOtherPlotsPanel.tBinMaxRangeLabel.setVisible(bVisible);
    if (bVisible) {
      String sRangeMinLabel = getTbinMinRangeLabel();
      CreateOtherPlotsPanel.tBinMinRangeLabel.setText(sRangeMinLabel);
      String sRangeMaxLabel = getTbinMaxRangeLabel();
      CreateOtherPlotsPanel.tBinMaxRangeLabel.setText(sRangeMaxLabel);
    }
  }
  
  /*
   * This function displays the two interactive and save selection
   * radio buttons.
   */
  static void makeSelectionModeVisible(boolean bVisible) {
    CreateOtherPlotsPanel.interactiveSelectionRadioButton.setVisible(bVisible);
    CreateOtherPlotsPanel.saveSelectionRadioButton.setVisible(bVisible);
  }
  
  /*
   * Create the string to display in the range label labe widget 
   */
  static String getXoYoRangeLabel(boolean bIsXo) {
    String sResult;
    sResult = "(0 - ";
    if (bIsXo) {
      sResult += Integer.toString(DataReduction.Nx - 1);
    } else {
      sResult += Integer.toString(DataReduction.Ny - 1);
    }
    sResult += ")";
    return sResult;
  }
  
  /*
   * Create the string to display in the text field
   */
  static String getXoYoTextField(boolean bIsXo) {
    String sResult;
    if (bIsXo) {
      sResult = Integer.toString(MouseSelection.infoX);
    } else {
      sResult = Integer.toString(MouseSelection.infoY);
    }
    return sResult;
  }
  
  /*
   * Create the string to display in the Min Tbin label range
   */
  static String getTbinMinRangeLabel() {
    String sResult;
    sResult = "( 0 - " + DataReduction.sNtof + " )";
    return sResult;
  }
  
  /*
   * Create the string to display in the Max Tbin label range
   */
  static String getTbinMaxRangeLabel() {
    String sResult;
    sResult = "( 0 - " + DataReduction.sNtof + " )";
    return sResult;
  }

}
