package gov.ornl.sns.iontools;

import java.awt.Dimension;

import javax.swing.*;

public class CreateFilesToTransferPanel {

  private static int iPanelXoff = 5;
  private static int iPanelYoff = 5;
  private static int iPanelWidth = 900;
  private static int iPanelHeight = 50; 
	private static int iPanel2Height = 300;
	private static int iButtonWidth = 200;
	private static int iButtonHeight = 30;
	
  private static int iButton1Xoff = 15;
	private static int iButton1Yoff = 5;
  private static int iIconWidth = 50;
  private static int iIconHeight = 30;
  private static int iIcon1Xoff = iButtonWidth + 2*iButton1Xoff;
  private static int iIcon2Xoff = iIcon1Xoff + iIconWidth + iButtonWidth + 2*iButton1Xoff; 
  private static int iButton2Xoff = iIcon1Xoff+iIconWidth+iButton1Xoff;
  private static int iButton3Xoff = iIcon2Xoff+iIconWidth+iButton1Xoff;
  
  private static int iProgressBarWidth = 600;
  private static int iProgressBarHeight = 30;
	private static int iSplitPaneWidth = 500;
  private static int iSplitPaneHeigth = 300;
  
  
  
  static void buildGUI() {

    DataReduction.filesToTransferPanel.setLayout(null);
    
		buildPanel1();  	  //panel of step 1
//		buildPanel2();      //panel of step 2
//		buildPanel3();      //panel of step 3
//		buildPanel4();      //panel that contains the processing bar
	}

	/*
	 * This function will create the step 1 of the tab
	 * - file selection -
	 */
	static void buildPanel1() {
		
		DataReduction.filesToTransferStep1Panel = new JPanel();
		DataReduction.filesToTransferStep1Panel.setLayout(null);

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
		
		DataReduction.filesToTransferStep1Panel.add(DataReduction.filesToKeep1Button);

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
    
    DataReduction.filesToTransferStep1Panel.add(DataReduction.filesToKeepArrowIcon);
    
    //Button #2 : check files  
    DataReduction.filesToKeep2Button = new JButton("Check files");
    DataReduction.filesToKeep2Button.setActionCommand("filesToKeep2Button");
    DataReduction.filesToKeep2Button.setPreferredSize(new Dimension(
        iButtonWidth,
        iButtonHeight));
    Dimension filesToKeep2ButtonSize = DataReduction.filesToKeep2Button.getPreferredSize();
    DataReduction.filesToKeep2Button.setBounds(
        iButton2Xoff,
        iButton1Yoff,
        filesToKeep2ButtonSize.width,
        filesToKeep2ButtonSize.height);
    
    DataReduction.filesToTransferStep1Panel.add(DataReduction.filesToKeep2Button);
    
    //Arrow #2
    DataReduction.filesToKeepArrowIcon2 = new JLabel();
    DataReduction.filesToKeepArrowIcon2.setIcon(DataReduction.arrowGif);
    DataReduction.filesToKeepArrowIcon2.setPreferredSize(new Dimension(
        iIconWidth,
        iIconHeight));
    DataReduction.filesToKeepArrowIcon2.setBounds(
        iIcon2Xoff,
        iButton1Yoff,
        filesToKeepArrowIconSize.width,
        filesToKeepArrowIconSize.height);
    
    DataReduction.filesToTransferStep1Panel.add(DataReduction.filesToKeepArrowIcon2);
    
    //Button #3
    DataReduction.filesToKeep3Button = new JButton("Transfer files");
    DataReduction.filesToKeep3Button.setActionCommand("filesToKeep3Button");
    DataReduction.filesToKeep3Button.setPreferredSize(new Dimension(
        iButtonWidth,
        iButtonHeight));
    Dimension filesToKeep3ButtonSize = DataReduction.filesToKeep3Button.getPreferredSize();
    DataReduction.filesToKeep3Button.setBounds(
        iButton3Xoff,
        iButton1Yoff,
        filesToKeep3ButtonSize.width,
        filesToKeep3ButtonSize.height);
    
    DataReduction.filesToTransferStep1Panel.add(DataReduction.filesToKeep3Button);
    
    
    
    
    
    
    
    
    DataReduction.filesToTransferStep1Panel.setPreferredSize(new Dimension(
        iPanelWidth,
        iPanelHeight));
    Dimension filesToTransferStep1PanelSize = DataReduction.filesToTransferStep1Panel.getPreferredSize();
    DataReduction.filesToTransferStep1Panel.setBounds(
        iPanelXoff,
        iPanelYoff,
        filesToTransferStep1PanelSize.width,
        filesToTransferStep1PanelSize.height);
            
    DataReduction.filesToTransferPanel.add(DataReduction.filesToTransferStep1Panel);		
	    
	}
	
	/* 
	 * This function will allow the user to validate or not
	 * the files he selected
	 */
	static void buildPanel2() {

		DataReduction.filesToTransferStep2Panel = new JPanel();
		DataReduction.filesToTransferStep2Panel.setLayout(null);
		
		DataReduction.filesToTransferSplitPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT,
        DataReduction.filesScrollPane, 
        DataReduction.detailScrollPane);
    DataReduction.filesToTransferSplitPane.setOneTouchExpandable(true);
    DataReduction.filesToTransferSplitPane.setDividerLocation(300);
    
