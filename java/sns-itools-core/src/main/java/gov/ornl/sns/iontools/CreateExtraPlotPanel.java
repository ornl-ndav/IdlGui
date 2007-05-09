package gov.ornl.sns.iontools;

import javax.swing.*;
import com.rsi.ion.*;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Color;
import java.awt.Component;
import javax.swing.event.ChangeListener;
import javax.swing.event.ChangeEvent;


public class CreateExtraPlotPanel {

	static private int xoff = 8;
	static private int yoff = 45;
	
	/*
	 * Creates the Extra Plots tab panel
	 */
	static void buildGUI() {
		
		DataReduction.extraPlotsPanel = new JPanel();
		DataReduction.extraPlotsPanel.setLayout(null);
				
		buildTabbedPane();
		buildXAxisScale();
		buildYAxisScale();

		//this is just used if user change EPtabs before running a 
		//data reduction
		String[] sEmpty = {IParameters.NA,
						   IParameters.NA,
						   IParameters.NA,
						   IParameters.NA};
		String[] sScale = {"linear", "log10"};
		boolean bFirstTime = true;
		DataReduction.myEPinterface = new ExtraPlotInterface(
				IParameters.SR,
				sEmpty,
				sScale,
				bFirstTime);
		
		DataReduction.bEPFirstTime = true;
		//change event handler to be able to refresh xmin, xmax, ymin and ymax text boxes.
		DataReduction.extraPlotsTabbedPane.addChangeListener(new ChangeListener() {
			public void stateChanged(ChangeEvent ev) {
				ExtraPlotsPopulateAxis.enabledOrNotAxis();
				ExtraPlotsPopulateAxis.populateAxis(DataReduction.bEPFirstTime);
			}});
	}
	
