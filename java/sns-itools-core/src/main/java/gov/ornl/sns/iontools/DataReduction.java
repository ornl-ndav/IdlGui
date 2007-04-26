/*
 * Copyright (c) 2007, J.-C. Bilheux <bilheuxjm@ornl.gov>
 * Spallation Neutron Source at Oak Ridge National Laboratory
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

//import gov.ornl.sns.iontools.IParameters;
import gov.ornl.sns.iontools.DisplayConfiguration;
import gov.ornl.sns.iontools.IParameters;
import gov.ornl.sns.iontools.IontoolsFile;
import java.awt.BorderLayout;
import java.awt.Component;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.GridBagLayout;
import java.awt.GridBagConstraints;
//import java.awt.image.BufferedImage;
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
    String          ucams = "j35";
    DisplayConfiguration   getN;
    int             iNtof;    
    int             iY12;  			//ymax-ymin+1 (signal)
    float           fNtof;
    IONGrConnection c_ionCon;
    
    
    IONJGrDrawable   c_plot;
    Dimension       c_dimApp;
    int             c_bConnected=0; // 0 => !conn, 1 => conn, -1 => conn failed
    
    //pid files names creation
    String 			pidSignalFileName;
    String          pidBackFileName;
    String   		sNexusFound;
    String          sNtof;
    int             iBack2SelectionExist = 0;
    
    String          instrument = IParameters.DEFAULT_INSTRUMENT;
    String          text1;
    String          text2;
    String          cmd; 
    JPanel          instrumentLogoPanel;
    JLabel          instrumentLogoLabel;
    JLabel	        runNumberLabel;	
    JTextField      runNumberTextField;
    JTextArea       generalInfoTextArea;

    //def of components of data reduction tab
    JPanel          topPanel;
    String          runNumberValue;
    final static int NUM_LOGO_IMAGES = 2;
    final static int START_INDEX = 0;
    ImageIcon[]     instrumentLogo = new ImageIcon[NUM_LOGO_IMAGES];
    
    JPanel          plotPanel;
    JPanel          leftPanel;
    JPanel          plotDataReductionPanel;
    JPanel          panela; //input tab
    JPanel          panel1; //selection
    JPanel          panel2; //log book
    JPanel          panelb; //DataReductionPlot

    //Data Reduction Plot
    IONJGrDrawable   c_dataReductionPlot;	    
    JPanel 			panelZoom;
    JPanel          panelZoomXaxis;
    JPanel          panelZoomYaxis;
    JLabel          labelXaxis;
    JLabel          labelYaxis;
    JRadioButton    linXaxisRadioButton;
    JRadioButton    logXaxisRadioButton;
    JRadioButton    linYaxisRadioButton;
    JRadioButton    logYaxisRadioButton;
    ButtonGroup     xAxisButtonGroup;
    ButtonGroup     yAxisButtonGroup;
    
    JPanel          panelc; //Extra plots
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
    JButton         clearSignalPidFileButton;
    JPanel          backgroundPidPanel;
    JTextField      backgroundPidFileTextField;    
    JButton         backgroundPidFileButton;
    JButton         clearBackPidFileButton;
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
    IONVariable     IONfoundNexusAndNtof;
    IONVariable     IONfoundNexus;
    IONVariable    	ionCmd;
    IONVariable     ionOutputPath;
    IONVariable     ionNtof;
    IONVariable     ionY12;
    IONVariable     ionYmin;
    
    boolean         bFoundNexus = false;
    
//parameters used to define the graphical window and the selection tool
    int             Nx;
    int             Ny;
    int             NyMin;
    int             NyMax;
    
    int		        c_xval1=0;	  // initial x for rubber band box
    int			    c_yval1=0;	  // initial y for rubber band box
    int		    	c_xval2=0;	  // final x for rubber band box
    int			    c_yval2=0;	  // final y for rubber band box
    int			    c_x1=0;		  // initial x java
    int			    c_y1=0;		  // initial y java
    int		    	c_x2=0;		  // final x java
    int		    	c_y2=0;		  // final y java
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

    //xmin, max and ymin and max pixelid values
    int				signal_xmin;
	int 			signal_ymin;
	int 			signal_xmax;
	int 			signal_ymax;
	int				back1_xmin;
	int				back1_ymin;
	int 			back1_xmax;
	int 			back1_ymax;
	int				back2_xmin;
	int 			back2_ymin;
	int				back2_xmax;
	int 			back2_ymax;
	int				info_xmin;
	int 			info_ymin;
	int 			info_xmax;
	int 			info_ymax;
    
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
	    Ny = getN.retrieveNy();
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
    	
    	
	if (bFoundNexus) {
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
		signalPidFileButton.setEnabled(true);
		saveXY(IParameters.SIGNAL_STRING,x_min, y_min, x_max, y_max);
		doBox();
		iY12 = y_max - y_min + 1;
	    } else if (modeSelected.compareTo("back1Selection") == 0) {
		back1SelectionTextArea.setText(text1);		
		back1SelectionTextArea.append(text2);		
		backgroundPidFileButton.setEnabled(true);
		saveXY(IParameters.BACK1_STRING,x_min, y_min, x_max, y_max);
		doBox();
	    } else if (modeSelected.compareTo("back2Selection") == 0) {
		back2SelectionTextArea.setText(text1);
		back2SelectionTextArea.append(text2);
		saveXY(IParameters.BACK2_STRING,x_min, y_min, x_max, y_max);
		iBack2SelectionExist = 1;
		doBox();
	    } else {
		generalInfoTextArea.setText(text1);
		generalInfoTextArea.append(text2);
		saveXY(IParameters.INFO_STRING,x_min, y_min, x_max, y_max);
	    }
	    	
	    c_plot.addIONMouseListener(this, com.rsi.ion.IONMouseListener.ION_MOUSE_DOWN);
	    
	}
      }
      return;
    }
    
    
    public void saveXY(String mode,int x_min, int y_min, int x_max, int y_max) {
    	if (mode.compareTo(IParameters.SIGNAL_STRING) == 0) {
    		signal_xmin = x_min;
    		signal_ymin = y_min;
    		signal_xmax = x_max;
    		signal_ymax = y_max;
    	} else if (mode.compareTo(IParameters.BACK1_STRING) == 0) {
    		back1_xmin = x_min;
    		back1_ymin = y_min;
    		back1_xmax = x_max;
    		back1_ymax = y_max;
    	} else if (mode.compareTo(IParameters.BACK2_STRING) == 0) {
    		back2_xmin = x_min;
    		back2_ymin = y_min;
    		back2_xmax = x_max;
    		back2_ymax = y_max;
    	} else if (mode.compareTo(IParameters.INFO_STRING) == 0) {
    		info_xmin = x_min;
    		info_ymin = y_min;
    		info_xmax = x_max;
    		info_ymax = y_max;
    	}
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
   	populateCheckDataReductionButtonValidationParameters();
    	    	
	if ("signalPidFileButton".equals(evt.getActionCommand())) {
		pidSignalFileName = IontoolsFile.createPidFileName(ucams, instrument, runNumberValue, IParameters.SIGNAL_STRING);
		signalPidFileTextField.setBackground(Color.RED);
		signalPidFileTextField.setText(pidSignalFileName);	
		
		int[] xarr = {signal_xmin, signal_xmax, signal_ymin, signal_ymax};
		int[] nx = {4};
		IONVariable IONxvals = new IONVariable(xarr,nx);
		IONVariable fullFileName = new IONVariable(pidSignalFileName);
		
		try {
			c_ionCon.setIDLVariable("XY", IONxvals);
			cmd = "CREATE_SIGNAL_PID_FILE, XY, " + fullFileName;
		} catch (Exception e) {
		}
		executeCmd(cmd);		
		clearSignalPidFileButton.setEnabled(true);
		CheckDataReductionButtonValidation.bSignalPidFileSaved = true;
		CheckDataReductionButtonValidation.sSignalPidFile = pidSignalFileName;
//		System.out.println("pidSignalFileName: " + pidSignalFileName);
	}
	
	if ("clearSignalPidFileButton".equals(evt.getActionCommand())) {
		signalPidFileTextField.setBackground(Color.WHITE);
		signalPidFileTextField.setText("");	
		saveXY(IParameters.SIGNAL_STRING,0,0,0,0);
		signal_x1 =signal_y1 = signal_x2 = signal_y2 = 0;
		doBox();
		clearSignalPidFileButton.setEnabled(false);
		signalPidFileButton.setEnabled(false);
		CheckDataReductionButtonValidation.bSignalPidFileSaved = false;
		CheckDataReductionButtonValidation.sSignalPidFile = "";
	}
	
	if ("backgroundPidFileButton".equals(evt.getActionCommand())) {
		pidBackFileName = IontoolsFile.createPidFileName(ucams, instrument, runNumberValue, IParameters.BACK_STRING);
		backgroundPidFileTextField.setBackground(Color.RED);
		backgroundPidFileTextField.setText(pidBackFileName);
	
		IONVariable fullFileName = new IONVariable(pidBackFileName);
		
		int[] xarrSignal = {signal_xmin, signal_xmax, signal_ymin, signal_ymax};
		int[] xarrBack1 = {back1_xmin, back1_xmax, back1_ymin, back1_ymax};
		int[] xarrBack2 = {back2_xmin, back2_xmax, back2_ymin, back2_ymax};
		int[] nx = {4};
		IONVariable IONxvalsSignal = new IONVariable(xarrSignal,nx);
		IONVariable IONxvalsBack1 = new IONVariable(xarrBack1, nx);
		IONVariable IONxvalsBack2 = new IONVariable(xarrBack2, nx);
		IONVariable ionBack2Selected = new IONVariable(iBack2SelectionExist);
		IONVariable ionNx = new IONVariable(Nx);
		IONVariable ionNy = new IONVariable(Ny);
		
		try {
			c_ionCon.setIDLVariable("back2Selected", ionBack2Selected);
			c_ionCon.setIDLVariable("Nx", ionNx);
			c_ionCon.setIDLVariable("Ny", ionNy);
			c_ionCon.setIDLVariable("XY_signal", IONxvalsSignal);
			c_ionCon.setIDLVariable("XY_back1", IONxvalsBack1);
			c_ionCon.setIDLVariable("XY_back2", IONxvalsBack2);
			cmd = "CREATE_BACKGROUND_PID_FILE, Nx, Ny, XY_signal, XY_back1, XY_back2, back2Selected, " + fullFileName;
		} catch (Exception e) {
		}
		executeCmd(cmd);		
		clearBackPidFileButton.setEnabled(true);
		CheckDataReductionButtonValidation.bBackPidFileSaved = true;
		CheckDataReductionButtonValidation.sBackPidFile = pidBackFileName;
	}
	
	if ("clearBackPidFileButton".equals(evt.getActionCommand())) {
		backgroundPidFileTextField.setBackground(Color.WHITE);
		backgroundPidFileTextField.setText("");	
		saveXY(IParameters.BACK1_STRING,0,0,0,0);
		saveXY(IParameters.BACK2_STRING,0,0,0,0);
		back1_x1 = back1_y1 = back1_x2 = back1_y2 = 0;
		back2_x1 = back2_y1 = back2_x2 = back2_y2 = 0;
		doBox();
		clearBackPidFileButton.setEnabled(false);
		backgroundPidFileButton.setEnabled(false);
		CheckDataReductionButtonValidation.bBackPidFileSaved = false;
		CheckDataReductionButtonValidation.sBackPidFile = "";
	}
	
	//if ("backgroundPidFileTextField".equals(evt.getActionCommand())) {
	  //}

	    if ("yesNormalization".equals(evt.getActionCommand())) {
		normalizationTextField.setEnabled(true);
		normalizationTextBoxLabel.setEnabled(true);
		CheckDataReductionButtonValidation.bNormalizationSwitch = true;
	    }

	    if ("noNormalization".equals(evt.getActionCommand())) {
		normalizationTextField.setEnabled(false);
		normalizationTextBoxLabel.setEnabled(false);
		CheckDataReductionButtonValidation.bNormalizationSwitch = false;
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
	    	CheckDataReductionButtonValidation.bCombineDataSpectrum = true;
	    }

	    if ("noCombineBackground".equals(evt.getActionCommand())) {
	    	CheckDataReductionButtonValidation.bCombineDataSpectrum = false;
	    }
	    
	    if ("yesInstrumentGeometry".equals(evt.getActionCommand())) {
	    instrumentGeometryButton.setEnabled(true);
		instrumentGeometryTextField.setEnabled(true);
		CheckDataReductionButtonValidation.bOverwriteInstrumentGeometry = true;
	    }

	    if ("noInstrumentGeometry".equals(evt.getActionCommand())) {
		instrumentGeometryButton.setEnabled(false);
		instrumentGeometryTextField.setEnabled(false);
		CheckDataReductionButtonValidation.bOverwriteInstrumentGeometry = false;
	    }

	    if ("instrumentGeometryButton".equals(evt.getActionCommand())) {
		System.out.println("I just pressed button in instrument geometry");
	    }

	    if ("instrumentGeometryTextField".equals(evt.getActionCommand())) {
	    	
	    }

	    if ("startDataReductionButton".equals(evt.getActionCommand())) {
	    	
	    	String cmd_local = RunRefDataReduction.createDataReductionCmd();
	    	
	    	c_ionCon.setDrawable(c_dataReductionPlot);
	    	ionOutputPath = new com.rsi.ion.IONVariable(IParameters.WORKING_PATH + "/" + instrument);
	    	
	    	String[] cmdArray = cmd_local.split(" ");
	    	int cmdArraySize = cmdArray.length;
	    	int[] nx = {cmdArraySize};
	    	ionCmd = new IONVariable(cmdArray,nx); 
	    	ionNtof = new IONVariable(iNtof);
	    	ionY12 = new IONVariable(iY12);
	    	ionYmin = new IONVariable(y_min);
	    	sendIDLVariable("IDLcmd", ionCmd);
	    		    	
	    	String cmd;
	    	if (CheckDataReductionButtonValidation.bCombineDataSpectrum) { //combine data
	    		cmd = "run_data_reduction_combine, IDLcmd, " + ionOutputPath + "," + runNumberValue + "," + instr;  
	    	} else {
	    		cmd = "run_data_reduction, IDLcmd, " + ionOutputPath + "," + runNumberValue + "," + instr + "," + ionNtof + "," + ionY12 + "," + ionYmin; 
	    	}
	    		
	    	showStatus("Processing...");
	    	executeCmd(cmd);
	    	showStatus("Done!");
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
	    		iNtof = fNtof.intValue();
	    		
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
	    panela = new JPanel();
	    dataReductionTabbedPane.addTab("Input", panela);
	    createInputGUI();

	    //data reduction plot/tab
	    panelb = new JPanel();
	    createDataReductionPlotPanel();
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
	    	c_y1= back2_y1;
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


    private void createDataReductionPlotPanel() {
		
//    	main panel of data reduction plot
    	panelb.setLayout(new BoxLayout(panelb,BoxLayout.Y_AXIS));
    	
    	JPanel dataReductionPlotPanel = new JPanel();
    	//zoom x-axis
    	c_dataReductionPlot = new IONJGrDrawable(IParameters.DATA_REDUCTION_PLOT_X, IParameters.DATA_REDUCTION_PLOT_Y);
    	c_dataReductionPlot.setAlignmentX(CENTER_ALIGNMENT);
    	dataReductionPlotPanel.add(c_dataReductionPlot);
    	dataReductionPlotPanel.setAlignmentX(CENTER_ALIGNMENT);
    	panelb.add(c_dataReductionPlot);
    	
    	panelZoom = new JPanel();
    	
	    //panel x-axis
    	//panelZoomXaxis = new JPanel(new FlowLayout(FlowLayout.CENTER));
    	panelZoomXaxis = new JPanel();
	    labelXaxis = new JLabel("X-axis");
	    linXaxisRadioButton = new JRadioButton("Linear");
	    linXaxisRadioButton.setSelected(true);
	    logXaxisRadioButton = new JRadioButton("Log10");
	    xAxisButtonGroup = new ButtonGroup();
	    xAxisButtonGroup.add(linXaxisRadioButton);
	    xAxisButtonGroup.add(logXaxisRadioButton);
	    panelZoomXaxis.add(linXaxisRadioButton);
	    panelZoomXaxis.add(logXaxisRadioButton);
	    	    
	    //panel y-axis
	    //panelZoomYaxis = new JPanel(new FlowLayout(FlowLayout.CENTER));
	    panelZoomYaxis = new JPanel();
	    labelYaxis = new JLabel("Y-axis");	
	    linYaxisRadioButton = new JRadioButton("Linear");
	    linYaxisRadioButton.setSelected(true);
	    logYaxisRadioButton = new JRadioButton("Log10");
	    yAxisButtonGroup = new ButtonGroup();
	    yAxisButtonGroup.add(linYaxisRadioButton);
	    yAxisButtonGroup.add(logYaxisRadioButton);
	    panelZoomYaxis.add(linYaxisRadioButton);
	    panelZoomYaxis.add(logYaxisRadioButton);
	    
	    panelZoom.add(panelZoomXaxis,BorderLayout.CENTER);
	    panelZoom.add(panelZoomYaxis,BorderLayout.PAGE_END);
	    panelb.add(panelZoom, BorderLayout.PAGE_END);
	    
	    
	    
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

    private void displayInstrumentLogo(int instrumentIndex) {
	    instrumentLogoLabel.setIcon(instrumentLogo[instrumentIndex]);		
    }
    

    private void createInputGUI() {

	//definition of variables
	buttonSignalBackgroundPanel = new JPanel(new GridLayout(0,1));   
	textFieldSignalBackgroundPanel = new JPanel(new GridLayout(0,1));
	JPanel clearSelectionPanel = new JPanel(new GridLayout(0,1));
	signalBackgroundPanel = new JPanel() ; 

	signalPidPanel = new JPanel();
	backgroundPidPanel = new JPanel();
	normalizationPanel = new JPanel(new FlowLayout(FlowLayout.LEADING));
	backgroundPanel = new JPanel(new FlowLayout(FlowLayout.LEADING));
	normBackgroundPanel = new JPanel(new FlowLayout(FlowLayout.LEADING));

	startDataReductionPanel = new JPanel(new FlowLayout());

	//signal pid infos
	signalPidFileButton = new JButton("Save Signal PID file");
	signalPidFileButton.setActionCommand("signalPidFileButton");
	signalPidFileButton.addActionListener(this);
	signalPidFileButton.setEnabled(false);
	signalPidFileButton.setToolTipText("Select a signal PID file");
	
	signalPidFileTextField = new JTextField(40);
	signalPidFileTextField.setEditable(false);
	signalPidFileTextField.setActionCommand("signalPidFileTextField");
	signalPidFileTextField.addActionListener(this);
	
	clearSignalPidFileButton = new JButton ("Clear signal");
	clearSignalPidFileButton.setActionCommand("clearSignalPidFileButton");
	clearSignalPidFileButton.addActionListener(this);
	clearSignalPidFileButton.setEnabled(false);
	clearSignalPidFileButton.setToolTipText("Reset the signal selection (file and display)");
		
	//background pid infos
	backgroundPidFileButton = new JButton("Save Background PID file");
	backgroundPidFileButton.setActionCommand("backgroundPidFileButton");
	backgroundPidFileButton.setEnabled(false);
	backgroundPidFileButton.addActionListener(this);
	backgroundPidFileButton.setToolTipText("Select a background PID file");
	
	backgroundPidFileTextField = new JTextField(40);
	backgroundPidFileTextField.setEditable(false);
	backgroundPidFileTextField.setActionCommand("backgroundPidFileTextField");
	backgroundPidFileTextField.addActionListener(this);

	clearBackPidFileButton = new JButton("Clear background");
	clearBackPidFileButton.setActionCommand("clearBackPidFileButton");
	clearBackPidFileButton.addActionListener(this);
	clearBackPidFileButton.setEnabled(false);
	clearBackPidFileButton.setToolTipText("Reset the background selection (file and display)");
	
	buttonSignalBackgroundPanel.add(signalPidFileButton);
	buttonSignalBackgroundPanel.add(backgroundPidFileButton);
	textFieldSignalBackgroundPanel.add(signalPidFileTextField);
	textFieldSignalBackgroundPanel.add(backgroundPidFileTextField);
	clearSelectionPanel.add(clearSignalPidFileButton);
	clearSelectionPanel.add(clearBackPidFileButton);
	signalBackgroundPanel.add(buttonSignalBackgroundPanel,BorderLayout.LINE_START);
	signalBackgroundPanel.add(textFieldSignalBackgroundPanel,BorderLayout.CENTER);
	signalBackgroundPanel.add(clearSelectionPanel,BorderLayout.LINE_END);
	
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
	    
	//intermediate plots
	intermediatePanel = new JPanel(new FlowLayout(FlowLayout.LEADING));
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

	intermediateButton = new JButton("Intermediate Plots");
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
	yesCombineSpectrumRadioButton.setSelected(false);
	yesCombineSpectrumRadioButton.addActionListener(this);

	noCombineSpectrumRadioButton = new JRadioButton("No");
	noCombineSpectrumRadioButton.setSelected(true);
	noCombineSpectrumRadioButton.setActionCommand("noCombineBackground");
	noCombineSpectrumRadioButton.addActionListener(this);

	combineSpectrumButtonGroup = new ButtonGroup();
	combineSpectrumButtonGroup.add(yesCombineSpectrumRadioButton);
	combineSpectrumButtonGroup.add(noCombineSpectrumRadioButton);

	combineSpectrumPanel.add(combineSpectrumLabel);
	combineSpectrumPanel.add(yesCombineSpectrumRadioButton);
	combineSpectrumPanel.add(noCombineSpectrumRadioButton);

	//overwrite instrument geometry
	instrumentGeometryPanel = new JPanel(new FlowLayout(FlowLayout.LEADING));
	instrumentGeometryLabel = new JLabel(" Overwrite instrument geometry:");
	
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

	instrumentGeometryPanel.add(instrumentGeometryLabel);
	instrumentGeometryPanel.add(yesInstrumentGeometryRadioButton);
	instrumentGeometryPanel.add(noInstrumentGeometryRadioButton);
	instrumentGeometryPanel.add(instrumentGeometryButton);
	instrumentGeometryPanel.add(instrumentGeometryTextField);

	//tab of runs 
	runsTabbedPane = new JTabbedPane();
	runsAddPanel = new JPanel(new FlowLayout());
	runsSequencePanel = new JPanel(new FlowLayout());

	runsAddLabel = new JLabel(" Run(s) number: ");
	runsAddTextField = new JTextField(30);
	runsAddTextField.setToolTipText("1230,1231,1234-1238,1240");
	runsAddTextField.setEditable(true);
	runsAddTextField.setActionCommand("runsAddTextField");
	runsAddTextField.addActionListener(this);
	runsAddPanel.add(runsAddLabel);
	runsAddPanel.add(runsAddTextField);
	runsTabbedPane.addTab("Add NeXus and GO",runsAddPanel);

	runsSequenceLabel = new JLabel(" Run(s) number: ");
	runsSequenceTextField = new JTextField(30);
	runsSequenceTextField.setToolTipText("1230,1231,1234-1238,1240");
	runsSequenceTextField.setEditable(true);
	runsSequenceTextField.setActionCommand("runsSequenceTextField");
	runsSequenceTextField.addActionListener(this);
	runsSequencePanel.add(runsSequenceLabel);
	runsSequencePanel.add(runsSequenceTextField);
	runsTabbedPane.addTab("GO sequentially",runsSequencePanel);

	//go button
	startDataReductionButton = new JButton(" START DATA REDUCTION ");
	startDataReductionButton.setActionCommand("startDataReductionButton");
	startDataReductionButton.addActionListener(this);
	startDataReductionButton.setToolTipText("Press to launch the data reduction");
	startDataReductionButton.setEnabled(true);
	startDataReductionPanel.add(startDataReductionButton);
	//startDataReductionButton.setEnabled(false);

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
    
    private void populateCheckDataReductionButtonValidationParameters() {
    	CheckDataReductionButtonValidation.sRunNumber = runNumberTextField.getText();
    	CheckDataReductionButtonValidation.sNormalizationRunNumber = normalizationTextField.getText(); 	    	
    	CheckDataReductionButtonValidation.sAddNexusAndGoString = runsAddTextField.getText();     
    	CheckDataReductionButtonValidation.sGoSequentiallyString = runsSequenceTextField.getText();    	
    	CheckDataReductionButtonValidation.sInstrumentGeometry = instrumentGeometryTextField.getText();
    	
    	if (runsTabbedPane.getSelectedIndex() == 0) {
    		CheckDataReductionButtonValidation.bAddNexusAndGo = true;
    	} else {
    		CheckDataReductionButtonValidation.bAddNexusAndGo = false;
    	}
    	CheckDataReductionButtonValidation.sInstrument = instrument;
    	
    	
    }
    
}
