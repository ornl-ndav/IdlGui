package gov.ornl.sns.iontools;

import java.awt.Dimension;
import java.awt.GridLayout;
import javax.swing.*;
import java.util.*;

public class CreateFilesToTransferPanel {

  private static int iPanelMenuXoff = 5;
  private static int iPanelMenuYoff = 5;
  private static int iPanelManualXoff = 5;
  private static int iPanelManualYoff = 85;
  
  private static int iFilesToTransferCheckBoxPanelXoff = 15;
  private static int iFilesToTransferCheckBoxPanelYoff = 25;
  private static int iFilesToTransferCheckBoxPanelWidth = 320;
  private static int iFilesToTransferCheckBoxPanelHeigth = 100;
  
  private static int iFilesTransferRadioButtonWidth = 400;
  private static int iFilesTransferRadioButtonHeight = 30;
  private static int iFilesTransferRadioButtonXoff = 5;
  private static int iAutomaticFilesTransferRadioButtonYoff = 5;
  private static int iManualFilesTransferRadioButtonYoff = 35;
  
  private static int iFilesToTransferListXoff = 15;
  private static int iFilestoTransferListYoff = 135;
  private static int iFilesToTransferListHeigth = 300;
  private static int iFilesTransferedListXoff = 450;
  private static int iFilesTransferedListYoff = 135;
  
  private static int iTransferFilesButtonXoff = 337;
  private static int iTransferFilesButtonYoff = 250;
  private static int iTransferFilesButtonWidth = 110;
  private static int iTransferFilesButtonHeight = 30;
    
  private static int iPanelWidth  = 790;
  private static int iPanel1Height = 70;
  private static int iPanel2Height = 600;
	
  
  static void buildGUI() {
    DataReduction.vFilesToTransfer = new Vector();
            
    DataReduction.filesToTransferPanel.setLayout(null);
    buildPanel1();  	  //panel of automatic/manual selection
    buildPanel2();      //panel of manual mode
  
  }

  static void buildPanel1() {
   
    DataReduction.filesToTransferMenuPanel = new JPanel();
    DataReduction.filesToTransferMenuPanel.setLayout(null);
    
    //first line - automatic transfer
    DataReduction.automaticFilesTransferRadioButton = new JRadioButton("Automatic Files Transfer");
    DataReduction.automaticFilesTransferRadioButton.setActionCommand("automaticFilesTransfer");
    DataReduction.automaticFilesTransferRadioButton.setPreferredSize(new Dimension(
        iFilesTransferRadioButtonWidth,
        iFilesTransferRadioButtonHeight));
    Dimension filesTransferRadioButtonSize = DataReduction.automaticFilesTransferRadioButton.getPreferredSize();
    DataReduction.automaticFilesTransferRadioButton.setBounds(
        iFilesTransferRadioButtonXoff,
        iAutomaticFilesTransferRadioButtonYoff,
        filesTransferRadioButtonSize.width,
        filesTransferRadioButtonSize.height);
    
    DataReduction.manualFilesTransferRadioButton = new JRadioButton("Manual Files Transfer");
    DataReduction.manualFilesTransferRadioButton.setActionCommand("manualFilesTransfer");
    DataReduction.manualFilesTransferRadioButton.setSelected(true);
    DataReduction.manualFilesTransferRadioButton.setPreferredSize(new Dimension(
        iFilesTransferRadioButtonWidth,
        iFilesTransferRadioButtonHeight));
    DataReduction.manualFilesTransferRadioButton.setBounds(
        iFilesTransferRadioButtonXoff,
        iManualFilesTransferRadioButtonYoff,
        filesTransferRadioButtonSize.width,
        filesTransferRadioButtonSize.height);
    
    DataReduction.filesTransferButtonGroup = new ButtonGroup();
    DataReduction.filesTransferButtonGroup.add(DataReduction.automaticFilesTransferRadioButton);
    DataReduction.filesTransferButtonGroup.add(DataReduction.manualFilesTransferRadioButton);
    
    DataReduction.filesToTransferMenuPanel.add(DataReduction.automaticFilesTransferRadioButton);
    DataReduction.filesToTransferMenuPanel.add(DataReduction.manualFilesTransferRadioButton);
    
    DataReduction.filesToTransferMenuPanel.setPreferredSize(new Dimension(
        iPanelWidth,
        iPanel1Height));
    Dimension filesToTransferMenuPanelSize = DataReduction.filesToTransferMenuPanel.getPreferredSize();
    DataReduction.filesToTransferMenuPanel.setBounds(
        iPanelMenuXoff,
        iPanelMenuYoff,
        filesToTransferMenuPanelSize.width,
        filesToTransferMenuPanelSize.height);
            
    DataReduction.filesToTransferPanel.add(DataReduction.filesToTransferMenuPanel);   
    
    
  }
  
