package gov.ornl.sns.iontools;

import javax.swing.*;
import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.Color;

public class CreateDataReductionInputGUI {

	public static void createInputGui() {
		
//	definition of variables
	DataReduction.buttonSignalBackgroundPanel = new JPanel(new GridLayout(0,1));   
	DataReduction.textFieldSignalBackgroundPanel = new JPanel(new GridLayout(0,1));
	DataReduction.clearSelectionPanel = new JPanel(new GridLayout(0,1));
	DataReduction.signalBackgroundPanel = new JPanel() ; 

	DataReduction.signalPidPanel = new JPanel();
	DataReduction.backgroundPidPanel = new JPanel();
	DataReduction.normalizationPanel = new JPanel(new FlowLayout(FlowLayout.LEADING));
	DataReduction.backgroundPanel = new JPanel(new FlowLayout(FlowLayout.LEADING));
	DataReduction.normBackgroundPanel = new JPanel(new FlowLayout(FlowLayout.LEADING));

	DataReduction.startDataReductionPanel = new JPanel(new FlowLayout());

	//signal pid infos
	DataReduction.signalPidFileButton = new JButton("Save Signal PID file");
	DataReduction.signalPidFileButton.setActionCommand("signalPidFileButton");
	DataReduction.signalPidFileButton.setEnabled(false);
	DataReduction.signalPidFileButton.setToolTipText("Select a signal PID file");
	
	DataReduction.signalPidFileTextField = new JTextField(40);
	DataReduction.signalPidFileTextField.setEditable(false);
	DataReduction.signalPidFileTextField.setActionCommand("signalPidFileTextField");
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
	DataReduction.backgroundPidFileTextField.setActionCommand("backgroundPidFileTextField");
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
	
	//normalization radio button
	DataReduction.normalizationLabel = new JLabel(" Normalization: ");
		
	DataReduction.yesNormalizationRadioButton = new JRadioButton("Yes");
	DataReduction.yesNormalizationRadioButton.setActionCommand("yesNormalization");
	DataReduction.yesNormalizationRadioButton.setSelected(true);
			
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
	DataReduction.normalizationTextField.setBackground(Color.RED);
	DataReduction.normalizationTextField.setActionCommand("normalizationTextField");
	DataReduction.normalizationTextField.setEditable(true);
	DataReduction.normalizationTextBoxPanel.add(DataReduction.normalizationTextBoxLabel);
	DataReduction.normalizationTextBoxPanel.add(DataReduction.normalizationTextField);
	DataReduction.normalizationPanel.add(DataReduction.normalizationTextBoxPanel);
	
	//background radio button
	DataReduction.backgroundLabel = new JLabel(" Background:    ");

	DataReduction.yesBackgroundRadioButton = new JRadioButton("Yes");
	DataReduction.yesBackgroundRadioButton.setActionCommand("yesBackground");
	DataReduction.yesBackgroundRadioButton.setSelected(true);

	DataReduction.noBackgroundRadioButton = new JRadioButton("No");
	DataReduction.noBackgroundRadioButton.setActionCommand("noBackground");

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
	DataReduction.yesNormBackgroundRadioButton.setSelected(true);

	DataReduction.noNormBackgroundRadioButton = new JRadioButton("No");
	DataReduction.noNormBackgroundRadioButton.setActionCommand("noNormBackground");

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
	DataReduction.noIntermediateRadioButton.setSelected(true);

	DataReduction.intermediateButtonGroup = new ButtonGroup();
	DataReduction.intermediateButtonGroup.add(DataReduction.yesIntermediateRadioButton);
	DataReduction.intermediateButtonGroup.add(DataReduction.noIntermediateRadioButton);
	
	DataReduction.intermediateButton = new JButton("Intermediate Plots");
	DataReduction.intermediateButton.setActionCommand("intermediateButton");
	DataReduction.intermediateButton.setToolTipText("List of intermediate plots available");
	DataReduction.intermediateButton.setEnabled(false);
	
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
	DataReduction.noCombineSpectrumRadioButton.setSelected(true);
	DataReduction.noCombineSpectrumRadioButton.setActionCommand("noCombineSpectrum");

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
	DataReduction.noInstrumentGeometryRadioButton.setSelected(true);

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
	DataReduction.generalInfoTextArea.setEditable(true);
	DataReduction.scrollPane = new JScrollPane(DataReduction.generalInfoTextArea,
						 JScrollPane.VERTICAL_SCROLLBAR_ALWAYS,
						 JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);

	//add all components
	DataReduction.panela = new JPanel();                           
	DataReduction.panela.setLayout(new BoxLayout(DataReduction.panela,BoxLayout.PAGE_AXIS));
	DataReduction.panela.add(DataReduction.signalBackgroundPanel);
	DataReduction.panela.add(DataReduction.normalizationPanel);
	DataReduction.panela.add(DataReduction.backgroundPanel);
	DataReduction.panela.add(DataReduction.normBackgroundPanel);
	DataReduction.panela.add(DataReduction.intermediatePanel);
	DataReduction.panela.add(DataReduction.combineSpectrumPanel);
	DataReduction.panela.add(DataReduction.instrumentGeometryPanel);
	DataReduction.panela.add(DataReduction.runsTabbedPane);
	DataReduction.panela.add(DataReduction.startDataReductionPanel);
	DataReduction.panela.add(DataReduction.scrollPane);

	}
}
