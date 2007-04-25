package gov.ornl.sns.iontools;

//import gov.ornl.sns.iontools.ParametersConfiguration;
import com.rsi.ion.*;

public class NexusFound {

	private boolean foundNexus;
	
	public NexusFound(IONVariable IONfoundNexus) {
		
		//0-> NeXus file not found 1-> NeXus file found
		if (IONfoundNexus.toString().compareTo("0") == 0) {
			foundNexus = false;
		} else {
			foundNexus = true;
		}
	}
	
	public boolean isNexusFound() {
			return foundNexus;
	}
	
}
