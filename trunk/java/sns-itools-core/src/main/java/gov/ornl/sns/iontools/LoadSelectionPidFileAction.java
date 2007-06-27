package gov.ornl.sns.iontools;

import java.awt.Graphics;
import java.awt.Color;

public class LoadSelectionPidFileAction {

  static com.rsi.ion.IONVariable ionPath;
  static com.rsi.ion.IONVariable ionExtension;
  static com.rsi.ion.IONVariable ionFullFileName;
  static String[] listOfPidFiles;
  static String[] myResultArray;
  static String   shortFileName;
  
  static void getListOfPidFilesInHomeDirectory() {
   
    String sPidDirectory = getPidDirectory();
    String sPidExtension = CreateSettingsPanel.pidFileExtensionTextField.getText();
    
    
    if (sPidExtension.compareTo("")!=0 && sPidDirectory.compareTo("")!=0) {
      ionPath = new com.rsi.ion.IONVariable(sPidDirectory);
      ionExtension = new com.rsi.ion.IONVariable(sPidExtension);
      String cmd = "list_of_files = get_list_of_pid_files (" + ionPath;
      cmd += "," + ionExtension + ")";
      
      //submit job in another thread
      SubmitLoadListOfPidFiles run = new SubmitLoadListOfPidFiles(cmd);
      Thread runThread = new Thread(run,"Work in progress");
      runThread.start();
    }
  }

  /*
   * This function retrieve the path to the PID files
   */
  static String getPidDirectory() {
    
    //current tmp folder or home directory
    int iPathSelected = CreateDataReductionInputGUI.homeOrCurrentSessionComboBox.getSelectedIndex();
    String sPidDirectory;
    if (iPathSelected == 0) { //Home directory
      sPidDirectory = CreateSettingsPanel.pidFileHomeDirectoryTextField.getText();
      return sPidDirectory;
    } else { //tmp folder
      return DataReduction.sTmpFolder;
    }
  }

  /*
   * This function loads the desired pid file
   */
  static void loadPidFile() {
    
    try {
      String  sPidFileFullName = getPidFileFullName();
      getSignalXYMinMax(sPidFileFullName);
      doBox();
    } catch (Exception e) {}
    
  }
  
   /*
    * Get the full path to the pid file name
    */
   static String getPidFileFullName() {
     int indexSelected = CreateDataReductionInputGUI.listOfPidFileToLoadComboBox.getSelectedIndex();
     return listOfPidFiles[indexSelected];
   }
   
   /*
    * Get only the pid file name (without path)
    */
   static String getPidFileShortName() {
     int indexSelected = CreateDataReductionInputGUI.listOfPidFileToLoadComboBox.getSelectedIndex();
     String sShortFileName = UtilsFunction.getOnlyLastPartOfFileName(listOfPidFiles[indexSelected]);
     return sShortFileName;
   }
   
   /*
    * This function will retrive the Xmin, Xmax, Ymin and Ymax from the
    * signal pid file
    */
   static void getSignalXYMinMax(String sFullFileName) {
     ionFullFileName = new com.rsi.ion.IONVariable(sFullFileName);
     String cmd = "xyMinMax = get_signal_xy_min_max( " + ionFullFileName + ")";
     try {
       IonUtils.executeCmd(cmd);
       com.rsi.ion.IONVariable myIONresult;
       myIONresult = IonUtils.queryVariable("xyMinMax");
       String[] XYMinMax = myIONresult.getStringArray();
       saveSignalXYMinMax(XYMinMax);
       DataReduction.pidSignalFileName = sFullFileName; //pid file name
       String sShortPidFileName = getPidFileShortName();
       updateSignalGUI(sShortPidFileName);
     } catch (Exception e) {};
   }
 
   /*
    * This function save xmin, xmax, ymin and ymax for the signal
    */
   static void saveSignalXYMinMax(String[] XYMinMax) {
     int xmin = Integer.parseInt(XYMinMax[0]);
     int ymin = Integer.parseInt(XYMinMax[1]);
     int xmax = Integer.parseInt(XYMinMax[2]);
     int ymax = Integer.parseInt(XYMinMax[3]);
     MouseSelectionParameters.signal_x1=2*(xmin);
     MouseSelectionParameters.signal_y1=2*(IParameters.NyRefl-ymin)-1;
     MouseSelectionParameters.signal_x2=2*(xmax);
     MouseSelectionParameters.signal_y2=2*(IParameters.NyRefl-ymax)-1;
     getSignalInfo(xmin, ymin, xmax, ymax);
   }
   
   /*
    * This function displays the info about the selection loaded in the 
    * selection tab.
    */
   static void getSignalInfo(int xmin, int ymin, int xmax, int ymax) {
     MouseSelection.saveXY(IParameters.SIGNAL_STRING,xmin, ymin, xmax, ymax);
   }
   
   /*
    * This function update the GUI once a signal pid file has been selected
    * that means, it adds its name in the load and the save signal text fields.
    * Enabled CLEAR button in save pid files.
    */
   static void updateSignalGUI(String sShortPidFileName){
     DataReduction.signalPidFileTextField.setText(sShortPidFileName);
     DataReduction.signalPidFileTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_FULL);
     DataReduction.clearSignalPidFileButton.setEnabled(true);
     CreateDataReductionInputGUI.loadSignalTextField.setText(sShortPidFileName);
     CreateDataReductionInputGUI.loadSignalTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_FULL);
   }
   
   static final void doBox(){
    
    int xmin = 0;
    int ymin = 0;
    int xmax = 0;
    int ymax = 0;
          
    Graphics g = DataReduction.c_plot.getGraphics();
    DataReduction.c_plot.update(g);
    
    for (int i=0; i<3; i++) {
        
      if (i == 0) {
        xmin = MouseSelectionParameters.signal_x1;
        ymin = MouseSelectionParameters.signal_y1;
        xmax = MouseSelectionParameters.signal_x2;
        ymax = MouseSelectionParameters.signal_y2;
        g.setColor(Color.red);
        } else if (i == 1) {
          xmin = MouseSelectionParameters.back1_x1;
          ymin = MouseSelectionParameters.back1_y1;
          xmax = MouseSelectionParameters.back1_x2;
          ymax = MouseSelectionParameters.back1_y2;
          g.setColor(Color.yellow);
        } else if (i == 2) {
          xmin = MouseSelectionParameters.back2_x1;
          ymin = MouseSelectionParameters.back2_y1;
          xmax = MouseSelectionParameters.back2_x2;
          ymax = MouseSelectionParameters.back2_y2;
          g.setColor(Color.green);
        }
        g.drawLine(xmin,ymin,xmin,ymax);
        g.drawLine(xmin,ymax,xmax,ymax);
        g.drawLine(xmax,ymax,xmax,ymin);
        g.drawLine(xmax,ymin,xmin,ymin);
      }
    }

   static void clearPidFile() {
       CreateDataReductionInputGUI.loadSignalTextField.setText("");
       CreateDataReductionInputGUI.loadSignalTextField.setBackground(IParameters.TEXT_BOX_REQUIRED_EMPTY);
       SaveSignalPidFileAction.clearSignalPidFileAction();
   }
   
   
   

}
