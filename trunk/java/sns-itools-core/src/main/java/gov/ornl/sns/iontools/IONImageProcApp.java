//
// Image Processing Demo using ION and ION Derived Classes
//
//

/*******************************************************************
 Copyright (c) 1997-2007, ITT Visual Information Solutions. All
  rights reserved. This software includes information which is
  proprietary to and a trade secret of ITT Visual Information Solutions.
  It is not to be disclosed to anyone outside of this organization.
  Reproduction by any means whatsoever is prohibited without express
  written permission.
********************************************************************/

import java.awt.*;
import java.awt.event.*;
import java.applet.*;
import javax.swing.*;
import java.io.*;
import java.net.*;
import com.rsi.ion.*;

public class IONImageProcApp extends Applet 
    implements IONOutputListener, IONDisconnectListener,
               MouseListener
{
  IONGraphicsClient c_ionClient;
  IONROICanvas c_ionRefImage;
  IONCanvas c_ionZoomImage;
  IONCanvas c_ionPlotImage;
  Dimension c_dimImage;
   static OutputStream logfile;
   
   JList fileList;
   DefaultListModel listModel;
   JList dataList;
   DefaultListModel datalistModel;

  // Saved Area
  Image c_imSaved;
  Point c_ptSaved;
  Rectangle c_rectRed=null;

  // Zoom info
  int win_size = 64,
      win_zoom = 192;

  // GUI Components
  CheckboxGroup c_grpProcess;
  Checkbox c_chkHistEq, c_chkSobel, c_chkRoberts, c_chkSmooth;
    //  Label c_lblStatus;
  boolean c_bFirstTime=true;

  // Connection State
  static final int STATE_NOCON  = 0;  // not connected
  static final int STATE_CON    = 1;  // connected
  static final int STATE_ERRCON = -1; // connection failed

  int c_conState = STATE_NOCON; // are we connected to ION?

  // ******************************
  // Init method
  // ******************************
  public void init()
  {
      start();
      initVars();
      buildGUI();

    return;
  }
  // ******************************
  // Start method
  // ******************************
  public void start() 
  {

System.out.println(">start");
    if(c_conState == STATE_NOCON) {  // Not connected to ION, do so.
      initION();
      if(c_conState == STATE_CON)
        initImage();
    }
  }
  // ******************************
  // Stop method (disconnect here)
  // ******************************
  public void stop(){
System.out.println(">stop");
    if(c_conState == STATE_CON) {
      c_ionClient.disconnect();
      c_conState = STATE_NOCON;
    }
  }
  // ******************************
  // Initialize variables
  // ******************************
  private void initVars()
  {
    c_dimImage = new Dimension(320, 256);
    c_ionClient = new IONGraphicsClient();
    c_ionClient.setCompression(false);
				
    c_ionRefImage = new IONROICanvas(c_dimImage.width, 
                                   c_dimImage.height);
    c_ionZoomImage = new IONCanvas(win_zoom, 
                                   win_zoom);
    c_ionPlotImage = new IONCanvas(600, 
            300);
    c_grpProcess = new CheckboxGroup();
    c_chkHistEq = new Checkbox("Equalize Histogram", c_grpProcess, true);
    c_chkSobel = new Checkbox("Detect Edges (Sobel)", c_grpProcess, true);
    c_chkRoberts = new Checkbox("Detect Edges (Roberts)", c_grpProcess, true);
    c_chkSmooth = new Checkbox("Smooth", c_grpProcess, true);
    //    c_lblStatus = new Label("Working...        ", Label.RIGHT);
    c_imSaved = null;
    c_ptSaved = new Point(-1, -1);
    fileList = new JList();
    listModel = new DefaultListModel();
    dataList = new JList();
    datalistModel = new DefaultListModel();
//System.err.println("<initVars");

    return;
  }
  // ******************************
  // Build the GUI
  // ******************************
  private void buildGUI()
  {

     Panel header = new Panel();
  
     header.setLayout(new GridLayout(1,4));
  
     header.add(new Label("ION Java Image Processing Demo"));
     //     header.add(c_lblStatus);
     header.add(new Label("  "));
     
     JPanel files = new JPanel(new BorderLayout());
     JButton b_dispImage = new JButton("Display Selected Image");
     b_dispImage.addActionListener(new ActionListener(){
    	 public void actionPerformed(ActionEvent ev){
    		 String fname = (String)fileList.getSelectedValue();
    		 String cmd = "image = imageproc_load_new(\"" + fname+ "\")";    		 
    		 try{
    			 c_ionClient.executeIDLCommand("wset, 0");
    			 c_ionClient.executeIDLCommand(cmd);
    		 }catch (Exception e){}
    	 }
     });
     files.add(fileList,BorderLayout.CENTER);
     files.add(b_dispImage,BorderLayout.SOUTH);

     Panel zoom = new Panel();
     zoom.setLayout(null);
     zoom.add(c_ionZoomImage);         

     Panel images = new Panel();
     images.setLayout(new GridLayout(1, 2));
     images.setBackground(Color.black);
     images.add(c_ionRefImage);
     images.add(zoom);
     c_ionRefImage.setBackground(Color.black);
     c_ionZoomImage.setLocation(64, 31);
     c_ionZoomImage.setBackground(Color.darkGray);

     Panel controls = new Panel();
     controls.setBackground(Color.lightGray);
     controls.setLayout(new FlowLayout());
     controls.add(c_chkHistEq);
     controls.add(c_chkSobel);
     controls.add(c_chkRoberts);
     controls.add(c_chkSmooth);
     
     JPanel toppanel = new JPanel();
     toppanel.setLayout(new BorderLayout());

     toppanel.add("North", header);
     toppanel.add("West", files);
     toppanel.add("Center", images);
     toppanel.add("South", controls);
     
     //Create the plot panel      
     JPanel plots = new JPanel(new BorderLayout());
     JButton b_dispPlot = new JButton("Display Selected Data");
     b_dispPlot.addActionListener(new ActionListener(){
    	 public void actionPerformed(ActionEvent ev){    		 
    		 String fname = (String)dataList.getSelectedValue();
    		 String cmd = "plot_load_new,\"" + fname+ "\"";    		 
    		 try{
    			 c_ionClient.executeIDLCommand("wset, 2");
    			 c_ionClient.executeIDLCommand(cmd);
    		 }catch (Exception e){}
    	 }
     });
     plots.add(dataList,BorderLayout.CENTER);
     plots.add(b_dispPlot,BorderLayout.SOUTH);
     
     JPanel bottompanel = new JPanel(new BorderLayout());
     bottompanel.add(plots, BorderLayout.WEST);
     bottompanel.add(c_ionPlotImage, BorderLayout.CENTER);

     setLayout(new GridLayout(2,1));
     add(toppanel);
     add(bottompanel);
//System.err.println("<buildGUI");
    return;
  }
  // ******************************
  // Connect to ION server
  // ******************************
  private void initION()
  {
      System.out.println("in iniION()");
    // Connect to the server
      //    c_lblStatus.setText("Connecting to Server ...");
    try { c_ionClient.connect(this.getCodeBase().getHost()); }
    catch(Exception e) { 
       String sMsg;

       // An exception was thrown. See what happened.
       if(e instanceof IOException)
         sMsg = "Error: Establishing Connection.";
       else if(e instanceof UnknownHostException)
         sMsg = "Error: Unknown Host.";       
       else if(e instanceof IONLicenseException)
         sMsg = "Error: ION Java License Unavailible.";              
       else
         sMsg ="Error: Unknown Connection error."; 

       //       c_lblStatus.setText(sMsg);
       //       showStatus(sMsg);

       c_conState = STATE_ERRCON;
       return;
    }
    
    String cmd = "dataFiles=GetIONDataFiles(\"jpg\")";     
    
    try{
      c_ionClient.executeIDLCommand(cmd); 
      IONVariable dataFiles = c_ionClient.getIDLVariable("dataFiles");
 	   String [] files = dataFiles.getStringArray();	   
 	   for (int i=0; i<files.length;i++)
 	   {
 		   listModel.addElement(files[i]);		   
 	   }
 	   fileList.setModel(listModel);
    }catch(Exception e)
    {
 	   //e.printStackTrace();
 	   JOptionPane.showMessageDialog(null, e.toString());
    }
    
    cmd = "dataFiles=GetIONDataFiles(\"dat\")";     
    
    try{
      c_ionClient.executeIDLCommand(cmd); 
      IONVariable dataFiles = c_ionClient.getIDLVariable("dataFiles");
 	   String [] files = dataFiles.getStringArray();	   
 	   for (int i=0; i<files.length;i++)
 	   {
 		   datalistModel.addElement(files[i]);		   
 	   }
 	   dataList.setModel(datalistModel);
    }catch(Exception e)
    {
 	   //e.printStackTrace();
 	   JOptionPane.showMessageDialog(null, e.toString());
    }
    
    

    c_conState = STATE_CON;

    // Add the drawable and let the server know it's there
    c_ionClient.addIONDrawable(c_ionRefImage, 0);
    c_ionClient.addIONDrawable(c_ionZoomImage, 1);
    c_ionClient.addIONDrawable(c_ionPlotImage, 2);

    c_ionClient.addIONOutputListener(this);
    c_ionClient.addIONDisconnectListener(this);
//System.err.println("<initION conState="+c_conState);
    return;
  }
  // ******************************
  // Initialize the image
  // ******************************

  private void initImage()
  {
      //    c_lblStatus.setText("Loading Reference Image ...");
     try {
       // This section sets up the 2 images on the IDL side.  image is a large
       // image used for processing and refimage is the image that is downloaded 
       // for the user to select ROIs from.
       c_ionClient.executeIDLCommand("wset, 0");
       c_ionClient.executeIDLCommand("loadct, 0");
       c_ionClient.executeIDLCommand("@imageproc_get.pro");
       c_ionClient.executeIDLCommand("image = bytscl(image[0:639, *])");
       c_ionClient.executeIDLCommand("refimage = bytscl(rebin(image[0:639, *], 320, 256))");
       c_ionClient.executeIDLCommand("tv, refimage");
       //Note that it is generally faster to package multiple 
       //IDL commands into a single .pro to call.  This example 
       //sends commands separately so that the code is easier to follow.
    } catch(Exception e) { 

      // IO Error
      if(e instanceof IOException) {
        System.err.println("Error: Communication error"); 
	//        c_lblStatus.setText("Error: Communication error");
      }
      
      // Illegal Command
      else if(e instanceof IONIllegalCommandException) {
        System.err.println("Error: Illegal Command"); 
	//        c_lblStatus.setText("Error: Illegal Command");
      }

      // Security Violation
      else if(e instanceof IONSecurityException) {
        System.err.println("Error: Security Violation"); 
	//        c_lblStatus.setText("Error: Security Violation");
      }
      // Security Violation
      else {
        System.err.println("Exc: "+e.getMessage()); 
	//        c_lblStatus.setText("Exc: "+e.getMessage());
      }

      return;
    }

        
    // Add this as a mouse listener
    c_ionRefImage.addMouseListener(this);

    //    c_lblStatus.setText("Click on the image");

//System.err.println("<initImage");
    return;
  }

  // ******************************
  // Draw the Zoom Section
  // ******************************
  
  protected void zoom(int x, int y)
  {
//System.err.println(">zoom");
    Graphics g;

    if(c_conState != STATE_CON) {
      return;
    }


    //    c_lblStatus.setText("Processing Image...");

    if(c_rectRed == null) {
      c_rectRed = new Rectangle();
    } 

    // Get the area to process
    int win_x = 640,  // c_dimImage.width,
        win_y = 512;  // c_dimImage.height;

    // Convert from refImage coords to image coords
    x = x*2;
    y = win_y - y*2;

    int xpos = x;
    int ypos = y;
    int win_size_h = win_size / 2;
    int win_zoom_h = win_zoom / 2;
    
    xpos = Math.min(Math.max(xpos, win_size_h), (win_x - win_size_h) - 1);
    ypos = Math.min(Math.max(ypos, win_size_h), (win_y - win_size_h) - 1);

    int img_x = xpos - win_zoom_h;
    int img_y = ypos - win_zoom_h;
    int sub_x = xpos - win_size_h;
    int sub_y = ypos - win_size_h;

    // Add a red rectangle around the image
    int win_zoom_q = win_zoom_h/2;
    int inv_y = win_y - y;
    c_rectRed.x = Math.min(Math.max((x - win_zoom_q)/2, -1),
                           c_dimImage.width-win_zoom_q);
    c_rectRed.y = Math.min(Math.max((inv_y - win_zoom_q)/2, -1),
                           c_dimImage.height-win_zoom_q);

    c_rectRed.width = c_rectRed.height = win_zoom_q;

    c_ionRefImage.setROI(c_rectRed, Color.red);
      
    try {
      // Make the zoom image
//System.err.println("before executeIDLCommand rebin zoom image");
      c_ionClient.executeIDLCommand("zoom_img = rebin(image[(" + sub_x + "):(" +
                                    (sub_x+win_size-1) + "), (" + sub_y + "):(" +
                                    (sub_y+win_size-1) + ")], " + win_zoom + ", " +
                                    win_zoom + ")");

//System.err.println("after executeIDLCommand rebin zoom image");
      // Run a filter on it

      Checkbox chkCur = c_grpProcess.getSelectedCheckbox();

      if(chkCur == c_chkHistEq)
        c_ionClient.executeIDLCommand("zoom_img = hist_equal(zoom_img)");        
      else if(chkCur == c_chkSobel)
        c_ionClient.executeIDLCommand("zoom_img = sobel(zoom_img)");
      else if(chkCur == c_chkRoberts)
        c_ionClient.executeIDLCommand("zoom_img = roberts(zoom_img)");
      else if(chkCur == c_chkSmooth)
        c_ionClient.executeIDLCommand("zoom_img = smooth(zoom_img, 5)");

//System.err.println("after image process of image");
      // If we're buffering on the client, save the area to be overwritten
      c_ptSaved.x = img_x;
      c_ptSaved.y = c_dimImage.height - img_y - 1;
 
      // Display the results
      //      c_lblStatus.setText("Transferring Image...");
      c_ionClient.executeIDLCommand("wset, 1");
//System.err.println("after wset");
      c_ionClient.executeIDLCommand("tv, zoom_img"); // + img_x + ", "  + img_y);
//System.err.println("after tv");
    } catch(Exception e) { 

      // IO Error
      if(e instanceof IOException) {
        System.err.println("Error: Communication error"); 
	//        c_lblStatus.setText("Error: Communication error");
      }
      
      // Illegal Command
      else if(e instanceof IONIllegalCommandException) {
        System.err.println("Error: Illegal Command"); 
	//        c_lblStatus.setText("Error: Illegal Command");
      }

      // Security Violation
      else if(e instanceof IONSecurityException) {
        System.err.println("Error: Security Violation"); 
	//        c_lblStatus.setText("Error: Security Violation");
      }
      // Security Violation
      else {
        System.err.println("Exception: "+e.getMessage()); 
	//        c_lblStatus.setText("Exception: "+e.getMessage());
      }

      return;
    }


    c_ionRefImage.repaint();
//System.err.println("after repaint");
//    c_lblStatus.setText("Click on the image");
    
    return;
  }


  // ******************************
  // Mouse Listener Implementation
  // ******************************

  // Note that these mouse listeners changed from ION1.2 to ION1.4.  This
  // version uses the java.awt MouseListener interface instead of the
  // IONMouseListener interface

  public void mouseClicked(MouseEvent e) {
  //System.out.println("mouseClicked x="+e.getX()+" y="+e.getY());
  }
  public void mouseEntered(MouseEvent e) {
  //System.out.println("mouseEntered x="+e.getX()+" y="+e.getY());
  }
  public void mouseExited(MouseEvent e) {
  //System.out.println("mouseExited x="+e.getX()+" y="+e.getY());
  }
  public void mousePressed(MouseEvent e) {
  //System.out.println("mousePressed x="+e.getX()+" y="+e.getY());
  }
  public void mouseReleased(MouseEvent e) {
  //System.out.println("mouseReleased x="+e.getX()+" y="+e.getY());
    zoom(e.getX(), e.getY());
  }

  // ******************************
  // Output Listener
  // ******************************

  public void IONOutputText(String sLine)
  {
    System.out.println(sLine);
  }


  // ******************************
  // Disconnect Listener
  // ******************************

  public void IONDisconnection(int iStatus)
  {
    switch(iStatus) {
    case ION_DIS_OK:
      c_conState = STATE_NOCON;
      break;
    case ION_DIS_ERR:
    case ION_DIS_SERVER:
      c_conState = STATE_ERRCON;
      //    c_lblStatus.setText("Error: Server Disconnected");      
      break;
    }
  }

}


