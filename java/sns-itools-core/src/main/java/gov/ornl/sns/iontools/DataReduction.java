//
// DataReduction.java
//

/*******************************************************************
 Copyright (c) 1997-2005, Research Systems, Inc.  All rights reserved.
 Unauthorized reproduction prohibited.

 (Of course, because these are examples, feel free to remove these 
 lines and modify to suit your needs.)
********************************************************************/

import java.awt.*;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.event.*;
import java.applet.*;
import java.io.*;
import java.net.*;
import java.util.Arrays;
import com.rsi.ion.*;
import javax.swing.*;


public class DataReduction extends JApplet implements IONDisconnectListener, 
						IONOutputListener, 
						ActionListener,
						IONMouseListener
{
    // Instance Vars
    String          ucams = "j35";

    IONGrConnection c_ionCon;
    IONGrDrawable   c_plot;
    Dimension       c_dimApp;
    int             c_bConnected=0; // 0 => !conn, 1 => conn, -1 => conn failed
    String          runNumberValue;
    String          instrument;
    String[]        instrumentStrings = {"REF_L", "REF_M"};
    String          text;
    String          cmd; 
    JLabel	    runNumberLabel;	
    JTextField      runNumber;
    JTextArea       generalInfoTextArea;

    //def of components of data reduction tab
    JPanel          topPanel;
    JPanel          plotPanel;
    JPanel          leftPanel;
    JPanel          plotDataReductionPanel;
    //    JPanel          dataReductionPanel;
    JPanel          panela; //input tab
    JPanel          panel1; //selection
    JPanel          panel2; //log book
    JPanel          panelb; //Extra plots
    JTabbedPane     tabbedPane;
    JTabbedPane     dataReductionTabbedPane;

    JLabel          blank1Label;
    JLabel          blank2Label;
    JLabel          blank3Label;
    
    //def of components of input tab

    JPanel          buttonSignalBackgroundPanel;
    JPanel          textFieldSignalBackgroundPanel;
    JPanel          signalBackgroundPanel;

    //signal and back pid
    JPanel          signalPidPanel;
    JTextField      signalPidFileTextField;
    JButton         signalPidFileButton;
    JPanel          backgroundPidPanel;
    JTextField      backgroundPidFileTextField;    
    JButton         backgroundPidFileButton;
    //normalization
    JPanel          normalizationPanel;
    JLabel          normalizationLabel;
    ButtonGroup     normalizationButtonGroup;
    JRadioButton    yesNormalizationRadioButton;
    JRadioButton    noNormalizationRadioButton;
    JPanel          normalizationTextBoxPanel;
    JLabel          normalizationTextBoxLabel;
    JTextField      normalizationTextField;
    //background
    JPanel          backgroundPanel;
    JLabel          backgroundLabel;
    ButtonGroup     backgroundButtonGroup;
    JRadioButton    yesBackgroundRadioButton;
    JRadioButton    noBackgroundRadioButton;
    //norm. background
    JPanel          normBackgroundPanel;
    JLabel          normBackgroundLabel;
    ButtonGroup     normBackgroundButtonGroup;
    JRadioButton    yesNormBackgroundRadioButton;
    JRadioButton    noNormBackgroundRadioButton;
    //tab of runs
    JTabbedPane     runsTabbedPane;
    JPanel          runsAddPanel;
    JLabel          runsAddLabel;
    JTextField      runsAddTextField;
    JPanel          runsSequencePanel;
    JLabel          runsSequenceLabel;
    JTextField      runsSequenceTextField;

    //tab of selection
    JTabbedPane     selectionTab;
    JPanel          signalSelectionPanel;
    JPanel          back1SelectionPanel;
    JPanel          back2SelectionPanel;
    JTextArea       signalSelectionTextArea;
    JTextArea       back1SelectionTextArea;
    JTextArea       back2SelectionTextArea;

    //tab of Log Book
    JTextArea       textAreaLogBook;
    
    //intermediate file output
    JPanel          intermediatePanel;
    JLabel          intermediateLabel;
    ButtonGroup     intermediateButtonGroup;
    JRadioButton    yesIntermediateRadioButton;
    JRadioButton    noIntermediateRadioButton;
    JButton         intermediateButton;

    //combine spectrum
    JPanel          combineSpectrumPanel;
    JLabel          combineSpectrumLabel;
    ButtonGroup     combineSpectrumButtonGroup;
    JRadioButton    yesCombineSpectrumRadioButton;
    JRadioButton    noCombineSpectrumRadioButton;

    //instrument geometry file
    JPanel          instrumentGeometryPanel;
    JLabel          instrumentGeometryLabel;
    JRadioButton    yesInstrumentGeometryRadioButton;
    JRadioButton    noInstrumentGeometryRadioButton;
    ButtonGroup     instrumentGeometryButtonGroup;
    JButton         instrumentGeometryButton;
    JTextField      instrumentGeometryTextField;

    //start data reduction
    JPanel          startDataReductionPanel;
    JButton         startDataReductionButton;

    JComboBox       instrList;
    IONVariable     instr;
    IONVariable     user;
    
    int             x_min;
    int             x_max;
    int             y_min;
    int             y_max;

    IONVariable     a_idl;
    IONCallableClient runFound;   //1 if a run has been found, 0 otherwise

    int	            c_xval1=0;	  // initial x for rubber band box
    int		    c_yval1=0;	  // initial y for rubber band box
    int		    c_xval2=0;	  // final x for rubber band box
    int		    c_yval2=0;	  // final y for rubber band box
    int		    c_x1=0;		  // initial x java
    int		    c_y1=0;		  // initial y java
    int		    c_x2=0;		  // final x java
    int		    c_y2=0;		  // final y java
    int             a=0;
    
    int             Nx = 256;
    int             Ny = 304;
    int             Ny_min = 0;
    int             Ny_max = (303-255);
    
    String          hostname;

    //menu
    JMenuBar        menuBar;
    JMenu           modeMenu;
    ButtonGroup     modeButtonGroup;
    JRadioButtonMenuItem selectModeMenuItem;
    JRadioButtonMenuItem infoModeMenuItem;
	
// ******************************
// Init Method
// ******************************
  
  public void init(){

      /*
      Container contentPane = getContentPane();
      contentPane.setLayout(new FlowLayout(FlowLayout.LEADING));
      
      contentPane.add(plotDataReductionPanel);
      */

      // Create connection and drawable objects
      c_ionCon   = new IONGrConnection();
      c_dimApp = getSize();
      buildGUI();	
      runNumber.requestFocusInWindow();

      connectToServer();

      //retrieve hostname
      //      System.out.println("user name is: " + System.getProperty("user.name"));
      
      try {
	  java.net.InetAddress localMachine = java.net.InetAddress.getLocalHost();
	  hostname = localMachine.getHostName();
	  //System.out.println("hostname is: " + localMachine.getHostName());
      }
      catch (java.net.UnknownHostException uhe)
	  {
	      //handle exception
	  }
      



  }
 /*
 *************************************************
 * Inorder to display status messages at startup and also 
 * to be able to disconnect when the page is not being viewed
 * we override the Applets start() and stop() methods
 *************************************************
 * start()
 *
 * Purpose:
 *   Overide the applet's start method.
 *   Connect to ION if not already connected.
 *
 *   Note: in pre-ION1.4 releases, this method called repaint.  repaint
 *   then would call our paint method (now deleted from this file).  The
 *   paint method was responsible for connecting.  However, in some cases
 *   our paint method would not be called and the applet would not get its
 *   data from the server.  
 *   We are now guaranteed that we will connect to the IONJ server because
 *   start() will always be called when the applet starts.
 */
  public void start(){ 
    if(c_bConnected == 0)  // Not connected to ION, do so.
      connectToServer();
    System.out.println("Connected");
  }
/*
 *************************************************
 * stop()
 *
 * Purpose:
 *   Override the applet's stop method. This method
 *   Is called when the page is not being viewed. We
 *   disconnect from the server when this is the case.
 */
  public void stop(){
    writeMessage("Page exited.");
	c_ionCon.removeIONDisconnectListener(this);
    if(c_bConnected == 1){
      c_ionCon.disconnect();
      c_bConnected=0;
    }
  }
/*
 ************************************************
 * connectToServer()
 *
 * Purpose:
 *  Connects to the ION server, providing feedback to user
 */
  private void connectToServer(){

  // Write Status message
     writeMessage("Connecting to ION Java Server...");

  // Connect to the server
     try { 
	 c_ionCon.connect(this.getCodeBase().getHost()); 
     } catch(UnknownHostException eUn) {
         System.err.println("Error: Unknown Host.") ;
         writeMessage("Error:Unknown Host.");
         c_bConnected = -1;
         return;
     } catch(IOException eIO) {
         System.err.println("Error: Establishing Connection. ION Java Server Down?");
         writeMessage("Error: Establishing Connection. ION Java Server Down?");
         c_bConnected = -1;
         return;
     } catch(IONLicenseException eLic){
         System.err.println("Error: ION Java License Unavailable.") ;
         writeMessage("Error: ION Java License Unavailable.");
         c_bConnected = -1;
         return;
     }
    c_bConnected = 1;
    writeMessage("Connected.");

 // Add the disconnect listener
    c_ionCon.addIONDisconnectListener(this);
    c_ionCon.addIONOutputListener(this);

    // Since we are only working with 8 bit, set decompose
    c_ionCon.setDecomposed(false);

    // disable the debug mode (shift-click on image)
    c_ionCon.debugMode(false);

    // add mouse listener
    c_plot.addIONMouseListener(this, IONMouseListener.ION_MOUSE_DOWN);

    // Add the drawables to the connection
    c_ionCon.addDrawable(c_plot);
  }

/*
 *******************************************
 * Mouse Listener Implementation
 */
  public void mousePressed(com.rsi.ion.IONDrawable drawable, int X, int Y, 
                    long when, int mask)
  {
      if (X < 0) {X = 0;};
      if (Y < Ny_min*2) {Y = Ny_min*2;};
      if (X > Nx*2) {X = 2*Nx-1;};
      if (Y > 2*Ny_max) {Y = 2*Ny-1;};
      
      c_x1= X;
      c_y1= Y;
      
      c_xval1 = (int) X / 2;
      c_yval1 = (int) (607-Y)/2;

      c_plot.addIONMouseListener(this, com.rsi.ion.IONMouseListener.ION_MOUSE_ANY);
      
      return;
  }
    
    public void mouseMoved(com.rsi.ion.IONDrawable drawable, int X, int Y, 
			   long when, int mask)
    {
	if (X < 0) {X = 0;};
	if (Y < 2*Ny_min) {Y = 2*Ny_min;};
	if (X > 2*Nx) {X = 2*Nx-1;};
	if (Y > 2*Ny_max) {Y = 2*Ny-1;};
	
	c_x2= X;
	c_y2= Y;
	
	c_xval2 = (int) X/2;
	c_yval2 = (int) (607-Y)/2;
	doBox();

	c_plot.addIONMouseListener(this, com.rsi.ion.IONMouseListener.ION_MOUSE_ANY);
	
	return;
    }
    
    public void mouseReleased(com.rsi.ion.IONDrawable drawable, int X, int Y, 
			      long when, int mask)
    { 
	int [] someArray = new int [2];
	
	//sort array
	//x
	someArray[0] = c_xval1;
	someArray[1] = c_xval2;
	Arrays.sort(someArray);
	x_min = someArray[0];
	x_max = someArray[1];
	
	//y
	someArray[0] = c_yval1;
	someArray[1] = c_yval2;
	Arrays.sort(someArray);
	y_min = someArray[0];
	y_max = someArray[1];
	
	// output values into textbox
	text = "x_min: " + x_min + "\ty_min: " + y_min + "\n";
	generalInfoTextArea.setText(text);
	text = "x_max: " + x_max + "\ty_max: " + y_max + "\n";
	generalInfoTextArea.append(text);
	
	doBox();
	c_plot.addIONMouseListener(this, com.rsi.ion.IONMouseListener.ION_MOUSE_DOWN);
	return;
    }
    
/*
***************************************
 *  actionPerformed()
 *
 * Purpose:
 *  Handles GUI events for displaying.
 */      
	public void actionPerformed(ActionEvent evt){

	    if ("signalPidFileButton".equals(evt.getActionCommand())) {
		System.out.println("I just pressed signalPidFileButton");
	    }

	    if ("signalPidFileTextField".equals(evt.getActionCommand())) {

	    }

	    if ("backgroundPidFileButton".equals(evt.getActionCommand())) {
		System.out.println("I just pressed backgroundpidFileButton");
	    }

	    if ("backgroundPidFileTextField".equals(evt.getActionCommand())) {
	    }

	    if ("yesNormalization".equals(evt.getActionCommand())) {
		normalizationTextField.setEnabled(true);
		normalizationTextBoxLabel.setEnabled(true);
	    }

	    if ("noNormalization".equals(evt.getActionCommand())) {
		normalizationTextField.setEnabled(false);
		normalizationTextBoxLabel.setEnabled(false);
	    }
	    
	    if ("normalizationTextField".equals(evt.getActionCommand())) {
	    }

	    if ("yesBackground".equals(evt.getActionCommand())) {
	    }

	    if ("noBackground".equals(evt.getActionCommand())) {
	    }

	    if ("yesNormBackground".equals(evt.getActionCommand())) {
		System.out.println("I just pressed yes in yesNormBackground");
	    }

	    if ("noNormBackground".equals(evt.getActionCommand())) {
		System.out.println("I just pressed no in noNormBackground");
	    }

	    if ("runsAddTextField".equals(evt.getActionCommand())) {
		System.out.println("I just pressed enter in runsAddTextField");
	    }

	    if ("runsSequenceTextField".equals(evt.getActionCommand())) {
		System.out.println("I just pressed enter in runsSequenceTextField");
	    }

	    if ("yesIntermediate".equals(evt.getActionCommand())) {
		intermediateButton.setEnabled(true);
	    }

	    if ("noIntermediate".equals(evt.getActionCommand())) {
		intermediateButton.setEnabled(false);
	    }

	    if ("intermediateButton".equals(evt.getActionCommand())) {
		System.out.println("I just pressed intermediateButton");
	    }
	    
	    if ("yesCombineBackground".equals(evt.getActionCommand())) {
		System.out.println("I just pressed yes in combine background");
	    }

	    if ("noCombineBackground".equals(evt.getActionCommand())) {
		System.out.println("I just pressed no in combine background");
	    }
	    
	    if ("yesInstrumentGeometry".equals(evt.getActionCommand())) {
		instrumentGeometryButton.setEnabled(true);
		instrumentGeometryTextField.setEnabled(true);
	    }

	    if ("noInstrumentGeometry".equals(evt.getActionCommand())) {
		instrumentGeometryButton.setEnabled(false);
		instrumentGeometryTextField.setEnabled(false);
	    }

	    if ("instrumentGeometryButton".equals(evt.getActionCommand())) {
		System.out.println("I just pressed button in instrument geometry");
	    }

	    if ("instrumentGeometryTextField".equals(evt.getActionCommand())) {
		System.out.println("I just pressed enter in text area of instrument geometry");
	    }

	    if ("startDataReductionButton".equals(evt.getActionCommand())) {
		System.out.println("I just pressed go Data Reduction");
	    }

	    if ("runNumber".equals(evt.getActionCommand())) {
		
		//retrive value of run number
		runNumberValue = runNumber.getText();
		
		/*
		//retrieve name of instrument
		instrument = (String)instrList.getSelectedItem();
		*/
		
		//	    if (instrument.compareTo("REF_L") == 0) {
		Nx = 256;
		Ny_min = 0;
		Ny_max = 304; 
		//	    } else {
		//		Nx = 304;
		//		Ny_min = 303-255;
		//		Ny_max = 255;
		//	    }
		
		instrument = "REF_L";
		instr = new com.rsi.ion.IONVariable(instrument);
		user = new com.rsi.ion.IONVariable(ucams);
		
		c_ionCon.setDrawable(c_plot);
		String cmd = "plot_data, " + runNumberValue + ", " + instr + ", " + user;
		
		showStatus("Processing...");
		executeCmd(cmd);
		showStatus("Done!");
		
		checkGUI();
		
	    }
	    
	    enabledGoDatReduction();
	    
	}   
    
    /*
      instrList.addActionListener( new ActionListener() {
      
      //retrieve value of combobox
      instrument = (String)instrList.getSelectedItem();
      
      if (compareTo(instrument, "REF_L" = 0)) {
      Nx = 256;
      Ny = 304;
      } else {
      Nx = 304;
      Ny = 256;
      }
      }
      );
    */	

/*
 ******************************************
 * buildGUI()
 *
 * Purpose:
 *   Builds the GUI for the applet
 */
	private void buildGUI(){

	    topPanel = new JPanel();
	    plotPanel = new JPanel();
	    leftPanel = new JPanel(new BorderLayout());

	    //	    dataReductionPanel = new JPanel();
	    tabbedPane = new JTabbedPane();
	    dataReductionTabbedPane = new JTabbedPane();
	    plotDataReductionPanel = new JPanel(new BorderLayout());
	    //	    dataReductionPanel = new JPanel();
	    GridBagLayout gridbag = new GridBagLayout();
	    GridBagConstraints c = new GridBagConstraints();
	    setLayout(gridbag);

	    //build menu
	    createMenu();

	    // First line (label + text box)
	    runNumberLabel = new JLabel("Run number: ",JLabel.LEFT);
	    c.gridx=0;
	    c.gridy=0;
	    c.gridwidth=1;
	    c.gridheight=1;
	    gridbag.setConstraints(runNumberLabel,c);

	    runNumber = new JTextField(10);
	    runNumber.setEditable(true);
	    runNumber.setActionCommand("runNumber");
	    runNumber.addActionListener(this);

	    c.gridx=1;
	    c.gridy=0;
	    c.gridwidth=1;
	    c.gridheight=1;
	    gridbag.setConstraints(runNumber,c);

	    /*
	    //combobox
	    instrList = new JComboBox(instrumentStrings);
	    instrList.setSelectedIndex(0);
	    instrList.addActionListener(this);
	    */

	    topPanel.add(runNumberLabel);
	    topPanel.add(runNumber);
	    //topPanel.add(instrList);

	    // Second line (plot)
	    c_plot = new IONGrDrawable(256*2, 304*2);
	    plotPanel.add(c_plot);
	    
	    leftPanel.add(topPanel,BorderLayout.NORTH);
	    leftPanel.add(plotPanel);
	    
	    //main DataReduction-Selection-logBook tabs - first tab
	    panela = new JPanel();
	    dataReductionTabbedPane.addTab("Input", panela);
	    createInputGUI();

	    panelb = new JPanel();
	    dataReductionTabbedPane.addTab("Extra Plots", panelb);
	    
	    tabbedPane.addTab("Data Reduction",dataReductionTabbedPane);

	    //second tab
	    panel1 = new JPanel();
	    tabbedPane.addTab("Selection", panel1);
	    createSelectionGui();

	    //third tab
	    panel2 = new JPanel();
	    createLogBoogGui();
	    tabbedPane.addTab("LogBook", panel2);
	    
	    setLayout(new BorderLayout());

	    plotDataReductionPanel.add(leftPanel,BorderLayout.WEST);
	    plotDataReductionPanel.add(tabbedPane);

	    //add everything in final window
	    JPanel contentPane  = new JPanel(new BorderLayout());
	    contentPane.add(plotDataReductionPanel);
	    add(contentPane);
	    setJMenuBar(menuBar);

	}

    protected JComponent makeTextPanel(String text) {
	JPanel panel = new JPanel(false);
	JLabel filler = new JLabel(text);
	filler.setHorizontalAlignment(JLabel.CENTER);
	panel.setLayout(new GridLayout(1,1));
	panel.add(filler);
	return panel;
    }








/*
 ************************************************
 * executeCmd()
 *
 * Purpose:
 *  Try executing IDL command.
 */
  private void executeCmd(String cmd) {
      try{
	  c_ionCon.setIDLVariable("instrument",instr);
	  c_ionCon.executeIDLCommand(cmd);
      } catch(Exception e) { 
	  String smsg;
	  if(e instanceof IOException)
	      smsg = "Communication error:"+e.getMessage(); 
	  else if(e instanceof IONSecurityException )
	      smsg = "ION Java security error"; 
	  else if(e instanceof IONIllegalCommandException )
	      smsg = "Illegal IDL Command detected on server."; 
	  else 
	      smsg = "Unknown error: "+e.getMessage();
	  System.err.println("Error: "+smsg);
	  writeMessage("Error: "+smsg);
      }
  }
 
 /*
 ************************************************
 * IONDisconnection()
 *
 * Purpose:
 *  Called when the connection is broken (can report reason).
 */
  public void IONDisconnection(int i){
    System.err.println("Server Connection Closed");
    writeMessage("Server Connection Closed");
    if(c_bConnected == 1)
      c_bConnected = 0;
  }

/*
 *******************************************
 * Output Listener Implementation
 */
  public void IONOutputText(String sMsg)  {
    writeMessage(sMsg);
 }

/*
 ***********************************************
 * writeMessage()
 *
 * Purpose:
 *   Utility method that is used to write a string to the
 *   screen using Java.
 */
  private void writeMessage(String sMsg){
        showStatus(sMsg);
	System.out.println(sMsg);
  }
    
/***********************
 * doBox 
 * 
 * Purpose: Draws rubber band box with Java.
 */
    private final void doBox(){
	
	Graphics g = c_plot.getGraphics();
	c_plot.update(g);
	g.setColor(Color.red);
	g.drawLine(c_x1,c_y1,c_x1,c_y2);
	g.drawLine(c_x1,c_y2,c_x2,c_y2);
	g.drawLine(c_x2,c_y2,c_x2,c_y1);
	g.drawLine(c_x2,c_y1,c_x1,c_y1);
    }



    private void createSelectionGui() {

	//definition of variables
	selectionTab = new JTabbedPane();

	signalSelectionPanel = new JPanel();
	signalSelectionTextArea = new JTextArea(30,50);
	signalSelectionPanel.add(signalSelectionTextArea);
	selectionTab.addTab("Signal", signalSelectionPanel);

	back1SelectionPanel = new JPanel();
	back1SelectionTextArea = new JTextArea(30,50);
	back1SelectionPanel.add(back1SelectionTextArea);
	selectionTab.addTab("Background 1", back1SelectionPanel);

	back2SelectionPanel = new JPanel();
	back2SelectionTextArea = new JTextArea(30,50);
	back2SelectionPanel.add(back2SelectionTextArea);
	selectionTab.addTab("Background 2", back2SelectionPanel);

	panel1.add(selectionTab);

    }




    private void createLogBoogGui() {
	
	//definition of variables
	textAreaLogBook = new JTextArea(40,60);
	
	textAreaLogBook.setEditable(false);
	JScrollPane scrollPane = new JScrollPane(textAreaLogBook,
						 JScrollPane.VERTICAL_SCROLLBAR_ALWAYS,
						 JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
	panel2.add(scrollPane);
    }


    private void createInputGUI() {

	//definition of variables
	buttonSignalBackgroundPanel = new JPanel(new GridLayout(0,1));   
	textFieldSignalBackgroundPanel = new JPanel(new GridLayout(0,1));  
	signalBackgroundPanel = new JPanel() ; 

	signalPidPanel = new JPanel();
	backgroundPidPanel = new JPanel();
	normalizationPanel = new JPanel(new FlowLayout(FlowLayout.LEADING));
	backgroundPanel = new JPanel(new FlowLayout(FlowLayout.LEADING));
	normBackgroundPanel = new JPanel(new FlowLayout(FlowLayout.LEADING));

	intermediatePanel = new JPanel(new FlowLayout(FlowLayout.LEADING));
	startDataReductionPanel = new JPanel(new FlowLayout());

	//signal pid infos
	signalPidFileButton = new JButton("Signal PID file");
	signalPidFileButton.setActionCommand("signalPidFileButton");
	signalPidFileButton.addActionListener(this);
	signalPidFileButton.setToolTipText("Select a signal PID file");
	
	signalPidFileTextField = new JTextField(30);
	signalPidFileTextField.setEditable(true);
	signalPidFileTextField.setActionCommand("signalPidFileTextField");
	signalPidFileTextField.addActionListener(this);
	
	//background pid infos
	backgroundPidFileButton = new JButton("Background PID file");
	backgroundPidFileButton.setActionCommand("backgroundPidFileButton");
	backgroundPidFileButton.addActionListener(this);
	backgroundPidFileButton.setToolTipText("Select a background PID file");
	
	backgroundPidFileTextField = new JTextField(30);
	backgroundPidFileTextField.setEditable(true);
	backgroundPidFileTextField.setActionCommand("backgroundPidFileTextField");
	backgroundPidFileTextField.addActionListener(this);

	buttonSignalBackgroundPanel.add(signalPidFileButton);
	buttonSignalBackgroundPanel.add(backgroundPidFileButton);
	textFieldSignalBackgroundPanel.add(signalPidFileTextField);
	textFieldSignalBackgroundPanel.add(backgroundPidFileTextField);
	signalBackgroundPanel.add(buttonSignalBackgroundPanel,BorderLayout.CENTER);
	signalBackgroundPanel.add(textFieldSignalBackgroundPanel,BorderLayout.LINE_END);
	
	//normalization radio button
	normalizationLabel = new JLabel(" Normalization: ");

	yesNormalizationRadioButton = new JRadioButton("Yes");
	yesNormalizationRadioButton.setActionCommand("yesNormalization");
	yesNormalizationRadioButton.setSelected(true);
	yesNormalizationRadioButton.addActionListener(this);

	noNormalizationRadioButton = new JRadioButton("No");
	noNormalizationRadioButton.setActionCommand("noNormalization");
	noNormalizationRadioButton.addActionListener(this);
	
	normalizationButtonGroup = new ButtonGroup();
	normalizationButtonGroup.add(yesNormalizationRadioButton);
	normalizationButtonGroup.add(noNormalizationRadioButton);
	
	normalizationPanel.add(normalizationLabel);
	normalizationPanel.add(yesNormalizationRadioButton);
	normalizationPanel.add(noNormalizationRadioButton);

	normalizationTextBoxPanel = new JPanel();
	normalizationTextBoxLabel = new JLabel("Run number: ");
	normalizationTextField = new JTextField(15);
	normalizationTextField.setActionCommand("normalizationTextField");
	normalizationTextField.setEditable(true);
	normalizationTextField.addActionListener(this);
	normalizationTextBoxPanel.add(normalizationTextBoxLabel);
	normalizationTextBoxPanel.add(normalizationTextField);
	normalizationPanel.add(normalizationTextBoxPanel);
	
	//background radio button
	backgroundLabel = new JLabel(" Background: ");

	yesBackgroundRadioButton = new JRadioButton("Yes");
	yesBackgroundRadioButton.setActionCommand("yesBackground");
	yesBackgroundRadioButton.setSelected(true);
	yesBackgroundRadioButton.addActionListener(this);

	noBackgroundRadioButton = new JRadioButton("No");
	noBackgroundRadioButton.setActionCommand("noBackground");
	noBackgroundRadioButton.addActionListener(this);

	backgroundButtonGroup = new ButtonGroup();
	backgroundButtonGroup.add(yesBackgroundRadioButton);
	backgroundButtonGroup.add(noBackgroundRadioButton);

	backgroundPanel.add(backgroundLabel);
	backgroundPanel.add(yesBackgroundRadioButton);
	backgroundPanel.add(noBackgroundRadioButton);

	//normalization background radio button
	normBackgroundLabel = new JLabel(" Normalization background: ");
	
	yesNormBackgroundRadioButton = new JRadioButton("Yes");
	yesNormBackgroundRadioButton.setActionCommand("yesNormBackground");
	yesNormBackgroundRadioButton.setSelected(true);
	yesNormBackgroundRadioButton.addActionListener(this);

	noNormBackgroundRadioButton = new JRadioButton("No");
	noNormBackgroundRadioButton.setActionCommand("noNormBackground");
	noNormBackgroundRadioButton.addActionListener(this);

	normBackgroundButtonGroup = new ButtonGroup();
	normBackgroundButtonGroup.add(yesNormBackgroundRadioButton);
	normBackgroundButtonGroup.add(noNormBackgroundRadioButton);

	normBackgroundPanel.add(normBackgroundLabel);
	normBackgroundPanel.add(yesNormBackgroundRadioButton);
	normBackgroundPanel.add(noNormBackgroundRadioButton);
	    
	//tab of runs 
	runsTabbedPane = new JTabbedPane();
	runsAddPanel = new JPanel(new FlowLayout());
	runsSequencePanel = new JPanel(new FlowLayout());

	runsAddLabel = new JLabel(" Run(s) number: ");
	runsAddTextField = new JTextField(30);
	runsAddTextField.setEditable(true);
	runsAddTextField.setActionCommand("runsAddTextField");
	runsAddTextField.addActionListener(this);
	runsAddPanel.add(runsAddLabel);
	runsAddPanel.add(runsAddTextField);
	runsTabbedPane.addTab("Add NeXus and GO",runsAddPanel);

	runsSequenceLabel = new JLabel(" Run(s) number: ");
	runsSequenceTextField = new JTextField(30);
	runsSequenceTextField.setEditable(true);
	runsSequenceTextField.setActionCommand("runsSequenceTextField");
	runsSequenceTextField.addActionListener(this);
	runsSequencePanel.add(runsSequenceLabel);
	runsSequencePanel.add(runsSequenceTextField);
	runsTabbedPane.addTab("GO sequentially",runsSequencePanel);

	//intermediate plots
	intermediateLabel = new JLabel(" Intermediate file output:");

	yesIntermediateRadioButton = new JRadioButton("Yes");
	yesIntermediateRadioButton.setActionCommand("yesIntermediate");
	yesIntermediateRadioButton.addActionListener(this);

	noIntermediateRadioButton = new JRadioButton("No");
	noIntermediateRadioButton.setActionCommand("noIntermediate");
	noIntermediateRadioButton.setSelected(true);
	noIntermediateRadioButton.addActionListener(this);

	intermediateButtonGroup = new ButtonGroup();
	intermediateButtonGroup.add(yesIntermediateRadioButton);
	intermediateButtonGroup.add(noIntermediateRadioButton);

	intermediateButton = new JButton("Plots");
	intermediateButton.setActionCommand("intermediateButton");
	intermediateButton.addActionListener(this);
	intermediateButton.setToolTipText("List of intermediate plots available");
	intermediateButton.setEnabled(false);
	
	intermediatePanel.add(intermediateLabel);
	intermediatePanel.add(yesIntermediateRadioButton);
	intermediatePanel.add(noIntermediateRadioButton);
	intermediatePanel.add(intermediateButton);
	
	//combine spectrum
	combineSpectrumPanel = new JPanel(new FlowLayout(FlowLayout.LEADING));
	combineSpectrumLabel = new JLabel(" Combine data spectrum: ");
	
	yesCombineSpectrumRadioButton = new JRadioButton("Yes");
	yesCombineSpectrumRadioButton.setActionCommand("yesCombineBackground");
	yesCombineSpectrumRadioButton.setSelected(true);
	yesCombineSpectrumRadioButton.addActionListener(this);

	noCombineSpectrumRadioButton = new JRadioButton("No");
	noCombineSpectrumRadioButton.setActionCommand("noCombineBackground");
	noCombineSpectrumRadioButton.addActionListener(this);

	combineSpectrumButtonGroup = new ButtonGroup();
	combineSpectrumButtonGroup.add(yesCombineSpectrumRadioButton);
	combineSpectrumButtonGroup.add(noCombineSpectrumRadioButton);

	combineSpectrumPanel.add(combineSpectrumLabel);
	combineSpectrumPanel.add(yesCombineSpectrumRadioButton);
	combineSpectrumPanel.add(noCombineSpectrumRadioButton);

	//overwrite instrument geometry
	instrumentGeometryLabel = new JLabel(" Overwrite instrument geometry:");
	instrumentGeometryPanel = new JPanel(new FlowLayout(FlowLayout.LEADING));

	yesInstrumentGeometryRadioButton = new JRadioButton("Yes");
	yesInstrumentGeometryRadioButton.setActionCommand("yesInstrumentGeometry");
	yesInstrumentGeometryRadioButton.addActionListener(this);

	noInstrumentGeometryRadioButton = new JRadioButton("No");
	noInstrumentGeometryRadioButton.setActionCommand("noInstrumentGeometry");
	noInstrumentGeometryRadioButton.setSelected(true);
	noInstrumentGeometryRadioButton.addActionListener(this);

	instrumentGeometryButtonGroup = new ButtonGroup();
	instrumentGeometryButtonGroup.add(yesInstrumentGeometryRadioButton);
	instrumentGeometryButtonGroup.add(noInstrumentGeometryRadioButton);

	instrumentGeometryButton = new JButton("Geometry file");
	instrumentGeometryButton.setActionCommand("instrumentGeometryButton");
	instrumentGeometryButton.addActionListener(this);
	instrumentGeometryButton.setToolTipText("Instrument geometry file");
	instrumentGeometryButton.setEnabled(false);
	
	instrumentGeometryTextField = new JTextField(30);
	instrumentGeometryTextField.setActionCommand("instrumentGeometryTextField");
	instrumentGeometryTextField.setEditable(true);
	instrumentGeometryTextField.addActionListener(this);

	instrumentGeometryPanel.add(intermediateLabel);
	instrumentGeometryPanel.add(yesInstrumentGeometryRadioButton);
	instrumentGeometryPanel.add(noInstrumentGeometryRadioButton);
	instrumentGeometryPanel.add(instrumentGeometryButton);
	instrumentGeometryPanel.add(instrumentGeometryTextField);

	//go button
	startDataReductionButton = new JButton(" START DATA REDUCTION ");
	startDataReductionButton.setActionCommand("startDataReductionButton");
	startDataReductionButton.addActionListener(this);
	startDataReductionButton.setToolTipText("Press to launch the data reduction");
	startDataReductionButton.setEnabled(true);
	startDataReductionPanel.add(startDataReductionButton);
	startDataReductionButton.setEnabled(false);

	blank1Label = new JLabel("    ");
	blank2Label = new JLabel("    ");
	blank3Label = new JLabel("    ");
	
	//general info text area 
	generalInfoTextArea = new JTextArea(5,40);
	generalInfoTextArea.setEditable(true);
	JScrollPane scrollPane = new JScrollPane(generalInfoTextArea,
						 JScrollPane.VERTICAL_SCROLLBAR_ALWAYS,
						 JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
	
	//add all components
	panela.setLayout(new BoxLayout(panela,BoxLayout.PAGE_AXIS));
	//	panela.add(signalPidPanel);
	//	panela.add(backgroundPidPanel);
	panela.add(signalBackgroundPanel);
	//	normalizationPanel.setBorder(BorderFactory.createLineBorder(Color.red));
	panela.add(normalizationPanel);
	//	backgroundPanel.setBorder(BorderFactory.createLineBorder(Color.red));
	panela.add(backgroundPanel);
	//	normBackgroundPanel.setBorder(BorderFactory.createLineBorder(Color.red));
	panela.add(normBackgroundPanel);
	panela.add(intermediatePanel);
	panela.add(combineSpectrumPanel);
	panela.add(instrumentGeometryPanel);
	panela.add(runsTabbedPane);
	panela.add(startDataReductionPanel);
	panela.add(scrollPane);

    }


    // method that check if all the parameters have been input to enable or not the GO
    // DataReduction.
    private void enabledGoDatReduction() {
	System.out.println("Checking if all the parameters are there");
    }


    private void createMenu() {

	//Create the menu bar
	menuBar = new JMenuBar();

	//Create the first menu
	modeMenu = new JMenu("Operation mode");
	modeMenu.setMnemonic(KeyEvent.VK_M);
	modeMenu.getAccessibleContext().setAccessibleDescription("Select the active operation mode");
	menuBar.add(modeMenu);

	//a group of radio button menu items
	modeButtonGroup = new ButtonGroup();

	selectModeMenuItem = new JRadioButtonMenuItem("Selection");
	selectModeMenuItem.setSelected(true);
	selectModeMenuItem.setMnemonic(KeyEvent.VK_S);
	modeButtonGroup.add(selectModeMenuItem);
	modeMenu.add(selectModeMenuItem);
	
	infoModeMenuItem = new JRadioButtonMenuItem("Info");
	infoModeMenuItem.setMnemonic(KeyEvent.VK_I);
	modeButtonGroup.add(infoModeMenuItem);
	modeMenu.add(infoModeMenuItem);
	modeMenu.setEnabled(false);
	
    }

    private void checkGUI() {
	
	//if the run number has been found, activate selection mode
	modeMenu.setEnabled(false);
    }

}
