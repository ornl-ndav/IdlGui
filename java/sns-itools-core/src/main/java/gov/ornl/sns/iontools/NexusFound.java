package gov.ornl.sns.iontools;

public class NexusFound {

	private boolean foundNexus;
	
	public NexusFound(String sNexusFound) {
		
		//0-> NeXus file not found 1-> NeXus file found
		if (sNexusFound.compareTo("0") == 0) {
			foundNexus = false;
		} else {
			foundNexus = true;
		}
	}
	
	public boolean isNexusFound() {
			return foundNexus;
	}
	
}
