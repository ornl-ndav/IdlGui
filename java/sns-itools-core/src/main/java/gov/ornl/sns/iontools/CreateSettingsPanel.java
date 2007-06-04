package gov.ornl.sns.iontools;

import javax.swing.*;
import java.awt.Dimension;
import java.awt.GridLayout;

public class CreateSettingsPanel {

	//extra plot panel
	private static int xoff = 10;
	private static int yoff = 5;
	private static int extraPlotSettingsPanelWidth = 400;
	private static int extraPlotSettingsPanelHeight = 200;
	private static int validateButtonWidth = 200;
	private static int validateButtonHeight = 30;
	private static int settingsValidateButtonXoff = 300;
	private static int settingsValidateButtonYoff = 590;
	private static int settingsSelectAllButtonXoff = 412;
	private static int settingsSelectAllButtonYoff = 510;
	private static int settingsSelectAllButtonDeltaX = 196;
	private static int settingsSelectButtonWidth = 180;
	private static int settingsSelectButtonHeight = 30;
  
  private static int settingsParametersXoff = xoff;
  private static int settingsParametersYoff = 203;
  private static int settingsParametersWidth = extraPlotSettingsPanelWidth;
  private static int settingsParametersHeight = 200;
	
	//saving parameters panel
	private static int savingParametersSettingsPanelWidth = 380;
	private static int savingParametersSettingsPanelHeight = 500;
	
  private static int nbrLinesNotXmlLabelXoff = 10;
  private static int nbrLinesNotXmlLabelYoff = 20;
  private static int nbrLinesNotXmlLabelWidth = 400;
  private static int nbrLinesNotXmlLabelHeight = 30;
  private static int nbrLinesXmlLabelXoff = nbrLinesNotXmlLabelXoff;
  private static int nbrLinesXmlLabelYoff = 50;
  private static int nbrLinesXmlLabelWidth = nbrLinesNotXmlLabelWidth;
  private static int nbrLinesXmlLabelHeight = nbrLinesNotXmlLabelHeight;
  
