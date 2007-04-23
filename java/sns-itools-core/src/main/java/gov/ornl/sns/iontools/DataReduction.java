//
package gov.ornl.sns.iontools;
//

/*******************************************************************
 Copyright (c) 1997-2005, Research Systems, Inc.  All rights reserved.
 Unauthorized reproduction prohibited.

 (Of course, because these are examples, feel free to remove these 
 lines and modify to suit your needs.)
********************************************************************/

import gov.ornl.sns.iontools.IParameters;
import gov.ornl.sns.iontools.DisplayConfiguration;
import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.GridBagLayout;
import java.awt.GridBagConstraints;
//import java.awt.image.BufferedImage;
import java.awt.Dimension;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.event.*;
//import java.applet.*;
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
    DisplayConfiguration   getN;
    
    IONGrConnection c_ionCon;

    IONJGrDrawable   c_plot;
    Dimension       c_dimApp;
    int             c_bConnected=0; // 0 => !conn, 1 => conn, -1 => conn failed
    String          runNumberValue;
    String          instrument = "REF_L";
    //    String[]        instrumentStrings = {"REF_L", "REF_M"};
    String          text1;
    String          text2;
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
    IONVariable     iVar;
    IONVariable     ionVar;
    IONVariable     IONfoundNexus;
    String          foundNexus = "0";
    
    int             Nx;
    int             Ny;
    int             NyMin;
    int             NyMax;
//    int             Ny_max = (303-255);
    
    int	            c_xval1=0;	  // initial x for rubber band box
    int		    c_yval1=0;	  // initial y for rubber band box
    int		    c_xval2=0;	  // final x for rubber band box
    int		    c_yval2=0;	  // final y for rubber band box
    int		    c_x1=0;		  // initial x java
    int		    c_y1=0;		  // initial y java
    int		    c_x2=0;		  // final x java
    int		    c_y2=0;		  // final y java
    int             a=0;

    int             signal_x1=0;
    int             signal_y1=0;
    int             back1_x1=0;
    int             back1_y1=0;
    int             back2_x1=0;
    int             back2_y1=0;
    int             signal_x2=0;
    int             signal_y2=0;
    int             back1_x2=0;
    int             back1_y2=0;
    int             back2_x2=0;
    int             back2_y2=0;
    int             info_x=0;
    int             info_y=0;

    String          hostname;

    //menu
    JMenuBar        menuBar;
    JMenu           dataReductionPackMenu;
    JMenu           modeMenu;
    JMenu           parametersMenu;
    JMenu           saveSessionMenu;

    //JMenuItem of DataReductionMenu
    JMenuItem       preferencesMenuItem;
//    InternalFrame   preferencesFrame;

    //JMenuItem of mode
    ButtonGroup     modeButtonGroup;
    JRadioButtonMenuItem signalSelectionModeMenuItem;
    JRadioButtonMenuItem background1SelectionModeMenuItem;
    JRadioButtonMenuItem background2SelectionModeMenuItem;
    JRadioButtonMenuItem infoModeMenuItem;
    JCheckBoxMenuItem    cbMenuItem;
    String  modeSelected="signalSelection";//signalSelection, back1Selection, back2Selection, info

    JMenu           intermediateMenu;

    //JMenuItem of instruments
    JMenu           instrumentMenu;
    JRadioButtonMenuItem reflRadioButton;
    JRadioButtonMenuItem refmRadioButton;
    JRadioButtonMenuItem bssRadioButton;
    ButtonGroup     instrumentButtonGroup;

    //JMenuItem of save session in parameters
    ButtonGroup          saveFullSessionButtonGroup;
    JRadioButtonMenuItem yesSaveFullSessionMenuItem;
    JRadioButtonMenuItem noSaveFullSessionMenu;

