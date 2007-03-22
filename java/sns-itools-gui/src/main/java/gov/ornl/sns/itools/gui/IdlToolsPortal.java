package gov.ornl.sns.itools.gui;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import java.net.URL;
import java.lang.System;  //to get the user name
import java.net.InetAddress;  //to get the hostname

public class IdlToolsPortal implements ActionListener{

	final static int NUM_IMAGES = 5;
	final static int START_INDEX = 0;
	
  Boolean enableButton = false;  //default behavior of the GO button
  enum enumHostname { dev, heater, mrac, lrac, bac, unknown}
  static String DEV = "dev.ornl.gov";
  static String HEATER = "heater.ornl.gov";
  static String LRAC = "lrac.sns.gov";
  static String MRAC = "mrac.sns.gov";
  static String BAC = "bac.sns.gov";
  static String UNKNOWN = "unknown";
  
	ImageIcon[] images = new ImageIcon[NUM_IMAGES];
	String[] info = new String[NUM_IMAGES];
	String hostname;

  //get hostname  
  enumHostname localHostname; 
    
	JPanel mainPanel, selectPanel, displayPanel, infoPanel, goPanel;
	JButton goButton;
	
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
	}
	
	public void actionPerformed(ActionEvent event) {
		if ("comboBoxChanged".equals(event.getActionCommand())) {
			// Update the icon to display the new IDL tool
			toolIconLabel.setIcon(images[toolChoices.getSelectedIndex()]);
			infoLabel.setText(info[toolChoices.getSelectedIndex()]);
      
      System.out.println("host is:" + hostname);
      
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
        case 0:
          switch (localHostname) {
          case bac: enableButton = true; break;
          default: enableButton = false; break;
          };
          break;
        case 1:
          switch (localHostname) {
          case bac: enableButton = true; break;
          default: enableButton = false; break;
          };
          break;
        case 2:
          switch (localHostname) {
          case lrac:
          case mrac:
          case heater:
          case bac: enableButton = true; break;
          default: enableButton = false; break;
          };
          break;
        case 3: 
          switch (localHostname) {
          case lrac:
          case mrac:
          case heater: enableButton = true; break;
          default: enableButton = false; break;
          };
          break;
        case 4:
          switch (localHostname) {
          case dev: enableButton = true; break;   //REMOVE_ME
          default: enableButton = false; break;
          }
      }
      goButton.setEnabled(enableButton);
      System.out.println("enableButton is: " + enableButton);
		}
		if ("go".equals(event.getActionCommand())){
			System.out.printf("I'm here with i=%d",toolChoices.getSelectedIndex());
		}
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
		//make sure w33e have a nice window decorations.
		JFrame.setDefaultLookAndFeelDecorated(true);
		
		//Create a new instance of idlToolsPortal
		IdlToolsPortal portal = new IdlToolsPortal();
		
		//Create and set up the window.
		JFrame portalFrame = new JFrame("SNS IDL tools");
		portalFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		portalFrame.setContentPane(portal.mainPanel);
		
		//Set the default button
		//portalFrame.getRootPane().setDefaultButton(goButton);
		
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