  /*
   * build the panel that list the categories of files to transfer
   */
  static void buildCategoriesPanel() {
    
    DataReduction.filesToTransferCheckBoxPanel = new JPanel();
    DataReduction.filesToTransferCheckBoxPanel.setLayout(new GridLayout(0,1));
    DataReduction.filesToTransferCheckBoxPanel.setBorder(BorderFactory.createCompoundBorder(
        BorderFactory.createTitledBorder("Categories of files to select from"),
        BorderFactory.createEmptyBorder(5,5,5,5)));
    
    DataReduction.transferPidFilesCheckBox = new JCheckBox("Pixel IDs selection files");
    DataReduction.transferPidFilesCheckBox.setSelected(IParameters.B_TRANSFER_PID_FILE);
    DataReduction.transferPidFilesCheckBox.setActionCommand("transferPidFilesCheckBox");
    
    DataReduction.transferDataReductionFileCheckBox = new JCheckBox("Main Data Reduction files");
    DataReduction.transferDataReductionFileCheckBox.setSelected(IParameters.B_TRANSFER_DATA_REDUCTION_FILE);
    DataReduction.transferDataReductionFileCheckBox.setActionCommand("transferDataReductionFileCheckBox");
    
    DataReduction.transferExtraPlotsCheckBox = new JCheckBox("Extra Plots files");
    DataReduction.transferExtraPlotsCheckBox.setSelected(IParameters.B_TRANSFER_EXTRA_PLOT_FILE);
    DataReduction.transferExtraPlotsCheckBox.setActionCommand("transferExtraPlotsCheckBox");
    
    DataReduction.transferTmpHistoCheckBox = new JCheckBox("Temporary Histogram files");
    DataReduction.transferTmpHistoCheckBox.setSelected(IParameters.B_TRANSFER_TMP_HISTO_FILE);
    DataReduction.transferTmpHistoCheckBox.setActionCommand("transferTmpHistoCheckBox");
    
    DataReduction.filesToTransferCheckBoxPanel.add(DataReduction.transferPidFilesCheckBox);
    DataReduction.filesToTransferCheckBoxPanel.add(DataReduction.transferDataReductionFileCheckBox);
    DataReduction.filesToTransferCheckBoxPanel.add(DataReduction.transferExtraPlotsCheckBox);
    DataReduction.filesToTransferCheckBoxPanel.add(DataReduction.transferTmpHistoCheckBox);
    
    DataReduction.filesToTransferCheckBoxPanel.setPreferredSize(new Dimension(
        iFilesToTransferCheckBoxPanelWidth,
        iFilesToTransferCheckBoxPanelHeigth));
    Dimension filesToTransferCheckBoxPanelSize = DataReduction.filesToTransferCheckBoxPanel.getPreferredSize();
    DataReduction.filesToTransferCheckBoxPanel.setBounds(
        iFilesToTransferCheckBoxPanelXoff,
        iFilesToTransferCheckBoxPanelYoff,
        filesToTransferCheckBoxPanelSize.width,
        filesToTransferCheckBoxPanelSize.height);
    
    DataReduction.filesToTransferManualPanel.add(DataReduction.filesToTransferCheckBoxPanel);
  }
  
	/*
	 * This function will create the second part of the tab
   * which is when we select manual transfer
   * 
	 */
	static void buildPanel2() {
		
	  DataReduction.filesToTransferManualPanel = new JPanel();
		DataReduction.filesToTransferManualPanel.setLayout(null);

    buildCategoriesPanel();
    
    DataReduction.filesToTransferList = new JList(DataReduction.vFilesToTransfer);
    DataReduction.filesToTransferList.setSelectionMode(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
    DataReduction.filesToTransferList.setSelectedIndex(0);
    JScrollPane listScrollPane = new JScrollPane(DataReduction.filesToTransferList);
    listScrollPane.setPreferredSize(new Dimension(
        iFilesToTransferCheckBoxPanelWidth,
        iFilesToTransferListHeigth));
    Dimension filesToTransferSize = listScrollPane.getPreferredSize();
    listScrollPane.setBounds(
        iFilesToTransferListXoff,
        iFilestoTransferListYoff,
        filesToTransferSize.width,
        filesToTransferSize.height);
    DataReduction.filesToTransferManualPanel.add(listScrollPane);
    
    DataReduction.transferFilesButton = new JButton("Transfer ->");
    DataReduction.transferFilesButton.setActionCommand("transferFilesButton");
    DataReduction.transferFilesButton.setPreferredSize(new Dimension(
        iTransferFilesButtonWidth,
        iTransferFilesButtonHeight));
    Dimension transferFilesButtonsize = DataReduction.transferFilesButton.getPreferredSize();
    DataReduction.transferFilesButton.setBounds(
        iTransferFilesButtonXoff,
        iTransferFilesButtonYoff,
        transferFilesButtonsize.width,
        transferFilesButtonsize.height);
    DataReduction.filesToTransferManualPanel.add(DataReduction.transferFilesButton);
    
    DataReduction.filesTransferedList = new JList();
    JScrollPane listScroll2Pane = new JScrollPane(DataReduction.filesTransferedList);
    listScrollPane.setPreferredSize(new Dimension(
        iFilesToTransferCheckBoxPanelWidth,
        iFilesToTransferListHeigth));
    listScroll2Pane.setBounds(
        iFilesTransferedListXoff,
        iFilesTransferedListYoff,
        filesToTransferSize.width,
        filesToTransferSize.height);
    DataReduction.filesToTransferManualPanel.add(listScroll2Pane);

    DataReduction.filesToTransferManualPanel.setPreferredSize(new Dimension(
        iPanelWidth,
        iPanel2Height));
    Dimension filesToTransferManualPanelSize = DataReduction.filesToTransferManualPanel.getPreferredSize();
    DataReduction.filesToTransferManualPanel.setBounds(
        iPanelManualXoff,
        iPanelManualYoff,
        filesToTransferManualPanelSize.width,
        filesToTransferManualPanelSize.height);
    DataReduction.filesToTransferManualPanel.setBorder(BorderFactory.createCompoundBorder(
        BorderFactory.createTitledBorder("Manual Selection"),
        BorderFactory.createEmptyBorder(5,5,5,5)));
    
    DataReduction.filesToTransferPanel.add(DataReduction.filesToTransferManualPanel);		
        
	}
	
	
}
