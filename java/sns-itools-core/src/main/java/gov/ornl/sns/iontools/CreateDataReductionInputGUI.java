package gov.ornl.sns.iontools;

import javax.swing.*;
import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.Color;

public class CreateDataReductionInputGUI {

  static JTabbedPane      saveLoadSelectionTabbedPane;
  static JPanel           loadPidPanel;
  static JComboBox        listOfPidFileToLoadComboBox;
  static JComboBox        typeOfSelectionComboBox;
  static JComboBox        homeOrCurrentSessionComboBox;
  static JButton          loadPidButton;
  static JButton          clearPidButton;
  static JLabel           loadSignalLabel;
  static JLabel           loadBackLabel;
  static JTextField       loadSignalTextField;
  static JTextField       loadBackTextField;
  
  static String[] listOfSelectionFiles = {""};
  
  static int      fileToSelectComboBoxXoff = 5;
  static int      fileToSelectComboBoxYoff = 5;
  static int      fileToSelectComboBoxWidth = 300;
  static int      typeOfSelectionComboBoxWidth = 145;
  static int      fileToSelectComboBoxHeight = 30;
    
  static int      loadButtonXoff = 315;
  static int      loadButtonYoff = fileToSelectComboBoxYoff;
  static int      loadButtonWidth = 125;
  static int      loadButtonHeight = fileToSelectComboBoxHeight;
  
  static int      loadLabelXoff = 445;
  static int      loadLabelYoff = fileToSelectComboBoxYoff;
  static int      loadLabelWidth = 50;
  static int      loadLabelHeight = fileToSelectComboBoxHeight;
  
  static int      fileTextFieldXoff = 490;
  static int      fileTextFieldYoff = fileToSelectComboBoxYoff;
  static int      fileTextFieldWidth = 300;
  static int      fileTextFieldHeight = fileToSelectComboBoxHeight;
  static int      textFieldSize = 100;
  static int      yoff= 35;
  
  static int      homeOrCurrentSessionComboBoxXoff = 155;
  static int      homeOrCurrentSessionComboBoxYoff = loadButtonYoff + yoff;
  static int      homeOrCurrentSessionComboBoxWidth = 150;
  static int      homeOrCurrentSessionComboBoxHeight = 30;
  
