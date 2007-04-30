package gov.ornl.sns.iontools;

public class MouseSelection {

	static void saveXY(String mode,int x_min, int y_min, int x_max, int y_max) {
    	
		if (mode.compareTo(IParameters.SIGNAL_STRING) == 0) {
    		DataReduction.signal_xmin = x_min;
    		DataReduction.signal_ymin = y_min;
    		DataReduction.signal_xmax = x_max;
    		DataReduction.signal_ymax = y_max;
    	} else if (mode.compareTo(IParameters.BACK1_STRING) == 0) {
    		DataReduction.back1_xmin = x_min;
    		DataReduction.back1_ymin = y_min;
    		DataReduction.back1_xmax = x_max;
    		DataReduction.back1_ymax = y_max;
    	} else if (mode.compareTo(IParameters.BACK2_STRING) == 0) {
    		DataReduction.back2_xmin = x_min;
    		DataReduction.back2_ymin = y_min;
    		DataReduction.back2_xmax = x_max;
    		DataReduction.back2_ymax = y_max;
    	} else if (mode.compareTo(IParameters.INFO_STRING) == 0) {
    		DataReduction.info_xmin = x_min;
    		DataReduction.info_ymin = y_min;
    		DataReduction.info_xmax = x_max;
    		DataReduction.info_ymax = y_max;
    	}
    }	
	
}
