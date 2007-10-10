package gov.ornl.sns.iontools;

import gov.ornl.sns.iontools.IParameters;

public class DisplayConfiguration {

	private String instrument;
	
	private int Nx;
	private int NxMin;
	private int NxMax;
	private int Ny;	
	private int NyMin;
	private int NyMax;
				
/**
 * Constructor that initialize the instrument name
 * @param inst
 */
	public DisplayConfiguration(String inst) {
			this.instrument = inst;
	}
	
	/**
	 * This method returns the number of pixels in the x-axis direction according to 
	 * the name of the instrument
	 * @return the number of pixels in the x-axis
	 */
	public int retrieveNx() {
		if (this.instrument.compareTo("REF_L") == 0) {
			Nx = IParameters.NxRefl;
		} else if (this.instrument.compareTo("REF_M") == 0) {
			Nx = IParameters.NxRefm;
		}	
		return Nx;
	}		

	/**
	 * This method returns the number of pixels in the y-axis direction according to
	 * the name of the instrument
	 * @return the number of pixel in the y-axis
	 */
	public int retrieveNy () {
		if (this.instrument.compareTo("REF_L") == 0) {
			Ny = IParameters.NyRefl;
		} else if (this.instrument.compareTo("REF_M") == 0) {
			Ny = IParameters.NyRefm;
		}	
		return Ny;
	}

	/**
	 * This method returns the Nx minimum used by the selection tool in the
	 * main graphical window
	 * @return NxMin
	 */
	public int retrieveNxMin() {
		if (this.instrument.compareTo("REF_L") == 0) {
			NxMin = IParameters.NxReflMin;
		} else if (this.instrument.compareTo("REF_M") == 0) {
			NxMin = IParameters.NxRefmMin;
		}
		return NxMin;
	}
	
	/**
	 * This method returns the Nx maximum used by the selection tool in the
	 * main graphical window
	 * @return NxMax
	 */
	public int retrieveNxMax() {
		if (this.instrument.compareTo("REF_L") == 0) {
			NxMax = IParameters.NxReflMax;
		} else if (this.instrument.compareTo("REF_M") == 0) {
			NxMax = IParameters.NxRefmMax;
		}
		return NxMax;
	}
	
	/**
	 * This method returns the Ny minimum used by the selection tool in the
	 * main graphical window
	 * @return NyMin
	 */
	public int retrieveNyMin() {
		if (this.instrument.compareTo("REF_L") == 0) {
			NyMin = IParameters.NyReflMin;
		} else if (this.instrument.compareTo("REF_M") == 0) {
			NyMin = IParameters.NyRefmMin;
		}
		return NyMin;
	}

	/**
	 * This method returns the Ny minimum used by the selection tool in the
	 * main graphical window
	 * @return NyMin
	 */
	public int retrieveNyMax() {
		if (this.instrument.compareTo("REF_L") == 0) {
			NyMax = IParameters.NyReflMax;
		} else if (this.instrument.compareTo("REF_M") == 0) {
			NyMax = IParameters.NyRefmMax;
		}
		return NyMax;
	}
	
  /*
   * This function set the background of the tabs
   */
    static void colorTabsBackground() {
      // Input
      DataReduction.dataReductionTabbedPane.setBackgroundAt(0, IParameters.DATA_REDUCTION_TABS);
      // Data Reduction Plot
      DataReduction.dataReductionTabbedPane.setBackgroundAt(1, IParameters.DATA_REDUCTION_TABS);
      // Extra Plots
      DataReduction.dataReductionTabbedPane.setBackgroundAt(2, IParameters.DATA_REDUCTION_TABS);
      
      // Data Reduction
      DataReduction.tabbedPane.setBackgroundAt(0, IParameters.MAIN_TABS);
      // Selection
      DataReduction.tabbedPane.setBackgroundAt(1, IParameters.MAIN_TABS);
      // Counts = f(TOF,X,Y)
      DataReduction.tabbedPane.setBackgroundAt(2, IParameters.MAIN_TABS);
      // Save Files
      DataReduction.tabbedPane.setBackgroundAt(3, IParameters.MAIN_TABS);
      // Settings
      DataReduction.tabbedPane.setBackgroundAt(4, IParameters.MAIN_TABS);
      // LogBook
      DataReduction.tabbedPane.setBackgroundAt(5, IParameters.MAIN_TABS);
                  
      // Save and Load Pid files
      CreateDataReductionInputGUI.saveLoadSelectionTabbedPane.setBackgroundAt(0, IParameters.PID_TABS);
      CreateDataReductionInputGUI.saveLoadSelectionTabbedPane.setBackgroundAt(1, IParameters.PID_TABS);
      
      //Extra Plots
      DataReduction.extraPlotsTabbedPane.setBackgroundAt(0, IParameters.EXTRA_PLOTS_TABS);
      DataReduction.extraPlotsTabbedPane.setBackgroundAt(1, IParameters.EXTRA_PLOTS_TABS);
      DataReduction.extraPlotsTabbedPane.setBackgroundAt(2, IParameters.EXTRA_PLOTS_TABS);
      DataReduction.extraPlotsTabbedPane.setBackgroundAt(3, IParameters.EXTRA_PLOTS_TABS);
      DataReduction.extraPlotsTabbedPane.setBackgroundAt(4, IParameters.EXTRA_PLOTS_TABS);
      
      //Selection
      DataReduction.selectionTab.setBackgroundAt(0, IParameters.SELECTION_INFO_TABS);
      DataReduction.selectionTab.setBackgroundAt(1, IParameters.SELECTION_INFO_TABS);
      DataReduction.selectionTab.setBackgroundAt(2, IParameters.SELECTION_INFO_TABS);
      
      //runs tab
      DataReduction.runsTabbedPane.setBackgroundAt(0, IParameters.SEQUENTIALLY_RUN_TABS);
      DataReduction.runsTabbedPane.setBackgroundAt(1, IParameters.SEQUENTIALLY_RUN_TABS);
      
    }
}
