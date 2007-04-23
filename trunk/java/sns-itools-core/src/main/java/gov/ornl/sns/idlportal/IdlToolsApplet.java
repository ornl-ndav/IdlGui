import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import java.net.URL;
import java.lang.System;  //to get the user name
import java.net.InetAddress;  //to get the hostname
import java.applet.Applet;
import java.io.*;

public class IdlToolsApplet extends Applet implements ActionListener{

    final static int NUM_IMAGES = 5;
    final static int START_INDEX = 0;
    
    Boolean enableButton = false; // default behavior of the GO button
    enum enumHostname { dev, heater, mrac, lrac, bac, unknown }
    //get hostname
    enumHostname localHostname;

    static String DEV = "dev.ornl.gov";
    static String HEATER = "heater";
    static String LRAC = "lrac";
    static String MRAC = "mrac";
    static String BAC = "bac.sns.gov";
    static String UNKNOWN = "unknown";
    
    static String PLOTBSS = "/SNS/users/j35/IDL/BSS/plotBSS";
    static String REALIGN_BSS = "/SNS/users/j35/IDL/BSS/RealignGUI/RealignBSS";
    static String REBIN_NEXUS = "/SNS/users/j35/IDL/RebinNeXus/rebinNeXus";
    static String DATA_REDUCTION = "/SNS/users/j35/IDL/DataReduction/data_reduction";

    ImageIcon[] images = new ImageIcon[NUM_IMAGES];
    String[] info = new String[NUM_IMAGES];
    
    JPanel selectPanel, displayPanel, infoPanel, goPanel;
    JButton goButton;
    
    JComboBox toolChoices = null;
    JLabel toolIconLabel = null;
    JLabel infoLabel = null;
    String hostname;

    public void init() {
		
	//System.out.println("user name is: " + System.getProperty("user.name"));
	
	try {
	    java.net.InetAddress localMachine = java.net.InetAddress.getLocalHost();
	    //  System.out.println("hostname is: " + localMachine.getHostName());
	}
	catch (java.net.UnknownHostException uhe)
	    {
		//handle exception
	    }
	
	hostname = "heater";

	//Create the tool selection and the display panels.
	displayPanel = new JPanel();
	selectPanel = new JPanel();
	infoPanel = new JPanel();
	goPanel = new JPanel();

	//Add various widgets tot he sub panels;
	addWidgets();
	
	//Create the main panel to contain the two sub panels
	//		setLayout(new BoxLayout.PAGE_AXIS);
	setLayout(new BoxLayout(this,BoxLayout.Y_AXIS));
	setBackground(Color.white);
	//setBorder(BorderFactory.createEmptyBorder(5,5,5,5));
	
	//Add the select and display panels to the main panel
	add(selectPanel);
	add(displayPanel);
	add(infoPanel);
	add(goPanel);
	
    }
    
    public void start() {
	System.out.println("Applet starting.");
    }
    
    public void stop() {
	System.out.println("Applet stopping.");
    }
    
    public void destroy() {
	System.out.println("Destroy method called.");
    }
    
    
    /*
     * Get the images and set up the widgets
     */
    public void addWidgets() {
	
	//Get the images and put them into an array of ImageIcons.
	images[0] = createImageIcon("plotBSS.gif");
	images[1] = createImageIcon("RealignBSS.gif");
	images[2] = createImageIcon("rebinNeXus.gif");
	images[3] = createImageIcon("DataReduction_M.gif");
	images[4] = createImageIcon("under_construction.gif");
	
	//Define the help text that goes with each tool
	//plotBSS
	info[0] = "<html><pre>This program plots data for the Backscattering instrument." +
	    "<br>It is also " +
	    "possible to display the range of time bins <br>desired</pre></html>";
	//RealignBSS
	info[1] = "<html><pre>Program used to realign the pixelID of the Backscattering <br>" +
	    "instrument. A NeXus file is then produced based on the new <br>" +
	    "position of these pixels</pre></html>";
	//rebinNeXus
	info[2] = "<html><pre>Program used to visualize the data of any NeXus file. <br>" +
	    "It can also be used to rebin the data (when running in <br>" +
	    " event mode) and create a local NeXus file</pre></html>";
	//DataReduction
	info[3] = "<html><pre>Program that performs some basic data_reduction for the <br>" +
	    "two reflectometers</pre></html>";
	//moreNeXus
	info[4] = "<html><pre>Program that gives information about a particular <br>" +
	    "run_number and can output the various data it contains.</pre></html>";
	
	/* 
	 * Create a label for displaying the tools preview and put
	 * a border around it
	 */
	toolIconLabel = new JLabel();
	toolIconLabel.setHorizontalAlignment(JLabel.CENTER);
	toolIconLabel.setVerticalAlignment(JLabel.CENTER);
	toolIconLabel.setVerticalTextPosition(JLabel.CENTER);
	toolIconLabel.setHorizontalTextPosition(JLabel.CENTER);
	toolIconLabel.setBorder(BorderFactory.createCompoundBorder(
								   BorderFactory.createLoweredBevelBorder(),
								   BorderFactory.createEmptyBorder(5, 5, 5, 5)));
	
	toolIconLabel.setBorder(BorderFactory.createCompoundBorder(
								   BorderFactory.createEmptyBorder(0, 0, 5, 0),
								   toolIconLabel.getBorder()));
	
	// Create a combobox with IDL tools choices
	String[] tools = {"plotBSS","RealignBSS","rebinNeXus","DataReduction",
			  "more_NeXus"};
	toolChoices = new JComboBox(tools);
	toolChoices.setSelectedIndex(START_INDEX);
	
	// Display the first image
	toolIconLabel.setIcon(images[START_INDEX]);
	toolIconLabel.setText("");
	
	// Add a border around the selected panel
	selectPanel.setBorder(BorderFactory.createCompoundBorder(
								 BorderFactory.createTitledBorder("IDL tool"),
								 BorderFactory.createEmptyBorder(5, 5, 5, 5)));
	
	// Add a border around the display panel
	displayPanel.setBorder(BorderFactory.createCompoundBorder(
								  BorderFactory.createTitledBorder("Preview of tool selected"),
								  BorderFactory.createEmptyBorder(5,5,5,5)));
	
	// Add a border around the info display Panel
	infoPanel.setBorder(BorderFactory.createCompoundBorder(
							       BorderFactory.createTitledBorder("Infos about tool selected"),
							       BorderFactory.createEmptyBorder(5,5,5,5)));
	
	//Button to validate tool selected
	goButton = new JButton("LAUNCH TOOL SELECTED");
	goButton.setActionCommand("go");
	
	// add a border around the go Panel
	goPanel.setBorder(BorderFactory.createCompoundBorder(
							     BorderFactory.createTitledBorder("GO"),
							     BorderFactory.createEmptyBorder(5,5,5,5)));
	
	infoLabel = new JLabel(info[0],JLabel.CENTER);
	infoLabel.setVerticalTextPosition(JLabel.CENTER);
	
	
	// Add idl tools combo box to select panel and image label
	displayPanel.add(toolIconLabel);
	selectPanel.add(toolChoices);
	goPanel.add(goButton);
	infoPanel.add(infoLabel);
	
	// Listen to events from the combo box
	toolChoices.addActionListener(this);
	goButton.addActionListener(this);
    }
    
