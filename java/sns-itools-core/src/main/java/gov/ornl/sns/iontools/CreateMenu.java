package gov.ornl.sns.iontools;

import javax.swing.*;
import java.awt.event.*;

public class CreateMenu {

	public static void buildGUI() { 
	
	//Create the menu bar
	DataReduction.menuBar = new JMenuBar();
		
	//Create the first menu
	DataReduction.dataReductionPackMenu = new JMenu("DataReductionPack");
	DataReduction.dataReductionPackMenu.setActionCommand("dataReductionPackMenu");
	DataReduction.dataReductionPackMenu.setMnemonic(KeyEvent.VK_D);
	DataReduction.dataReductionPackMenu.setEnabled(true);
	DataReduction.menuBar.add(DataReduction.dataReductionPackMenu);

	//name of instrument 
	DataReduction.instrumentMenu = new JMenu("Instrument");
	DataReduction.instrumentMenu.setMnemonic(KeyEvent.VK_I);
	DataReduction.dataReductionPackMenu.add(DataReduction.instrumentMenu);

	//a group of radio button menu items
	DataReduction.instrumentButtonGroup = new ButtonGroup();

	DataReduction.reflRadioButton = new JRadioButtonMenuItem("REF_L");
	DataReduction.reflRadioButton.setActionCommand("instrumentREFL");
	DataReduction.reflRadioButton.setSelected(true);
	DataReduction.reflRadioButton.setMnemonic(KeyEvent.VK_L);
	DataReduction.instrumentButtonGroup.add(DataReduction.reflRadioButton);
	DataReduction.instrumentMenu.add(DataReduction.reflRadioButton);
	
	DataReduction.refmRadioButton = new JRadioButtonMenuItem("REF_M");
	DataReduction.refmRadioButton.setActionCommand("instrumentREFM");
	DataReduction.refmRadioButton.setSelected(true);
	DataReduction.refmRadioButton.setMnemonic(KeyEvent.VK_M);
	DataReduction.instrumentButtonGroup.add(DataReduction.refmRadioButton);
	DataReduction.instrumentMenu.add(DataReduction.refmRadioButton);

	//preferences
	DataReduction.preferencesMenuItem = new JMenuItem("Preferences...");
	DataReduction.preferencesMenuItem.setMnemonic(KeyEvent.VK_C);
	DataReduction.preferencesMenuItem.setActionCommand("preferencesMenuItem");
	DataReduction.dataReductionPackMenu.add(DataReduction.preferencesMenuItem);

	//Create the second menu
	DataReduction.modeMenu = new JMenu("Mode");
	DataReduction.modeMenu.setActionCommand("modeMenu");
	DataReduction.modeMenu.setMnemonic(KeyEvent.VK_M);
	DataReduction.modeMenu.setEnabled(false);
	DataReduction.modeMenu.getAccessibleContext().setAccessibleDescription("Select the active operation mode");
	DataReduction.menuBar.add(DataReduction.modeMenu);

	//a group of radio button menu items
	DataReduction.modeButtonGroup = new ButtonGroup();

	DataReduction.signalSelectionModeMenuItem = new JRadioButtonMenuItem("Signal selection");
	DataReduction.signalSelectionModeMenuItem.setActionCommand("signalSelection");
	DataReduction.signalSelectionModeMenuItem.setSelected(true);
	DataReduction.signalSelectionModeMenuItem.setMnemonic(KeyEvent.VK_S);
	DataReduction.modeButtonGroup.add(DataReduction.signalSelectionModeMenuItem);
	DataReduction.modeMenu.add(DataReduction.signalSelectionModeMenuItem);
	
	DataReduction.background1SelectionModeMenuItem = new JRadioButtonMenuItem("Background #1 selection");
	DataReduction.background1SelectionModeMenuItem.setActionCommand("back1Selection");
	DataReduction.background1SelectionModeMenuItem.setSelected(true);
	DataReduction.background1SelectionModeMenuItem.setMnemonic(KeyEvent.VK_S);
	DataReduction.modeButtonGroup.add(DataReduction.background1SelectionModeMenuItem);
	DataReduction.modeMenu.add(DataReduction.background1SelectionModeMenuItem);

	DataReduction.background2SelectionModeMenuItem = new JRadioButtonMenuItem("Background #2 selection");
	DataReduction.background2SelectionModeMenuItem.setActionCommand("back2Selection");
	DataReduction.background2SelectionModeMenuItem.setSelected(true);
	DataReduction.background2SelectionModeMenuItem.setMnemonic(KeyEvent.VK_S);
	DataReduction.modeButtonGroup.add(DataReduction.background2SelectionModeMenuItem);
	DataReduction.modeMenu.add(DataReduction.background2SelectionModeMenuItem);

	}	
}	