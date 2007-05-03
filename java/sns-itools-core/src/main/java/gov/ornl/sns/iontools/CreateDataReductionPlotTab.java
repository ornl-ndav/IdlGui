package gov.ornl.sns.iontools;

import com.rsi.ion.*;
import javax.swing.*;
import java.awt.Font;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Component;

public class CreateDataReductionPlotTab {

	static void initializeDisplay() {
	
		DataReduction.panelb.setLayout(null);
		
		//plot
		DataReduction.c_dataReductionPlot = new IONJGrDrawable(IParameters.DATA_REDUCTION_PLOT_X, IParameters.DATA_REDUCTION_PLOT_Y);
		DataReduction.panelb.add(DataReduction.c_dataReductionPlot);
		
		initializeYAxisDisplay();
		initializeXAxisDisplay();
	
	}
	
	
	/*
	 * Create GUI of y-axis
	 */
	static void initializeYAxisDisplay() {  
			
	int xoff = 50;	
	DataReduction.labelYaxis = new JLabel("Y-axis");
	DataReduction.labelYaxis.setFont(new Font("sansserif",Font.BOLD,15));
	DataReduction.labelYaxis.setForeground(Color.RED);
	DataReduction.labelYaxis.setPreferredSize(new Dimension(100,30));
	Dimension labelYaxisSize = DataReduction.labelYaxis.getPreferredSize();
	DataReduction.labelYaxis.setBounds(IParameters.DATA_REDUCTION_PLOT_X+xoff,
			0,
			labelYaxisSize.width,
			labelYaxisSize.height);
	DataReduction.panelb.add(DataReduction.labelYaxis);

	xoff = 40;
	int yoff = 10;
	String[] linLogStrings = {"linear","log10"};
    DataReduction.linLogComboBoxY = new JComboBox(linLogStrings);
    DataReduction.linLogComboBoxY.setPreferredSize(new Dimension(100,30));
    DataReduction.linLogComboBoxY.setAlignmentX(Component.CENTER_ALIGNMENT);
    DataReduction.linLogComboBoxY.setSelectedIndex(1);
    Dimension linLogComboBoxYSize = DataReduction.linLogComboBoxY.getPreferredSize();
    DataReduction.linLogComboBoxY.setBounds(IParameters.DATA_REDUCTION_PLOT_X + xoff,
    			labelYaxisSize.height + yoff,
    			linLogComboBoxYSize.width,
    			linLogComboBoxYSize.height);
    DataReduction.panelb.add(DataReduction.linLogComboBoxY);
    
    //ymax
    yoff = 80;
    xoff = 5;
    DataReduction.maxLabel = new JLabel("max");
    DataReduction.maxLabel.setPreferredSize(new Dimension(50,30));
    Dimension maxLabelSize = DataReduction.maxLabel.getPreferredSize();
    DataReduction.maxLabel.setBounds(IParameters.DATA_REDUCTION_PLOT_X + xoff,
    		yoff,
    		maxLabelSize.width,
    		maxLabelSize.height);
    DataReduction.panelb.add(DataReduction.maxLabel);
    
    xoff = 40;
    yoff += 0;
    DataReduction.yMaxTextField = new JTextField(13);
    DataReduction.yMaxTextField.setEditable(true);
    DataReduction.yMaxTextField.setActionCommand("yMaxTextField");
    DataReduction.yMaxTextField.setPreferredSize(new Dimension(30,30));
    Dimension yMaxTextFieldSize = DataReduction.yMaxTextField.getPreferredSize();
    DataReduction.yMaxTextField.setBounds(IParameters.DATA_REDUCTION_PLOT_X + xoff,
    		yoff,
    		yMaxTextFieldSize.width,
    		yMaxTextFieldSize.height);
    DataReduction.panelb.add(DataReduction.yMaxTextField);
    
    //ymin
    yoff = 70+45;
    xoff = 5;
    DataReduction.minLabel = new JLabel("min");
    DataReduction.minLabel.setPreferredSize(new Dimension(50,30));
    Dimension minLabelSize = DataReduction.minLabel.getPreferredSize();
    DataReduction.minLabel.setBounds(IParameters.DATA_REDUCTION_PLOT_X + xoff,
    		yoff,
    		minLabelSize.width,
    		minLabelSize.height);
    DataReduction.panelb.add(DataReduction.minLabel);
    
    xoff = 40;
    yoff += 0;
    DataReduction.yMinTextField = new JTextField(13);
    DataReduction.yMinTextField.setEditable(true);
    DataReduction.yMinTextField.setActionCommand("yMinTextField");
    DataReduction.yMinTextField.setPreferredSize(new Dimension(30,30));
    Dimension yMinTextFieldSize = DataReduction.yMinTextField.getPreferredSize();
    DataReduction.yMinTextField.setBounds(IParameters.DATA_REDUCTION_PLOT_X + xoff,
    		yoff,
    		yMinTextFieldSize.width,
    		yMinTextFieldSize.height);
    DataReduction.panelb.add(DataReduction.yMinTextField);
    
    //validate button
    xoff = 5;
    yoff += 45;
    DataReduction.yValidateButton = new JButton("Validate changes");
    DataReduction.yValidateButton.setActionCommand("yValidateButton");
    DataReduction.yValidateButton.setToolTipText("Validate y axis changes");
    DataReduction.yValidateButton.setPreferredSize(new Dimension(180,30));
    Dimension yValidateButtonSize = DataReduction.yValidateButton.getPreferredSize();
    DataReduction.yValidateButton.setBounds(IParameters.DATA_REDUCTION_PLOT_X + xoff,
    		yoff,
    		yValidateButtonSize.width,
    		yValidateButtonSize.height);
    DataReduction.panelb.add(DataReduction.yValidateButton);	
    
    //reset button
    xoff = 5;
    yoff += 45;
    DataReduction.yResetButton = new JButton("Reset y-axis");
    DataReduction.yResetButton.setActionCommand("yResetButton");
    DataReduction.yResetButton.setToolTipText("Reset y axis");
    DataReduction.yResetButton.setPreferredSize(new Dimension(180,30));
    Dimension yResetButtonSize = DataReduction.yResetButton.getPreferredSize();
    DataReduction.yResetButton.setBounds(IParameters.DATA_REDUCTION_PLOT_X + xoff,
    		yoff,
    		yResetButtonSize.width,
    		yResetButtonSize.height);
    DataReduction.panelb.add(DataReduction.yResetButton);	
    
    	}
	/*
	 * Create GUI of x-axis
	 */
	static void initializeXAxisDisplay() {
		
		int xoff = 30;	
		int yoff = 10;
		DataReduction.labelXaxis = new JLabel("X-axis");
		DataReduction.labelXaxis.setFont(new Font("sansserif",Font.BOLD,15));
		DataReduction.labelXaxis.setForeground(Color.RED);
		DataReduction.labelXaxis.setPreferredSize(new Dimension(100,30));
		Dimension labelXaxisSize = DataReduction.labelXaxis.getPreferredSize();
		DataReduction.labelXaxis.setBounds(xoff,
				IParameters.DATA_REDUCTION_PLOT_Y+yoff,
				labelXaxisSize.width,
				labelXaxisSize.height);
		DataReduction.panelb.add(DataReduction.labelXaxis);
		DataReduction.labelXaxis.setVisible(false);
		
		xoff = 10;
		yoff = 45;
		String[] linLogStrings = {"linear","log10"};
		DataReduction.linLogComboBoxX = new JComboBox(linLogStrings);
	    DataReduction.linLogComboBoxX.setPreferredSize(new Dimension(100,30));
	    DataReduction.linLogComboBoxX.setAlignmentX(Component.CENTER_ALIGNMENT);
	    DataReduction.linLogComboBoxX.setSelectedIndex(0);
	    Dimension linLogComboBoxXSize = DataReduction.linLogComboBoxX.getPreferredSize();
	    DataReduction.linLogComboBoxX.setBounds(xoff,
	    			IParameters.DATA_REDUCTION_PLOT_Y + yoff,
	    			linLogComboBoxXSize.width,
	    			linLogComboBoxXSize.height);
	    DataReduction.panelb.add(DataReduction.linLogComboBoxX);
	    DataReduction.linLogComboBoxX.setVisible(false);
	    
	    //ymax
	    xoff = 135;
	    yoff = 15;
	    DataReduction.maxLabel = new JLabel("max");
	    DataReduction.maxLabel.setPreferredSize(new Dimension(50,30));
	    Dimension maxLabelSize = DataReduction.maxLabel.getPreferredSize();
	    DataReduction.maxLabel.setBounds(xoff,
	    		IParameters.DATA_REDUCTION_PLOT_Y + yoff,
	    		maxLabelSize.width,
	    		maxLabelSize.height);
	    DataReduction.panelb.add(DataReduction.maxLabel);
	    DataReduction.maxLabel.setVisible(false);
	    
	    xoff = 170;
	    yoff += 0;
	    DataReduction.xMaxTextField = new JTextField(13);
	    DataReduction.xMaxTextField.setEditable(true);
	    DataReduction.xMaxTextField.setActionCommand("xMaxTextField");
	    DataReduction.xMaxTextField.setPreferredSize(new Dimension(30,30));
	    Dimension xMaxTextFieldSize = DataReduction.xMaxTextField.getPreferredSize();
	    DataReduction.xMaxTextField.setBounds(xoff,
	    		IParameters.DATA_REDUCTION_PLOT_Y + yoff,
	    		xMaxTextFieldSize.width,
	    		xMaxTextFieldSize.height);
	    DataReduction.panelb.add(DataReduction.xMaxTextField);
	    DataReduction.xMaxTextField.setVisible(false);
	    
	    //ymin
	    xoff = 135;
	    yoff += 35;
	    DataReduction.minLabel = new JLabel("min");
	    DataReduction.minLabel.setPreferredSize(new Dimension(50,30));
	    Dimension minLabelSize = DataReduction.minLabel.getPreferredSize();
	    DataReduction.minLabel.setBounds(xoff,
	    		IParameters.DATA_REDUCTION_PLOT_Y + yoff,
	    		minLabelSize.width,
	    		minLabelSize.height);
	    DataReduction.panelb.add(DataReduction.minLabel);
	    DataReduction.minLabel.setVisible(false);
	    
	    xoff = 170;
	    yoff += 0;
	    DataReduction.xMinTextField = new JTextField(13);
	    DataReduction.xMinTextField.setEditable(true);
	    DataReduction.xMinTextField.setActionCommand("xMinTextField");
	    DataReduction.xMinTextField.setPreferredSize(new Dimension(30,30));
	    Dimension xMinTextFieldSize = DataReduction.xMinTextField.getPreferredSize();
	    DataReduction.xMinTextField.setBounds(xoff,
	    		IParameters.DATA_REDUCTION_PLOT_Y + yoff,
	    		xMinTextFieldSize.width,
	    		xMinTextFieldSize.height);
	    DataReduction.panelb.add(DataReduction.xMinTextField);
	    DataReduction.xMinTextField.setVisible(false);
	    	    
	    //validate changes
	    xoff = 350;
	    yoff = 15;
	    DataReduction.xValidateButton = new JButton("Validate changes");
	    DataReduction.xValidateButton.setActionCommand("xValidateButton");
	    DataReduction.xValidateButton.setToolTipText("Validate x axis changes");
	    DataReduction.xValidateButton.setPreferredSize(new Dimension(180,30));
	    Dimension xValidateButtonSize = DataReduction.xValidateButton.getPreferredSize();
	    DataReduction.xValidateButton.setBounds(xoff,
	    		IParameters.DATA_REDUCTION_PLOT_Y + yoff,
	    		xValidateButtonSize.width,
	    		xValidateButtonSize.height);
	    DataReduction.panelb.add(DataReduction.xValidateButton);	
	    DataReduction.xValidateButton.setVisible(false);
	    
	    //reset button
	    xoff = 350;
	    yoff += 35;
	    DataReduction.xResetButton = new JButton("Reset x-axis");
	    DataReduction.xResetButton.setActionCommand("xResetButton");
	    DataReduction.xResetButton.setToolTipText("Reset x axis");
	    DataReduction.xResetButton.setPreferredSize(new Dimension(180,30));
	    Dimension xResetButtonSize = DataReduction.xResetButton.getPreferredSize();
	    DataReduction.xResetButton.setBounds(xoff,
	    		IParameters.DATA_REDUCTION_PLOT_Y + yoff,
	    		xResetButtonSize.width,
	    		xResetButtonSize.height);
	    DataReduction.panelb.add(DataReduction.xResetButton);	
	    DataReduction.xResetButton.setVisible(false);
	}

}
	
