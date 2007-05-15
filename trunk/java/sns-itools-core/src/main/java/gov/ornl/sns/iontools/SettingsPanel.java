package gov.ornl.sns.iontools;

import javax.swing.*;
import java.awt.Dimension;
import java.awt.GridLayout;

public class SettingsPanel {

	//extra plot panel
	private static int xoff = 10;
	private static int yoff = 5;
	private static int extraPlotSettingsPanelWidth = 400;
	private static int extraPlotSettingsPanelHeight = 200;
	private static int validateButtonWidth = 200;
	private static int validateButtonHeight = 30;
	private static int settingsValidateButtonXoff = 300;
	private static int settingsValidateButtonYoff = 590;
	
	//saving parameters panel
	private static int savingParametersSettingsPanelWidth = 400;
	private static int savingParametersSettingsPanelHeight = 370;
	
	public static void buildGUI() {
		
		DataReduction.settingsPanel.setLayout(null);  			// main panel of tab
		buildSettingsExtraPlotPanel();
		buildSettingsSavingParametersPanel();
		
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
				xoff,
				yoff + extraPlotSettingsPanelHeight,
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
			
	}
	
	
}
