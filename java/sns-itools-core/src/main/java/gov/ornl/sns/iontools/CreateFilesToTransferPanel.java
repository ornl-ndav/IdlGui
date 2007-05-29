package gov.ornl.sns.iontools;

import java.awt.Dimension;

import javax.swing.*;

public class CreateFilesToTransferPanel {

  private static int iPanelMenuXoff = 5;
  private static int iPanelMenuYoff = 5;
  private static int iPanelManualXoff = 5;
  private static int iPanelManualYoff = 100;
  
  private static int iFilesTransferRadioButtonWidth = 400;
  private static int iFilesTransferRadioButtonHeight = 30;
  private static int iFilesTransferRadioButtonXoff = 5;
  private static int iAutomaticFilesTransferRadioButtonYoff = 5;
  private static int iManualFilesTransferRadioButtonYoff = 35;
  
  private static int iPanelWidth = 900;
  private static int iPanelHeight = 80; 
	private static int iPanel2Height = 300;
	private static int iButtonWidth = 340;
	private static int iButtonHeight = 30;
	
  private static int iButton1Xoff = 15;
	private static int iButton1Yoff = 5;
  private static int iIconWidth = 50;
  private static int iIconHeight = 30;
  private static int iIcon1Xoff = iButtonWidth + 2*iButton1Xoff;
  private static int iIcon2Xoff = iIcon1Xoff + iIconWidth + iButtonWidth + 2*iButton1Xoff; 
  private static int iButton2Xoff = iIcon1Xoff+iIconWidth+iButton1Xoff;
    
  static void buildGUI() {

    DataReduction.filesToTransferPanel.setLayout(null);
    
		buildPanel1();  	  //panel of step 1
		buildPanel2();      //panel of step 2
//		buildPanel3();      //panel of step 3
//		buildPanel4();      //panel that contains the processing bar
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
        iPanelHeight));
    Dimension filesToTransferMenuPanelSize = DataReduction.filesToTransferMenuPanel.getPreferredSize();
    DataReduction.filesToTransferMenuPanel.setBounds(
        iPanelMenuXoff,
        iPanelMenuYoff,
        filesToTransferMenuPanelSize.width,
        filesToTransferMenuPanelSize.height);
            
    DataReduction.filesToTransferPanel.add(DataReduction.filesToTransferMenuPanel);   
    
    
  }
  
  
	/*
	 * This function will create the second part of the tab
   * which is when we select manaul transfer
   * 
	 */
	static void buildPanel2() {
		
		DataReduction.filesToTransferManualPanel = new JPanel();
		DataReduction.filesToTransferManualPanel.setLayout(null);

    //Button #1 : Select files to keep
		DataReduction.filesToKeep1Button = new JButton("Select files to save");
		DataReduction.filesToKeep1Button.setActionCommand("filesToKeepButton");
		DataReduction.filesToKeep1Button.setPreferredSize(new Dimension(
				iButtonWidth,
				iButtonHeight));
		Dimension filesToKeepButtonSize = DataReduction.filesToKeep1Button.getPreferredSize();
		DataReduction.filesToKeep1Button.setBounds(
				iButton1Xoff,
				iButton1Yoff,
				filesToKeepButtonSize.width,
				filesToKeepButtonSize.height);
		
		DataReduction.filesToTransferManualPanel.add(DataReduction.filesToKeep1Button);

    //Arrow #1
    DataReduction.arrowGif = DataReduction.createImageIcon("/gov/ornl/sns/iontools/images/right_arrow.gif");
    DataReduction.filesToKeepArrowIcon = new JLabel();
    DataReduction.filesToKeepArrowIcon.setIcon(DataReduction.arrowGif);
    DataReduction.filesToKeepArrowIcon.setPreferredSize(new Dimension(
        iIconWidth,
        iIconHeight));
    Dimension filesToKeepArrowIconSize = DataReduction.filesToKeepArrowIcon.getPreferredSize();
    DataReduction.filesToKeepArrowIcon.setBounds(
        iIcon1Xoff,
        iButton1Yoff,
        filesToKeepArrowIconSize.width,
        filesToKeepArrowIconSize.height);
    
    DataReduction.filesToTransferManualPanel.add(DataReduction.filesToKeepArrowIcon);
    
    //Button #3
    DataReduction.filesToKeep3Button = new JButton("Transfer files");
    DataReduction.filesToKeep3Button.setActionCommand("filesToKeep3Button");
    DataReduction.filesToKeep3Button.setPreferredSize(new Dimension(
        iButtonWidth,
        iButtonHeight));
    Dimension filesToKeep3ButtonSize = DataReduction.filesToKeep3Button.getPreferredSize();
    DataReduction.filesToKeep3Button.setBounds(
        iButton2Xoff,
        iButton1Yoff,
        filesToKeep3ButtonSize.width,
        filesToKeep3ButtonSize.height);
    
    DataReduction.filesToTransferManualPanel.add(DataReduction.filesToKeep3Button);
    
    DataReduction.filesToTransferManualPanel.setPreferredSize(new Dimension(
        iPanelWidth,
        iPanelHeight));
    Dimension filesToTransferManualPanelSize = DataReduction.filesToTransferManualPanel.getPreferredSize();
    DataReduction.filesToTransferManualPanel.setBounds(
        iPanelManualXoff,
        iPanelManualYoff,
        filesToTransferManualPanelSize.width,
        filesToTransferManualPanelSize.height);
            
    DataReduction.filesToTransferPanel.add(DataReduction.filesToTransferManualPanel);		
	    
	}
	
	
}