	/*
	 * Creates the X scale for all the extra plots
	 */
	static void buildXAxisScale() {
		
		int xoff = 5;	
		int yoff = 55;
		DataReduction.labelXaxisEP = new JLabel("X-axis");
		DataReduction.labelXaxisEP.setFont(new Font("sansserif",Font.BOLD,15));
		DataReduction.labelXaxisEP.setForeground(Color.RED);
		DataReduction.labelXaxisEP.setPreferredSize(new Dimension(100,30));
		Dimension labelXaxisEPSize = DataReduction.labelXaxisEP.getPreferredSize();
		DataReduction.labelXaxisEP.setBounds(xoff,
				IParameters.DATA_REDUCTION_PLOT_Y+yoff,
				labelXaxisEPSize.width,
				labelXaxisEPSize.height);
		DataReduction.extraPlotsPanel.add(DataReduction.labelXaxisEP);
		DataReduction.labelXaxisEP.setVisible(true);
		
		xoff = 65;
		yoff = 55;
		String[] linLogStrings = {"linear","log10"};
		DataReduction.linLogComboBoxXEP = new JComboBox(linLogStrings);
	    DataReduction.linLogComboBoxXEP.setPreferredSize(new Dimension(100,30));
	    DataReduction.linLogComboBoxXEP.setAlignmentX(Component.CENTER_ALIGNMENT);
	    DataReduction.linLogComboBoxXEP.setSelectedIndex(0);
	    Dimension linLogComboBoxXEPSize = DataReduction.linLogComboBoxX.getPreferredSize();
	    DataReduction.linLogComboBoxXEP.setBounds(xoff,
	    			IParameters.DATA_REDUCTION_PLOT_Y + yoff,
	    			linLogComboBoxXEPSize.width,
	    			linLogComboBoxXEPSize.height);
	    DataReduction.extraPlotsPanel.add(DataReduction.linLogComboBoxXEP);
	    DataReduction.linLogComboBoxXEP.setVisible(true);
	    
	    //ymin
	    xoff = 175;
	    yoff = 55;
	    DataReduction.minLabelEP = new JLabel("min");
	    DataReduction.minLabelEP.setPreferredSize(new Dimension(50,30));
	    Dimension minLabelEPSize = DataReduction.minLabelEP.getPreferredSize();
	    DataReduction.minLabelEP.setBounds(xoff,
	    		IParameters.DATA_REDUCTION_PLOT_Y + yoff,
	    		minLabelEPSize.width,
	    		minLabelEPSize.height);
	    DataReduction.extraPlotsPanel.add(DataReduction.minLabelEP);
	    DataReduction.minLabelEP.setVisible(true);
	    
	    xoff = 200;
	    yoff = 55;
	    DataReduction.xMinTextFieldEP = new JTextField(8);
	    DataReduction.xMinTextFieldEP.setEditable(true);
	    DataReduction.xMinTextFieldEP.setActionCommand("xMinTextFieldEP");
	    DataReduction.xMinTextFieldEP.setPreferredSize(new Dimension(20,30));
	    Dimension xMinTextFieldEPSize = DataReduction.xMinTextFieldEP.getPreferredSize();
	    DataReduction.xMinTextFieldEP.setBounds(xoff,
	    		IParameters.DATA_REDUCTION_PLOT_Y + yoff,
	    		xMinTextFieldEPSize.width,
	    		xMinTextFieldEPSize.height);
	    DataReduction.extraPlotsPanel.add(DataReduction.xMinTextFieldEP);
	    DataReduction.xMinTextFieldEP.setVisible(true);
	    	    
	    //ymax
	    xoff += 100;
	    yoff = 55;
	    DataReduction.maxLabelEP = new JLabel("max");
	    DataReduction.maxLabelEP.setPreferredSize(new Dimension(50,30));
	    Dimension maxLabelEPSize = DataReduction.maxLabelEP.getPreferredSize();
	    DataReduction.maxLabelEP.setBounds(xoff,
	    		IParameters.DATA_REDUCTION_PLOT_Y + yoff,
	    		maxLabelEPSize.width,
	    		maxLabelEPSize.height);
	    DataReduction.extraPlotsPanel.add(DataReduction.maxLabelEP);
	    DataReduction.maxLabelEP.setVisible(true);
	    
	    xoff += 28;
	    yoff = 55;
	    DataReduction.xMaxTextFieldEP = new JTextField(8);
	    DataReduction.xMaxTextFieldEP.setEditable(true);
	    DataReduction.xMaxTextFieldEP.setActionCommand("xMaxTextFieldEP");
	    DataReduction.xMaxTextFieldEP.setPreferredSize(new Dimension(30,30));
	    Dimension xMaxTextFieldEPSize = DataReduction.xMaxTextFieldEP.getPreferredSize();
	    DataReduction.xMaxTextFieldEP.setBounds(xoff,
	    		IParameters.DATA_REDUCTION_PLOT_Y + yoff,
	    		xMaxTextFieldEPSize.width,
	    		xMaxTextFieldEPSize.height);
	    DataReduction.extraPlotsPanel.add(DataReduction.xMaxTextFieldEP);
	    DataReduction.xMaxTextFieldEP.setVisible(true);

	    //validate changes
	    xoff += 100;
	    yoff = 55;
	    DataReduction.xValidateButtonEP = new JButton("Refresh");
	    DataReduction.xValidateButtonEP.setActionCommand("xValidateButtonEP");
	    DataReduction.xValidateButtonEP.setToolTipText("Validate x axis changes");
	    DataReduction.xValidateButtonEP.setPreferredSize(new Dimension(100,30));
	    Dimension xValidateButtonEPSize = DataReduction.xValidateButtonEP.getPreferredSize();
	    DataReduction.xValidateButtonEP.setBounds(xoff,
	    		IParameters.DATA_REDUCTION_PLOT_Y + yoff,
	    		xValidateButtonEPSize.width,
	    		xValidateButtonEPSize.height);
	    DataReduction.extraPlotsPanel.add(DataReduction.xValidateButtonEP);	
	    DataReduction.xValidateButtonEP.setVisible(true);
	    
	    //reset button
	    xoff += 110;
	    yoff = 55;
	    DataReduction.xResetButtonEP = new JButton("Reset x-axis");
	    DataReduction.xResetButtonEP.setActionCommand("xResetButtonEP");
	    DataReduction.xResetButtonEP.setToolTipText("Reset x axis");
	    DataReduction.xResetButtonEP.setPreferredSize(new Dimension(120,30));
	    Dimension xResetButtonEPSize = DataReduction.xResetButtonEP.getPreferredSize();
	    DataReduction.xResetButtonEP.setBounds(xoff,
	    		IParameters.DATA_REDUCTION_PLOT_Y + yoff,
	    		xResetButtonEPSize.width,
	    		xResetButtonEPSize.height);
	    DataReduction.extraPlotsPanel.add(DataReduction.xResetButtonEP);	
	    DataReduction.xResetButtonEP.setVisible(true);
	    
	}
	
