package gov.ornl.sns.iontools;

import javax.swing.*;
import java.awt.Component;

public class LoadctPanel {

	static void buildGUI() {
		
		DataReduction.loadctComboBox = new JComboBox(IParameters.LOADCT_NAME);
		DataReduction.loadctComboBox.setAlignmentX(Component.CENTER_ALIGNMENT);
		DataReduction.loadctComboBox.setSelectedIndex(IParameters.LOADCT_DEFAULT_INDEX);
		DataReduction.loadctComboBox.setActionCommand("loadctComboBox");
		DataReduction.loadctComboBox.setEnabled(false);
						
	}
	
}
