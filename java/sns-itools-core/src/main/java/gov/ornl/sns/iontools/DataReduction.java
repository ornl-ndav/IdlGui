
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
import java.awt.GridLayout;
import java.awt.event.*;
import java.io.*;
import java.net.*;
import java.util.Arrays;
import com.rsi.ion.*;
import javax.swing.*;
import javax.swing.event.ChangeListener;
import javax.swing.event.ChangeEvent;
import java.awt.Font;
import java.util.Vector;

public class DataReduction extends JApplet implements IONDisconnectListener, 
						      IONOutputListener, 
						      ActionListener,
						      IONMouseListener
						      
{	
  // Instance Vars
    static String           ucams = "ionuser";				  //ucams
    static String           remoteUser;           
    static String           instrument = IParameters.DEFAULT_INSTRUMENT;
    static String           runNumberValue;
    static String           sTmpOutputFileName = "";         //the full name of the file that contains the dump histo data
    static String 			    pidSignalFileName = "";     //name of signal pid file
    static String           pidBackFileName = "";		    //name of back pid file
    static String	      		sNexusFound;			          //NeXus file found or not
    static String     	 	  sNtof = "";					            //Number of time of flight
    static String          	text1;
    static String          	text2;
    static String          	cmd; 
    static String           hostname;
    static String  		      modeSelected="signalSelection";//signalSelection, back1Selection, back2Selection, info
    static String           sTmpFolder;                  // ex:/SNS/users/ionuser/94545484585458454/
    static String           sTmpFolderRelativePath;      // ex: 945454845585458454
    
    
    static int              iBack2SelectionExist = 0;
    static int              c_bConnected=0; // 0 => !conn, 1 => conn, -1 => conn failed
    static int              Nx;
    static int 	            Ny;
    static int              NyMin;
    static int              NyMax;
    static int		          c_xval1=0;	  // initial x for rubber band box
    static int			        c_yval1=0;	  // initial y for rubber band box
    static int		    	    c_xval2=0;	  // final x for rubber band box
    static int			        c_yval2=0;	  // final y for rubber band box
    static int			        c_x1=0;  		  // initial x java
    static int			        c_y1=0;		    // initial y java
    static int		    	    c_x2=0;		    // final x java
    static int		    	    c_y2=0;		    // final y java
    static int              a=0;
    static int             	x_min;
    static int             	x_max;
    static int             	y_min;
    static int             	y_max;
    final static int 	      NUM_LOGO_IMAGES = 2;
    final static int 	      START_INDEX = 0;
    
    static boolean      	  bFoundNexus = false;
    static boolean 			    bEPFirstTime;
    
    static GuiLiveParameters  liveParameters;
    static ExtraPlotInterface myEPinterface;
    static ParametersToKeep   myParametersToKeep;
    
    static DisplayConfiguration    getN;
    static float                   fNtof;

    static ImageIcon[]     	instrumentLogo = new ImageIcon[NUM_LOGO_IMAGES];
    static ImageIcon     		detectorLayout = new ImageIcon();
    static ImageIcon        processingGif = new ImageIcon();
    static ImageIcon        arrowGif = new ImageIcon();
    
    //ION
    static IONGrConnection  c_ionCon;
    static IONJGrDrawable   c_plot_REFL;
    static IONJGrDrawable   c_plot_REFM;
    static IONJGrDrawable   c_plot;
    static IONJGrDrawable   c_dataReductionPlot;	     //data reduction plot    
    static IONJGrDrawable   c_SRextraPlots;            //Signal Region summed vs TOF drawing window
    static IONJGrDrawable   c_BSextraPlots;            //Background summed vs TOF
    static IONJGrDrawable   c_SRBextraPlots;           //Signal Region with background summed vs TOF
    static IONJGrDrawable   c_NRextraPlots;            //Normalization region summed vs TOF
    static IONJGrDrawable   c_BRNextraPlots;           //Background region from normalization summed TOF
    static IONJGrDrawable   c_otherPlots;
    
    static IONVariable      ionInstrument;
    static IONVariable     	user;
    static IONVariable     	a_idl;
    static IONVariable     	iVar;
    static IONVariable     	ionVar;
    static IONVariable     	IONfoundNexusAndNtof;
    static IONVariable     	IONfoundNexus;
    static IONVariable      ionCmd;
    static IONVariable     	ionOutputPath;
    static IONVariable     	ionNtof;
    static IONVariable     	ionY12;
    static IONVariable     	ionYmin;
    static IONVariable      ionLoadct;
    static IONVariable      ionExtraPlotCmd;
    static IONVariable      ionRunNumberValue;
    static IONVariable      ionWorkingPathSession;
    
    static Dimension        c_dimApp;
    
    static JPanel          	instrumentLogoPanel;
    static JPanel           topPanel;
    static JPanel 			    clearSelectionPanel ;
    static JPanel           plotPanel;
    static JPanel           leftPanel;
    static JPanel           plotDataReductionPanel;
    static JPanel           panela; //input tab			   
    static JPanel           panel1; //selection
    static JPanel           panel2; //log book
    static JPanel           panelb; //DataReductionPlot
    static JPanel           extraPlotsPanel; //Extra plots
    static JPanel           settingsPanel; //settings panel
    static JPanel           otherPlotsPanel;
    static JPanel           buttonSignalBackgroundPanel;
    static JPanel           textFieldSignalBackgroundPanel;
    static JPanel           signalBackgroundPanel;
    static JPanel          	signalPidPanel;
    static JPanel          	normalizationPanel;
    static JPanel      	    backgroundPanel;
    static JPanel          	signalSelectionPanel;
    static JPanel          	back1SelectionPanel;
    static JPanel          	back2SelectionPanel;
    static JPanel           pixelInfoPanel;
    static JPanel          	instrumentGeometryPanel;
    static JPanel           normBackgroundPanel;
    static JPanel          	runsAddPanel;
    static JPanel          	combineSpectrumPanel;
    static JPanel          	startDataReductionPanel;
    static JPanel          	intermediatePanel;
    static JPanel          	backgroundPidPanel;
    static JPanel          	normalizationTextBoxPanel;
    static JPanel          	runsSequencePanel;
    static JPanel           displayModePanel;           
    static JPanel           loadctPanel;
    static JPanel           extraPlotSettingsPanel;
    static JPanel           savingParametersSettingsPanel;
    static JPanel           wavelengthPanel;
    static JPanel           detectorAnglePanel;
    static JPanel           processingPanel;
    static JPanel           filesToTransferPanel;
    static JPanel           filesToTransferManualPanel;
    static JPanel           filesToTransferMenuPanel;
    static JPanel           filesToTransferCheckBoxPanel;
    static JPanel           settingsParametersPanel;
    
    static JTabbedPane      settingsTabbedPane; 	
    static JTabbedPane      tabbedPane;
    static JTabbedPane      dataReductionTabbedPane;
    static JTabbedPane     	selectionTab;
    static JTabbedPane      runsTabbedPane;
    static JTabbedPane      extraPlotsTabbedPane;
    
    static JMenuBar         menuBar;
    
    static JCheckBoxMenuItem  cbMenuItem;
    
    static JSplitPane       filesToTransferSplitPane;
    static JScrollPane      filesScrollPane;
    static JScrollPane      detailScrollPane;
    
    static JMenu            dataReductionPackMenu;
    static JMenu            modeMenu;
    static JMenu            parametersMenu;
    static JMenu            saveSessionMenu;
    static JMenu           	intermediateMenu;
    static JMenu            instrumentMenu;
    
    static JList            filesToTransferList;
    static JList            filesTransferedList;
    
    static JProgressBar     saveFilesToTransferProgressBar;
    
    static JRadioButtonMenuItem    reflRadioButton;
    static JRadioButtonMenuItem    refmRadioButton;
    static JRadioButtonMenuItem    bssRadioButton;
    static JRadioButtonMenuItem    signalSelectionModeMenuItem;
    static JRadioButtonMenuItem    background1SelectionModeMenuItem;
    static JRadioButtonMenuItem    background2SelectionModeMenuItem;
    static JRadioButtonMenuItem    infoModeMenuItem;
    static JRadioButtonMenuItem    yesSaveFullSessionMenuItem;
    static JRadioButtonMenuItem    noSaveFullSessionMenu;

    static JMenuItem        preferencesMenuItem;
    
    static JRadioButton     yesNormalizationRadioButton;
    static JRadioButton    	noNormalizationRadioButton;
    static JRadioButton     yesBackgroundRadioButton;
    static JRadioButton     noBackgroundRadioButton;
    static JRadioButton     yesIntermediateRadioButton;
    static JRadioButton     noIntermediateRadioButton;
    static JRadioButton    	yesCombineSpectrumRadioButton;
    static JRadioButton    	noCombineSpectrumRadioButton;
    static JRadioButton     yesNormBackgroundRadioButton;
    static JRadioButton     noNormBackgroundRadioButton;
    static JRadioButton    	yesInstrumentGeometryRadioButton;
    static JRadioButton    	noInstrumentGeometryRadioButton;
    static JRadioButton     automaticFilesTransferRadioButton;
    static JRadioButton     manualFilesTransferRadioButton;
    
    static ButtonGroup      normalizationButtonGroup;
    static ButtonGroup      backgroundButtonGroup;
    static ButtonGroup      normBackgroundButtonGroup;
    static ButtonGroup      intermediateButtonGroup;
    static ButtonGroup     	combineSpectrumButtonGroup;
    static ButtonGroup     	instrumentGeometryButtonGroup;
    static ButtonGroup     	modeButtonGroup;
    static ButtonGroup      saveFullSessionButtonGroup;
    static ButtonGroup     	instrumentButtonGroup;
    static ButtonGroup      filesTransferButtonGroup;
    
    static JCheckBox	      extraPlotsSRCheckBox;
    static JCheckBox 		    extraPlotsBSCheckBox;
    static JCheckBox        extraPlotsSRBCheckBox;
    static JCheckBox        extraPlotsNRCheckBox;
    static JCheckBox        extraPlotsBRNCheckBox;
    static JCheckBox     	  saveSignalPidFileCheckBox;
    static JCheckBox 		    saveBackPidFileCheckBox;
    static JCheckBox        saveMinWavelengthCheckBox;
    static JCheckBox 		    saveMaxWavelengthCheckBox;
    static JCheckBox  		  saveWidthWavelengthCheckBox;
    static JCheckBox		    saveDetectorAngleCheckBox;
    static JCheckBox		    saveDetectorAnglePMCheckBox;
    static JCheckBox        saveDetectorAngleUnitsCheckBox;
    static JCheckBox		    saveNormalizationCheckBox;
    static JCheckBox 		    saveBackgroundCheckBox;
    static JCheckBox     	  saveNormalizationBackgroundCheckBox;
    static JCheckBox		    saveIntermediateFileOutputCheckBox;
    static JCheckBox		    saveCombineDataSpectrumCheckBox;
    static JCheckBox		    saveOverwriteInstrumentGeometryCheckBox;
    static JCheckBox		    saveAddAndGoRunNumberCheckBox;
    static JCheckBox		    saveGoSequentiallyCheckBox;
    static JCheckBox        transferPidFilesCheckBox;
    static JCheckBox        transferDataReductionFileCheckBox;
    static JCheckBox        transferExtraPlotsCheckBox;
    static JCheckBox        transferTmpHistoCheckBox;
        
    static JLabel          	instrumentLogoLabel;
    static JLabel	          runNumberLabel;	
    static JLabel           labelXaxis;
    static JLabel           labelXaxisEP;
    static JLabel           labelYaxis;
    static JLabel           labelYaxisEP;
    static JLabel           maxLabel;
    static JLabel           maxLabelEP;
    static JLabel           minLabel;
    static JLabel           minLabelEP;
    static JLabel         	normalizationLabel;
    static JLabel           blank1Label;
    static JLabel           blank2Label;
    static JLabel           blank3Label;
    static JLabel           normalizationTextBoxLabel;
    static JLabel           normBackgroundLabel;
    static JLabel         	backgroundLabel;
    static JLabel          	runsAddLabel;
    static JLabel           pixelInfoLabel;
    static JLabel          	runsSequenceLabel;
    static JLabel          	instrumentGeometryLabel;
    static JLabel          	intermediateLabel;
    static JLabel          	combineSpectrumLabel;
    static JLabel           wavelengthLabel;
    static JLabel           wavelengthMinLabel;
    static JLabel           wavelengthMaxLabel;
    static JLabel           wavelengthWidthLabel;
    static JLabel           wavelengthAngstromsLabel;
    static JLabel           detectorAngleLabel;
    static JLabel           detectorAnglePMLabel;
    static JLabel           processingLabel;
    static JLabel           processingInfoLabel;
    static JLabel           filesToKeepArrowIcon;
    static JLabel           filesToKeepArrowIcon2;
    static JLabel           filesToKeep2Label;
    static JLabel           nbrInfoLinesDisplayedNotXmlFilesLabel;
    static JLabel           nbrInfoLinesDisplayedXmlFilesLabel;
    static JLabel           renameFileLabel;
    static JLabel           oldFileNameLabel;
    static JLabel           nxsummaryConfigFileLabel;
        
    static JTextField      	runNumberTextField;
    static JTextField       yMaxTextField;
    static JTextField       yMinTextField;
    static JTextField       xMaxTextField;
    static JTextField       xMinTextField;
    static JTextField       yMaxTextFieldEP;
    static JTextField       yMinTextFieldEP;
    static JTextField       xMaxTextFieldEP;
    static JTextField       xMinTextFieldEP;
    static JTextField       signalPidFileTextField;
    static JTextField       backgroundPidFileTextField;    
    static JTextField       normalizationTextField;
    static JTextField       runsAddTextField;
    static JTextField       runsSequenceTextField;
    static JTextField       instrumentGeometryTextField;
    static JTextField       wavelengthMinTextField;
    static JTextField       wavelengthMaxTextField;
    static JTextField       wavelengthWidthTextField;
    static JTextField       detectorAngleTextField;
    static JTextField       detectorAnglePMTextField;
    static JTextField       saveFileInfoMessageTextfield;      
    static JTextField       nbrInfoLinesDisplayedNotXmlFilesTextField;
    static JTextField       nbrInfoLinesDisplayedXmlFilesTextField;
    static JTextField       nxsummaryConfigFileTextField;
    
    static JTextArea        generalInfoTextArea;
    static JTextArea        signalSelectionTextArea;
    static JTextArea        back1SelectionTextArea;
    static JTextArea        back2SelectionTextArea;
    static JTextArea        pixelInfoTextArea;
    static JTextArea      	textAreaLogBook;
    static JTextArea        saveFileInfoTextArea;
        
    static JButton          yValidateButton;
    static JButton          yValidateButtonEP;
    static JButton          xValidateButton;
    static JButton          xValidateButtonEP;
    static JButton          yResetButton;
    static JButton          yResetButtonEP;
    static JButton          xResetButton;
    static JButton          xResetButtonEP;
    static JButton          dataReductionPlotValidateButton;
    static JButton          backgroundPidFileButton;
    static JButton          clearBackPidFileButton;
    static JButton          signalPidFileButton;
    static JButton          clearSignalPidFileButton;
    static JButton          intermediateButton;
    static JButton      	  startDataReductionButton;
    static JButton      	  instrumentGeometryButton;
    static JButton      	  settingsValidateButton; 
    static JButton          replotSelectionButton;  
    static JButton          settingsSelectAllButton;
    static JButton          settingsUnselectAllButton;
    static JButton          transferFilesButton;
    static JButton          transferRefreshButton;
    
    static JScrollPane 		  scrollPane;
    static JScrollPane      saveFileInfoScrollPane;    
    
    static Vector           vFilesToTransfer;
    static Vector           fFilesTransfered; 
    
    static JComboBox        linLogComboBoxX;
    static JComboBox        linLogComboBoxXEP;
    static JComboBox        linLogComboBoxY;
    static JComboBox        linLogComboBoxYEP;
    static JComboBox       	instrList;
    static JComboBox        loadctComboBox;
    static JComboBox        detectorAngleUnuitsComboBox;
    
    
// ******************************
// Init Method
// ******************************
  
  public void init(){

	  initializeParameters();
	  
    //get remote user ucams
    //if not found, ucams is set to developer ucams
    remoteUser = getParameter("userName");
    try {
       byte[] sTmp = remoteUser.getBytes();
    } catch (Exception e)
    {
      remoteUser = IParameters.DEVELOPER_UCAMS;
    }

    /*
      Container contentPane = getContentPane();
      contentPane.setLayout(new FlowLayout(FlowLayout.LEADING));
      
      contentPane.add(plotDataReductionPanel);
      */

      // Create connection and drawable objects
      c_ionCon   = new IONGrConnection();
      c_dimApp = getSize();
      buildGUI();	
      runNumberTextField.requestFocusInWindow();
      connectToServer();

      //create tmp folder inside ionuser
      UtilsFunction.createTmpFolder();

      //retrieve hostname
      //java.util.Properties props = System.getProperties();
      //props.list(System.out);
      //String username = System.getProperty("os.arch");
      //System.out.println("os.name: " + username);
      
      try {
        java.net.InetAddress localMachine = java.net.InetAddress.getLocalHost();
        hostname = localMachine.getHostName();
        }
        catch (java.net.UnknownHostException uhe)
        {
	      //handle exception
	  } 

        DataReduction.generalInfoTextArea.setText("WELCOME " + remoteUser); 
  }
 
  /**
   * This method initialize all the parameters used to display the GUI.
   * as well as the temporary folder created for that particular session.
   *
   */
  static void initializeParameters() {
	   
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
    SaveFilesTabAction.transferAllFilesFromCurrentSession();
    UtilsFunction.removeTmpFolder();
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
    	// temporary = "user: " + this.getCodeBase().getAuthority();
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
    c_plot_REFL.addIONMouseListener(this, IONMouseListener.ION_MOUSE_DOWN);
    c_plot_REFM.addIONMouseListener(this, IONMouseListener.ION_MOUSE_DOWN);
    c_dataReductionPlot.addIONMouseListener(this, IONMouseListener.ION_MOUSE_DOWN);

    // Add the drawables to the connection
    c_ionCon.addDrawable(c_plot_REFL);
    c_ionCon.addDrawable(c_plot_REFM);
    c_ionCon.addDrawable(c_dataReductionPlot);
    c_ionCon.addDrawable(c_SRextraPlots);
    c_ionCon.addDrawable(c_BSextraPlots);
    c_ionCon.addDrawable(c_SRBextraPlots);
    c_ionCon.addDrawable(c_NRextraPlots);
    c_ionCon.addDrawable(c_BRNextraPlots);
    c_ionCon.addDrawable(c_otherPlots);
    
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
	  c_yval1 = (int) ((NyMax*2-1)-Y)/2;
	  
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
	    c_yval2 = (int) ((NyMax*2-1)-Y)/2;

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
	    		TabUtils.addForegroundColor(tabbedPane,1);
	    		TabUtils.addForegroundColor(selectionTab, 0);
          
          //if right tab is on Other Plots and signal selection has been selected, then update
          if (tabbedPane.getSelectedIndex()==2 &&
              CreateOtherPlotsPanel.list2OfOtherPlotsComboBox.getSelectedIndex()==4 &&
              CreateOtherPlotsPanel.interactiveSelectionRadioButton.isSelected()) {
              OtherPlotsAction.selectDesiredPlot();
            } 
            
	    	} else if (modeSelected.compareTo("back1Selection") == 0) {
	    		backgroundPidFileButton.setEnabled(true);
	    		MouseSelection.saveXY(IParameters.BACK1_STRING,x_min, y_min, x_max, y_max);
	    		TabUtils.addForegroundColor(tabbedPane,1);
	    		TabUtils.addForegroundColor(selectionTab, 1);
	    	} else if (modeSelected.compareTo("back2Selection") == 0) {
	    		MouseSelection.saveXY(IParameters.BACK2_STRING,x_min, y_min, x_max, y_max);
	    		iBack2SelectionExist = 1;
          TabUtils.addForegroundColor(tabbedPane,1);
	    		TabUtils.addForegroundColor(selectionTab, 2);
	    	} 
	    	doBox();
	    }
	    
	    if (mask == 4) {  //right click
	    	MouseSelection.saveXYinfo(x_max, y_max);
	    	//if right tab is on 'other plots' and plot selected is xo or yo, update plot
        if (tabbedPane.getSelectedIndex() == 2 &&
            (CreateOtherPlotsPanel.list2OfOtherPlotsComboBox.getSelectedIndex() == 2) ||
             CreateOtherPlotsPanel.list2OfOtherPlotsComboBox.getSelectedIndex() == 3 ||
             CreateOtherPlotsPanel.list2OfOtherPlotsComboBox.getSelectedIndex() == 4) {
              OtherPlotsAction.selectDesiredPlot();
        } else {
              dataReductionTabbedPane.setSelectedIndex(0);
              tabbedPane.setSelectedIndex(1);
              selectionTab.setSelectedIndex(3);
        }
	    }
	    	
	    c_plot.addIONMouseListener(this, com.rsi.ion.IONMouseListener.ION_MOUSE_DOWN);
	}
      }
      return;
    }

    /***********************
     * doBox 
     * 
     * Purpose: Draws rubber band box with Java.
     */
      static final void doBox(){
        
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


/*	
***************************************
*  actionPerformed()
*
* Purpose:
*  Handles GUI events for displaying.
*/      
    public void actionPerformed(ActionEvent evt){
	    	
    //fill up all widgets parameters each time an action is done
    CheckGUI.populateCheckDataReductionButtonValidationParameters();	
   	CheckGUI.populateCheckDataReductionPlotParameters();
   	liveParameters = new GuiLiveParameters();
   	SuperEventHandler.lookForEvent(evt);
   	liveParameters = new GuiLiveParameters();
	
    }   
  
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
	    processingPanel = new JPanel();
	    
	    //build menu
	    CreateMenu.buildGUI();
	    	  	    
	    //get the instrument logo picture and put them into an array of instrumentLogo
	    for (int i=0 ; i<NUM_LOGO_IMAGES ; i++) {
	    	instrumentLogo[i] = createImageIcon("/gov/ornl/sns/iontools/images/image" + i + ".jpg");	
	    }

	    //processing logo and info message
	    processingInfoLabel = new JLabel("");
	    processingInfoLabel.setVisible(true);
	    processingInfoLabel.setForeground(Color.BLUE);
	    processingInfoLabel.setFont(new Font("Serif", Font.PLAIN, 20));
      processingGif = createImageIcon("/gov/ornl/sns/iontools/images/sns_logo_animated_2.gif");
      
      processingLabel = new JLabel();
	    processingLabel.setVisible(true);
	    processingLabel.setIcon(processingGif);
	    processingPanel.add(processingInfoLabel);
	    processingPanel.add(processingLabel);
	    processingPanel.setVisible(false);
	    
	    //create top left panel (logo + run number)
	    createRunNumberPanel();

	    c_plot_REFL = new IONJGrDrawable(Nx*2, Ny*2);
	    c_plot_REFL.setVisible(true);
	    c_plot_REFM = new IONJGrDrawable(Ny*2,Nx*2);
	    c_plot_REFM.setVisible(false);
	    
	    c_plot = c_plot_REFL;
	    
	    plotPanel.add(c_plot_REFL,BorderLayout.NORTH);
	    plotPanel.add(c_plot_REFM);
	    leftPanel.add(topPanel,BorderLayout.NORTH);
	    leftPanel.add(plotPanel,BorderLayout.SOUTH);
	    
	    //create loadct panel below main plot
	    LoadctPanel.buildGUI();
	    plotPanel.add(loadctComboBox,BorderLayout.SOUTH);
	
	    //main DataReduction-Selection-logBook tabs - first tab
	    CreateDataReductionInputGUI.createInputGui();
	    
	    //dataReductionTabbedPane.addTab("Input", panela);  //remove_comments
	    dataReductionTabbedPane.addTab("Input", panela);
      	    
	    //data reduction plot/tab
	    panelb = new JPanel();
	    CreateDataReductionPlotTab.initializeDisplay();
	    dataReductionTabbedPane.addTab("Data Reduction Plot", panelb);
	    
	    //Extra plots tab (inside data reduction tab)
	    CreateExtraPlotPanel.buildGUI();
	    dataReductionTabbedPane.addTab("Extra Plots", extraPlotsPanel);
	    
      //-> 1st main tab
	    tabbedPane.addTab("Data Reduction",dataReductionTabbedPane);     

	    //-> second main tab (selection)
	    panel1 = new JPanel();
	    tabbedPane.addTab("Selection", panel1);                            
	    createSelectionGui();

      //-> 3rd main tab - Other plots
	    CreateOtherPlotsPanel.createGUI();
      tabbedPane.addTab("Counts = f( TOF, X, Y )",otherPlotsPanel);
            
      //-> 4rd main tab - files to transfer tab
      filesToTransferPanel = new JPanel(new GridLayout(0,1));
      tabbedPane.addTab("Save Files", filesToTransferPanel);           
      CreateSaveFilesTabPanel.buildGUI();
	    
	    //-> 5th main tab (settings) 
	    settingsPanel = new JPanel();
	    CreateSettingsPanel.buildGUI();
	    tabbedPane.addTab("Settings", settingsPanel);       
		        
      //-> last main tab (log book) only for j35
      if (remoteUser.compareTo(IParameters.DEVELOPER_UCAMS)==0) {
        panel2 = new JPanel();
        createLogBoogGui();
        tabbedPane.addTab("LogBook", panel2);
      }

      setLayout(new BorderLayout());
	    plotDataReductionPanel.add(leftPanel,BorderLayout.WEST);
	    plotDataReductionPanel.add(tabbedPane);
	    plotDataReductionPanel.add(processingPanel);	    
	    
	    //add everything in final window
	    //	    JPanel contentPane  = new JPanel(new BorderLayout());
	    //create internal frame for preferences
	    //createFrame();
	    
	    add(plotDataReductionPanel);
	    setJMenuBar(menuBar);
	   
	    //change event handler to be able to remove blue foreground of main tab
		tabbedPane.addChangeListener(new ChangeListener() {
			public void stateChanged(ChangeEvent ev) {
        
        if (tabbedPane.getSelectedIndex()==3) { //if Transfer tab is selected
          if (ParametersToKeep.bNeedToRefreshListOfFiles) {
            SaveFilesTabAction.updateListOfFilesToTransfer(true); //refresh hashtable
            ParametersToKeep.bNeedToRefreshListOfFiles = false;
          }
        }
        TabUtils.removeColorOfParentTab(tabbedPane, selectionTab);
		}});
	    
	  //event handler for save and load selection
    CreateDataReductionInputGUI.saveLoadSelectionTabbedPane.addChangeListener(new ChangeListener() {
      public void stateChanged(ChangeEvent ev) {
        
        //if load tab is selected
        if (CreateDataReductionInputGUI.saveLoadSelectionTabbedPane.getSelectedIndex()==1 && 
            ParametersToKeep.bThreadInProcess != true) {
          LoadSelectionPidFileAction.getListOfPidFilesInHomeDirectory();
        }
        
      }});
    
    addActionListener();
      DisplayConfiguration.colorTabsBackground();

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
	  c_ionCon.setIDLVariable("instrument",ionInstrument);
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
  public void writeMessage(String sMsg){
        showStatus(sMsg);
  }
    

    private void createSelectionGui() {
	//definition of variables
	selectionTab = new JTabbedPane();
	
	signalSelectionPanel = new JPanel();
	signalSelectionTextArea = new JTextArea(40,50);
  signalSelectionTextArea.setEditable(false);
    signalSelectionPanel.add(signalSelectionTextArea);
	selectionTab.addTab("Signal", signalSelectionPanel);

	back1SelectionPanel = new JPanel();
	back1SelectionTextArea = new JTextArea(40,50);
  back1SelectionTextArea.setEditable(false);
	back1SelectionPanel.add(back1SelectionTextArea);
	selectionTab.addTab("Background 1", back1SelectionPanel);

	back2SelectionPanel = new JPanel();
	back2SelectionTextArea = new JTextArea(40,50);
  back2SelectionTextArea.setEditable(false);
	back2SelectionPanel.add(back2SelectionTextArea);
	selectionTab.addTab("Background 2", back2SelectionPanel);

	pixelInfoPanel = new JPanel();
	pixelInfoLabel = new JLabel();
	detectorLayout = createImageIcon("/gov/ornl/sns/iontools/images/detector_layout.jpg");	
	pixelInfoLabel.setIcon(detectorLayout);		
	pixelInfoTextArea = new JTextArea(30,30);
  pixelInfoTextArea.setEditable(false);
	pixelInfoPanel.add(pixelInfoLabel);
	pixelInfoPanel.add(Box.createRigidArea(new Dimension(20,0)));
	pixelInfoPanel.add(pixelInfoTextArea);
	selectionTab.addTab("Pixel info", pixelInfoPanel);

	//change event handler to be able to remove blue foreground
	selectionTab.addChangeListener(new ChangeListener() {
		public void stateChanged(ChangeEvent ev) {
			TabUtils.removeColorWhenClicked(selectionTab);
			TabUtils.removeColorOfParentTab(tabbedPane,selectionTab);
	}});
	
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

    static void displayInstrumentLogo(int instrumentIndex) {
    	instrumentLogoLabel.setIcon(instrumentLogo[instrumentIndex]);		
    }
    

    // method that check if all the parameters have been input to enable or not the GO
    // DataReduction.
//    private void enabledGoDatReduction() {
//	System.out.println("Checking if all the parameters are there");
 //   }
    
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
	    	    
	    runNumberLabel = new JLabel("Run #",JLabel.LEFT);
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

	    replotSelectionButton = new JButton("<html><font size=2>Replot Selection</html>");
	    replotSelectionButton.setPreferredSize(new Dimension(90,30));
	    replotSelectionButton.setActionCommand("replotSelectionButton");
	    replotSelectionButton.addActionListener(this);
	    
	    c.gridx=3;
	    c.gridy=0;
	    c.gridwidth=1;
	    c.gridheight=1;
	    gridbag.setConstraints(replotSelectionButton,c);
	    
	    instrumentLogoPanel.add(instrumentLogoLabel);
	    topPanel.add(instrumentLogoPanel);
	    topPanel.add(runNumberLabel);
	    topPanel.add(runNumberTextField);
	    topPanel.add(replotSelectionButton);
	    
	    //Display the first image
	    instrumentLogoLabel.setIcon(instrumentLogo[START_INDEX]);
	    
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

    private void addActionListener() {
    	DataReduction.signalPidFileButton.addActionListener(this);
    	DataReduction.clearSignalPidFileButton.addActionListener(this);
    	DataReduction.backgroundPidFileButton.addActionListener(this);
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
    	DataReduction.loadctComboBox.addActionListener(this);
    	DataReduction.extraPlotsBRNCheckBox.addActionListener(this);
    	DataReduction.extraPlotsBSCheckBox.addActionListener(this);
    	DataReduction.extraPlotsNRCheckBox.addActionListener(this);
    	DataReduction.extraPlotsSRBCheckBox.addActionListener(this);
    	DataReduction.extraPlotsSRCheckBox.addActionListener(this);
    	DataReduction.settingsValidateButton.addActionListener(this);
    	DataReduction.reflRadioButton.addActionListener(this);
    	DataReduction.refmRadioButton.addActionListener(this);
    	DataReduction.preferencesMenuItem.addActionListener(this);
    	DataReduction.signalSelectionModeMenuItem.addActionListener(this);
    	DataReduction.background1SelectionModeMenuItem.addActionListener(this);
    	DataReduction.background2SelectionModeMenuItem.addActionListener(this);
    	DataReduction.wavelengthMinTextField.addActionListener(this);
    	DataReduction.wavelengthMaxTextField.addActionListener(this);
    	DataReduction.wavelengthWidthTextField.addActionListener(this);
    	DataReduction.detectorAngleTextField.addActionListener(this);
    	DataReduction.detectorAnglePMTextField.addActionListener(this);
    	CreateDataReductionInputGUI.loadPidButton.addActionListener(this);
      CreateDataReductionInputGUI.clearPidButton.addActionListener(this);
      CreateDataReductionInputGUI.homeOrCurrentSessionComboBox.addActionListener(this);
      
    	//from Data Reduction plot tab
    	DataReduction.yMaxTextField.addActionListener(this);
	    DataReduction.yMinTextField.addActionListener(this);
	    DataReduction.yResetButton.addActionListener(this);
	    DataReduction.yValidateButton.addActionListener(this);
	    DataReduction.xMaxTextField.addActionListener(this);
	    DataReduction.xMinTextField.addActionListener(this);
	    DataReduction.xResetButton.addActionListener(this);
	    DataReduction.xValidateButton.addActionListener(this);
	  	
	    //from extra plots tab
	    DataReduction.yMaxTextFieldEP.addActionListener(this);
	    DataReduction.yMinTextFieldEP.addActionListener(this);
	    DataReduction.yResetButtonEP.addActionListener(this);
	    DataReduction.yValidateButtonEP.addActionListener(this);
	    DataReduction.xMaxTextFieldEP.addActionListener(this);
	    DataReduction.xMinTextFieldEP.addActionListener(this);
	    DataReduction.xResetButtonEP.addActionListener(this);
	    DataReduction.xValidateButtonEP.addActionListener(this);
	  	
	    //from settings
	    DataReduction.saveSignalPidFileCheckBox.addActionListener(this);
	    DataReduction.saveBackPidFileCheckBox.addActionListener(this);
	    DataReduction.saveNormalizationCheckBox.addActionListener(this);
	    DataReduction.saveBackgroundCheckBox.addActionListener(this);
	    DataReduction.saveNormalizationBackgroundCheckBox.addActionListener(this);
	    DataReduction.saveIntermediateFileOutputCheckBox.addActionListener(this);
	    DataReduction.saveCombineDataSpectrumCheckBox.addActionListener(this);
	    DataReduction.saveOverwriteInstrumentGeometryCheckBox.addActionListener(this);
	    DataReduction.saveAddAndGoRunNumberCheckBox.addActionListener(this);
	    DataReduction.saveGoSequentiallyCheckBox.addActionListener(this);
	    DataReduction.settingsSelectAllButton.addActionListener(this);
	    DataReduction.settingsUnselectAllButton.addActionListener(this);
      DataReduction.nbrInfoLinesDisplayedNotXmlFilesTextField.addActionListener(this);
      DataReduction.nbrInfoLinesDisplayedXmlFilesTextField.addActionListener(this);
                    
	    //from Files Transfer
      DataReduction.automaticFilesTransferRadioButton.addActionListener(this);
      DataReduction.manualFilesTransferRadioButton.addActionListener(this);
      DataReduction.transferFilesButton.addActionListener(this);
      DataReduction.transferPidFilesCheckBox.addActionListener(this);
      DataReduction.transferDataReductionFileCheckBox.addActionListener(this);
      DataReduction.transferExtraPlotsCheckBox.addActionListener(this);
      DataReduction.transferRefreshButton.addActionListener(this);
      DataReduction.saveFileInfoMessageTextfield.addActionListener(this);
      
      //from other plots
      CreateOtherPlotsPanel.list1OfOtherPlotsComboBox.addActionListener(this);
      CreateOtherPlotsPanel.list2OfOtherPlotsComboBox.addActionListener(this);
      CreateOtherPlotsPanel.xoTextField.addActionListener(this);
      CreateOtherPlotsPanel.yoTextField.addActionListener(this);
      CreateOtherPlotsPanel.refreshButton.addActionListener(this);
      CreateOtherPlotsPanel.tBinMinTextField.addActionListener(this);
      CreateOtherPlotsPanel.tBinMaxTextField.addActionListener(this);
      CreateOtherPlotsPanel.clearButton.addActionListener(this);
      CreateOtherPlotsPanel.saveSelectionRadioButton.addActionListener(this);
      CreateOtherPlotsPanel.interactiveSelectionRadioButton.addActionListener(this);
      CreateOtherPlotsPanel.pixelIDTextField.addActionListener(this);
      
    }
      
}