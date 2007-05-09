package gov.ornl.sns.iontools;

public class DebuggingTools {

	static void displayData(){
		
		System.out.println("Instrument is:                  " 
				+ DataReduction.liveParameters.getInstrument());
		System.out.println("Signal PID file is:             " 
				+ DataReduction.liveParameters.getSignalPidFile());
		System.out.println("Back. PID file is:              " 
				+ DataReduction.liveParameters.getBackPidFile());
		System.out.println("run number is:                  " 
				+ DataReduction.liveParameters.getRunNumber());
		System.out.println("Signal Pid file has been saved: " 
				+ DataReduction.liveParameters.isSignalPidFileSaved());
		System.out.println("Back. Pid file has been saved:  "
				+ DataReduction.liveParameters.isBackPidFileSaved());
		System.out.println("Normalization has been selected:"
				+ DataReduction.liveParameters.isNormalizationSwitch());
		System.out.println("Normalization run number is:    "
				+ DataReduction.liveParameters.getNormalizationRunNumber());
		System.out.println("Background has been selected:   "
				+ DataReduction.liveParameters.isBackgroundSwitch());
		System.out.println("Normalization background switch:"
				+ DataReduction.liveParameters.isNormalizationBackgroundSwitch());
		System.out.println("Intermediate plots selected:    "
				+ DataReduction.liveParameters.isIntermediatePlotsSwitch());
		System.out.println(" - Extra plots SR selected:  " 
				+ DataReduction.liveParameters.isExtraPlotsSRBselected());
		System.out.println(" - Extra plots BS selected:  " 
				+ DataReduction.liveParameters.isExtraPlotsBSselected());
		System.out.println(" - Extra plots SRB selected: " 
				+ DataReduction.liveParameters.isExtraPlotsSRBselected());
		System.out.println(" - Extra plots NR selected:  "
				+ DataReduction.liveParameters.isExtraPlotsNRselected());
		System.out.println(" - Extra plots BRN selected: "
				+ DataReduction.liveParameters.isExtraPlotsBRNselected());
		System.out.println("Combine data spetrum selected:  "
				+ DataReduction.liveParameters.isCombineDataSpectrum());
		System.out.println("Overwrite instrument geometry:  "
				+ DataReduction.liveParameters.isOverwriteInstrumentGeometry());
		System.out.println("Instrument geometry is:         "
				+ DataReduction.liveParameters.getInstrumentGeometry());
		System.out.println("Add NeXus and go is selected:   "
				+ DataReduction.liveParameters.isAddNexusAndGo());
		System.out.println("Add NeXus ang go string:        "
				+ DataReduction.liveParameters.getAddNexusAndGoString());
		System.out.println("Go Sequentially string:         "
				+ DataReduction.liveParameters.getGoSequentiallyString());
			
	}
	
}
