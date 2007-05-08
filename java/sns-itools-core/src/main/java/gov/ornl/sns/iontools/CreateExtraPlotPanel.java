package gov.ornl.sns.iontools;

import javax.swing.*;
import com.rsi.ion.*;

public class CreateExtraPlotPanel {

	static void buildGUI() {
		
		DataReduction.extraPlotsPanel = new JPanel();
		DataReduction.extraPlotsTabbedPane = new JTabbedPane();
		
		//Signal region summed vs TOF
		DataReduction.c_SRextraPlots  = new IONJGrDrawable(
				IParameters.EXTRA_PLOTS_X,
				IParameters.EXTRA_PLOTS_Y);
		DataReduction.extraPlotsTabbedPane.addTab("Signal", DataReduction.c_SRextraPlots);
		
		//Background summed vs tof
		DataReduction.c_BextraPlots = new IONJGrDrawable(
				IParameters.EXTRA_PLOTS_X,
				IParameters.EXTRA_PLOTS_Y);
		DataReduction.extraPlotsTabbedPane.addTab("Background", DataReduction.c_BextraPlots);

		//Signal region with background summed vs TOF
		DataReduction.c_SRBextraPlots = new IONJGrDrawable(
				IParameters.EXTRA_PLOTS_X,
				IParameters.EXTRA_PLOTS_Y);
		DataReduction.extraPlotsTabbedPane.addTab("Signal with Background", DataReduction.c_SRBextraPlots);
		
		//Normalization region summed vs TOF
		DataReduction.c_NRextraPlots = new IONJGrDrawable(
				IParameters.EXTRA_PLOTS_X,
				IParameters.EXTRA_PLOTS_Y);
		DataReduction.extraPlotsTabbedPane.addTab("Normalization", DataReduction.c_NRextraPlots);
		
		//Background region from normalization summed TOF
		DataReduction.c_BRNextraPlots = new IONJGrDrawable(
				IParameters.EXTRA_PLOTS_X,
				IParameters.EXTRA_PLOTS_Y);
		DataReduction.extraPlotsTabbedPane.addTab("Background from Normalization", DataReduction.c_BRNextraPlots);

		DataReduction.extraPlotsPanel.add(DataReduction.extraPlotsTabbedPane);
		
				
	}
	
	
}
