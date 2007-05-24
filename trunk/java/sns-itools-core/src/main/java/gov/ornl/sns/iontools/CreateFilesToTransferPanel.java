package gov.ornl.sns.iontools;

import java.awt.Dimension;

import javax.swing.*;

public class CreateFilesToTransferPanel {

  private static int iPanelXoff = 5;
  private static int iPanelYoff = 5;
  private static int iPanelWidth = 800;
  private static int iPanelHeight = 50; 
	private static int iPanel2Height = 300;
  private static int iIconLabelWidth = 30;
	private static int iIconLabelHeight = 30;
	private static int iLabelXoff = 10;
	private static int iLabelYoff = 15;
	private static int iButtonWidth = 300;
	private static int iButtonHeight = 30;
	private static int iButtonXoff = 100;
	private static int iButtonYoff = 15;
  private static int iProgressBarWidth = 600;
  private static int iProgressBarHeight = 30;
	private static int iSplitPaneWidth = 500;
  private static int iSplitPaneHeigth = 300;
  
  static void buildGUI() {

    DataReduction.filesToTransferPanel.setLayout(null);
    
		buildPanel1();  	  //panel of step 1
		buildPanel2();      //panel of step 2
		buildPanel3();      //panel of step 3
		buildPanel4();      //panel that contains the processing bar
	}

	/*
	 * This function will create the step 1 of the tab
	 * - file selection -
	 */
	static void buildPanel1() {
		
		DataReduction.filesToTransferStep1Panel = new JPanel();
		DataReduction.filesToTransferStep1Panel.setLayout(null);
//	    DataReduction.filesToTransferStep1Panel.setBorder(BorderFactory.createCompoundBorder(
//				BorderFactory.createTitledBorder("Step 1"),
//				BorderFactory.createEmptyBorder(5,5,5,5)));
		
		DataReduction.filesToKeepIcon1Label = new JLabel("1:");
		DataReduction.filesToKeepIcon1Label.setPreferredSize(new Dimension(
				iIconLabelWidth,
				iIconLabelHeight));
		Dimension filesToKeepIconLabelSize = DataReduction.filesToKeepIcon1Label.getPreferredSize();
		DataReduction.filesToKeepIcon1Label.setBounds(
				iLabelXoff,
				iLabelYoff,
				filesToKeepIconLabelSize.width,
				filesToKeepIconLabelSize.height);
				
		DataReduction.filesToKeep1Button = new JButton("Select files to save");
		DataReduction.filesToKeep1Button.setActionCommand("filesToKeepButton");
		DataReduction.filesToKeep1Button.setPreferredSize(new Dimension(
				iButtonWidth,
				iButtonHeight));
		Dimension filesToKeepButtonSize = DataReduction.filesToKeep1Button.getPreferredSize();
		DataReduction.filesToKeep1Button.setBounds(
				iButtonXoff,
				iButtonYoff,
				filesToKeepButtonSize.width,
				filesToKeepButtonSize.height);
		
		DataReduction.filesToTransferStep1Panel.add(DataReduction.filesToKeepIcon1Label);
		DataReduction.filesToTransferStep1Panel.add(DataReduction.filesToKeep1Button);
		
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
		
		DataReduction.filesToKeepIcon2Label = new JLabel("2:");
		DataReduction.filesToKeepIcon2Label.setPreferredSize(new Dimension(
				iIconLabelWidth,
				iIconLabelHeight));
		Dimension filesToKeepIconLabelSize = DataReduction.filesToKeepIcon2Label.getPreferredSize();
		DataReduction.filesToKeepIcon2Label.setBounds(
				iLabelXoff,
				iLabelYoff,
				filesToKeepIconLabelSize.width,
				filesToKeepIconLabelSize.height);
		
		DataReduction.filesToTransferStep2Panel.add(DataReduction.filesToKeepIcon2Label);
		
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
        iButtonXoff,
        iButtonYoff,
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
	
		DataReduction.filesToKeepIcon3Label = new JLabel("3:");
		DataReduction.filesToKeepIcon3Label.setPreferredSize(new Dimension(
				iIconLabelWidth,
				iIconLabelHeight));
		Dimension filesToKeepIconLabelSize = DataReduction.filesToKeepIcon3Label.getPreferredSize();
		DataReduction.filesToKeepIcon3Label.setBounds(
				iLabelXoff,
				iLabelYoff,
				filesToKeepIconLabelSize.width,
				filesToKeepIconLabelSize.height);
		
		DataReduction.filesToKeep3Button = new JButton("Transfer files to your home directory");
		DataReduction.filesToKeep3Button.setActionCommand("filesToKeep3Button");
		DataReduction.filesToKeep3Button.setPreferredSize(new Dimension(
				iButtonWidth,
				iButtonHeight));
		Dimension filesToKeepButtonSize = DataReduction.filesToKeep3Button.getPreferredSize();
		DataReduction.filesToKeep3Button.setBounds(
				iButtonXoff,
				iButtonYoff,
				filesToKeepButtonSize.width,
				filesToKeepButtonSize.height);
		
		DataReduction.filesToTransferStep3Panel.add(DataReduction.filesToKeepIcon3Label);
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
        iLabelXoff,
        iLabelYoff,
        saveFilesToTransferProgressBarSize.width,
        saveFilesToTransferProgressBarSize.height);
    
    DataReduction.filesToTransferProcessingPanel.add(DataReduction.saveFilesToTransferProgressBar);
		
    DataReduction.filesToTransferProcessingPanel.setPreferredSize(new Dimension(
        iPanelWidth,
        iPanelHeight));
    Dimension filesToTransferProcessingPanelSize = DataReduction.filesToTransferProcessingPanel.getPreferredSize();
    DataReduction.filesToTransferProcessingPanel.setBounds(
        iButtonXoff,
        3*iPanelYoff + 2*iPanelHeight + iPanel2Height,
        filesToTransferProcessingPanelSize.width,
        filesToTransferProcessingPanelSize.height);
    
    DataReduction.filesToTransferPanel.add(DataReduction.filesToTransferProcessingPanel);
	}
	
	
	
	
	
	
	
	
}
