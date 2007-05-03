package gov.ornl.sns.iontools;

import javax.swing.*;
import java.awt.Font;
import java.awt.Color;
import java.awt.Dimension;

public class ExtraPlotPanel {

	public static void buildGUI() {
		
		DataReduction.extraPlotPanel = new JPanel();
		DataReduction.extraPlotPanel.setLayout(null);
		
		DataReduction.labelYaxis = new JLabel("afdafdadfdfafdfadfdasfdasfafdfadf");
		DataReduction.labelYaxis.setFont(new Font("sansserif",Font.BOLD,15));
		DataReduction.labelYaxis.setForeground(Color.RED);
		DataReduction.labelYaxis.setPreferredSize(new Dimension(100,30));
		Dimension labelYaxisSize = DataReduction.labelYaxis.getPreferredSize();
		DataReduction.labelYaxis.setBounds(0,
				0,
				labelYaxisSize.width,
				labelYaxisSize.height);
		DataReduction.extraPlotPanel.add(DataReduction.labelYaxis);

		
		
	}
	
}