    public void actionPerformed(ActionEvent event) {
	if ("comboBoxChanged".equals(event.getActionCommand())) {
	    // Update the icon to display the new IDL tool
	    toolIconLabel.setIcon(images[toolChoices.getSelectedIndex()]);
	    infoLabel.setText(info[toolChoices.getSelectedIndex()]);
	}
	if ("go".equals(event.getActionCommand())){
	    Process p;
	    try {
		
		switch (toolChoices.getSelectedIndex()) {
		case 0: // plotBSS
		    p = (Runtime.getRuntime()).exec(PLOTBSS);
		    //System.exit(0);  
		    break;
		case 1: //RealignBSS
		    p = (Runtime.getRuntime()).exec(REALIGN_BSS);
		    //System.exit(0);
		    break;
		case 2: //rebinNeXus
		    p = (Runtime.getRuntime()).exec(REBIN_NEXUS);
		    //System.exit(0);
		    break;
		case 3: //DataReduction
		    p = (Runtime.getRuntime()).exec(DATA_REDUCTION);
		    //System.exit(0);
		    break;
		case 4: //under_construction
		default: break;
		}
	    }
	    catch (IOException e)
		{
		    System.out.println(e.getMessage());
		}
	}
    }
    
    /** Check if tools is available on computer and enable or not
     * go button accordingly to result
     */
    public void setGoButton() {
	
	if (hostname.compareTo(DEV) == 0) {
	    localHostname = enumHostname.dev;
	} else if (hostname.compareTo(HEATER) == 0) {
	    localHostname = enumHostname.heater;
	} else if (hostname.compareTo(MRAC) == 0) {
	    localHostname = enumHostname.mrac;
	} else if (hostname.compareTo(LRAC) == 0) {
	    localHostname = enumHostname.lrac;
	} else if (hostname.compareTo(BAC) == 0) {
	    localHostname = enumHostname.bac;
	} else {
	    localHostname = enumHostname.unknown;
	}
        
	switch (toolChoices.getSelectedIndex()) {
	case 0: //plotBSS
	    switch (localHostname) {
	    case bac: enableButton = true; break;
	    default: enableButton = false; break;
	    };
	    break;
	case 1: //RealignBSS
	    switch (localHostname) {
	    case bac: enableButton = true; break;
	    default: enableButton = false; break;
	    };
	    break;
	case 2: //rebinNeXus
	    switch (localHostname) {
	    case lrac:
	    case mrac:
	    case heater:
	    case bac: enableButton = true; break;
	    default: enableButton = false; break;
	    };
	    break;
	case 3: //DataReduction
	    switch (localHostname) {
	    case lrac:
	    case mrac:
	    case heater: enableButton = true; break;
	    default: enableButton = false; break;
	    };
	    break;
	case 4: //under_construction
	    switch (localHostname) {
	    case dev: enableButton = true; break;
	    default: enableButton = false; break;
	    }
	}
	goButton.setEnabled(enableButton);
    }
    

    /** Returns an ImageIcon, or null if the path was invalid. */
    protected static ImageIcon createImageIcon(String path) {
	java.net.URL imageURL = IdlToolsApplet.class.getResource(path);
	
	if (imageURL == null) {
	    System.err.println("Resource not found: "
			       + path);
	    return null;
	} else {
	    return new ImageIcon(imageURL);
	}
    }
    
}