  	public static void createInputGui() {
	    
  //definition of variables
  DataReduction.buttonSignalBackgroundPanel = new JPanel(new GridLayout(0,1));   
	DataReduction.textFieldSignalBackgroundPanel = new JPanel(new GridLayout(0,1));
	DataReduction.clearSelectionPanel = new JPanel(new GridLayout(0,1));
	DataReduction.signalBackgroundPanel = new JPanel() ; 

	DataReduction.signalPidPanel = new JPanel();
  
	DataReduction.backgroundPidPanel = new JPanel();
	DataReduction.wavelengthPanel = new JPanel(new FlowLayout(FlowLayout.LEADING));
	DataReduction.detectorAnglePanel = new JPanel(new FlowLayout(FlowLayout.LEADING));
	DataReduction.normalizationPanel = new JPanel(new FlowLayout(FlowLayout.LEADING));
	DataReduction.backgroundPanel = new JPanel(new FlowLayout(FlowLayout.LEADING));
	DataReduction.normBackgroundPanel = new JPanel(new FlowLayout(FlowLayout.LEADING));

	DataReduction.startDataReductionPanel = new JPanel(new FlowLayout());

  //save and load selection tabs
  saveLoadSelectionTabbedPane = new JTabbedPane();
  
  //first tab SAVE SELECTION
	//signal pid infos
	DataReduction.signalPidFileButton = new JButton("Save Signal PID file");
	DataReduction.signalPidFileButton.setActionCommand("signalPidFileButton");
	DataReduction.signalPidFileButton.setEnabled(false);
	DataReduction.signalPidFileButton.setToolTipText("Select a signal PID file");
	
	DataReduction.signalPidFileTextField = new JTextField(40);
	DataReduction.signalPidFileTextField.setEditable(false);
	DataReduction.signalPidFileTextField.setBackground(Color.RED);
	
	DataReduction.clearSignalPidFileButton = new JButton ("Clear signal");
	DataReduction.clearSignalPidFileButton.setActionCommand("clearSignalPidFileButton");
	DataReduction.clearSignalPidFileButton.setEnabled(false);
	DataReduction.clearSignalPidFileButton.setToolTipText("Reset the signal selection (file and display)");
		
	//background pid infos
	DataReduction.backgroundPidFileButton = new JButton("Save Background PID file");
	DataReduction.backgroundPidFileButton.setActionCommand("backgroundPidFileButton");
	DataReduction.backgroundPidFileButton.setEnabled(false);
	DataReduction.backgroundPidFileButton.setToolTipText("Select a background PID file");
	
	DataReduction.backgroundPidFileTextField = new JTextField(40);
	DataReduction.backgroundPidFileTextField.setEditable(false);
	DataReduction.backgroundPidFileTextField.setBackground(Color.RED);
	
	DataReduction.clearBackPidFileButton = new JButton("Clear background");
	DataReduction.clearBackPidFileButton.setActionCommand("clearBackPidFileButton");
	DataReduction.clearBackPidFileButton.setEnabled(false);
	DataReduction.clearBackPidFileButton.setToolTipText("Reset the background selection (file and display)");
	
	DataReduction.buttonSignalBackgroundPanel.add(DataReduction.signalPidFileButton);
	DataReduction.buttonSignalBackgroundPanel.add(DataReduction.backgroundPidFileButton);
	DataReduction.textFieldSignalBackgroundPanel.add(DataReduction.signalPidFileTextField);
	DataReduction.textFieldSignalBackgroundPanel.add(DataReduction.backgroundPidFileTextField);
	DataReduction.clearSelectionPanel.add(DataReduction.clearSignalPidFileButton);
	DataReduction.clearSelectionPanel.add(DataReduction.clearBackPidFileButton);
	DataReduction.signalBackgroundPanel.add(DataReduction.buttonSignalBackgroundPanel,BorderLayout.LINE_START);
	DataReduction.signalBackgroundPanel.add(DataReduction.textFieldSignalBackgroundPanel,BorderLayout.CENTER);
	DataReduction.signalBackgroundPanel.add(DataReduction.clearSelectionPanel,BorderLayout.LINE_END);
	saveLoadSelectionTabbedPane.addTab("SAVE SELECTION", DataReduction.signalBackgroundPanel); //first tab

  //second tab LOAD SELECTION
  loadPidPanel = new JPanel();
  loadPidPanel.setLayout(null);
  
  //top part of LOAD selection tab
  listOfPidFileToLoadComboBox = new JComboBox(listOfSelectionFiles);
  listOfPidFileToLoadComboBox.setBounds(
      fileToSelectComboBoxXoff,
      fileToSelectComboBoxYoff,
      fileToSelectComboBoxWidth,
      fileToSelectComboBoxHeight);
  loadPidPanel.add(listOfPidFileToLoadComboBox);
  
  loadPidButton = new JButton("LOAD");
  loadPidButton.setActionCommand("loadPidButton");
  loadPidButton.setToolTipText("Load and use the selected file as the signal or background PID file");
  loadPidButton.setBounds(
      loadButtonXoff,
      loadButtonYoff,
      loadButtonWidth,
      loadButtonHeight);
  loadPidPanel.add(loadPidButton);
  
  loadSignalLabel = new JLabel("Signal:");
  loadSignalLabel.setBounds(
      loadLabelXoff,
      loadLabelYoff,
      loadLabelWidth,
      loadLabelHeight);
  loadPidPanel.add(loadSignalLabel);
  
  loadSignalTextField = new JTextField(textFieldSize);
  loadSignalTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_EMPTY);
  loadSignalTextField.setEditable(false);
  loadSignalTextField.setBounds(
      fileTextFieldXoff,
      fileTextFieldYoff,
      fileTextFieldWidth,
      fileTextFieldHeight);
  loadPidPanel.add(loadSignalTextField);
  
