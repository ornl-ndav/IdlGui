package gov.ornl.sns.iontools;

public class OtherPlotsUpdateGui {

  /*
   * This function updates the gui according to the plot selected
   */
  static void updateGUI(int index) {
    
    boolean bMakeXoVisible = false;
    boolean bMakeYoVisible = false;
    boolean bMakeTbinVisible = false;
    
    switch (index) {
    case 0: //clear
      break;
    case 1: //Counts = f( TOF , Sum(X) , Sum(Y) )
      break;
    case 2: //Counts = f( TOF , Xo , Sum(Y) )
      bMakeXoVisible = true;
      break;
    case 3: //Counts = f( TOF , Sum(X) , Yo )
      bMakeYoVisible = true;
      break;
    case 4: //Counts = f( TOF , signal_selection )
      break;
    case 5: //Counts = f( TOF , back1_selection )
      break;
    case 6: //Counts = f( TOF , back2_selection )
      break;
    case 7: //Counts = f( TOFo , Sum(X) , Sum(Y) )
      bMakeTbinVisible = true;
      break;
    default:
    } 
    makeXoVisible(bMakeXoVisible);
    makeYoVisible(bMakeYoVisible);
    makeTbinVisible(bMakeTbinVisible);
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