    Dimension minimumSize = new Dimension(300,50);
    DataReduction.filesScrollPane = new JScrollPane();
    DataReduction.detailScrollPane = new JScrollPane();
    
    DataReduction.filesScrollPane.setMinimumSize(minimumSize);
    DataReduction.detailScrollPane.setMinimumSize(minimumSize);
    
    DataReduction.filesToTransferSplitPane.setPreferredSize(new Dimension(
        iSplitPaneWidth,
        iSplitPaneHeigth));
    Dimension filesToTransferSplitPaneSize = DataReduction.filesToTransferSplitPane.getPreferredSize();
    DataReduction.filesToTransferSplitPane.setBounds(
        iButton1Xoff,
        iButton1Yoff,
        filesToTransferSplitPaneSize.width,
        filesToTransferSplitPaneSize.height);
        
    DataReduction.filesToTransferStep2Panel.add(DataReduction.filesToTransferSplitPane);
    
    DataReduction.filesToTransferStep2Panel.setPreferredSize(new Dimension(
        iPanelWidth,
        iPanelHeight));
    Dimension filesToTransferStep2PanelSize = DataReduction.filesToTransferStep2Panel.getPreferredSize();
    DataReduction.filesToTransferStep2Panel.setBounds(
        iPanelXoff,
        iPanelYoff + iPanelHeight,
        filesToTransferStep2PanelSize.width,
        filesToTransferStep2PanelSize.height);
    
    DataReduction.filesToTransferPanel.add(DataReduction.filesToTransferStep2Panel);
		
	}
	
	/*
	 * This function performs the last step (3) by transferring
	 * the data to the user home directory
	 */
	static void buildPanel3() {
	
		DataReduction.filesToTransferStep3Panel = new JPanel();
		DataReduction.filesToTransferStep3Panel.setLayout(null);
	
		DataReduction.filesToKeep3Button = new JButton("Transfer files to your home directory");
		DataReduction.filesToKeep3Button.setActionCommand("filesToKeep3Button");
		DataReduction.filesToKeep3Button.setPreferredSize(new Dimension(
				iButtonWidth,
				iButtonHeight));
		Dimension filesToKeepButtonSize = DataReduction.filesToKeep3Button.getPreferredSize();
		DataReduction.filesToKeep3Button.setBounds(
				iButton1Xoff,
				iButton1Yoff,
				filesToKeepButtonSize.width,
				filesToKeepButtonSize.height);
		
		DataReduction.filesToTransferStep3Panel.add(DataReduction.filesToKeep3Button);
		
    DataReduction.filesToTransferStep3Panel.setPreferredSize(new Dimension(
        iPanelWidth,
        iPanelHeight));
    Dimension filesToTransferStep3PanelSize = DataReduction.filesToTransferStep3Panel.getPreferredSize();
    DataReduction.filesToTransferStep3Panel.setBounds(
        iPanelXoff,
        2*iPanelYoff + iPanelHeight + iPanel2Height,
        filesToTransferStep3PanelSize.width,
        filesToTransferStep3PanelSize.height);
    
    DataReduction.filesToTransferPanel.add(DataReduction.filesToTransferStep3Panel);
	
	}
	
	/*
	 * This function contains a processing bar that shows the transfer of data
	 */
	static void buildPanel4() {
		
		DataReduction.filesToTransferProcessingPanel = new JPanel();
		DataReduction.filesToTransferProcessingPanel.setLayout(null);
    
    DataReduction.saveFilesToTransferProgressBar = new JProgressBar(0,400);
    DataReduction.saveFilesToTransferProgressBar.setValue(50);
    DataReduction.saveFilesToTransferProgressBar.setStringPainted(true);
    
    DataReduction.saveFilesToTransferProgressBar.setPreferredSize(new Dimension(
        iProgressBarWidth,
        iProgressBarHeight));
    Dimension saveFilesToTransferProgressBarSize = DataReduction.saveFilesToTransferProgressBar.getPreferredSize();
    DataReduction.saveFilesToTransferProgressBar.setBounds(
        iButton1Xoff,
        iButton1Yoff,
        saveFilesToTransferProgressBarSize.width,
        saveFilesToTransferProgressBarSize.height);
    
    DataReduction.filesToTransferProcessingPanel.add(DataReduction.saveFilesToTransferProgressBar);
		
    DataReduction.filesToTransferProcessingPanel.setPreferredSize(new Dimension(
        iPanelWidth,
        iPanelHeight));
    Dimension filesToTransferProcessingPanelSize = DataReduction.filesToTransferProcessingPanel.getPreferredSize();
    DataReduction.filesToTransferProcessingPanel.setBounds(
        iButton1Xoff,
        3*iPanelYoff + 2*iPanelHeight + iPanel2Height,
        filesToTransferProcessingPanelSize.width,
        filesToTransferProcessingPanelSize.height);
    
    DataReduction.filesToTransferPanel.add(DataReduction.filesToTransferProcessingPanel);
	}
	
	
	
	
	
	
	
	
}
