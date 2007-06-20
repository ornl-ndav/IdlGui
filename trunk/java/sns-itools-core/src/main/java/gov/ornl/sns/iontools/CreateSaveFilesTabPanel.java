package gov.ornl.sns.iontools;

import java.awt.Dimension;
import java.awt.GridLayout;
import javax.swing.*;
import java.util.*;
import javax.swing.event.ListSelectionListener;
import javax.swing.event.ListSelectionEvent;

public class CreateSaveFilesTabPanel {

  private static int iPanelMenuXoff = 5;
  private static int iPanelMenuYoff = 5;
  private static int iPanelManualXoff = 5;
  private static int iPanelManualYoff = 72;
  
  private static int iFilesToTransferCheckBoxPanelXoff = 15;
  private static int iFilesToTransferCheckBoxPanelYoff = 20;
  private static int iFilesToTransferCheckBoxPanelWidth = 320;
  private static int iFilesToTransferCheckBoxPanelHeight = 100;
  
  private static int iFilesToTransferRefreshButtonXoff = 450;
  private static int iFilesToTransferRefreshButtonYoff = 60;
  private static int iFilesToTransferRefreshButtonWidth = 320;
  private static int iFilesToTransferRefreshButtonHeight = 30;
  
  private static int iFilesTransferRadioButtonWidth = 400;
  private static int iFilesTransferRadioButtonHeight = 30;
  private static int iFilesTransferRadioButtonXoff = 5;
  private static int iAutomaticFilesTransferRadioButtonYoff = 5;
  private static int iManualFilesTransferRadioButtonYoff = 27;
  
  private static int iFilesToTransferListXoff = 15;
  private static int iFilesToTransferListYoff = 130;
  private static int iFilesToTransferListHeigth = 235;
  private static int iFilesTransferedListXoff = 450;
  private static int iFilesTransferedListYoff = iFilesToTransferListYoff;
  
  private static int iTransferFilesButtonXoff = 337;
  private static int iTransferFilesButtonYoff = 250;
  private static int iTransferFilesButtonWidth = 110;
  private static int iTransferFilesButtonHeight = 30;
    
  private static int iPanelWidth  = 790;
  private static int iPanel1Height = 70;
  private static int iPanel2Height = 550;
	
  private static int iSaveFileInfoTextAreaXoff = 15;
  private static int iSaveFileInfoTextAreaYoff = 410;
  private static int iSaveFileInfoTextAreaWidth = 755;
  private static int iSaveFileInfoTextAreaHeight = 128;
  
  private static int iRenameFileLabelXoff = 15;
  private static int iRenameFileLabelYoff = 373;
  private static int iRenameFileLabelWidth = 80;
  private static int iRenameFileLabelHeigth = 30;
  
  private static int iSaveFileInfoMessageXoff = 90;
  private static int iSaveFileInfoMessageYoff = iRenameFileLabelYoff;
  private static int iSaveFileInfoMessageWidth = 200;
  private static int iSaveFileInfomessageHeight = 30; 
  
  private static int iOldFileNameLabelXoff = 390;
  private static int iOldFileNameLabelYoff = iRenameFileLabelYoff;
  private static int iOldFileNameLabelWidth = 350;
  private static int iOldFileNameLabelHeigth = 30;
  
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
    DataReduction.automaticFilesTransferRadioButton = new JRadioButton("Save Files Automatically");
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
    
    DataReduction.manualFilesTransferRadioButton = new JRadioButton("Save Files Manually");
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
    
    DataReduction.filesToTransferCheckBoxPanel.add(DataReduction.transferPidFilesCheckBox);
    DataReduction.filesToTransferCheckBoxPanel.add(DataReduction.transferDataReductionFileCheckBox);
    DataReduction.filesToTransferCheckBoxPanel.add(DataReduction.transferExtraPlotsCheckBox);
        
    DataReduction.filesToTransferCheckBoxPanel.setPreferredSize(new Dimension(
        iFilesToTransferCheckBoxPanelWidth,
        iFilesToTransferCheckBoxPanelHeight));
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
    
    //refresh button
    DataReduction.transferRefreshButton = new JButton("REFRESH LIST OF FILES");
    DataReduction.transferRefreshButton.setActionCommand("transferRefreshButton");
    DataReduction.transferRefreshButton.setEnabled(ParametersToKeep.bNeedToValidateSaveRefreshButton);
    DataReduction.transferRefreshButton.setPreferredSize(new Dimension(
        iFilesToTransferRefreshButtonWidth,
        iFilesToTransferRefreshButtonHeight));
    Dimension transferRefreshButtonSize = DataReduction.transferRefreshButton.getPreferredSize();
    DataReduction.transferRefreshButton.setBounds(
        iFilesToTransferRefreshButtonXoff,
        iFilesToTransferRefreshButtonYoff,
        transferRefreshButtonSize.width,
        transferRefreshButtonSize.height);
    DataReduction.filesToTransferManualPanel.add(DataReduction.transferRefreshButton);
    
