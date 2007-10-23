package gov.ornl.sns.itools.gui;
//import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
//import java.net.URL;
import java.lang.System;  //to get the user name
//import java.net.InetAddress;  //to get the hostname
import java.io.*; //to run IDL tools on command line

public class IdlToolsPortal implements ActionListener{

	final static int NUM_IMAGES = 9;   //number of tools
	final static int START_INDEX = 0;
	
  Boolean enableButton = false;  //default behavior of the GO button
  enum enumHostname {dev, heater, mrac, lrac, bac, bac2, unknown}
  static String DEV = "dev.ornl.gov";
  static String HEATER = "heater";
  static String LRAC = "lrac";
  static String MRAC = "mrac";
  static String BAC = "bac.sns.gov";
  static String BAC2 = "bac2";
  static String UNKNOWN = "unknown";
  
  static String PLOTBSS = "/SNS/users/j35/IDL/BSS/plotBSS";
  static String REALIGN_BSS = "/SNS/users/j35/IDL/BSS/RealignGUI/RealignBSS";
  static String REBIN_NEXUS = "/SNS/users/j35/IDL/RebinNeXus/rebinNeXus";
  static String DATA_REDUCTION = "/SNS/users/j35/IDL/DataReduction/data_reduction";
  static String REFL_SCALE = "/SNS/software/idltools/RefLScale";
  static String REF_REDUCTION = "/SNS/software/idltools/ref_reduction"; 
  static String MINI_REF_REDUCTION = "/SNS/software/idltools/mini_ref_reduction"; 
  static String TS_REBIN_GUI = "/SNS/software/idltools/TS_rebin_GUI";
  
	ImageIcon[] images = new ImageIcon[NUM_IMAGES];
	String[] info = new String[NUM_IMAGES];
	String hostname;

  //get hostname  
  enumHostname localHostname; 
    
	JPanel mainPanel, selectPanel, displayPanel, infoPanel, goPanel;
	static JButton goButton;
	
	JComboBox toolChoices = null;
	JLabel toolIconLabel = null;
	JLabel infoLabel = null;
	
	public IdlToolsPortal() {
		
		//Create the tool selection and the display panels.
		displayPanel = new JPanel();
		selectPanel = new JPanel();
		infoPanel = new JPanel();
		goPanel = new JPanel();
    
    try {
      java.net.InetAddress localMachine = java.net.InetAddress.getLocalHost();
      hostname = localMachine.getHostName();
    } 
    catch (java.net.UnknownHostException uhe)
    {
     //handle exception
      hostname = "unknown";
    }
        
    //Add various widgets tot he sub panels;
		addWidgets();
		
		//Create the main panel to contain the two sub panels
		mainPanel = new JPanel();
		mainPanel.setLayout(new BoxLayout(mainPanel, BoxLayout.PAGE_AXIS));
		mainPanel.setBorder(BorderFactory.createEmptyBorder(5,5,5,5));
		
		//Add the select and display panels to the main panel
		mainPanel.add(selectPanel);
		mainPanel.add(displayPanel);
		mainPanel.add(infoPanel);
		mainPanel.add(goPanel);
    
  }
	
	/*
	 * Get the images and set up the widgets
	 */
	private void addWidgets() {
		
		//Get the images and put them into an array of ImageIcons.
		images[0] = createImageIcon("/gov/ornl/sns/itools/images/plotBSS.gif");
		images[1] = createImageIcon("/gov/ornl/sns/itools/images/RealignBSS.gif");
		images[2] = createImageIcon("/gov/ornl/sns/itools/images/rebinNeXus.gif");
		images[3] = createImageIcon("/gov/ornl/sns/itools/images/DataReduction_M.gif");
		images[4] = createImageIcon("/gov/ornl/sns/itools/images/under_construction.gif");
    images[5] = createImageIcon("/gov/ornl/sns/itools/images/RefLScale.gif");
    images[6] = createImageIcon("/gov/ornl/sns/itools/images/REFreduction.gif");
    images[7] = createImageIcon("/gov/ornl/sns/itools/images/miniREFreduction.gif");
    images[8] = createImageIcon("/gov/ornl/sns/itools/images/TS_rebin_batch.gif");
		
		//Define the help text that goes with each tool
		//plotBSS
		info[0] = "<html>This program plots data for the Backscattering instrument. It is also<br>" +
				"possible to display the range of time bins desired</html>";
		//RealignBSS
		info[1] = "<html>Program used to realign the pixelID of the Backscattering instrument.<br>" +
				"A NeXus file is then produced based on the new position of these pixels</html>";
		//rebinNeXus
		info[2] = "<html>Program used to visualize the data of any NeXus file. It can also be used<br>" +
				"to rebin the data (when running in event mode) and create a local NeXus file</html>";
		//DataReduction
		info[3] = "<html>Program that performs some basic data_reduction for the two reflectometers</html>";
		//moreNeXus
		info[4] = "<html>Program that gives information about a particular run_number and can output the<br>" +
				"various data it contains</html>";
    //RefLScale
    info[5] = "<html>This program rescale a set of files produced by the <b>REF_L data reduction<br>" +
        "program</b>.</html>";
    //REFreduction
    info[6] = "<html>This is the new DataReduction GUI.... better, stronger, <br>" +
      "more beautiful............ just for your pleasure.</html>";
    //miniREFreduction
    info[7] = "<html>This is the mini version of the new DataReduction GUI (REFreduction).</html>";
    //TS_rebin_batch
    info[8] = "<html>This programs rebin a set of run numbers.</html>";
      
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
		String[] tools = {
        "plotBSS",
        "RealignBSS",
        "rebinNeXus",
        "DataReduction",
				"more_NeXus",
        "ReflScale",
        "REFreduction (high resolution mode)",
        "REFreduction (low resolution mode)",
        "TS_rebin_gui"};
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
    goButton.setEnabled(false);
    
		// add a border around the go Panel
		goPanel.setBorder(BorderFactory.createCompoundBorder(
				BorderFactory.createTitledBorder("GO"),
				BorderFactory.createEmptyBorder(5,5,5,5)));
		
		infoLabel = new JLabel(info[0],JLabel.CENTER);
		
		// Add idl tools combo box to select panel and image label
		displayPanel.add(toolIconLabel);
		selectPanel.add(toolChoices);
		goPanel.add(goButton);
		infoPanel.add(infoLabel);
		
		// Listen to events from the combo box
		toolChoices.addActionListener(this);
		goButton.addActionListener(this);
    setGoButton();
	}
	