  //bottom part of load selection PID files
  String[] listOfSelection = IParameters.LIST_OF_SELECTION;
  typeOfSelectionComboBox = new JComboBox(listOfSelection);
  typeOfSelectionComboBox.setActionCommand("typeOfSelectionComboBox");
  typeOfSelectionComboBox.setBounds(
      fileToSelectComboBoxXoff,
      fileToSelectComboBoxYoff + yoff,
      typeOfSelectionComboBoxWidth,
      fileToSelectComboBoxHeight);
  loadPidPanel.add(typeOfSelectionComboBox);
  
  String[] listOfDirectory = { "Home directory","Current session" };
  homeOrCurrentSessionComboBox = new JComboBox(listOfDirectory);
  homeOrCurrentSessionComboBox.setActionCommand("homeOrCurrentSessionComboBox");
  homeOrCurrentSessionComboBox.setBounds(
      homeOrCurrentSessionComboBoxXoff,
      homeOrCurrentSessionComboBoxYoff,
      homeOrCurrentSessionComboBoxWidth,
      homeOrCurrentSessionComboBoxHeight);
  String sInfo = "HOME DIRECTORY: defined in the settings tab - ";
  sInfo += "CURRENT SESSION: used only through the life of the current session";
  homeOrCurrentSessionComboBox.setToolTipText(sInfo);
  loadPidPanel.add(homeOrCurrentSessionComboBox);
    
  clearPidButton = new JButton("CLEAR");
  clearPidButton.setActionCommand("clearPidButton");
  clearPidButton.setToolTipText("clear the selected file");
  clearPidButton.setBounds(
      loadButtonXoff,
      loadButtonYoff + yoff,
      loadButtonWidth,
      loadButtonHeight);
  loadPidPanel.add(clearPidButton);
  
  loadBackLabel = new JLabel("  Back.:");
  loadBackLabel.setBounds(
      loadLabelXoff,
      loadLabelYoff + yoff,
      loadLabelWidth,
      loadLabelHeight);
  loadPidPanel.add(loadBackLabel);
  