    DataReduction.filesToTransferList = new JList(DataReduction.vFilesToTransfer);
    
    ListSelectionModel listSelectionModel = DataReduction.filesToTransferList.getSelectionModel();
    listSelectionModel.addListSelectionListener(new ListSelectionListener() {
      public void valueChanged(ListSelectionEvent e) {
        if (e.getValueIsAdjusting()) return;
        ListSelectionModel lsm = (ListSelectionModel)e.getSource();
        if (!lsm.isSelectionEmpty()) {
          int[] indexSelected = DataReduction.filesToTransferList.getSelectedIndices();
          SaveFilesTabAction.displaySelectedFileInfo(indexSelected[0]);
        }
      }
    }
    );
    
    DataReduction.filesToTransferList.setSelectionMode(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
    DataReduction.filesToTransferList.setSelectedIndex(0);
    JScrollPane listScrollPane = new JScrollPane(DataReduction.filesToTransferList);
    listScrollPane.setPreferredSize(new Dimension(
        iFilesToTransferCheckBoxPanelWidth,
        iFilesToTransferListHeigth));
    Dimension filesToTransferSize = listScrollPane.getPreferredSize();
    listScrollPane.setBounds(
        iFilesToTransferListXoff,
        iFilesToTransferListYoff,
        filesToTransferSize.width,
        filesToTransferSize.height);
    DataReduction.filesToTransferManualPanel.add(listScrollPane);
    
    DataReduction.transferFilesButton = new JButton("SAVE ->");
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

    DataReduction.renameFileLabel = new JLabel("File name:");
    DataReduction.renameFileLabel.setPreferredSize(new Dimension(
        iRenameFileLabelWidth,
        iRenameFileLabelHeigth));
    Dimension renameFileLabelSize = DataReduction.renameFileLabel.getPreferredSize();
    DataReduction.renameFileLabel.setBounds(
        iRenameFileLabelXoff,
        iRenameFileLabelYoff,
        renameFileLabelSize.width,
        renameFileLabelSize.height);
    DataReduction.filesToTransferManualPanel.add(DataReduction.renameFileLabel);
    
    DataReduction.saveFileInfoMessageTextfield = new JTextField(25);
    DataReduction.saveFileInfoMessageTextfield.setEditable(true);
    DataReduction.saveFileInfoMessageTextfield.setActionCommand("saveFileInfoMessageTextField");
    DataReduction.saveFileInfoMessageTextfield.setPreferredSize(new Dimension(
        iSaveFileInfoMessageWidth,
        iSaveFileInfomessageHeight));
    Dimension saveFileInfoMessageTextFieldSize = DataReduction.saveFileInfoMessageTextfield.getPreferredSize();
    DataReduction.saveFileInfoMessageTextfield.setBounds(
        iSaveFileInfoMessageXoff,
        iSaveFileInfoMessageYoff,
        saveFileInfoMessageTextFieldSize.width,
        saveFileInfoMessageTextFieldSize.height);
    DataReduction.filesToTransferManualPanel.add(DataReduction.saveFileInfoMessageTextfield);
    
    DataReduction.oldFileNameLabel = new JLabel("");
    DataReduction.oldFileNameLabel.setPreferredSize(new Dimension(
        iOldFileNameLabelWidth,
        iOldFileNameLabelHeigth));
    Dimension oldFileNameLabelSize = DataReduction.oldFileNameLabel.getPreferredSize();
    DataReduction.oldFileNameLabel.setBounds(
        iOldFileNameLabelXoff,
        iOldFileNameLabelYoff,
        oldFileNameLabelSize.width,
        oldFileNameLabelSize.height);
    DataReduction.filesToTransferManualPanel.add(DataReduction.oldFileNameLabel);
    
    DataReduction.saveFileInfoTextArea = new JTextArea(5,40);
    DataReduction.saveFileInfoTextArea.setEditable(false);
    DataReduction.saveFileInfoScrollPane = new JScrollPane(DataReduction.saveFileInfoTextArea,
               JScrollPane.VERTICAL_SCROLLBAR_ALWAYS,
               JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
    DataReduction.saveFileInfoScrollPane.setPreferredSize(new Dimension(
        iSaveFileInfoTextAreaWidth,
        iSaveFileInfoTextAreaHeight));
    Dimension saveFileInfoTextAreaSize = DataReduction.saveFileInfoScrollPane.getPreferredSize();
    DataReduction.saveFileInfoScrollPane.setBounds(
        iSaveFileInfoTextAreaXoff,
        iSaveFileInfoTextAreaYoff,
        saveFileInfoTextAreaSize.width,
        saveFileInfoTextAreaSize.height);
    DataReduction.filesToTransferManualPanel.add(DataReduction.saveFileInfoScrollPane);
        
    DataReduction.filesToTransferPanel.add(DataReduction.filesToTransferManualPanel);		
        
	}
	
}