	/*
	 * Creates the Y scale for all the extra plots
	 */
	static void buildYAxisScale() {
		
		int xoff = 50;	
		DataReduction.labelYaxisEP = new JLabel("Y-axis");
		DataReduction.labelYaxisEP.setFont(new Font("sansserif",Font.BOLD,15));
		DataReduction.labelYaxisEP.setForeground(Color.RED);
		DataReduction.labelYaxisEP.setPreferredSize(new Dimension(100,30));
		Dimension labelYaxisEPSize = DataReduction.labelYaxisEP.getPreferredSize();
		DataReduction.labelYaxisEP.setBounds(IParameters.DATA_REDUCTION_PLOT_X+xoff,
				0,
				labelYaxisEPSize.width,
				labelYaxisEPSize.height);
		DataReduction.extraPlotsPanel.add(DataReduction.labelYaxisEP);

		xoff = 40;
		int yoff = 10;
		String[] linLogStrings = {"linear","log10"};
	    DataReduction.linLogComboBoxYEP = new JComboBox(linLogStrings);
	    DataReduction.linLogComboBoxYEP.setPreferredSize(new Dimension(100,30));
	    DataReduction.linLogComboBoxYEP.setAlignmentX(Component.CENTER_ALIGNMENT);
	    DataReduction.linLogComboBoxYEP.setSelectedIndex(1);
	    Dimension linLogComboBoxYEPSize = DataReduction.linLogComboBoxY.getPreferredSize();
	    DataReduction.linLogComboBoxYEP.setBounds(IParameters.DATA_REDUCTION_PLOT_X + xoff,
	    			labelYaxisEPSize.height + yoff,
	    			linLogComboBoxYEPSize.width,
	    			linLogComboBoxYEPSize.height);
	    DataReduction.extraPlotsPanel.add(DataReduction.linLogComboBoxYEP);
	    
	    //ymax
	    yoff = 80;
	    xoff = 10;
	    DataReduction.maxLabelEP = new JLabel("max");
	    DataReduction.maxLabelEP.setPreferredSize(new Dimension(50,30));
	    Dimension maxLabelEPSize = DataReduction.maxLabelEP.getPreferredSize();
	    DataReduction.maxLabelEP.setBounds(IParameters.DATA_REDUCTION_PLOT_X + xoff,
	    		yoff,
	    		maxLabelEPSize.width,
	    		maxLabelEPSize.height);
	    DataReduction.extraPlotsPanel.add(DataReduction.maxLabelEP);
	    
	    xoff = 40;
	    yoff += 0;
	    DataReduction.yMaxTextFieldEP = new JTextField(9);
	    DataReduction.yMaxTextFieldEP.setEditable(true);
	    DataReduction.yMaxTextFieldEP.setActionCommand("yMaxTextFieldEP");
	    DataReduction.yMaxTextFieldEP.setPreferredSize(new Dimension(5,30));
	    Dimension yMaxTextFieldEPSize = DataReduction.yMaxTextFieldEP.getPreferredSize();
	    DataReduction.yMaxTextFieldEP.setBounds(IParameters.DATA_REDUCTION_PLOT_X + xoff,
	    		yoff,
	    		yMaxTextFieldEPSize.width,
	    		yMaxTextFieldEPSize.height);
	    DataReduction.extraPlotsPanel.add(DataReduction.yMaxTextFieldEP);
	    
	    //ymin
	    yoff = 70+45;
	    xoff = 10;
	    DataReduction.minLabelEP = new JLabel("min");
	    DataReduction.minLabelEP.setPreferredSize(new Dimension(50,30));
	    Dimension minLabelEPSize = DataReduction.minLabelEP.getPreferredSize();
	    DataReduction.minLabelEP.setBounds(IParameters.DATA_REDUCTION_PLOT_X + xoff,
	    		yoff,
	    		minLabelEPSize.width,
	    		minLabelEPSize.height);
	    DataReduction.extraPlotsPanel.add(DataReduction.minLabelEP);
	    
	    xoff = 40;
	    yoff += 0;
	    DataReduction.yMinTextFieldEP = new JTextField(9);
	    DataReduction.yMinTextFieldEP.setEditable(true);
	    DataReduction.yMinTextFieldEP.setActionCommand("yMinTextFieldEP");
	    DataReduction.yMinTextFieldEP.setPreferredSize(new Dimension(20,30));
	    Dimension yMinTextFieldEPSize = DataReduction.yMinTextFieldEP.getPreferredSize();
	    DataReduction.yMinTextFieldEP.setBounds(IParameters.DATA_REDUCTION_PLOT_X + xoff,
	    		yoff,
	    		yMinTextFieldEPSize.width,
	    		yMinTextFieldEPSize.height);
	    DataReduction.extraPlotsPanel.add(DataReduction.yMinTextFieldEP);
	    
	    //validate button
	    xoff = 10;
	    yoff += 45;
	    DataReduction.yValidateButtonEP = new JButton("Refresh");
	    DataReduction.yValidateButtonEP.setActionCommand("yValidateButtonEP");
	    DataReduction.yValidateButtonEP.setToolTipText("Validate y axis changes");
	    DataReduction.yValidateButtonEP.setPreferredSize(new Dimension(135,30));
	    Dimension yValidateButtonEPSize = DataReduction.yValidateButtonEP.getPreferredSize();
	    DataReduction.yValidateButtonEP.setBounds(IParameters.DATA_REDUCTION_PLOT_X + xoff,
	    		yoff,
	    		yValidateButtonEPSize.width,
	    		yValidateButtonEPSize.height);
	    DataReduction.extraPlotsPanel.add(DataReduction.yValidateButtonEP);	
	    
	    //reset button
	    xoff = 10;
	    yoff += 45;
	    DataReduction.yResetButtonEP = new JButton("Reset y-axis");
	    DataReduction.yResetButtonEP.setActionCommand("yResetButtonEP");
	    DataReduction.yResetButtonEP.setToolTipText("Reset y axis");
	    DataReduction.yResetButtonEP.setPreferredSize(new Dimension(135,30));
	    Dimension yResetButtonEPSize = DataReduction.yResetButtonEP.getPreferredSize();
	    DataReduction.yResetButtonEP.setBounds(IParameters.DATA_REDUCTION_PLOT_X + xoff,
	    		yoff,
	    		yResetButtonEPSize.width,
	    		yResetButtonEPSize.height);
	    DataReduction.extraPlotsPanel.add(DataReduction.yResetButtonEP);	
	    		
	}
	
