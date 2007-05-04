/*
 * Copyright (c) 2007, J.-C. Bilheux <bilheuxjm@ornl.gov>
 * showpallation Neutron Source at Oak Ridge National Laboratory
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
package gov.ornl.sns.iontools;

import gov.ornl.sns.iontools.DisplayConfiguration;
import gov.ornl.sns.iontools.IParameters;
import java.awt.BorderLayout;
import java.awt.GridBagLayout;
import java.awt.GridBagConstraints;
import java.awt.Dimension;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.event.*;
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
    static String          ucams = "j35";
    static String          instrument = IParameters.DEFAULT_INSTRUMENT;
    static String          runNumberValue;
    static String          sTmpOutputFileName;   //the full name of the file that contaits the dump histo data
    
    DisplayConfiguration   getN;
    static float           fNtof;
    
    static IONGrConnection c_ionCon;
    
    static IONJGrDrawable   c_plot;
    static Dimension        c_dimApp;
    static int              c_bConnected=0; // 0 => !conn, 1 => conn, -1 => conn failed
    
    //pid files names creation
    static String 			pidSignalFileName;
    static String           pidBackFileName;
    static String  		 		sNexusFound;
    static String          		sNtof;
    static int              iBack2SelectionExist = 0;
    
    //extra plot panel
    static JPanel		extraPlotPanel;
    
    static String          	text1;
    static String          	text2;
    static String          	cmd; 
    static JPanel          	instrumentLogoPanel;
    static JLabel          	instrumentLogoLabel;
    static JLabel	        	runNumberLabel;	
    static JTextField      	runNumberTextField;
    static JTextArea    generalInfoTextArea;

    //def of components of data reduction tab
    static JPanel 		        topPanel;
    static JPanel 				clearSelectionPanel ;
    final static int 	NUM_LOGO_IMAGES = 2;
    final static int 	START_INDEX = 0;
    ImageIcon[]     	instrumentLogo = new ImageIcon[NUM_LOGO_IMAGES];
    
    static JPanel          plotPanel;
    static JPanel          leftPanel;
    static JPanel          plotDataReductionPanel;
    static JPanel          panela; //input tab			   
    static JPanel          panel1; //selection
    static JPanel          panel2; //log book
    static JPanel          panelb; //DataReductionPlot
    static JScrollPane 		   scrollPane;
    
    //Data Reduction Plot
    static IONJGrDrawable   c_dataReductionPlot;	    
    static JLabel           labelXaxis;
    static JLabel           labelYaxis;
    static JLabel           maxLabel;
    static JLabel           minLabel;
    static JTextField       yMaxTextField;
    static JTextField       yMinTextField;
    static JTextField       xMaxTextField;
    static JTextField       xMinTextField;
    static JButton          yValidateButton;
    static JButton          xValidateButton;
    static JButton          yResetButton;
    static JButton          xResetButton;
    static JComboBox        linLogComboBoxX;
    static JComboBox        linLogComboBoxY;
    static JButton          dataReductionPlotValidateButton;
    
    static JPanel           panelc; //Extra plots
    static JTabbedPane      tabbedPane;
    static JTabbedPane      dataReductionTabbedPane;

    static JPanel           settingsPanel; //settings panel
    
    static JLabel           blank1Label;
    static JLabel           blank2Label;
    static JLabel           blank3Label;
    
    //def of components of input tab
    static JPanel           buttonSignalBackgroundPanel;
    static JPanel           textFieldSignalBackgroundPanel;
    static JPanel           signalBackgroundPanel;

    //signal and back pid
    static JPanel          	signalPidPanel;
    static JTextField   signalPidFileTextField;
    static JButton      signalPidFileButton;
    static JButton  	clearSignalPidFileButton;
    static JPanel          	backgroundPidPanel;
    static JTextField   backgroundPidFileTextField;    
    static JButton      backgroundPidFileButton;
    static JButton  	clearBackPidFileButton;

    //normalization
    static JPanel          	normalizationPanel;
    static JLabel         		normalizationLabel;
    static ButtonGroup    	 	normalizationButtonGroup;
    static JRadioButton    	yesNormalizationRadioButton;
    static JRadioButton    	noNormalizationRadioButton;
    static JPanel          	normalizationTextBoxPanel;
    static JLabel       normalizationTextBoxLabel;
    static JTextField   normalizationTextField;
    //background
    static JPanel        	    backgroundPanel;
    static JLabel         	    backgroundLabel;
    static ButtonGroup         backgroundButtonGroup;
    static JRadioButton        yesBackgroundRadioButton;
    static JRadioButton        noBackgroundRadioButton;
    //norm. background
    static JPanel              normBackgroundPanel;
    static JLabel              normBackgroundLabel;
    static ButtonGroup         normBackgroundButtonGroup;
    static JRadioButton        yesNormBackgroundRadioButton;
    static JRadioButton        noNormBackgroundRadioButton;

    //tab of runs
    static JTabbedPane  runsTabbedPane;
    static JPanel          	runsAddPanel;
    static JLabel          	runsAddLabel;
    static JTextField   runsAddTextField;
    static JPanel          	runsSequencePanel;
    static JLabel          	runsSequenceLabel;
    static JTextField   runsSequenceTextField;

    //tab of selection
    static JTabbedPane     	selectionTab;
    static JPanel          	signalSelectionPanel;
    static JPanel          	back1SelectionPanel;
    static JPanel          	back2SelectionPanel;
    static JPanel              pixelInfoPanel;
    static JLabel              pixelInfoLabel;
    static JTextArea    signalSelectionTextArea;
    static JTextArea    back1SelectionTextArea;
    static JTextArea    back2SelectionTextArea;
    static JTextArea    pixelInfoTextArea;
    static ImageIcon    		detectorLayout = new ImageIcon();
    
    //tab of Log Book
    static JTextArea      	    textAreaLogBook;
    
    //intermediate file output
    static JPanel          	intermediatePanel;
    static JLabel          	intermediateLabel;
    static ButtonGroup         intermediateButtonGroup;
    static JRadioButton        yesIntermediateRadioButton;
    static JRadioButton        noIntermediateRadioButton;
    static JButton             intermediateButton;
    
    //combine spectrum
    static JPanel          	combineSpectrumPanel;
    static JLabel          	combineSpectrumLabel;
    static ButtonGroup     	combineSpectrumButtonGroup;
    static JRadioButton    	yesCombineSpectrumRadioButton;
    static JRadioButton    	noCombineSpectrumRadioButton;

    //instrument geometry file
    static JPanel          	instrumentGeometryPanel;
    static JLabel          	instrumentGeometryLabel;
    static JRadioButton    	yesInstrumentGeometryRadioButton;
    static JRadioButton    	noInstrumentGeometryRadioButton;
    static ButtonGroup     	instrumentGeometryButtonGroup;
    static JButton      instrumentGeometryButton;
    static JTextField   instrumentGeometryTextField;

    //start data reduction
    static JPanel          	startDataReductionPanel;
    static JButton         	startDataReductionButton;

    static JComboBox       	instrList;
    static IONVariable  instr;
    static IONVariable     	user;
    
    static int             	x_min;
    static int             	x_max;
    static int             	y_min;
    static int             	y_max;

    static IONVariable     	a_idl;
    static IONVariable     	iVar;
    static IONVariable     	ionVar;
    static IONVariable     	IONfoundNexusAndNtof;
    static IONVariable     	IONfoundNexus;
    static IONVariable    		ionCmd;
    static IONVariable     	ionOutputPath;
    static IONVariable     	ionNtof;
    static IONVariable     	ionY12;
    static IONVariable     	ionYmin;
    
    static boolean      	    bFoundNexus = false;
    
//parameters used to define the graphical window and the selection tool
    static int             Nx;
    static int             Ny;
    static int             NyMin;
    static int             NyMax;
    
    static int		        c_xval1=0;	  // initial x for rubber band box
    static int			    c_yval1=0;	  // initial y for rubber band box
    static int		    	c_xval2=0;	  // final x for rubber band box
    static int			    c_yval2=0;	  // final y for rubber band box
    static int			    c_x1=0;		  // initial x java
    static int			    c_y1=0;		  // initial y java
    static int		    	c_x2=0;		  // final x java
    static int		    	c_y2=0;		  // final y java
    static int             a=0;

    
    static String          hostname;

    //menu
    static JMenuBar        menuBar;
    static JMenu           dataReductionPackMenu;
    static JMenu           modeMenu;
    static JMenu           parametersMenu;
    static JMenu           saveSessionMenu;

    //JMenuItem of DataReductionMenu
    static JMenuItem       preferencesMenuItem;
//    InternalFrame   preferencesFrame;

    //JMenuItem of mode
    static ButtonGroup     		modeButtonGroup;
    static JRadioButtonMenuItem    signalSelectionModeMenuItem;
    static JRadioButtonMenuItem    background1SelectionModeMenuItem;
    static JRadioButtonMenuItem    background2SelectionModeMenuItem;
    static JRadioButtonMenuItem    infoModeMenuItem;
    static JCheckBoxMenuItem       cbMenuItem;
    static String  			    modeSelected="signalSelection";//signalSelection, back1Selection, back2Selection, info

    static JMenu           		intermediateMenu;

    //JMenuItem of instruments
    static JMenu           		instrumentMenu;
    static JRadioButtonMenuItem 	reflRadioButton;
    static JRadioButtonMenuItem 	refmRadioButton;
    static JRadioButtonMenuItem 	bssRadioButton;
    static ButtonGroup     		instrumentButtonGroup;

    //JMenuItem of save session in parameters
    static ButtonGroup          	saveFullSessionButtonGroup;
    static JRadioButtonMenuItem 	yesSaveFullSessionMenuItem;
    static JRadioButtonMenuItem 	noSaveFullSessionMenu;

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
      runNumberTextField.requestFocusInWindow();

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
 
  /**
   * This method initialize all the parameters used to display the GUI.
   *
   */
  private void initializeParameters() {
	   
	  	//retrieve Nx, Ny, NyMin and NyMax according to instrument type
	    //used to display data
	    getN = new DisplayConfiguration(instrument);
	    Nx = getN.retrieveNx();
	    ParametersConfiguration.Nx = Nx;
	    Ny = getN.retrieveNy();
	    ParametersConfiguration.Ny = Ny;
		NyMin = getN.retrieveNyMin();
	    NyMax = getN.retrieveNyMax();
	  
	    //NeXus not found yet
	    IONfoundNexus = new IONVariable((int)0);  
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
    c_dataReductionPlot.addIONMouseListener(this, IONMouseListener.ION_MOUSE_DOWN);

    // Add the drawables to the connection
    c_ionCon.addDrawable(c_plot);
    c_ionCon.addDrawable(c_dataReductionPlot);
    
  }

