package gov.ornl.sns.iontools;

public class ProcessingInterfaceWithGui {

	static void displayProcessingMessage(String sMessage) {
		
		DataReduction.processingPanel.setVisible(true);
		DataReduction.processingInfoLabel.setText(sMessage + "....");
	
	}
	
	static void removeProcessingMessage() {
		
		DataReduction.processingPanel.setVisible(false);
		
	}
	
	
}