  private static int nbrLinesNotXmlTextFieldXoff = 310;
  private static int nbrLinesNotXmlTextFieldYoff = nbrLinesNotXmlLabelYoff;
  private static int nbrLinesNotXmlTextFieldWidth = 50;
  private static int nbrLinesNotXmlTextFieldHeight = nbrLinesNotXmlLabelHeight;
  private static int nbrLinesXmlTextFieldXoff = nbrLinesNotXmlTextFieldXoff;
  private static int nbrLinesXmlTextFieldYoff = nbrLinesXmlLabelYoff;
  private static int nbrLinesXmlTextFieldWidth = nbrLinesNotXmlTextFieldWidth;
  private static int nbrLinesXmlTextFieldHeight = nbrLinesNotXmlLabelHeight;
  
  
	public static void buildGUI() {
		
		DataReduction.settingsPanel.setLayout(null);  			// main panel of tab
		buildSettingsExtraPlotPanel();
		buildSettingsSavingParametersPanel();
    buildSettingsParametersPanel();
	}
	
	
	public static void buildSettingsExtraPlotPanel() {
							
		DataReduction.extraPlotSettingsPanel = new JPanel();   	// extra plots panel
		DataReduction.extraPlotSettingsPanel.setLayout(new GridLayout(0,1));
		DataReduction.extraPlotSettingsPanel.setBorder(BorderFactory.createCompoundBorder(
				BorderFactory.createTitledBorder("Extra Plots"),
				BorderFactory.createEmptyBorder(5,5,5,5)));		
		
		DataReduction.extraPlotSettingsPanel.setPreferredSize(new Dimension(
				extraPlotSettingsPanelWidth,
				extraPlotSettingsPanelHeight));
		Dimension extraPlotSettingsPanelSize = DataReduction.extraPlotSettingsPanel.getPreferredSize();
		DataReduction.extraPlotSettingsPanel.setBounds(xoff,
				yoff,
				extraPlotSettingsPanelSize.width,
				extraPlotSettingsPanelSize.height);
					
		// ** list of plots available **
		// signal region summed vs TOF
		DataReduction.extraPlotsSRCheckBox = new JCheckBox("Signal Region summed vs TOF");
		DataReduction.extraPlotsSRCheckBox.setSelected(IParameters.YES_INTERMEDIATE_SR);
		DataReduction.extraPlotsSRCheckBox.setActionCommand("extraPlotsSRCheckBox");
		DataReduction.extraPlotSettingsPanel.add(DataReduction.extraPlotsSRCheckBox);
		
		// background summed vs tof
		DataReduction.extraPlotsBSCheckBox = new JCheckBox("Background summed vs TOF");
		DataReduction.extraPlotsBSCheckBox.setSelected(IParameters.YES_INTERMEDIATE_BS);
		DataReduction.extraPlotsBSCheckBox.setActionCommand("extraPlotsBSCheckBox");
		DataReduction.extraPlotSettingsPanel.add(DataReduction.extraPlotsBSCheckBox);

		// signal region with background vs TOF
		DataReduction.extraPlotsSRBCheckBox = new JCheckBox("Signal region with background summed vs TOF");
		DataReduction.extraPlotsSRBCheckBox.setSelected(IParameters.YES_INTERMEDIATE_SRB);
		DataReduction.extraPlotsSRBCheckBox.setActionCommand("extraPlotsSRBCheckBox");
		DataReduction.extraPlotSettingsPanel.add(DataReduction.extraPlotsSRBCheckBox);

		// normalization region summed vs TOF
		DataReduction.extraPlotsNRCheckBox = new JCheckBox("Normalization region summed vs TOF");
		DataReduction.extraPlotsNRCheckBox.setSelected(IParameters.YES_INTERMEDIATE_NR);
		DataReduction.extraPlotsNRCheckBox.setActionCommand("extraPlotsNRCheckBox");
		DataReduction.extraPlotSettingsPanel.add(DataReduction.extraPlotsNRCheckBox);

		// Background region from normalization summed TOF
		DataReduction.extraPlotsBRNCheckBox = new JCheckBox("Background region from normalization summed vs TOF");
		DataReduction.extraPlotsBRNCheckBox.setSelected(IParameters.YES_INTERMEDIATE_BRN);
		DataReduction.extraPlotsBRNCheckBox.setActionCommand("extraPlotsBRNCheckBox");
		DataReduction.extraPlotSettingsPanel.add(DataReduction.extraPlotsBRNCheckBox);
		
		//validate button
		DataReduction.settingsValidateButton = new JButton("Validate");
		DataReduction.settingsValidateButton.setActionCommand("settingsValidateButton");
		DataReduction.settingsValidateButton.setToolTipText("Validate changes");
		DataReduction.settingsValidateButton.setPreferredSize(new Dimension(
				validateButtonWidth,
				validateButtonHeight));		
		Dimension settingsValidateButtonDimension = DataReduction.settingsValidateButton.getPreferredSize();
		DataReduction.settingsValidateButton.setBounds(
				settingsValidateButtonXoff,
				settingsValidateButtonYoff,
				settingsValidateButtonDimension.width,
				settingsValidateButtonDimension.height);
		
		DataReduction.settingsPanel.add(DataReduction.extraPlotSettingsPanel);
		DataReduction.settingsPanel.add(DataReduction.settingsValidateButton);
		
	}
	