	/*
	 * Creates the tabbed pane of all the extra plots (drawing window)
	 */
	static void buildTabbedPane() {
		
		DataReduction.extraPlotsTabbedPane = new JTabbedPane();
		DataReduction.extraPlotsTabbedPane.setPreferredSize(
				new Dimension(IParameters.DATA_REDUCTION_PLOT_X+xoff,
							  IParameters.DATA_REDUCTION_PLOT_Y+yoff));	
		Dimension extraPlotsTabbedPaneSize = 
			DataReduction.extraPlotsTabbedPane.getPreferredSize();
		DataReduction.extraPlotsTabbedPane.setBounds(
				0,
				0,
				extraPlotsTabbedPaneSize.width,
				extraPlotsTabbedPaneSize.height);
		
		//Signal region summed vs TOF
		DataReduction.c_SRextraPlots  = new IONJGrDrawable(
				IParameters.EXTRA_PLOTS_X,
				IParameters.EXTRA_PLOTS_Y);
		DataReduction.extraPlotsTabbedPane.addTab("Signal", DataReduction.c_SRextraPlots);
		
		//Background summed vs tof
		DataReduction.c_BSextraPlots = new IONJGrDrawable(
				IParameters.EXTRA_PLOTS_X,
				IParameters.EXTRA_PLOTS_Y);
		DataReduction.extraPlotsTabbedPane.addTab("Background", DataReduction.c_BSextraPlots);

		//Signal region with background summed vs TOF
		DataReduction.c_SRBextraPlots = new IONJGrDrawable(
				IParameters.EXTRA_PLOTS_X,
				IParameters.EXTRA_PLOTS_Y);
		DataReduction.extraPlotsTabbedPane.addTab("Signal with Background", DataReduction.c_SRBextraPlots);
		
		//Normalization region summed vs TOF
		DataReduction.c_NRextraPlots = new IONJGrDrawable(
				IParameters.EXTRA_PLOTS_X,
				IParameters.EXTRA_PLOTS_Y);
		DataReduction.extraPlotsTabbedPane.addTab("Normalization", DataReduction.c_NRextraPlots);
		
		//Background region from normalization summed TOF
		DataReduction.c_BRNextraPlots = new IONJGrDrawable(
				IParameters.EXTRA_PLOTS_X,
				IParameters.EXTRA_PLOTS_Y);
		DataReduction.extraPlotsTabbedPane.addTab("Background from Normalization", DataReduction.c_BRNextraPlots);

		DataReduction.extraPlotsPanel.add(DataReduction.extraPlotsTabbedPane);
		
		
	}
	
	
}
