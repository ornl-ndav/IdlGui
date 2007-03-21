package gov.ornl.sns.itools.gui;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import java.net.URL;

public class idlToolsPortal implements ActionListener{

	final static int NUM_IMAGES = 5;
	final static int START_INDEX = 0;
	
	ImageIcon[] images = new ImageIcon[NUM_IMAGES];
	JPanel mainPanel, selectPanel, displayPanel;
	
	JComboBox toolChoices = null;
	JLabel toolIconLabel = null;
	
	public idlToolsPortal() {
		
		//Create the tool selection and the display panels.
		selectPanel = new JPanel();
		displayPanel = new JPanel();
		
		//Add various widgets tot he sub panels;
		addWidgets();
		
		//Create the main panel to contain the two sub panels
		mainPanel = new JPanel();
		mainPanel.setLayout(new BoxLayout(mainPanel, BoxLayout.PAGE_AXIS));
		mainPanel.setBorder(BorderFactory.createEmptyBorder(5,5,5,5));
		
		//Add the select and display panels to the main panel
		mainPanel.add(selectPanel);
		mainPanel.add(displayPanel);
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
				BorderFactory.createEmptyBorder(0, 0, 10, 0),
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
				BorderFactory.createTitledBorder("Select IDL tool"),
				BorderFactory.createEmptyBorder(5, 5, 5, 5)));
		
		// Add a border around the display panel
		displayPanel.setBorder(BorderFactory.createCompoundBorder(
				BorderFactory.createTitledBorder("Preview of tool selected"),
				BorderFactory.createEmptyBorder(5,5,5,5)));
		
		// Add idl tools combo box to select panel and image label
		displayPanel.add(toolIconLabel);
		selectPanel.add(toolIconLabel);
		
		// Listen to events from the combo box
		toolChoices.addActionListener(this);
	}
	
	public void actionPerformed(ActionEvent event) {
		if ("comboBoxChanged".equals(event.getActionCommand())) {
			// Update the icon to display the new IDL tool
			toolIconLabel.setIcon(images[toolChoices.getSelectedIndex()]);
		}
	}
	
	/** Returns an ImageIcon, or null if the path was invalid. */
	protected static ImageIcon createImageIcon(String path) {
		java.net.URL imageURL = idlToolsPortal.class.getResource(path);
		
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
		idlToolsPortal portal = new idlToolsPortal();
		
		//Create and set up the window.
		JFrame portalFrame = new JFrame("SNS IDL tools");
		portalFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		portalFrame.setContentPane(portal.mainPanel);
		
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
	}
}
