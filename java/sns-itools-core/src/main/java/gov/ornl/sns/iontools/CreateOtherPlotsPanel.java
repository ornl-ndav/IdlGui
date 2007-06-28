package gov.ornl.sns.iontools;

import javax.swing.*;
import java.awt.Dimension;
import java.awt.Component;
import com.rsi.ion.*;

public class CreateOtherPlotsPanel {

  static JButton          refreshButton;
  static JButton          clearButton;
  static JPanel           topPartPanel;
  static JScrollPane      infoScrollPane;
  
  static JLabel           infoLabel;
  static JLabel           xoLabel;
  static JLabel           yoLabel;
  static JLabel           tBinMinLabel;
  static JLabel           tBinMaxLabel;
  static JLabel           list1OfOtherPlotsLabel;
  static JLabel           list2OfOtherPlotsLabel;
  static JLabel           orLabel;
  static JLabel           pixelIDLabel;
  static JLabel           xAxisLabel;
  static JLabel           yAxisLabel;
  
  static JTextArea        infoTextArea;
  static JTextField       tBinMinTextField;
  static JTextField       tBinMaxTextField;
  static JTextField       xoTextField;
  static JTextField       yoTextField;
  static JTextField       pixelIDTextField;
  
  static JComboBox        list1OfOtherPlotsComboBox;
  static JComboBox        list2OfOtherPlotsComboBox;
  static JComboBox        xAxisComboBox;
  static JComboBox        yAxisComboBox;
  
  static JRadioButton     interactiveSelectionRadioButton;
  static JRadioButton     saveSelectionRadioButton;
  static ButtonGroup      selectionButtonGroup;
  
  static int topPartPanelXoff = 5;
  static int topPartPanelYoff = 5;
  static int topPartPanelWidth = 800;
  static int topPartPanelHeight = 40;
  
  static int list1OfOtherPlotsLabelXoff = 5;
  static int list1OfOtherPlotsLabelYoff = 5;
  static int list1OfOtherPlotsLabelWidth = 50;
  static int list1OfOtherPlotsLabelHeight = 30;
  
  static int list1OfOtherPlotsXoff = 40;
  static int list1OfOtherPlotsYoff = 5;
  static int list1OfOtherPlotsWidth = 155;
  static int list1OfOtherPlotsHeight = 30;

  static int list2OfOtherPlotsLabelXoff = 220;
  static int list2OfOtherPlotsLabelYoff = 5;
  static int list2OfOtherPlotsLabelWidth = 50;
  static int list2OfOtherPlotsLabelHeight = 30;
  
  static int list2OfOtherPlotsXoff = 250;
  static int list2OfOtherPlotsYoff = list1OfOtherPlotsYoff;
  static int list2OfOtherPlotsWidth = 200;
  static int list2OfOtherPlotsHeight = list1OfOtherPlotsHeight;
  
  static int xAxisLabelXoff = 490;
  static int yAxisLabelXoff = 650;
  static int xAxisLabelYoff = list1OfOtherPlotsYoff;
  static int xAxisLabelWidth = 50;
  static int xAxisLabelHeight = 30;
  
  static int xAxisComboBoxXoff = 540;
  static int yAxisComboBoxXoff = 700;
  static int xAxisComboBoxYoff = xAxisLabelYoff;
  static int xAxisComboBoxWidth = 80;
  static int xAxisComboBoxHeight = 30;
  
  static int refreshButtonXoff = 565;
  static int refreshButtonYoff = 50;
  static int refreshButtonWidth = 230;
  static int refreshButtonHeight = 30;
  
  static int clearButtonXoff = refreshButtonXoff;
  static int clearButtonYoff = refreshButtonYoff + 35;
  static int clearButtonWidth = refreshButtonWidth;
  static int clearButtonHeight = refreshButtonHeight;
  
  static int otherPlotsGraphicalWindowXoff = 5;
  static int otherPlotsGraphicalWindowYoff = 40;
  static int otherPlotsGraphicalWindowWidth = IParameters.OTHER_PLOTS_X;
  static int otherPlotsGraphicalWindowHeight = IParameters.OTHER_PLOTS_Y;
  
  static int yoff = 35;
  static int yoff2 = 100;
  static int infoLabelXoff = 575;
  static int infoLabelYoff = 18 + yoff2;
  static int infoLabelWidth = 200;
  static int infoLabelHeight = 30;
  