	public static void buildSettingsSavingParametersPanel() {
		
		DataReduction.savingParametersSettingsPanel = new JPanel();   	
		DataReduction.savingParametersSettingsPanel.setLayout(new GridLayout(0,1));
		DataReduction.savingParametersSettingsPanel.setBorder(BorderFactory.createCompoundBorder(
				BorderFactory.createTitledBorder("Parameters to keep between runs"),
				BorderFactory.createEmptyBorder(5,5,5,5)));		
		
		DataReduction.savingParametersSettingsPanel.setPreferredSize(new Dimension(
				savingParametersSettingsPanelWidth,
				savingParametersSettingsPanelHeight));
		Dimension savingParametersSettingsPanelSize = DataReduction.savingParametersSettingsPanel.getPreferredSize();
		DataReduction.savingParametersSettingsPanel.setBounds(
				xoff + extraPlotSettingsPanelWidth, 
				yoff,
				savingParametersSettingsPanelSize.width,
				savingParametersSettingsPanelSize.height);

		DataReduction.saveSignalPidFileCheckBox = new JCheckBox("Signal PID file name");
		DataReduction.saveSignalPidFileCheckBox.setSelected(true);
		DataReduction.saveSignalPidFileCheckBox.setActionCommand("saveSignalPidFileCheckBox");
		DataReduction.savingParametersSettingsPanel.add(DataReduction.saveSignalPidFileCheckBox);
		
		DataReduction.saveBackPidFileCheckBox = new JCheckBox("Background PID file name");
		DataReduction.saveBackPidFileCheckBox.setSelected(true);
		DataReduction.saveBackPidFileCheckBox.setActionCommand("saveBackPidFileCheckBox");
		DataReduction.savingParametersSettingsPanel.add(DataReduction.saveBackPidFileCheckBox);
		
		DataReduction.saveMinWavelengthCheckBox = new JCheckBox("Min wavelength");
		DataReduction.saveMinWavelengthCheckBox.setSelected(true);
		DataReduction.saveMinWavelengthCheckBox.setActionCommand("saveMinWavelengthCheckBox");
		DataReduction.savingParametersSettingsPanel.add(DataReduction.saveMinWavelengthCheckBox);
    DataReduction.saveMinWavelengthCheckBox.setEnabled(false);
		
		DataReduction.saveMaxWavelengthCheckBox = new JCheckBox("Max wavelength");
		DataReduction.saveMaxWavelengthCheckBox.setSelected(true);
		DataReduction.saveMaxWavelengthCheckBox.setActionCommand("saveMaxWavelengthCheckBox");
		DataReduction.savingParametersSettingsPanel.add(DataReduction.saveMaxWavelengthCheckBox);
		DataReduction.saveMaxWavelengthCheckBox.setEnabled(false);
    
		DataReduction.saveWidthWavelengthCheckBox = new JCheckBox("Width wavelength");
		DataReduction.saveWidthWavelengthCheckBox.setSelected(true);
		DataReduction.saveWidthWavelengthCheckBox.setActionCommand("saveWidthWavelengthCheckBox");
		DataReduction.savingParametersSettingsPanel.add(DataReduction.saveWidthWavelengthCheckBox);
		DataReduction.saveWidthWavelengthCheckBox.setEnabled(false);
    
		DataReduction.saveDetectorAngleCheckBox = new JCheckBox("Detector angle");
		DataReduction.saveDetectorAngleCheckBox.setSelected(true);
		DataReduction.saveDetectorAngleCheckBox.setActionCommand("saveDetectorAngleCheckBox");
		DataReduction.savingParametersSettingsPanel.add(DataReduction.saveDetectorAngleCheckBox);
		DataReduction.saveDetectorAngleCheckBox.setEnabled(false);
    
		DataReduction.saveDetectorAnglePMCheckBox = new JCheckBox("Detector angle incertitude");
		DataReduction.saveDetectorAnglePMCheckBox.setSelected(true);
		DataReduction.saveDetectorAnglePMCheckBox.setActionCommand("saveDetectorAnglePMCheckBox");
		DataReduction.savingParametersSettingsPanel.add(DataReduction.saveDetectorAnglePMCheckBox);
		DataReduction.saveDetectorAnglePMCheckBox.setEnabled(false);
    
		DataReduction.saveDetectorAngleUnitsCheckBox = new JCheckBox("Detector angle units");
		DataReduction.saveDetectorAngleUnitsCheckBox.setSelected(true);
		DataReduction.saveDetectorAngleUnitsCheckBox.setActionCommand("saveDetectorAngleUnitsCheckBox");
		DataReduction.savingParametersSettingsPanel.add(DataReduction.saveDetectorAngleUnitsCheckBox);
		DataReduction.saveDetectorAngleUnitsCheckBox.setEnabled(false);
    
		DataReduction.saveNormalizationCheckBox = new JCheckBox("Normalization");
		DataReduction.saveNormalizationCheckBox.setSelected(true);
		DataReduction.saveNormalizationCheckBox.setActionCommand("saveNormalizationCheckBox");
		DataReduction.savingParametersSettingsPanel.add(DataReduction.saveNormalizationCheckBox);
		
		DataReduction.saveBackgroundCheckBox = new JCheckBox("Background");
		DataReduction.saveBackgroundCheckBox.setSelected(true);
		DataReduction.saveBackgroundCheckBox.setActionCommand("saveBackgroundCheckBox");
		DataReduction.savingParametersSettingsPanel.add(DataReduction.saveBackgroundCheckBox);
		
		DataReduction.saveNormalizationBackgroundCheckBox = new JCheckBox("Normalization Background");
		DataReduction.saveNormalizationBackgroundCheckBox.setSelected(true);
		DataReduction.saveNormalizationBackgroundCheckBox.setActionCommand("saveNormalizationBackgroundCheckBox");
		DataReduction.savingParametersSettingsPanel.add(DataReduction.saveNormalizationBackgroundCheckBox);
		
		DataReduction.saveIntermediateFileOutputCheckBox = new JCheckBox("Intermediate file output");
		DataReduction.saveIntermediateFileOutputCheckBox.setSelected(true);
		DataReduction.saveIntermediateFileOutputCheckBox.setActionCommand("saveIntermediateFileOutputCheckBox");
		DataReduction.savingParametersSettingsPanel.add(DataReduction.saveIntermediateFileOutputCheckBox);
		
		DataReduction.saveCombineDataSpectrumCheckBox = new JCheckBox("Combine data spetrum");
		DataReduction.saveCombineDataSpectrumCheckBox.setSelected(true);
		DataReduction.saveCombineDataSpectrumCheckBox.setActionCommand("saveCombineDataSpectrumCheckBox");
		DataReduction.savingParametersSettingsPanel.add(DataReduction.saveCombineDataSpectrumCheckBox);
		
		DataReduction.saveOverwriteInstrumentGeometryCheckBox = new JCheckBox("Overwrite instrument geometry");
		DataReduction.saveOverwriteInstrumentGeometryCheckBox.setSelected(true);
		DataReduction.saveOverwriteInstrumentGeometryCheckBox.setActionCommand("saveOverwriteInstrumentGeometryCheckBox");
		DataReduction.savingParametersSettingsPanel.add(DataReduction.saveOverwriteInstrumentGeometryCheckBox);
		
		DataReduction.saveAddAndGoRunNumberCheckBox = new JCheckBox("Add NeXus and Go");
		DataReduction.saveAddAndGoRunNumberCheckBox.setSelected(true);
		DataReduction.saveAddAndGoRunNumberCheckBox.setActionCommand("saveAddAndGoRunNumberCheckBox");
		DataReduction.savingParametersSettingsPanel.add(DataReduction.saveAddAndGoRunNumberCheckBox);
		
		DataReduction.saveGoSequentiallyCheckBox = new JCheckBox("Go Sequentially");
		DataReduction.saveGoSequentiallyCheckBox.setSelected(true);
		DataReduction.saveGoSequentiallyCheckBox.setActionCommand("saveGoSequentiallyCheckBox");
		DataReduction.savingParametersSettingsPanel.add(DataReduction.saveGoSequentiallyCheckBox);
		
		DataReduction.settingsPanel.add(DataReduction.savingParametersSettingsPanel);
	
		DataReduction.settingsSelectAllButton = new JButton("Select all");
		DataReduction.settingsSelectAllButton.setActionCommand("settingsSelectAllButton");
		DataReduction.settingsSelectAllButton.setToolTipText("Select everything");
		DataReduction.settingsSelectAllButton.setPreferredSize(new Dimension(
				settingsSelectButtonWidth,
				settingsSelectButtonHeight));
		Dimension settingsSelectButtonDimension = DataReduction.settingsSelectAllButton.getPreferredSize();
		DataReduction.settingsSelectAllButton.setBounds(
				settingsSelectAllButtonXoff,
				settingsSelectAllButtonYoff,
				settingsSelectButtonDimension.width,
				settingsSelectButtonDimension.height);
		DataReduction.settingsPanel.add(DataReduction.settingsSelectAllButton);
				
		DataReduction.settingsUnselectAllButton = new JButton("Unselect all");
		DataReduction.settingsUnselectAllButton.setActionCommand("settingsUnselectAllButton");
		DataReduction.settingsUnselectAllButton.setToolTipText("Unselect everything");
		DataReduction.settingsUnselectAllButton.setPreferredSize(new Dimension(
				settingsSelectButtonWidth,
				settingsSelectButtonHeight));
		Dimension settingsUnselectButtonDimension = DataReduction.settingsUnselectAllButton.getPreferredSize();
		DataReduction.settingsUnselectAllButton.setBounds(
				settingsSelectAllButtonXoff + settingsSelectAllButtonDeltaX,
				settingsSelectAllButtonYoff,
				settingsUnselectButtonDimension.width,
				settingsUnselectButtonDimension.height);
    DataReduction.settingsPanel.add(DataReduction.settingsUnselectAllButton);
	}	
  