	public void actionPerformed(ActionEvent event) {
		if ("comboBoxChanged".equals(event.getActionCommand())) {
			// Update the icon to display the new IDL tool
			toolIconLabel.setIcon(images[toolChoices.getSelectedIndex()]);
			infoLabel.setText(info[toolChoices.getSelectedIndex()]);
      setGoButton();
    }
		if ("go".equals(event.getActionCommand())){

		  Process p;
      try {
      
        switch (toolChoices.getSelectedIndex()) {
         case 0: // plotBSS
           p = (Runtime.getRuntime()).exec(PLOTBSS);
           System.exit(0);  
           break;
         case 1: //RealignBSS
           p = (Runtime.getRuntime()).exec(REALIGN_BSS);
           System.exit(0);
           break;
         case 2: //rebinNeXus
           p = (Runtime.getRuntime()).exec(REBIN_NEXUS);
           System.exit(0);
           break;
         case 3: //DataReduction
           p = (Runtime.getRuntime()).exec(DATA_REDUCTION);
           System.exit(0);
           break;
         case 4: //under_construction
           break;
         case 5: //RefLSupport
           p = (Runtime.getRuntime()).exec(REFL_SCALE);
           System.exit(0);
         case 6: //REFreduction
           p = (Runtime.getRuntime()).exec(REF_REDUCTION);
           System.exit(0);
         case 7: //miniREFreduction
           p = (Runtime.getRuntime()).exec(MINI_REF_REDUCTION);
           System.exit(0);
         case 8: //TS_rebin_gui
           p = (Runtime.getRuntime()).exec(TS_REBIN_GUI);
           System.exit(0);
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
    } else if (hostname.compareTo(BAC2) == 0) {
      localHostname = enumHostname.bac2;
    } else {
      localHostname = enumHostname.unknown;
    }
        
    switch (toolChoices.getSelectedIndex()) {
      case 0: //plotBSS
        switch (localHostname) {
        case bac2:
        case bac: enableButton = true; break;
        default: enableButton = false; break;
        };
        break;
      case 1: //RealignBSS
        switch (localHostname) {
        case bac2:
        case bac: enableButton = true; break;
        default: enableButton = false; break;
        };
        break;
      case 2: //rebinNeXus
        switch (localHostname) {
        case lrac:
        case mrac:
        case heater:
        case bac2:
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
        };
        break;
      case 5: //RefLScale
        switch (localHostname) {
        case lrac:  
        case mrac:  
        case heater: enableButton = true; break;
        default: enableButton = false; break;
        };
        break;
      case 6: //REFreduction
        switch (localHostname) {
        case lrac:
        case mrac:enableButton = true; break;
        default: enableButton = false; break;
        };
      case 7: //miniREFreduction
        switch (localHostname) {
        case lrac:
        case mrac:enableButton = true; break;
        default: enableButton = false; break;
        };
        break;
      case 8: //TS_rebin_gui
        switch (localHostname) {
        default:enableButton = true; break;
        };
        break;
      
    } 
    goButton.setEnabled(enableButton);
  }
  
  
	/** Returns an ImageIcon, or null if the path was invalid. */
	protected static ImageIcon createImageIcon(String path) {
		java.net.URL imageURL = IdlToolsPortal.class.getResource(path);
		
		if (imageURL == null) {
			System.err.println("Resource not found: "
					+ path);
			return null;
		} else {
			return new ImageIcon(imageURL);
		}
	}
	
	/**
	 * Create the GUI and show it. 
	 */
	private static void createAndShowGUI() {
		//make sure we have a nice window decorations.
		JFrame.setDefaultLookAndFeelDecorated(true);
		
		//Create a new instance of idlToolsPortal
		IdlToolsPortal portal = new IdlToolsPortal();
		
		//Create and set up the window.
		JFrame portalFrame = new JFrame("SNS IDL tools");
		portalFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		portalFrame.setContentPane(portal.mainPanel);
		
		//Set the default button
		portalFrame.getRootPane().setDefaultButton(goButton);
		
		//Display the window
		portalFrame.pack();
		portalFrame.setVisible(true);
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		//Schedule a jobn for the event dispatching threads:
		//creating and showing this application's GUI.
		javax.swing.SwingUtilities.invokeLater(new Runnable() {
			public void run()  {
				createAndShowGUI();
				}
		});
    
	// give user name	
  // System.out.println("user name is: " + System.getProperty("user.name"));
	
  }
}