  static int infoScrollPaneXoff = 560;
  static int infoScrollPaneYoff = 55 + yoff2;
  static int infoScrollPaneWidth = 240;
  static int infoScrollPaneHeight = 250;
  
  static int yoff3 = yoff2 + 55;
  static int xoLabelXoff = 560;
  static int xoLabelYoff = 260 + yoff3;
  static int xoLabelWidth = 100;
  static int xoLabelHeight = 30;
  
  static int yoLabelXoff = xoLabelXoff;
  static int yoLabelYoff = xoLabelYoff + yoff;
  static int yoLabelWidth = xoLabelWidth;
  static int yoLabelHeight = xoLabelHeight;
  
  static int xoTextFieldXoff = 595;
  static int xoTextFieldYoff = xoLabelYoff;
  static int xoTextFieldWidth = 50;
  static int xoTextFieldHeight = xoLabelHeight;
  
  static int yoTextFieldXoff = xoTextFieldXoff;
  static int yoTextFieldYoff = yoLabelYoff;
  static int yoTextFieldWidth = xoTextFieldWidth;
  static int yoTextFieldHeight = xoLabelHeight;

  //OR and pixelID labels and pixeldID textbox
  static int orLabelXoff = 660;
  static int orLabelYoff = xoLabelYoff + yoff/2;
  static int orLabelWidth = 20;
  static int orLabelHeight = 30;
  
  static int pixelIDLabelXoff = 700;
  static int pixelIDLabelYoff = xoLabelYoff;
  static int pixelIDLabelWidth = 100;
  static int pixelIDLabelHeight = 30;
  
  static int pixelIDTextFieldXoff = 700;
  static int pixelIDTextFieldYoff = xoLabelYoff + yoff;
  static int pixelIDTextFieldWidth = 60;
  static int pixelIDTextFieldHeight = 30;
  
  //interactive and save selection radio buttons
  static int saveSelectionXoff = xoLabelXoff;
  static int saveSelectionYoff = xoLabelYoff;
  static int saveSelectionWidth = 250;
  static int saveSelectionHeight = 30;

  static int yoffRadio = 35;
  static int interactiveSelectionXoff = xoLabelXoff;
  static int interactiveSelectionYoff = saveSelectionYoff + yoffRadio;
  static int interactiveSelectionWidth = saveSelectionWidth;
  static int interactiveSelectionHeight = saveSelectionHeight;

  //Tbin min
  static int tBinOff = yoff;
  static int tBinMinLabelXoff = xoLabelXoff;
  static int tBinMinLabelYoff = interactiveSelectionYoff + tBinOff;
  static int tBinMinLabelWidth = 100;
  static int tBinMinLabelHeight = 30;
  
  static int tBinMinTextFieldXoff = 630;
  static int tBinMinTextFieldYoff = tBinMinLabelYoff;
  static int tBinMinTextFieldWidth = 65;
  static int tBinMinTextFieldHeight = xoTextFieldHeight;
  
  //Tbin max
  static int yoff1 = 35;
  static int tBinMaxLabelXoff = tBinMinLabelXoff;
  static int tBinMaxLabelYoff = tBinMinLabelYoff + yoff1;
  static int tBinMaxLabelWidth = 100;
  static int tBinMaxLabelHeight = 30;
  
  static int tBinMaxTextFieldXoff = tBinMinTextFieldXoff;
  static int tBinMaxTextFieldYoff = tBinMinLabelYoff + yoff1;
  static int tBinMaxTextFieldWidth = tBinMinTextFieldWidth;
  static int tBinMaxTextFieldHeight = xoTextFieldHeight;
  
  static void createGUI() {
    DataReduction.otherPlotsPanel = new JPanel();
    DataReduction.otherPlotsPanel.setLayout(null);
    createListOfPlotsPanel();
    createPlotArea();
    createInfoArea();
   }
  
