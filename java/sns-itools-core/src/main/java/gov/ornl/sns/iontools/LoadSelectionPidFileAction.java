package gov.ornl.sns.iontools;

import java.awt.Graphics;
import java.awt.Color;

public class LoadSelectionPidFileAction {

  static com.rsi.ion.IONVariable ionPath;
  static com.rsi.ion.IONVariable ionExtension;
  static com.rsi.ion.IONVariable ionFullFileName;
  static String[] listOfPidFiles;
  static String[] myResultArray;
  
  static void getListOfPidFilesInHomeDirectory() {
   
    String sPidDirectory = getPidDirectory();
    String sPidExtension = CreateSettingsPanel.pidFileExtensionTextField.getText();
    
    if (sPidExtension.compareTo("")!=0 && sPidDirectory.compareTo("")!=0) {
      ionPath = new com.rsi.ion.IONVariable(sPidDirectory);
      ionExtension = new com.rsi.ion.IONVariable(sPidExtension);
      String cmd = "list_of_files = get_list_of_pid_files (" + ionPath;
      cmd += "," + ionExtension + ")";
      IonUtils.executeCmd(cmd);
      
      com.rsi.ion.IONVariable myIONresult;
      myIONresult = IonUtils.queryVariable("list_of_files");
      
      try {
        myResultArray = myIONresult.getStringArray();
        listOfPidFiles = new String[myResultArray.length];
        System.arraycopy(myResultArray, 0, listOfPidFiles, 0, myResultArray.length);        
        String[] lastPartResultArray = UtilsFunction.getLastPartOfStringArray(myResultArray);
        
        //Number of files to list
        int iNbrOfPidFiles = myResultArray.length;
        if (iNbrOfPidFiles > 0) {
          CreateDataReductionInputGUI.listOfPidFileToLoadComboBox.removeAllItems();
            for (int i=0; i<iNbrOfPidFiles; ++i) {
              CreateDataReductionInputGUI.listOfPidFileToLoadComboBox.addItem(lastPartResultArray[i]);
            }
        }
      } catch (Exception e) {
        CreateDataReductionInputGUI.listOfPidFileToLoadComboBox.removeAllItems(); 
      }
      
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
      boolean bSignalPid = isSignalSelected();
      String  sPidFileFullName = getPidFileFullName();
      if (bSignalPid) {
        getSignalXYMinMax(sPidFileFullName);
      } else {
        getBackXYMinMax(sPidFileFullName);
      }
      doBox();
    } catch (Exception e) {}
    
  }
  
  /*
   * This functions returns true if the signal PID file is selected
   * false if background is selected
   */
   static boolean isSignalSelected() {
     int iSelectedIndex = CreateDataReductionInputGUI.typeOfSelectionComboBox.getSelectedIndex();
     if (iSelectedIndex == 0) {
       return true;
     } else {
       return false;
     }
   }
     
   /*
    * Get the full path to the pid file name
    */
   static String getPidFileFullName() {
     int indexSelected = CreateDataReductionInputGUI.listOfPidFileToLoadComboBox.getSelectedIndex();
     return listOfPidFiles[indexSelected];
   }
   
   /*
    * This function will retrive the Xmin, Xmax, Ymin and Ymax from the
    * signal pid file
    */
   static void getSignalXYMinMax(String sFullFileName) {
   ionFullFileName = new com.rsi.ion.IONVariable(sFullFileName);
   String cmd = "xyMinMax = get_signal_xy_min_max( " + ionFullFileName + ")";
   IonUtils.executeCmd(cmd);
   try {
     com.rsi.ion.IONVariable myIONresult;
     myIONresult = IonUtils.queryVariable("xyMinMax");
     String[] XYMinMax = myIONresult.getStringArray();
     saveSignalXYMinMax(XYMinMax);
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
   
   static void getSignalInfo(int xmin, int ymin, int xmax, int ymax) {
     MouseSelection.saveXY(IParameters.SIGNAL_STRING,xmin, ymin, xmax, ymax);
   }
   
   /*
    * This function will retrive the Xmin, Xmax, Ymin and Ymax from the
    * back pid file
    */
   static void getBackXYMinMax(String sFullFileName) {
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
}