/*
 *******************************************
 * Mouse Listener Implementation
 */
  public void mousePressed(com.rsi.ion.IONDrawable drawable, int X, int Y, 
                    long when, int mask)
  {
	  	  
	  if (bFoundNexus) {

	  if (X < 0) {X = 0;};
	  if (Y < NyMin*2) {Y = NyMin*2;};
	  if (X > Nx*2) {X = 2*Nx-1;};
	  if (Y > 2*NyMax) {Y = 2*Ny-1;};
	  
	  if (mask == 1) {  //left click
		  if (modeSelected.compareTo("signalSelection") == 0) {
			  MouseSelectionParameters.signal_x1 = X;
			  MouseSelectionParameters.signal_y1 = Y;
		  } else if (modeSelected.compareTo("back1Selection") == 0) {
			  MouseSelectionParameters.back1_x1 = X;
			  MouseSelectionParameters.back1_y1 = Y;
		  } else if (modeSelected.compareTo("back2Selection") == 0) {
			  MouseSelectionParameters.back2_x1 = X;
			  MouseSelectionParameters.back2_y1 = Y;
		  }
	  } 
	  
	  if (mask == 4) {  //rigth click
		  MouseSelectionParameters.info_x = X;
	      MouseSelectionParameters.info_y = Y;
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
    	
    	
	if (bFoundNexus) {
	  
		if (X < 0) {X = 0;};
	    if (Y < 2*NyMin) {Y = 2*NyMin;};
	    if (X > 2*Nx) {X = 2*Nx-1;};
	    if (Y > 2*NyMax) {Y = 2*Ny-1;};
	    
	    c_xval2 = (int) X/2;
	    c_yval2 = (int) (607-Y)/2;

	    if (mask == 1) { //left click
	    	if (modeSelected.compareTo("signalSelection") == 0) {
	    		MouseSelectionParameters.signal_x2 = X;
	    		MouseSelectionParameters.signal_y2 = Y;
	    	} else if (modeSelected.compareTo("back1Selection") == 0) {
	    		MouseSelectionParameters.back1_x2 = X;
	    		MouseSelectionParameters.back1_y2 = Y;
	    	} else if (modeSelected.compareTo("back2Selection") == 0) {
	    		MouseSelectionParameters.back2_x2 = X;
	    		MouseSelectionParameters.back2_y2 = Y;
	    	}
	    	doBox();
	    }
	    	
	    if (mask == 4) {  //right click
	    	MouseSelectionParameters.info_x = X;
	    	MouseSelectionParameters.info_y = Y;
	    }
	    
	    c_plot.addIONMouseListener(this, com.rsi.ion.IONMouseListener.ION_MOUSE_ANY);
	}
	return;
    }
    
    public void mouseReleased(com.rsi.ion.IONDrawable drawable, int X, int Y, 
			      long when, int mask)
    { 
      if (bFoundNexus) {
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
	  
	if (IONfoundNexus.toString().compareTo("0") != 0) {

	    if (X < 0) {X = 0;};
	    if (Y < 2*NyMin) {Y = 2*NyMin;};
	    if (X > 2*Nx) {X = 2*Nx-1;};
	    if (Y > 2*NyMax) {Y = 2*Ny-1;};
	    
	    if (mask == 1) {  //left click
	    	if (modeSelected.compareTo("signalSelection") == 0) {
	    		signalPidFileButton.setEnabled(true);
	    		MouseSelection.saveXY(IParameters.SIGNAL_STRING,x_min, y_min, x_max, y_max);
	    		ParametersConfiguration.iY12 = y_max - y_min + 1;
	    	} else if (modeSelected.compareTo("back1Selection") == 0) {
	    		backgroundPidFileButton.setEnabled(true);
	    		MouseSelection.saveXY(IParameters.BACK1_STRING,x_min, y_min, x_max, y_max);
	    	} else if (modeSelected.compareTo("back2Selection") == 0) {
	    		MouseSelection.saveXY(IParameters.BACK2_STRING,x_min, y_min, x_max, y_max);
	    		iBack2SelectionExist = 1;
	    	} 
	    	doBox();
	    }
	    
	    if (mask == 4) {  //right click
	    	MouseSelection.saveXYinfo(x_max, y_max);
	    	dataReductionTabbedPane.setSelectedIndex(0);
	    	tabbedPane.setSelectedIndex(1);
	    	selectionTab.setSelectedIndex(3);
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
	
    //fill all widgets parameters each time an action is done
   	CheckGUI.populateCheckDataReductionButtonValidationParameters();
   	CheckGUI.populateCheckDataReductionPlotParameters();

   	if ("signalPidFileButton".equals(evt.getActionCommand())) {
		SaveSignalPidFileAction.signalPidFileButton();
	}
	
	if ("clearSignalPidFileButton".equals(evt.getActionCommand())) {
		SaveSignalPidFileAction.clearSignalPidFileAction();
		doBox();
	}
	
	if ("backgroundPidFileButton".equals(evt.getActionCommand())) {
		SaveBackgroundPidFileAction.backgroundPidFileButton();
	}
	
	if ("clearBackPidFileButton".equals(evt.getActionCommand())) {
		SaveBackgroundPidFileAction.clearBackgroundPidFileAction();
		doBox();
	}
	
	if ("xValidateButton".equals(evt.getActionCommand()) ||
		"yValidateButton".equals(evt.getActionCommand()) ||
		"xMaxTextField".equals(evt.getActionCommand()) ||
		"xMinTextField".equals(evt.getActionCommand()) ||
		"yMaxTextField".equals(evt.getActionCommand()) ||
		"yMinTextField".equals(evt.getActionCommand())) {
		if (CheckDataReductionButtonValidation.bCombineDataSpectrum) { //combine plot
			UpdateDataReductionPlotCombineInterface.validateDataReductionPlotCombineXYAxis();
		} else { //uncombine plot
			UpdateDataReductionPlotUncombineInterface.validateDataReductionPlotUncombineXYAxis();
		}
	}
		
	if ("xResetButton".equals(evt.getActionCommand())) {
		UpdateDataReductionPlotCombineInterface.resetDataReductionPlotCombineXAxis();
	}
	
	if ("yResetButton".equals(evt.getActionCommand())) {
		if (CheckDataReductionButtonValidation.bCombineDataSpectrum) { //combine plot
			UpdateDataReductionPlotCombineInterface.resetDataReductionPlotCombineYAxis();
		} else {
			UpdateDataReductionPlotUncombineInterface.resetDataReductionPlotUncombineYAxis();
		}
	}
	
	if ("yesNormalization".equals(evt.getActionCommand())) {
	  	NormalizationAction.yesNormalization();
	}

	if ("noNormalization".equals(evt.getActionCommand())) {
	   	NormalizationAction.noNormalization();
	}
	    
	if ("normalizationTextField".equals(evt.getActionCommand())) {
	   	NormalizationAction.yesNormalization();
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

	if ("yesIntermediate".equals(evt.getActionCommand())) {
		intermediateButton.setEnabled(true);
	}

	if ("noIntermediate".equals(evt.getActionCommand())) {
		intermediateButton.setEnabled(false);
	}

	if ("intermediateButton".equals(evt.getActionCommand())) {
		System.out.println("I just pressed intermediateButton");
	}
	    
	if ("yesCombineSpectrum".equals(evt.getActionCommand())) {
	   	CheckDataReductionButtonValidation.bCombineDataSpectrum = true;
	   	CheckGUI.enableDataReductionPlotXAxis();
	}

	if ("noCombineSpectrum".equals(evt.getActionCommand())) {
	   	CheckDataReductionButtonValidation.bCombineDataSpectrum = false;
	   	CheckGUI.disableDataReductionPlotXAxis();
	}
	    
	if ("yesInstrumentGeometry".equals(evt.getActionCommand())) {
	   	InstrumentGeometryAction.yesInstrumentGeometry();
	}

	if ("noInstrumentGeometry".equals(evt.getActionCommand())) {
	   	InstrumentGeometryAction.noInstrumentGeometry();
	}

	if ("instrumentGeometryButton".equals(evt.getActionCommand())) {
		System.out.println("I just pressed button in instrument geometry");
	}

	if ("instrumentGeometryTextField".equals(evt.getActionCommand())) {
	   	InstrumentGeometryAction.yesInstrumentGeometry();	    		
	}

	if ("startDataReductionButton".equals(evt.getActionCommand())) {
	    	
	  	String cmd_local = RunRefDataReduction.createDataReductionCmd();
	    	
	   	c_ionCon.setDrawable(c_dataReductionPlot);
	   	ionOutputPath = new com.rsi.ion.IONVariable(IParameters.WORKING_PATH + "/" + instrument);
	    		    	
	   	String[] cmdArray = cmd_local.split(" ");
	   	int cmdArraySize = cmdArray.length;
	   	int[] nx = {cmdArraySize};
	   	ionCmd = new IONVariable(cmdArray,nx); 
	   	sendIDLVariable("IDLcmd", ionCmd);
	    		    	
	   	String cmd;
	   	if (CheckDataReductionButtonValidation.bCombineDataSpectrum) { //combine data
	    		
	   		cmd = "array_result = run_data_reduction_combine (IDLcmd, " + ionOutputPath + "," + runNumberValue + "," + instr + ")";
	    	showStatus("Processing...");
	    	executeCmd(cmd);
	    	showStatus("Done!");

    		IONVariable myIONresult;
    		myIONresult = queryVariable("array_result");
	    	String[] myResultArray;
	    	myResultArray = myIONresult.getStringArray();
	    			    		
	    	CheckGUI.populateCheckDataReductionPlotCombineParameters(myResultArray);
	    	UpdateDataReductionPlotCombineInterface.updateDataReductionPlotGUI();
	    	
	    } else {
	    
	    	ionNtof = new IONVariable(ParametersConfiguration.iNtof);
		   	ionY12 = new IONVariable(ParametersConfiguration.iY12);
		   	ionYmin = new IONVariable(MouseSelectionParameters.signal_ymin);
		   	
		   	cmd = "array_result = run_data_reduction (IDLcmd, " + ionOutputPath + "," + runNumberValue + "," ;
	    	cmd += instr + "," + ionNtof + "," + ionY12 + "," + ionYmin + ")"; 
	    	
	    	showStatus("Processing...");
		   	executeCmd(cmd);
		   	showStatus("Done!");
	    
    		IONVariable myIONresult;
    		myIONresult = queryVariable("array_result");
	    	String[] myResultArray;
	    	myResultArray = myIONresult.getStringArray();
		   	
	    	CheckGUI.populateCheckDataReductionPlotParameters(myResultArray);
	    	UpdateDataReductionPlotUncombineInterface.updateDataReductionPlotGUI();
	    }
	    	    	
	   	//show data reductin plot tab
	   	dataReductionTabbedPane.setSelectedIndex(1);
	    
	}
	    
	//if one of the intermediate check box is check
	if ("plot1".equals(evt.getActionCommand())) {
		System.out.println("in check box");
	}

	if ("instrumentREFL".equals(evt.getActionCommand())) {
	   	displayInstrumentLogo(0);
	  	instrument = "REF_L";
	}

	if ("instrumentREFM".equals(evt.getActionCommand())) {
	   	displayInstrumentLogo(1);
	   	instrument = "REF_M";
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
	    
	if ("runsAddTextField".equals(evt.getActionCommand())) {
	}
	    
	if ("runsSequenceTextField".equals(evt.getActionCommand())) {
	}

	if ("runNumberTextField".equals(evt.getActionCommand())) {
	    	    	
		//retrive value of run number
		runNumberValue = runNumberTextField.getText();
		
		if (runNumberValue.compareTo("") != 0) {   //plot only if there is a run number
	   
			reinitializeVariables();
			
			/*
		    //retrieve name of instrument
		    instrument = (String)instrList.getSelectedItem();
		    */

		    // createVar();
		   
			instr = new com.rsi.ion.IONVariable(instrument);
			user = new com.rsi.ion.IONVariable(ucams); 

			c_ionCon.setDrawable(c_plot);
	    		    		
			String cmd = "result = plot_data( " + runNumberValue + ", " + 
			instr + ", " + user+")";
	    		
			showStatus("Processing...");
			executeCmd(cmd);
	    		
			IONVariable myIONresult;
			myIONresult = queryVariable("result");
			String[] myResultArray;
			myResultArray = myIONresult.getStringArray();
	    		
			//Nexus file found or not 
			sNexusFound = myResultArray[0];
			NexusFound foundNexus = new NexusFound(sNexusFound);
			bFoundNexus = foundNexus.isNexusFound();
	    		
			//Number of tof 
			sNtof = myResultArray[1];
			Float fNtof = new Float(sNtof);
			ParametersConfiguration.iNtof = fNtof.intValue();
				    		
			//name of tmp output file name
			sTmpOutputFileName = myResultArray[2];
			showStatus("Done!");
			checkGUI();
	    	
			//check if run number is not already part of the data reduction runs
			UpdateDataReductionRunNumberTextField.updateDataReductionRunNumbers(runNumberValue);
	    
			//update text field
			if (bFoundNexus) {
				if (CheckDataReductionButtonValidation.bAddNexusAndGo) {
					runsAddTextField.setText(CheckDataReductionButtonValidation.sAddNexusAndGoString);
	    		} else {
	    			runsSequenceTextField.setText(CheckDataReductionButtonValidation.sGoSequentiallyString);
	    		}	
	    	}	
	    }	
	}		
	    
	if (CheckDataReductionButtonValidation.checkDataReductionButtonStatus()) {
		startDataReductionButton.setEnabled(true);
	} else {
		startDataReductionButton.setEnabled(false);
	}
	    	    
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
	    tabbedPane = new JTabbedPane();
	    dataReductionTabbedPane = new JTabbedPane();
	    plotDataReductionPanel = new JPanel();

	    //build menu
	    createMenu();
	    
	    //create extra plot panel 
	    ExtraPlotPanel.buildGUI();
	  	    
	    //get the instrument logo picture and put them into an array of instrumentLogo
	    for (int i=0 ; i<NUM_LOGO_IMAGES ; i++) {
	    	instrumentLogo[i] = createImageIcon("/gov/ornl/sns/iontools/images/image" + i + ".jpg");	
	    }

	    //create top left panel (logo + run number)
	    createRunNumberPanel();

	    //main plot
	    c_plot = new IONJGrDrawable(Nx*2, Ny*2);
	    plotPanel.add(c_plot,BorderLayout.SOUTH);
	    leftPanel.add(topPanel,BorderLayout.NORTH);
	    leftPanel.add(plotPanel,BorderLayout.SOUTH);
	    	    
	    //main DataReduction-Selection-logBook tabs - first tab
	    CreateDataReductionInputGUI.createInputGui();
	    addActionListener();
	    
	    //dataReductionTabbedPane.addTab("Input", panela);  //remove_comments
	    dataReductionTabbedPane.addTab("Input", panela);
	    
	    //data reduction plot/tab
	    panelb = new JPanel();
	    CreateDataReductionPlotTab.initializeDisplay();
	    yMaxTextField.addActionListener(this);
	    yMinTextField.addActionListener(this);
	    yResetButton.addActionListener(this);
	    yValidateButton.addActionListener(this);
	    xMaxTextField.addActionListener(this);
	    xMinTextField.addActionListener(this);
	    xResetButton.addActionListener(this);
	    xValidateButton.addActionListener(this);
	  	    
		dataReductionTabbedPane.addTab("Data Reduction Plot", panelb);
	    
	    //Extra plots tab (inside data reduction tab)
	    panelc = new JPanel();
	    dataReductionTabbedPane.addTab("Extra Plots", panelc);
	    
	    tabbedPane.addTab("Data Reduction",dataReductionTabbedPane);

	    //second main tab (selection)
	    panel1 = new JPanel();
	    tabbedPane.addTab("Selection", panel1);
	    createSelectionGui();

	    //third main tab (log book)
	    panel2 = new JPanel();
	    createLogBoogGui();
	    tabbedPane.addTab("LogBook", panel2);
	    
	    //configuration tab 
	    settingsPanel = new JPanel();
	    tabbedPane.addTab("Settings", settingsPanel);
	    
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

	/** Returns an ImageIcon, or null if the path was invalid. */
	protected static ImageIcon createImageIcon(String path) {
		java.net.URL imageURL = DataReduction.class.getResource(path);
		
		if (imageURL == null) {
			System.err.println("Resource not found: " + path);
			return null;
		} else {
			return new ImageIcon(imageURL);
		}
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
	
	for (int i=0; i<3; i++) {
	    
		if (i == 0) {
			c_x1 = MouseSelectionParameters.signal_x1;
			c_y1 = MouseSelectionParameters.signal_y1;
			c_x2 = MouseSelectionParameters.signal_x2;
			c_y2 = MouseSelectionParameters.signal_y2;
			g.setColor(Color.red);
	    } else if (i == 1) {
	    	c_x1 = MouseSelectionParameters.back1_x1;
	    	c_y1 = MouseSelectionParameters.back1_y1;
	    	c_x2 = MouseSelectionParameters.back1_x2;
	    	c_y2 = MouseSelectionParameters.back1_y2;
	    	g.setColor(Color.yellow);
	    } else if (i == 2) {
	    	c_x1 = MouseSelectionParameters.back2_x1;
	    	c_y1 = MouseSelectionParameters.back2_y1;
	    	c_x2 = MouseSelectionParameters.back2_x2;
	    	c_y2 = MouseSelectionParameters.back2_y2;
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
	signalSelectionTextArea.setEditable(false);
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

	pixelInfoPanel = new JPanel();
	pixelInfoLabel = new JLabel();
	detectorLayout = createImageIcon("/gov/ornl/sns/iontools/images/detector_layout.jpg");	
	pixelInfoLabel.setIcon(detectorLayout);		
	pixelInfoTextArea = new JTextArea(30,30);
	pixelInfoPanel.add(pixelInfoLabel);
	pixelInfoPanel.add(Box.createRigidArea(new Dimension(20,0)));
	pixelInfoPanel.add(pixelInfoTextArea);
	selectionTab.addTab("Pixel info", pixelInfoPanel);
	
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

    private void displayInstrumentLogo(int instrumentIndex) {
    	instrumentLogoLabel.setIcon(instrumentLogo[instrumentIndex]);		
    }
    

    // method that check if all the parameters have been input to enable or not the GO
    // DataReduction.
//    private void enabledGoDatReduction() {
//	System.out.println("Checking if all the parameters are there");
 //   }


    private void createMenu() {

	//Create the menu bar
	menuBar = new JMenuBar();
		
	//Create the first menu
	dataReductionPackMenu = new JMenu("DataReductionPack");
	dataReductionPackMenu.setActionCommand("dataReductionPackMenu");
	dataReductionPackMenu.setMnemonic(KeyEvent.VK_D);
	dataReductionPackMenu.setEnabled(true);
	menuBar.add(dataReductionPackMenu);

	//name of instrument 
	instrumentMenu = new JMenu("Instrument");
	instrumentMenu.setMnemonic(KeyEvent.VK_I);
	dataReductionPackMenu.add(instrumentMenu);

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

	//preferences
	preferencesMenuItem = new JMenuItem("Preferences...");
	preferencesMenuItem.setMnemonic(KeyEvent.VK_C);
	preferencesMenuItem.setActionCommand("preferencesMenuItem");
	preferencesMenuItem.addActionListener(this);
	dataReductionPackMenu.add(preferencesMenuItem);

	//Create the second menu
	modeMenu = new JMenu("Mode");
	modeMenu.setActionCommand("modeMenu");
	modeMenu.setMnemonic(KeyEvent.VK_M);
	modeMenu.setEnabled(false);
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

    private void createRunNumberPanel() {
    	
	    GridBagLayout gridbag = new GridBagLayout();
	    GridBagConstraints c = new GridBagConstraints();
	    setLayout(gridbag);

	    //    	 First line (logo + label + text box)
	    instrumentLogoPanel = new JPanel();
	    c.gridx=0;
	    c.gridy=0;
	    c.gridwidth=1;
	    c.gridheight=1;
	    gridbag.setConstraints(instrumentLogoPanel,c);
	    
	    instrumentLogoLabel = new JLabel();
	    instrumentLogoLabel.setHorizontalAlignment(JLabel.CENTER);
	    instrumentLogoLabel.setVerticalAlignment(JLabel.CENTER);
	    	    
	    runNumberLabel = new JLabel("Run number: ",JLabel.LEFT);
	    c.gridx=1;
	    c.gridy=0;
	    c.gridwidth=1;
	    c.gridheight=1;
	    gridbag.setConstraints(runNumberLabel,c);

	    runNumberTextField = new JTextField(10);
	    runNumberTextField.setEditable(true);
	    runNumberTextField.setActionCommand("runNumberTextField");
	    runNumberTextField.addActionListener(this);

	    c.gridx=2;
	    c.gridy=0;
	    c.gridwidth=1;
	    c.gridheight=1;
	    gridbag.setConstraints(runNumberTextField,c);

	    /*
	    //combobox
	    instrList = new JComboBox(instrumentStrings);
	    instrList.setSelectedIndex(0);
	    instrList.addActionListener(this);
	    */
	    
	    instrumentLogoPanel.add(instrumentLogoLabel);
	    topPanel.add(instrumentLogoPanel);
	    topPanel.add(runNumberLabel);
	    topPanel.add(runNumberTextField);

	    //Display the first image
	    instrumentLogoLabel.setIcon(instrumentLogo[START_INDEX]);
	    
    }
        
    private void checkGUI() {
	
	//if the run number has been found, activate selection mode
	if (IONfoundNexus.toString().compareTo("0") == 0) { //run number has been found
	    modeMenu.setEnabled(false); 					//mode menu
	    parametersMenu.setEnabled(false);  				//parameters menu
	} else {											//run number has not been found
		modeMenu.setEnabled(true);
	    parametersMenu.setEnabled(true);
	}
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

    private void reinitializeVariables() {

    	iBack2SelectionExist = 0;  					//reinitialize back2 selection 
    	backgroundPidFileButton.setEnabled(false);  //disable background pid button
    	signalPidFileButton.setEnabled(true);       //disable signal pid button
    	
    }
    
    private void addActionListener() {
    	
    	DataReduction.signalPidFileButton.addActionListener(this);
    	DataReduction.signalPidFileTextField.addActionListener(this);
    	DataReduction.clearSignalPidFileButton.addActionListener(this);
    	DataReduction.backgroundPidFileButton.addActionListener(this);
    	DataReduction.backgroundPidFileTextField.addActionListener(this);
    	DataReduction.clearBackPidFileButton.addActionListener(this);
    	DataReduction.yesNormalizationRadioButton.addActionListener(this);
    	DataReduction.noNormalizationRadioButton.addActionListener(this);
    	DataReduction.normalizationTextField.addActionListener(this);
    	DataReduction.yesBackgroundRadioButton.addActionListener(this);
    	DataReduction.noBackgroundRadioButton.addActionListener(this);
    	DataReduction.yesNormBackgroundRadioButton.addActionListener(this);
    	DataReduction.noNormBackgroundRadioButton.addActionListener(this);
    	DataReduction.yesIntermediateRadioButton.addActionListener(this);
    	DataReduction.noIntermediateRadioButton.addActionListener(this);
    	DataReduction.intermediateButton.addActionListener(this);
    	DataReduction.yesCombineSpectrumRadioButton.addActionListener(this);
    	DataReduction.noCombineSpectrumRadioButton.addActionListener(this);
    	DataReduction.yesInstrumentGeometryRadioButton.addActionListener(this);
    	DataReduction.noInstrumentGeometryRadioButton.addActionListener(this);
    	DataReduction.instrumentGeometryButton.addActionListener(this);
    	DataReduction.instrumentGeometryTextField.addActionListener(this);
    	DataReduction.runsAddTextField.addActionListener(this);
    	DataReduction.runsSequenceTextField.addActionListener(this);
    	DataReduction.startDataReductionButton.addActionListener(this);
    	
    }
    
    
    
    
}