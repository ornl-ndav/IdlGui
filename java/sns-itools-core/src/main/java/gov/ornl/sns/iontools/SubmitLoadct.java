package gov.ornl.sns.iontools;

public class SubmitLoadct implements Runnable {

	/*
	 * This class runs the loadct plot in another thread
	 */
	private String cmd;
	
	public SubmitLoadct(String cmd) {

		this.cmd = cmd;
		
	}
	
	public void run() {
		
		ProcessingInterfaceWithGui.displayProcessingMessage("Replot in progress");
		IonUtils.executeCmd(this.cmd);
		ProcessingInterfaceWithGui.removeProcessingMessage();
		
	}
	
	static String createLoadctCmd() {
		
		DataReduction.ionLoadct = new com.rsi.ion.IONVariable(DataReduction.loadctComboBox.getSelectedIndex());
   		String cmd_loadct = "replot_data, " + DataReduction.runNumberValue + ","; 
		cmd_loadct += DataReduction.ionInstrument + "," + DataReduction.user + ",";
		cmd_loadct += DataReduction.ionLoadct;
		cmd_loadct += "," + DataReduction.ionWorkingPathSession;
		return cmd_loadct;
		
	}
}