  static void createListOfPlotsPanel() {
    
    topPartPanel = new JPanel();
    topPartPanel.setLayout(null);
    
    list1OfOtherPlotsLabel = new JLabel("TOF :");
    list1OfOtherPlotsLabel.setBounds(
        list1OfOtherPlotsLabelXoff,
        list1OfOtherPlotsLabelYoff,
        list1OfOtherPlotsLabelWidth,
        list1OfOtherPlotsLabelHeight);
    topPartPanel.add(list1OfOtherPlotsLabel);
    
    list1OfOtherPlotsComboBox = new JComboBox(IParameters.LIST_OF_OTHER_PLOTS_PART1);
    list1OfOtherPlotsComboBox.setAlignmentX(Component.CENTER_ALIGNMENT);
    list1OfOtherPlotsComboBox.setSelectedIndex(0);
    list1OfOtherPlotsComboBox.setActionCommand("list1OfOtherPlotsComboBox");
    list1OfOtherPlotsComboBox.setEnabled(false);
    list1OfOtherPlotsComboBox.setBounds(
        list1OfOtherPlotsXoff,
        list1OfOtherPlotsYoff,
        list1OfOtherPlotsWidth,
        list1OfOtherPlotsHeight);
    topPartPanel.add(list1OfOtherPlotsComboBox);
    
    list2OfOtherPlotsLabel = new JLabel("X,Y :");
    list2OfOtherPlotsLabel.setBounds(
        list2OfOtherPlotsLabelXoff,
        list2OfOtherPlotsLabelYoff,
        list2OfOtherPlotsLabelWidth,
        list2OfOtherPlotsLabelHeight);
    topPartPanel.add(list2OfOtherPlotsLabel);

    list2OfOtherPlotsComboBox = new JComboBox(IParameters.LIST_OF_OTHER_PLOTS_PART2);
    list2OfOtherPlotsComboBox.setAlignmentX(Component.CENTER_ALIGNMENT);
    list2OfOtherPlotsComboBox.setSelectedIndex(0);
    list2OfOtherPlotsComboBox.setActionCommand("list2OfOtherPlotsComboBox");
    list2OfOtherPlotsComboBox.setEnabled(false);
    list2OfOtherPlotsComboBox.setBounds(
        list2OfOtherPlotsXoff,
        list2OfOtherPlotsYoff,
        list2OfOtherPlotsWidth,
        list2OfOtherPlotsHeight);
    topPartPanel.add(list2OfOtherPlotsComboBox);
        
    xAxisLabel = new JLabel("X-axis:");
    xAxisLabel.setBounds(
        xAxisLabelXoff,
        xAxisLabelYoff,
        xAxisLabelWidth,
        xAxisLabelHeight);
    topPartPanel.add(xAxisLabel);
    
    xAxisComboBox = new JComboBox(IParameters.LIST_OF_X_AXIS);
    xAxisComboBox.setSelectedIndex(0);
    xAxisComboBox.setActionCommand("xAxisComboBox");
    xAxisComboBox.setEnabled(false);
    xAxisComboBox.setBounds(
        xAxisComboBoxXoff,
        xAxisComboBoxYoff,
        xAxisComboBoxWidth,
        xAxisComboBoxHeight);
    topPartPanel.add(xAxisComboBox);
        
    yAxisLabel = new JLabel("Y-axis:");
    yAxisLabel.setBounds(
        yAxisLabelXoff,
        xAxisLabelYoff,
        xAxisLabelWidth,
        xAxisLabelHeight);
    topPartPanel.add(yAxisLabel);
    
    yAxisComboBox = new JComboBox(IParameters.LIST_OF_Y_AXIS);
    yAxisComboBox.setSelectedIndex(0);
    yAxisComboBox.setActionCommand("yAxisComboBox");
    yAxisComboBox.setEnabled(false);
    yAxisComboBox.setBounds(
        yAxisComboBoxXoff,
        xAxisComboBoxYoff,
        xAxisComboBoxWidth,
        xAxisComboBoxHeight);
    topPartPanel.add(yAxisComboBox);
    
    topPartPanel.setPreferredSize(new Dimension(
        topPartPanelWidth,
        topPartPanelHeight));
    Dimension topPartPanelSize = topPartPanel.getPreferredSize();
    topPartPanel.setBounds(
        topPartPanelXoff,
        topPartPanelYoff,
        topPartPanelSize.width,
        topPartPanelSize.height);
    DataReduction.otherPlotsPanel.add(topPartPanel);
  
  }
  
