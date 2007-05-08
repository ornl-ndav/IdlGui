package gov.ornl.sns.iontools;

import javax.swing.*;
import java.awt.Dimension;
import java.awt.GridLayout;

public class SettingsPanel {

	private static int xoff = 10;
	private static int yoff = 5;
	private static int extraPlotSettingsPanelWidth = 400;
	private static int extraPlotSettingsPanelHeight = 200;
	private static int validateButtonWidth = 200;
	private static int validateButtonHeight = 30;
	private static int settingsValidateButtonXoff = 300;
	private static int settingsValidateButtonYoff = 590;
	
	public static void buildGUI() {
		
		buildSettingsExtraPlotPanel();
		
	}
	
	
	public static void buildSettingsExtraPlotPanel() {
		
		DataReduction.settingsPanel.setLayout(null);  			// main panel of tab
				
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
		DataReduction.extraPlotsSRCheckBox.setSelected(true);
		DataReduction.extraPlotsSRCheckBox.setActionCommand("extraPlotsSRCheckBox");
		DataReduction.extraPlotSettingsPanel.add(DataReduction.extraPlotsSRCheckBox);
		
		// background summed vs tof
		DataReduction.extraPlotsBSCheckBox = new JCheckBox("Background summed vs TOF");
		DataReduction.extraPlotsBSCheckBox.setSelected(true);
		DataReduction.extraPlotsBSCheckBox.setActionCommand("extraPlotsBSCheckBox");
		DataReduction.extraPlotSettingsPanel.add(DataReduction.extraPlotsBSCheckBox);

		// signal region with background vs TOF
		DataReduction.extraPlotsSRBCheckBox = new JCheckBox("Signal region with background summed vs TOF");
		DataReduction.extraPlotsSRBCheckBox.setSelected(true);
		DataReduction.extraPlotsSRBCheckBox.setActionCommand("extraPlotsSRBCheckBox");
		DataReduction.extraPlotSettingsPanel.add(DataReduction.extraPlotsSRBCheckBox);

		// normalization region summed vs TOF
		DataReduction.extraPlotsNRCheckBox = new JCheckBox("Normalization region summed vs TOF");
		DataReduction.extraPlotsNRCheckBox.setSelected(true);
		DataReduction.extraPlotsNRCheckBox.setActionCommand("extraPlotsNRCheckBox");
		DataReduction.extraPlotSettingsPanel.add(DataReduction.extraPlotsNRCheckBox);

		// Background region from normalization summed TOF
		DataReduction.extraPlotsBRNCheckBox = new JCheckBox("Background region from normalization summed vs TOF");
		DataReduction.extraPlotsBRNCheckBox.setSelected(true);
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
	
}