	static void buildSettingsParametersPanel() {

    DataReduction.settingsParametersPanel = new JPanel();    //settings parameters panel
    DataReduction.settingsParametersPanel.setLayout(null);
    DataReduction.settingsParametersPanel.setBorder(BorderFactory.createCompoundBorder(
        BorderFactory.createTitledBorder("Configuration"),
        BorderFactory.createEmptyBorder(5,5,5,5)));   
    
    DataReduction.settingsParametersPanel.setPreferredSize(new Dimension(
        settingsParametersWidth,
        settingsParametersHeight));
    Dimension settingsParametersPanelSize = DataReduction.settingsParametersPanel.getPreferredSize();
    DataReduction.settingsParametersPanel.setBounds(
        settingsParametersXoff,
        settingsParametersYoff,
        settingsParametersPanelSize.width,
        settingsParametersPanelSize.height);
    DataReduction.settingsPanel.add(DataReduction.settingsParametersPanel);
  
    //Nbr of info lines displayed for not XML files in save files
    String message = "Nbr of info lines displayed - no XML file";
    DataReduction.nbrInfoLinesDisplayedNotXmlFilesLabel = new JLabel(message);
    DataReduction.nbrInfoLinesDisplayedNotXmlFilesLabel.setPreferredSize(new Dimension(
        nbrLinesNotXmlLabelWidth,
        nbrLinesNotXmlLabelHeight));
    Dimension nbrInfoLinesDisplayedNotXmlFilesLabelSize = DataReduction.nbrInfoLinesDisplayedNotXmlFilesLabel.getPreferredSize();
    DataReduction.nbrInfoLinesDisplayedNotXmlFilesLabel.setBounds(
        nbrLinesNotXmlLabelXoff,
        nbrLinesNotXmlLabelYoff,
        nbrInfoLinesDisplayedNotXmlFilesLabelSize.width,
        nbrInfoLinesDisplayedNotXmlFilesLabelSize.height);
    DataReduction.settingsParametersPanel.add(DataReduction.nbrInfoLinesDisplayedNotXmlFilesLabel);
    
    
    DataReduction.nbrInfoLinesDisplayedNotXmlFilesTextField = new JTextField(5);
    DataReduction.nbrInfoLinesDisplayedNotXmlFilesTextField.setActionCommand("nbrInfoLinesDisplayedNotXmlFilesTextField");
    DataReduction.nbrInfoLinesDisplayedNotXmlFilesTextField.setEditable(true);
    String sNbrOfLines = Integer.toString(IParameters.i_NO_RMD_NBR_LINE_DISPLAYED);
    DataReduction.nbrInfoLinesDisplayedNotXmlFilesTextField.setText(sNbrOfLines);
    DataReduction.nbrInfoLinesDisplayedNotXmlFilesTextField.setPreferredSize(new Dimension(
        nbrLinesNotXmlTextFieldWidth,
        nbrLinesNotXmlTextFieldHeight));
    Dimension nbrInfoLinesDisplayedNotXmlFilesTextFieldSize = DataReduction.nbrInfoLinesDisplayedNotXmlFilesTextField.getPreferredSize();
    DataReduction.nbrInfoLinesDisplayedNotXmlFilesTextField.setBounds(
        nbrLinesNotXmlTextFieldXoff,
        nbrLinesNotXmlTextFieldYoff,
        nbrInfoLinesDisplayedNotXmlFilesTextFieldSize.width,
        nbrInfoLinesDisplayedNotXmlFilesTextFieldSize.height);
    DataReduction.settingsParametersPanel.add(DataReduction.nbrInfoLinesDisplayedNotXmlFilesTextField);
    
    //  Nbr of info lines displayed for XML files in save files
    message = "Nbr of info lines displayed - XML file";
    DataReduction.nbrInfoLinesDisplayedXmlFilesLabel = new JLabel(message);
    DataReduction.nbrInfoLinesDisplayedXmlFilesLabel.setPreferredSize(new Dimension(
        nbrLinesXmlLabelWidth,
        nbrLinesXmlLabelHeight));
    Dimension nbrInfoLinesDisplayedXmlFilesLabelSize = DataReduction.nbrInfoLinesDisplayedXmlFilesLabel.getPreferredSize();
    DataReduction.nbrInfoLinesDisplayedXmlFilesLabel.setBounds(
        nbrLinesXmlLabelXoff,
        nbrLinesXmlLabelYoff,
        nbrInfoLinesDisplayedXmlFilesLabelSize.width,
        nbrInfoLinesDisplayedXmlFilesLabelSize.height);
    DataReduction.settingsParametersPanel.add(DataReduction.nbrInfoLinesDisplayedXmlFilesLabel);
    
    DataReduction.nbrInfoLinesDisplayedXmlFilesTextField = new JTextField(5);
    DataReduction.nbrInfoLinesDisplayedXmlFilesTextField.setActionCommand("nbrInfoLinesDisplayedXmlFilesTextField");
    DataReduction.nbrInfoLinesDisplayedXmlFilesTextField.setEditable(true);
    sNbrOfLines = Integer.toString(IParameters.i_RMD_NBR_LINE_DISPLAYED);
    DataReduction.nbrInfoLinesDisplayedXmlFilesTextField.setText(sNbrOfLines);
    DataReduction.nbrInfoLinesDisplayedXmlFilesTextField.setPreferredSize(new Dimension(
        nbrLinesXmlTextFieldWidth,
        nbrLinesXmlTextFieldHeight));
    Dimension nbrInfoLinesDisplayedXmlFilesTextFieldSize = DataReduction.nbrInfoLinesDisplayedXmlFilesTextField.getPreferredSize();
    DataReduction.nbrInfoLinesDisplayedXmlFilesTextField.setBounds(
        nbrLinesXmlTextFieldXoff,
        nbrLinesXmlTextFieldYoff,
        nbrInfoLinesDisplayedXmlFilesTextFieldSize.width,
        nbrInfoLinesDisplayedXmlFilesTextFieldSize.height);
    DataReduction.settingsParametersPanel.add(DataReduction.nbrInfoLinesDisplayedXmlFilesTextField);
    
    
  }
}