  static void createPlotArea() {
    
    DataReduction.c_otherPlots = new IONJGrDrawable(IParameters.OTHER_PLOTS_X, IParameters.OTHER_PLOTS_Y);
    DataReduction.c_otherPlots.setVisible(true);
    DataReduction.c_otherPlots.setPreferredSize(new Dimension(
        otherPlotsGraphicalWindowWidth,
        otherPlotsGraphicalWindowHeight));
    Dimension c_otherPlotsSize = DataReduction.c_otherPlots.getPreferredSize();
    DataReduction.c_otherPlots.setBounds(
        otherPlotsGraphicalWindowXoff,
        otherPlotsGraphicalWindowYoff,
        c_otherPlotsSize.width,
        c_otherPlotsSize.height);
    DataReduction.otherPlotsPanel.add(DataReduction.c_otherPlots);
      
  }  

  static void createInfoArea() {
  
    refreshButton = new JButton("P L O T");
    refreshButton.setActionCommand("refreshButton");
    refreshButton.setEnabled(false);
    refreshButton.setPreferredSize(new Dimension(
        refreshButtonWidth,
        refreshButtonHeight));
    refreshButton.setBounds(
        refreshButtonXoff,
        refreshButtonYoff,
        refreshButtonWidth,
        refreshButtonHeight);
    DataReduction.otherPlotsPanel.add(refreshButton);

    clearButton = new JButton("CLEAR PLOT");
    clearButton.setActionCommand("clearButton");
    clearButton.setEnabled(false);
    clearButton.setBounds(
        clearButtonXoff,
        clearButtonYoff,
        clearButtonWidth,
        clearButtonHeight);
    DataReduction.otherPlotsPanel.add(clearButton);
    
    infoLabel = new JLabel("Information about selected plot");
    infoLabel.setPreferredSize(new Dimension(
        infoLabelWidth,
        infoLabelHeight));
    Dimension infoLabelSize = infoLabel.getPreferredSize();
    infoLabel.setBounds(
        infoLabelXoff,
        infoLabelYoff,
        infoLabelSize.width,
        infoLabelSize.height);
    DataReduction.otherPlotsPanel.add(infoLabel);    
    
    infoTextArea = new JTextArea(20,40);
    infoTextArea.setEditable(false);
    infoScrollPane = new JScrollPane(infoTextArea,
        JScrollPane.VERTICAL_SCROLLBAR_NEVER,
        JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
    //infoScrollPane.setWheelScrollingEnabled(true);
    infoScrollPane.setPreferredSize(new Dimension(
        infoScrollPaneWidth,
        infoScrollPaneHeight));
    Dimension infoScrollPaneSize = infoScrollPane.getPreferredSize();
    infoScrollPane.setBounds(
        infoScrollPaneXoff,
        infoScrollPaneYoff,
        infoScrollPaneSize.width,
        infoScrollPaneSize.height);
  DataReduction.otherPlotsPanel.add(infoScrollPane);
  
  //xo label - text field - message widgets
  xoLabel = new JLabel("Xo : ");
  xoLabel.setVisible(false);
  xoLabel.setBounds(
      xoLabelXoff,
      xoLabelYoff,
      xoLabelWidth,
      xoLabelHeight);
  DataReduction.otherPlotsPanel.add(xoLabel);
  
  xoTextField = new JTextField("");
  xoTextField.setVisible(false);
  xoTextField.setEditable(true);
  xoTextField.setActionCommand("xoTextField");
  xoTextField.setBounds(
      xoTextFieldXoff,
      xoTextFieldYoff,
      xoTextFieldWidth,
      xoTextFieldHeight);
  DataReduction.otherPlotsPanel.add(xoTextField);
  
  //yo label - text field - message widgets  
  yoLabel = new JLabel("Yo : ");
  yoLabel.setVisible(false);
  yoLabel.setBounds(
      yoLabelXoff,
      yoLabelYoff,
      yoLabelWidth,
      yoLabelHeight);
  DataReduction.otherPlotsPanel.add(yoLabel);
  
  yoTextField = new JTextField("");
  yoTextField.setVisible(false);
  yoTextField.setEditable(true);
  yoTextField.setActionCommand("yoTextField");
  yoTextField.setBounds(
      yoTextFieldXoff,
      yoTextFieldYoff,
      yoTextFieldWidth,
      yoTextFieldHeight);
  DataReduction.otherPlotsPanel.add(yoTextField);
  
  //or and pixelid labels
  orLabel = new JLabel("OR");
  orLabel.setVisible(false);
  orLabel.setBounds(
      orLabelXoff,
      orLabelYoff,
      orLabelWidth,
      orLabelHeight);
  DataReduction.otherPlotsPanel.add(orLabel);
  
  pixelIDLabel = new JLabel("Pixel ID:");
  pixelIDLabel.setVisible(false);
  pixelIDLabel.setBounds(
      pixelIDLabelXoff,
      pixelIDLabelYoff,
      pixelIDLabelWidth,
      pixelIDLabelHeight);
  DataReduction.otherPlotsPanel.add(pixelIDLabel);
  
  //pixelID TextField
  pixelIDTextField = new JTextField("0");
  pixelIDTextField.setVisible(false);
  pixelIDTextField.setActionCommand("pixelIDTextField");
  pixelIDTextField.setEditable(true);
  pixelIDTextField.setBounds(
      pixelIDTextFieldXoff,
      pixelIDTextFieldYoff,
      pixelIDTextFieldWidth,
      pixelIDTextFieldHeight);
  DataReduction.otherPlotsPanel.add(pixelIDTextField);
  
  //tbin min 
  tBinMinLabel = new JLabel("Tbin min : ");
  tBinMinLabel.setVisible(false);
  tBinMinLabel.setBounds(
      tBinMinLabelXoff,
      tBinMinLabelYoff,
      tBinMinLabelWidth,
      tBinMinLabelHeight);
  DataReduction.otherPlotsPanel.add(tBinMinLabel);
  
  tBinMinTextField = new JTextField("0");
  tBinMinTextField.setVisible(false);
  tBinMinTextField.setActionCommand("tBinMinTextField");
  tBinMinTextField.setEditable(true);
  tBinMinTextField.setBounds(
      tBinMinTextFieldXoff,
      tBinMinTextFieldYoff,
      tBinMinTextFieldWidth,
      tBinMinTextFieldHeight);
  DataReduction.otherPlotsPanel.add(tBinMinTextField);
  
  //tbin max 
  tBinMaxLabel = new JLabel("Tbin max : ");
  tBinMaxLabel.setVisible(false);
  tBinMaxLabel.setBounds(
      tBinMaxLabelXoff,
      tBinMaxLabelYoff,
      tBinMaxLabelWidth,
      tBinMaxLabelHeight);
  DataReduction.otherPlotsPanel.add(tBinMaxLabel);
  
  tBinMaxTextField = new JTextField("1");
  tBinMaxTextField.setVisible(false);
  tBinMaxTextField.setActionCommand("tBinMaxTextField");
  tBinMaxTextField.setEditable(true);
  tBinMaxTextField.setBounds(
      tBinMaxTextFieldXoff,
      tBinMaxTextFieldYoff,
      tBinMaxTextFieldWidth,
      tBinMaxTextFieldHeight);
  DataReduction.otherPlotsPanel.add(tBinMaxTextField);
  
  saveSelectionRadioButton = new JRadioButton("Save Selection Mode");
  saveSelectionRadioButton.setActionCommand("saveSelectionRadioButton");
  saveSelectionRadioButton.setSelected(true);
  saveSelectionRadioButton.setVisible(false);
  saveSelectionRadioButton.setBounds(
      saveSelectionXoff,
      saveSelectionYoff,
      saveSelectionWidth,
      saveSelectionHeight);
  
  interactiveSelectionRadioButton = new JRadioButton("Interactive Selection Mode");
  interactiveSelectionRadioButton.setActionCommand("interactiveSelectionRadioButton");
  interactiveSelectionRadioButton.setVisible(false);
  interactiveSelectionRadioButton.setBounds(
      interactiveSelectionXoff,
      interactiveSelectionYoff,
      interactiveSelectionWidth,
      interactiveSelectionHeight);

  selectionButtonGroup = new ButtonGroup();
  selectionButtonGroup.add(saveSelectionRadioButton);
  selectionButtonGroup.add(interactiveSelectionRadioButton);
  DataReduction.otherPlotsPanel.add(interactiveSelectionRadioButton);
  DataReduction.otherPlotsPanel.add(saveSelectionRadioButton);
    

  }
}
