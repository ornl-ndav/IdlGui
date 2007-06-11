package gov.ornl.sns.iontools;

import javax.swing.*;
import java.awt.Dimension;
import java.awt.Component;
import com.rsi.ion.*;

public class CreateOtherPlotsPanel {

  static JPanel topPartPanel;
  static JTextArea infoTextArea;
  static JScrollPane infoScrollPane;
  static JLabel infoLabel;
  
  static int topPartPanelXoff = 5;
  static int topPartPanelYoff = 5;
  static int topPartPanelWidth = 800;
  static int topPartPanelHeight = 40;
  
  static int listOfOtherPlotsXoff = 5;
  static int listOfOtherPlotsYoff = 5;
  static int listOfOtherPlotsWidth = 550;
  static int listOfOtherPlotsHeight = 30;

  static int otherPlotsGraphicalWindowXoff = 5;
  static int otherPlotsGraphicalWindowYoff = 40;
  static int otherPlotsGraphicalWindowWidth = IParameters.OTHER_PLOTS_X;
  static int otherPlotsGraphicalWindowHeight = IParameters.OTHER_PLOTS_Y;
  
  static int infoLabelXoff = 570;
  static int infoLabelYoff = 15;
  static int infoLabelWidth = 200;
  static int infoLabelHeight = 30;
  
  static int infoScrollPaneXoff = 560;
  static int infoScrollPaneYoff = 55;
  static int infoScrollPaneWidth = 240;
  static int infoScrollPaneHeight = 150;
  
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
        
    DataReduction.listOfOtherPlotsComboBox = new JComboBox(IParameters.LIST_OF_OTHER_PLOTS);
    DataReduction.listOfOtherPlotsComboBox.setAlignmentX(Component.CENTER_ALIGNMENT);
    DataReduction.listOfOtherPlotsComboBox.setSelectedIndex(0);
    DataReduction.listOfOtherPlotsComboBox.setActionCommand("listOfOtherPlotsComboBox");
    DataReduction.listOfOtherPlotsComboBox.setEnabled(true);
    DataReduction.listOfOtherPlotsComboBox.setPreferredSize(new Dimension(
        listOfOtherPlotsWidth,
        listOfOtherPlotsHeight));
    Dimension listOfOtherPlotsComboBoxSize = DataReduction.listOfOtherPlotsComboBox.getPreferredSize();
    DataReduction.listOfOtherPlotsComboBox.setBounds(
        listOfOtherPlotsXoff,
        listOfOtherPlotsYoff,
        listOfOtherPlotsComboBoxSize.width,
        listOfOtherPlotsComboBoxSize.height);
    topPartPanel.add(DataReduction.listOfOtherPlotsComboBox);
    
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
    topPartPanel.add(infoLabel);    
    
    infoTextArea = new JTextArea(20,40);
    infoTextArea.setEditable(false);
    infoScrollPane = new JScrollPane(infoTextArea,
        JScrollPane.VERTICAL_SCROLLBAR_NEVER,
        JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
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
  
  }








}