// ******************************
// Init Method
// ******************************
  
  public void init(){

	  initializeParameters();
	  
	  /*
      Container contentPane = getContentPane();
      contentPane.setLayout(new FlowLayout(FlowLayout.LEADING));
      
      contentPane.add(plotDataReductionPanel);
      */

      // Create connection and drawable objects
      c_ionCon   = new IONGrConnection();
      //      c_ionClient = new IONCallableClient();  //try
      c_dimApp = getSize();
      buildGUI();	
      runNumber.requestFocusInWindow();

      connectToServer();
      IONfoundNexus = new IONVariable((int)0);

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
 
  /**
   * This method initialize all the parameters used to display the GUI.
   *
   */
  private void initializeParameters() {
	   
	    //retrieve Nx, Ny, NyMin and NyMax according to instrument type
	    getN = new DisplayConfiguration("REF_L");
	    Nx = getN.retrieveNx();
	    Ny = getN.retrieveNy();
		NyMin = getN.retrieveNyMin();
	    NyMax = getN.retrieveNyMax();
	  System.out.println("NyMin: " + NyMin);
	  System.out.println("NyMax: " + NyMax);
	    
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
	 //	 c_ionClient.connect(this.getCodeBase().getHost());   //try
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
      if (IONfoundNexus.toString().compareTo("0") != 0) {

	  if (X < 0) {X = 0;};
	  if (Y < NyMin*2) {Y = NyMin*2;};
	  if (X > Nx*2) {X = 2*Nx-1;};
	  if (Y > 2*NyMax) {Y = 2*Ny-1;};
	  
	  
	  if (modeSelected.compareTo("signalSelection") == 0) {
	      signal_x1 = X;
	      signal_y1 = Y;
	  } else if (modeSelected.compareTo("back1Selection") == 0) {
	      back1_x1 = X;
	      back1_y1 = Y;
	  } else if (modeSelected.compareTo("back2Selection") == 0) {
	      back2_x1 = X;
	      back2_y1 = Y;
	  } else {
	      info_x = X;
	      info_y = Y;
	  }

	  c_xval1 = (int) X / 2;
	  c_yval1 = (int) (607-Y)/2;
	  
	  c_plot.addIONMouseListener(this, com.rsi.ion.IONMouseListener.ION_MOUSE_ANY);
      }
      return;
  }
    
    public void mouseMoved(com.rsi.ion.IONDrawable drawable, int X, int Y, 
			   long when, int mask)
    {
	if (IONfoundNexus.toString().compareTo("0") != 0) {
	    if (X < 0) {X = 0;};
	    if (Y < 2*NyMin) {Y = 2*NyMin;};
	    if (X > 2*Nx) {X = 2*Nx-1;};
	    if (Y > 2*NyMax) {Y = 2*Ny-1;};
	    
	    c_xval2 = (int) X/2;
	    c_yval2 = (int) (607-Y)/2;

	    if (modeSelected.compareTo("signalSelection") == 0) {
		signal_x2 = X;
		signal_y2 = Y;
		doBox();
	    } else if (modeSelected.compareTo("back1Selection") == 0) {
		back1_x2 = X;
		back1_y2 = Y;
		doBox();
	    } else if (modeSelected.compareTo("back2Selection") == 0) {
		back2_x2 = X;
		back2_y2 = Y;
		doBox();
	    } else {
		info_x = X;
		info_y = Y;
	    }
	    
	    c_plot.addIONMouseListener(this, com.rsi.ion.IONMouseListener.ION_MOUSE_ANY);
	}
	return;
    }
    
    public void mouseReleased(com.rsi.ion.IONDrawable drawable, int X, int Y, 
			      long when, int mask)
    { 
      if (IONfoundNexus.toString().compareTo("0") != 0) {
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
	  text1= "x_min: " + x_min + "\ty_min: " + y_min + "\n";
	  //	  generalInfoTextArea.setText(text);
	  text2 = "x_max: " + x_max + "\ty_max: " + y_max + "\n";

	if (IONfoundNexus.toString().compareTo("0") != 0) {

	    if (X < 0) {X = 0;};
	    if (Y < 2*NyMin) {Y = 2*NyMin;};
	    if (X > 2*Nx) {X = 2*Nx-1;};
	    if (Y > 2*NyMax) {Y = 2*Ny-1;};
	    
	    if (modeSelected.compareTo("signalSelection") == 0) {
		signalSelectionTextArea.setText(text1);
		signalSelectionTextArea.append(text2);
		doBox();
	    } else if (modeSelected.compareTo("back1Selection") == 0) {
		back1SelectionTextArea.setText(text1);		
		back1SelectionTextArea.append(text2);		
		doBox();
	    } else if (modeSelected.compareTo("back2Selection") == 0) {
		back2SelectionTextArea.setText(text1);
		back2SelectionTextArea.append(text2);
		doBox();
	    } else {
		generalInfoTextArea.setText(text1);
		generalInfoTextArea.append(text2);
	    }
	    	
	    c_plot.addIONMouseListener(this, com.rsi.ion.IONMouseListener.ION_MOUSE_DOWN);
	    
	}
      }
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
	    
	    //if one of the intermediate check box is check
	    if ("plot1".equals(evt.getActionCommand())) {
		System.out.println("in check box");
	    }

	    if ("instrumentREFL".equals(evt.getActionCommand())) {
		instrument = "REF_L";
	    }

	    if ("instrumentREFM".equals(evt.getActionCommand())) {
		instrument = "REF_M";
	    }

	    if ("instrumentBSS".equals(evt.getActionCommand())) {
		instrument = "BSS";
	    }

	    if ("preferencesMenuItem".equals(evt.getActionCommand())) {
		//    preferencesFrame.setVisible(true);
	    }

	    if ("signalSelection".equals(evt.getActionCommand())) {
		modeSelected = "signalSelection";
	    }
	    
	    if ("back1Selection".equals(evt.getActionCommand())) {
		modeSelected = "back1Selection";
	    }
	    
	    if ("back2Selection".equals(evt.getActionCommand())) {
		modeSelected = "back2Selection";
	    }
	    
	    if ("info".equals(evt.getActionCommand())) {
		modeSelected = "info";
	    }
	    
	    if ("runNumber".equals(evt.getActionCommand())) {
		
		//retrive value of run number
		runNumberValue = runNumber.getText();
		
		if (runNumberValue.compareTo("") != 0) {   //plot only if there is a run number

		    /*
		    //retrieve name of instrument
		    instrument = (String)instrList.getSelectedItem();
		    */

		    // createVar();
		   
		    instr = new com.rsi.ion.IONVariable(instrument);
		    user = new com.rsi.ion.IONVariable(ucams); 


		    //	    sendIDLVariable("X",iVar);
	
		    c_ionCon.setDrawable(c_plot);
		    
		    String cmd = "foundNexus = plot_data( " + runNumberValue + ", " + 
			instr + ", " + user+")";

		    showStatus("Processing...");
		    executeCmd(cmd);
		    IONfoundNexus = queryVariable("foundNexus");

		    showStatus("Done!");
		    checkGUI();
		}
	    }
	    
	    enabledGoDatReduction();
	    
	}   
    
    /*
      instrList.addActionListener( new ActionListener() {
      
      //retrieve value of combobox
      instrument = (String)instrList.getSelectedItem();
      
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
	    plotPanel = new JPanel(new BorderLayout());
	    leftPanel = new JPanel(new BorderLayout());

	    //	    dataReductionPanel = new JPanel();
	    tabbedPane = new JTabbedPane();
	    dataReductionTabbedPane = new JTabbedPane();
	    plotDataReductionPanel = new JPanel();
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
	    //	    topPanel.add(instrList);

	    
	    // Second line (plot)
	    c_plot = new IONJGrDrawable(Nx*2, Ny*2);
	    plotPanel.add(c_plot,BorderLayout.SOUTH);
	    leftPanel.add(topPanel,BorderLayout.NORTH);
	    leftPanel.add(plotPanel,BorderLayout.SOUTH);

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
	    //	    JPanel contentPane  = new JPanel(new BorderLayout());

	    //create internal frame for preferences
	    //createFrame();
	    
	    add(plotDataReductionPanel);
	    //contentPane.add(plotDataReductionPanel);
	    //add(contentPane);
	    setJMenuBar(menuBar);

	}


/*
    protected void createFrame() {
	preferencesFrame = new InternalFrame();
	
	//preferencesFrame.setVisible(false);
	preferencesFrame.setVisible(false);
	add(preferencesFrame);
	
	try {
	    preferencesFrame.setSelected(true);
	} catch (java.beans.PropertyVetoException e) {}
    }
    
    

    protected JComponent makeTextPanel(String text) {
	JPanel panel = new JPanel(false);
	JLabel filler = new JLabel(text);
	filler.setHorizontalAlignment(JLabel.CENTER);
	panel.setLayout(new GridLayout(1,1));
	panel.add(filler);
	return panel;
    }

*/

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
	
	for (int i=0; i<3; i++) {
	    
	    if (i == 0) {
		c_x1 = signal_x1;
		c_y1 = signal_y1;
		c_x2 = signal_x2;
		c_y2 = signal_y2;
		g.setColor(Color.red);
	    } else if (i == 1) {
		c_x1 = back1_x1;
		c_y1 = back1_y1;
		c_x2 = back1_x2;
		c_y2 = back1_y2;
		g.setColor(Color.yellow);
	    } else if (i == 2) {
		c_x1 = back2_x1;
		c_y1 = back2_y1;
		c_x2 = back2_x2;
		c_y2 = back2_y2;
		g.setColor(Color.green);
	    }
		
	    g.drawLine(c_x1,c_y1,c_x1,c_y2);
	    g.drawLine(c_x1,c_y2,c_x2,c_y2);
	    g.drawLine(c_x2,c_y2,c_x2,c_y1);
	    g.drawLine(c_x2,c_y1,c_x1,c_y1);
	}
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
	dataReductionPackMenu = new JMenu("DataReductionPack");
	dataReductionPackMenu.setActionCommand("dataReductionPackMenu");
	dataReductionPackMenu.setMnemonic(KeyEvent.VK_D);
	dataReductionPackMenu.setEnabled(true);
	menuBar.add(dataReductionPackMenu);
		
	preferencesMenuItem = new JMenuItem("Preferences...");
	preferencesMenuItem.setMnemonic(KeyEvent.VK_C);
	preferencesMenuItem.setActionCommand("preferencesMenuItem");
	preferencesMenuItem.addActionListener(this);
	dataReductionPackMenu.add(preferencesMenuItem);

	//Create the second menu
	modeMenu = new JMenu("Mode");
	modeMenu.setActionCommand("modeMenu");
	modeMenu.setMnemonic(KeyEvent.VK_M);
	modeMenu.getAccessibleContext().setAccessibleDescription("Select the active operation mode");
	menuBar.add(modeMenu);

	//a group of radio button menu items
	modeButtonGroup = new ButtonGroup();

	signalSelectionModeMenuItem = new JRadioButtonMenuItem("Signal selection");
	signalSelectionModeMenuItem.setActionCommand("signalSelection");
	signalSelectionModeMenuItem.addActionListener(this);
	signalSelectionModeMenuItem.setSelected(true);
	signalSelectionModeMenuItem.setMnemonic(KeyEvent.VK_S);
	modeButtonGroup.add(signalSelectionModeMenuItem);
	modeMenu.add(signalSelectionModeMenuItem);
	
	background1SelectionModeMenuItem = new JRadioButtonMenuItem("Background #1 selection");
	background1SelectionModeMenuItem.setActionCommand("back1Selection");
	background1SelectionModeMenuItem.addActionListener(this);
	background1SelectionModeMenuItem.setSelected(true);
	background1SelectionModeMenuItem.setMnemonic(KeyEvent.VK_S);
	modeButtonGroup.add(background1SelectionModeMenuItem);
	modeMenu.add(background1SelectionModeMenuItem);

	background2SelectionModeMenuItem = new JRadioButtonMenuItem("Background #2 selection");
	background2SelectionModeMenuItem.setActionCommand("back2Selection");
	background2SelectionModeMenuItem.addActionListener(this);
	background2SelectionModeMenuItem.setSelected(true);
	background2SelectionModeMenuItem.setMnemonic(KeyEvent.VK_S);
	modeButtonGroup.add(background2SelectionModeMenuItem);
	modeMenu.add(background2SelectionModeMenuItem);

	infoModeMenuItem = new JRadioButtonMenuItem("Info");
	infoModeMenuItem.setActionCommand("info");
	infoModeMenuItem.addActionListener(this);
	infoModeMenuItem.setMnemonic(KeyEvent.VK_I);
	modeButtonGroup.add(infoModeMenuItem);
	modeMenu.add(infoModeMenuItem);
	modeMenu.setEnabled(true);

	//create the second menu
	parametersMenu = new JMenu("Parameters");
	parametersMenu.setActionCommand("parametersMenu");
	parametersMenu.setMnemonic(KeyEvent.VK_P);
	parametersMenu.getAccessibleContext().setAccessibleDescription("Select the various parameters");
	parametersMenu.setEnabled(false);

	parametersMenu.setRequestFocusEnabled(true);
	parametersMenu.requestFocus(true);
	menuBar.add(parametersMenu);

	/*
	//a subemenu of list of intermediate plots
	intermediateMenu = new JMenuItem("Intermediate plots");
	intermediateMenu.setMnemonic(KeyEvent.VK_I);
	modeMenu.add(intermediateMenu);
	*/

	//instrument
	instrumentMenu = new JMenu("Instrument");
	instrumentMenu.setMnemonic(KeyEvent.VK_I);
	parametersMenu.add(instrumentMenu);

	//a group of radio button menu items
	instrumentButtonGroup = new ButtonGroup();

	reflRadioButton = new JRadioButtonMenuItem("REF_L");
	reflRadioButton.setActionCommand("instrumentREFL");
	reflRadioButton.addActionListener(this);
	reflRadioButton.setSelected(true);
	reflRadioButton.setMnemonic(KeyEvent.VK_L);
	instrumentButtonGroup.add(reflRadioButton);
	instrumentMenu.add(reflRadioButton);
	
	refmRadioButton = new JRadioButtonMenuItem("REF_M");
	refmRadioButton.setActionCommand("instrumentREFM");
	refmRadioButton.addActionListener(this);
	refmRadioButton.setSelected(true);
	refmRadioButton.setMnemonic(KeyEvent.VK_M);
	instrumentButtonGroup.add(refmRadioButton);
	instrumentMenu.add(refmRadioButton);

	bssRadioButton = new JRadioButtonMenuItem("BSS");
	bssRadioButton.setActionCommand("instrumentBSS");
	bssRadioButton.addActionListener(this);
	bssRadioButton.setSelected(true);
	bssRadioButton.setMnemonic(KeyEvent.VK_B);
	instrumentButtonGroup.add(bssRadioButton);
	instrumentMenu.add(bssRadioButton);









	//intermediate plot
	intermediateMenu = new JMenu("Intermediate plots");
	intermediateMenu.setMnemonic(KeyEvent.VK_P);
	parametersMenu.add(intermediateMenu);
	
	//a list of check box intermediate plots
	cbMenuItem = new JCheckBoxMenuItem("Signal Region Summed vs TOF");
	cbMenuItem.setActionCommand("plot1");
	cbMenuItem.addActionListener(this);
        intermediateMenu.add(cbMenuItem);
	
	cbMenuItem = new JCheckBoxMenuItem("Background Summed vs TOF");
	cbMenuItem.addActionListener(this);
	intermediateMenu.add(cbMenuItem);

	cbMenuItem = new JCheckBoxMenuItem("Signal Region Summed vs TOF");
	cbMenuItem.addActionListener(this);
	intermediateMenu.add(cbMenuItem);

	cbMenuItem = new JCheckBoxMenuItem("Normalization Region Summed vs TOF");
	cbMenuItem.addActionListener(this);
	intermediateMenu.add(cbMenuItem);

	cbMenuItem = new JCheckBoxMenuItem("Background Region from Normalization Summed vs TOF");
	cbMenuItem.addActionListener(this);
	intermediateMenu.add(cbMenuItem);

	//save full session
	saveSessionMenu = new JMenu("Parameters saved between sessions");
	saveSessionMenu.setMnemonic(KeyEvent.VK_S);
	parametersMenu.add(saveSessionMenu);
	
	//list of parameters to save
	cbMenuItem = new JCheckBoxMenuItem("Save everything");
	cbMenuItem.addActionListener(this);
	saveSessionMenu.add(cbMenuItem);

	saveSessionMenu.addSeparator();

	cbMenuItem = new JCheckBoxMenuItem("Save background 1 selection");
	cbMenuItem.addActionListener(this);
	saveSessionMenu.add(cbMenuItem);

	cbMenuItem = new JCheckBoxMenuItem("Save background 2 selection");
	cbMenuItem.addActionListener(this);
	saveSessionMenu.add(cbMenuItem);

	saveSessionMenu.addSeparator();

	cbMenuItem = new JCheckBoxMenuItem("Save signal Pid file");
	cbMenuItem.addActionListener(this);
	saveSessionMenu.add(cbMenuItem);

	cbMenuItem = new JCheckBoxMenuItem("Save background Pid file");
	cbMenuItem.addActionListener(this);
	saveSessionMenu.add(cbMenuItem);
	
	saveSessionMenu.addSeparator();

	cbMenuItem = new JCheckBoxMenuItem("Save normalization run number");
	cbMenuItem.addActionListener(this);
	saveSessionMenu.add(cbMenuItem);

	    
    }

    private void checkGUI() {
	
	//if the run number has been found, activate selection mode
	if (IONfoundNexus.toString().compareTo("0") == 0) {
	    modeMenu.setEnabled(false);
	    parametersMenu.setEnabled(false);
	} else {
	    	    modeMenu.setEnabled(true);
	    parametersMenu.setEnabled(true);
	}
    }

    private void createVar() {

	iVar = new IONVariable((int)0);
	sendIDLVariable("X",iVar);
    }
    
    private void sendIDLVariable(String sVariable, IONVariable ionVar) {
	try {
	    c_ionCon.setIDLVariable(sVariable,ionVar);
	} catch (Exception e) {}
    }
    
    private IONVariable queryVariable(String sVariable) {
	try {
	    ionVar = c_ionCon.getIDLVariable(sVariable);
	} catch (Exception e) {}
	return ionVar;
    }

    
}