  loadBackTextField = new JTextField(textFieldSize);
  loadBackTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_EMPTY);
  loadBackTextField.setEditable(false);
  loadBackTextField.setBounds(
      fileTextFieldXoff,
      fileTextFieldYoff + yoff,
      fileTextFieldWidth,
      fileTextFieldHeight);
  loadPidPanel.add(loadBackTextField);
  
  saveLoadSelectionTabbedPane.addTab("LOAD SELECTION", loadPidPanel);
    
  //Wavelength (for REF_M only)
	DataReduction.wavelengthLabel = new JLabel("Wavelength:   ");
	
	DataReduction.wavelengthMinLabel = new JLabel("Min ");
	DataReduction.wavelengthMinTextField = new JTextField(7);
	DataReduction.wavelengthMinTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_EMPTY);
	DataReduction.wavelengthMinTextField.setEditable(true);
	DataReduction.wavelengthMinTextField.setActionCommand("wavelengthMinTextField");
	
	DataReduction.wavelengthMaxLabel = new JLabel("Max ");
	DataReduction.wavelengthMaxTextField = new JTextField(7);
	DataReduction.wavelengthMaxTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_EMPTY);
	DataReduction.wavelengthMaxTextField.setEditable(true);
	DataReduction.wavelengthMaxTextField.setActionCommand("wavelengthMaxTextField");
	
	DataReduction.wavelengthWidthLabel = new JLabel("Width ");
	DataReduction.wavelengthWidthTextField = new JTextField(7);
	DataReduction.wavelengthWidthTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_EMPTY);
	DataReduction.wavelengthWidthTextField.setEditable(true);
	DataReduction.wavelengthWidthTextField.setActionCommand("wavelengthWidthTextField");
	
	DataReduction.wavelengthAngstromsLabel = new JLabel("Angstroms");
	
	DataReduction.wavelengthPanel.add(DataReduction.wavelengthLabel);
	DataReduction.wavelengthPanel.add(DataReduction.wavelengthMinLabel);
	DataReduction.wavelengthPanel.add(DataReduction.wavelengthMinTextField);
	DataReduction.wavelengthPanel.add(DataReduction.wavelengthMaxLabel);
	DataReduction.wavelengthPanel.add(DataReduction.wavelengthMaxTextField);
	DataReduction.wavelengthPanel.add(DataReduction.wavelengthWidthLabel);
	DataReduction.wavelengthPanel.add(DataReduction.wavelengthWidthTextField);
	DataReduction.wavelengthPanel.add(DataReduction.wavelengthAngstromsLabel);
		
	//Detector Angle (for REF_M only)
	DataReduction.detectorAngleLabel = new JLabel("Detector Angle:      ");
	DataReduction.detectorAngleTextField = new JTextField(7);
	DataReduction.detectorAngleTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_EMPTY);
	DataReduction.detectorAngleTextField.setEditable(true);
	DataReduction.detectorAngleTextField.setActionCommand("detectorAngleTextField");
	
	DataReduction.detectorAnglePMLabel = new JLabel("+/- ");
	DataReduction.detectorAnglePMTextField = new JTextField(7);
	DataReduction.detectorAnglePMTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_EMPTY);
	DataReduction.detectorAnglePMTextField.setEditable(true);
	DataReduction.detectorAnglePMTextField.setActionCommand("detectorAnglePMTextField");
	
	String[] angleUnitsStrings = {"radians","degres"};
    DataReduction.detectorAngleUnuitsComboBox = new JComboBox(angleUnitsStrings);
		
	DataReduction.detectorAnglePanel.add(DataReduction.detectorAngleLabel);
	DataReduction.detectorAnglePanel.add(DataReduction.detectorAngleTextField);
	DataReduction.detectorAnglePanel.add(DataReduction.detectorAnglePMLabel);
	DataReduction.detectorAnglePanel.add(DataReduction.detectorAnglePMTextField);
	DataReduction.detectorAnglePanel.add(Box.createRigidArea(new Dimension(39,0)));
	DataReduction.detectorAnglePanel.add(DataReduction.detectorAngleUnuitsComboBox);
	
	//normalization radio button
	DataReduction.normalizationLabel = new JLabel(" Normalization: ");
		
	DataReduction.yesNormalizationRadioButton = new JRadioButton("Yes");
	DataReduction.yesNormalizationRadioButton.setActionCommand("yesNormalization");
	DataReduction.noNormalizationRadioButton = new JRadioButton("No");
	DataReduction.noNormalizationRadioButton.setActionCommand("noNormalization");

	DataReduction.normalizationButtonGroup = new ButtonGroup();
	DataReduction.normalizationButtonGroup.add(DataReduction.yesNormalizationRadioButton);
	DataReduction.normalizationButtonGroup.add(DataReduction.noNormalizationRadioButton);
	
	DataReduction.normalizationPanel.add(DataReduction.normalizationLabel);
	DataReduction.normalizationPanel.add(DataReduction.yesNormalizationRadioButton);
	DataReduction.normalizationPanel.add(DataReduction.noNormalizationRadioButton);

	DataReduction.normalizationTextBoxPanel = new JPanel();
	DataReduction.normalizationTextBoxLabel = new JLabel("Run number: ");
	DataReduction.normalizationTextField = new JTextField(15);
	DataReduction.normalizationTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_EMPTY);
	DataReduction.normalizationTextField.setActionCommand("normalizationTextField");
	DataReduction.normalizationTextField.setEditable(true);
	DataReduction.normalizationTextBoxPanel.add(DataReduction.normalizationTextBoxLabel);
	DataReduction.normalizationTextBoxPanel.add(DataReduction.normalizationTextField);
	DataReduction.normalizationPanel.add(DataReduction.normalizationTextBoxPanel);

	if (IParameters.YES_NORMALIZATION_CHECK_BOX) {
		DataReduction.yesNormalizationRadioButton.setSelected(true);
	} else {
		DataReduction.noNormalizationRadioButton.setSelected(true);
		DataReduction.normalizationTextField.setEnabled(false);
		DataReduction.normalizationTextBoxLabel.setEnabled(false);
	}
	
	//background radio button
	DataReduction.backgroundLabel = new JLabel(" Background:    ");

	DataReduction.yesBackgroundRadioButton = new JRadioButton("Yes");
	DataReduction.yesBackgroundRadioButton.setActionCommand("yesBackground");
	DataReduction.noBackgroundRadioButton = new JRadioButton("No");
	DataReduction.noBackgroundRadioButton.setActionCommand("noBackground");

	if (IParameters.YES_BACKGROUND_CHECK_BOX) {
		DataReduction.yesBackgroundRadioButton.setSelected(true);	
	} else {
		DataReduction.noBackgroundRadioButton.setSelected(true);
	}
		
	DataReduction.backgroundButtonGroup = new ButtonGroup();
	DataReduction.backgroundButtonGroup.add(DataReduction.yesBackgroundRadioButton);
	DataReduction.backgroundButtonGroup.add(DataReduction.noBackgroundRadioButton);

	DataReduction.backgroundPanel.add(DataReduction.backgroundLabel);
	DataReduction.backgroundPanel.add(DataReduction.yesBackgroundRadioButton);
	DataReduction.backgroundPanel.add(DataReduction.noBackgroundRadioButton);

	//normalization background radio button
	DataReduction.normBackgroundLabel = new JLabel(" Normalization background: ");
	
	DataReduction.yesNormBackgroundRadioButton = new JRadioButton("Yes");
	DataReduction.yesNormBackgroundRadioButton.setActionCommand("yesNormBackground");
	DataReduction.noNormBackgroundRadioButton = new JRadioButton("No");
	DataReduction.noNormBackgroundRadioButton.setActionCommand("noNormBackground");

	if (IParameters.YES_NORMALIZATION_BACKGROUND_CHECK_BOX) {
		DataReduction.yesNormBackgroundRadioButton.setSelected(true);
	} else {
		DataReduction.noNormBackgroundRadioButton.setSelected(true);
	}
	
	DataReduction.normBackgroundButtonGroup = new ButtonGroup();
	DataReduction.normBackgroundButtonGroup.add(DataReduction.yesNormBackgroundRadioButton);
	DataReduction.normBackgroundButtonGroup.add(DataReduction.noNormBackgroundRadioButton);

	DataReduction.normBackgroundPanel.add(DataReduction.normBackgroundLabel);
	DataReduction.normBackgroundPanel.add(DataReduction.yesNormBackgroundRadioButton);
	DataReduction.normBackgroundPanel.add(DataReduction.noNormBackgroundRadioButton);
	    
	//intermediate plots
	DataReduction.intermediatePanel = new JPanel(new FlowLayout(FlowLayout.LEADING));
	DataReduction.intermediateLabel = new JLabel(" Intermediate file output:     ");

	DataReduction.yesIntermediateRadioButton = new JRadioButton("Yes");
	DataReduction.yesIntermediateRadioButton.setActionCommand("yesIntermediate");
	DataReduction.noIntermediateRadioButton = new JRadioButton("No");
	DataReduction.noIntermediateRadioButton.setActionCommand("noIntermediate");

	DataReduction.intermediateButtonGroup = new ButtonGroup();
	DataReduction.intermediateButtonGroup.add(DataReduction.yesIntermediateRadioButton);
	DataReduction.intermediateButtonGroup.add(DataReduction.noIntermediateRadioButton);
	
	DataReduction.intermediateButton = new JButton("Intermediate Plots");
	DataReduction.intermediateButton.setActionCommand("intermediateButton");
	DataReduction.intermediateButton.setToolTipText("List of intermediate plots available");

	if (IParameters.YES_INTERMEDIATE_FILE_CHECK_BOX) {
		DataReduction.yesIntermediateRadioButton.setSelected(true);
	} else {
		DataReduction.noIntermediateRadioButton.setSelected(true);
		DataReduction.intermediateButton.setEnabled(false);
	}
	
	DataReduction.intermediatePanel.add(DataReduction.intermediateLabel);
	DataReduction.intermediatePanel.add(DataReduction.yesIntermediateRadioButton);
	DataReduction.intermediatePanel.add(DataReduction.noIntermediateRadioButton);
	DataReduction.intermediatePanel.add(DataReduction.intermediateButton);

    //combine spectrum
	DataReduction.combineSpectrumPanel = new JPanel(new FlowLayout(FlowLayout.LEADING));
	DataReduction.combineSpectrumLabel = new JLabel(" Combine data spectrum:     ");
	
	DataReduction.yesCombineSpectrumRadioButton = new JRadioButton("Yes");
	DataReduction.yesCombineSpectrumRadioButton.setActionCommand("yesCombineSpectrum");
	DataReduction.yesCombineSpectrumRadioButton.setSelected(false);
	DataReduction.noCombineSpectrumRadioButton = new JRadioButton("No");
	DataReduction.noCombineSpectrumRadioButton.setActionCommand("noCombineSpectrum");

	if (IParameters.YES_COMBINE_DATA_SPECTRUM) {
		DataReduction.yesCombineSpectrumRadioButton.setSelected(true);
	} else {
		DataReduction.noCombineSpectrumRadioButton.setSelected(true);
	}
	
	DataReduction.combineSpectrumButtonGroup = new ButtonGroup();
	DataReduction.combineSpectrumButtonGroup.add(DataReduction.yesCombineSpectrumRadioButton);
	DataReduction.combineSpectrumButtonGroup.add(DataReduction.noCombineSpectrumRadioButton);
	
	DataReduction.combineSpectrumPanel.add(DataReduction.combineSpectrumLabel);
	DataReduction.combineSpectrumPanel.add(DataReduction.yesCombineSpectrumRadioButton);
	DataReduction.combineSpectrumPanel.add(DataReduction.noCombineSpectrumRadioButton);
	
	//overwrite instrument geometry
	DataReduction.instrumentGeometryPanel = new JPanel(new FlowLayout(FlowLayout.LEADING));
	DataReduction.instrumentGeometryLabel = new JLabel(" Overwrite instrument geometry:");
	
	DataReduction.yesInstrumentGeometryRadioButton = new JRadioButton("Yes");
	DataReduction.yesInstrumentGeometryRadioButton.setActionCommand("yesInstrumentGeometry");
	DataReduction.noInstrumentGeometryRadioButton = new JRadioButton("No");
	DataReduction.noInstrumentGeometryRadioButton.setActionCommand("noInstrumentGeometry");
	
	DataReduction.instrumentGeometryButtonGroup = new ButtonGroup();
	DataReduction.instrumentGeometryButtonGroup.add(DataReduction.yesInstrumentGeometryRadioButton);
	DataReduction.instrumentGeometryButtonGroup.add(DataReduction.noInstrumentGeometryRadioButton);

	DataReduction.instrumentGeometryButton = new JButton("Geometry file");
	DataReduction.instrumentGeometryButton.setActionCommand("instrumentGeometryButton");
	DataReduction.instrumentGeometryButton.setToolTipText("Instrument geometry file");
	DataReduction.instrumentGeometryButton.setEnabled(false);
	
	DataReduction.instrumentGeometryTextField = new JTextField(30);
	DataReduction.instrumentGeometryTextField.setActionCommand("instrumentGeometryTextField");
	DataReduction.instrumentGeometryTextField.setEditable(true);

	if (IParameters.YES_OVERWRITE_INSTRUMENT_GEOMETRY) {
		DataReduction.yesInstrumentGeometryRadioButton.setSelected(true);	
	} else {
		DataReduction.noInstrumentGeometryRadioButton.setSelected(true);
		DataReduction.instrumentGeometryButton.setEnabled(false);
		DataReduction.instrumentGeometryTextField.setEnabled(false);
	}
						
	DataReduction.instrumentGeometryPanel.add(DataReduction.instrumentGeometryLabel);
	DataReduction.instrumentGeometryPanel.add(DataReduction.yesInstrumentGeometryRadioButton);
	DataReduction.instrumentGeometryPanel.add(DataReduction.noInstrumentGeometryRadioButton);
	DataReduction.instrumentGeometryPanel.add(DataReduction.instrumentGeometryButton);
	DataReduction.instrumentGeometryPanel.add(DataReduction.instrumentGeometryTextField);

	//tab of runs 
	DataReduction.runsTabbedPane = new JTabbedPane();
	DataReduction.runsAddPanel = new JPanel(new FlowLayout());
	DataReduction.runsSequencePanel = new JPanel(new FlowLayout());

	DataReduction.runsAddLabel = new JLabel(" Run(s) number: ");
	DataReduction.runsAddTextField = new JTextField(30);
	DataReduction.runsAddTextField.setToolTipText("1230,1231,1234-1238,1240");
	DataReduction.runsAddTextField.setEditable(true);
	DataReduction.runsAddTextField.setBackground(Color.RED);
	DataReduction.runsAddTextField.setActionCommand("runsAddTextField");
	DataReduction.runsAddPanel.add(DataReduction.runsAddLabel);
	DataReduction.runsAddPanel.add(DataReduction.runsAddTextField);
	DataReduction.runsTabbedPane.addTab("Add NeXus and GO",DataReduction.runsAddPanel);

	DataReduction.runsSequenceLabel = new JLabel(" Run(s) number: ");
	DataReduction.runsSequenceTextField = new JTextField(30);
	DataReduction.runsSequenceTextField.setToolTipText("1230,1231,1234-1238,1240");
	DataReduction.runsSequenceTextField.setEditable(true);
	DataReduction.runsSequenceTextField.setBackground(Color.RED);
	DataReduction.runsSequenceTextField.setActionCommand("runsSequenceTextField");
	DataReduction.runsSequencePanel.add(DataReduction.runsSequenceLabel);
	DataReduction.runsSequencePanel.add(DataReduction.runsSequenceTextField);
	DataReduction.runsTabbedPane.addTab("GO sequentially",DataReduction.runsSequencePanel);

	//go button
	DataReduction.startDataReductionButton = new JButton(" START DATA REDUCTION ");
	DataReduction.startDataReductionButton.setActionCommand("startDataReductionButton");
	DataReduction.startDataReductionButton.setToolTipText("Press to launch the data reduction");
	DataReduction.startDataReductionButton.setEnabled(true);
	DataReduction.startDataReductionPanel.add(DataReduction.startDataReductionButton);
	//startDataReductionButton.setEnabled(false);

	DataReduction.blank1Label = new JLabel("    ");
	DataReduction.blank2Label = new JLabel("    ");
	DataReduction.blank3Label = new JLabel("    ");
	
	//general info text area 
	DataReduction.generalInfoTextArea = new JTextArea(5,40);
	DataReduction.generalInfoTextArea.setEditable(false);
	DataReduction.scrollPane = new JScrollPane(DataReduction.generalInfoTextArea,
						 JScrollPane.VERTICAL_SCROLLBAR_ALWAYS,
						 JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);

	//add all components
	DataReduction.panela = new JPanel();                           
	DataReduction.panela.setLayout(new BoxLayout(DataReduction.panela,BoxLayout.PAGE_AXIS));
	DataReduction.panela.add(saveLoadSelectionTabbedPane);
	DataReduction.panela.add(DataReduction.wavelengthPanel);
	DataReduction.panela.add(DataReduction.detectorAnglePanel);
	DataReduction.panela.add(DataReduction.normalizationPanel);
	DataReduction.panela.add(DataReduction.backgroundPanel);
	DataReduction.panela.add(DataReduction.normBackgroundPanel);
	DataReduction.panela.add(DataReduction.intermediatePanel);
	DataReduction.panela.add(DataReduction.combineSpectrumPanel);
	DataReduction.panela.add(DataReduction.instrumentGeometryPanel);
	DataReduction.panela.add(DataReduction.runsTabbedPane);
	DataReduction.panela.add(DataReduction.startDataReductionPanel);
	DataReduction.panela.add(DataReduction.scrollPane);
	
	DataReduction.wavelengthPanel.setVisible(false);
	DataReduction.detectorAnglePanel.setVisible(false);

	}
}
