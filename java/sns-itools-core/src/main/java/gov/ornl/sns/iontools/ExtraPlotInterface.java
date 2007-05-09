package gov.ornl.sns.iontools;

public class ExtraPlotInterface {

	//type of instance
	private String type;
	private String sNotDefined = "N/A";
	
	//Signal Region 
	private String xMinSR;
	private String yMinSR;
	private String xMaxSR;
	private String yMaxSR;
	
	//Background Summed
	private String xMinBS;
	private String yMinBS;
	private String xMaxBS;
	private String yMaxBS;
	
	//Signal Region with Background
	private String xMinSRB ;
	private String yMinSRB;
	private String xMaxSRB;
	private String yMaxSRB;
	
	//Normalization region
	private String xMinNR;
	private String yMinNR;
	private String xMaxNR;
	private String yMaxNR;

	//Background region from normalization
	private String xMinBRN;
	private String yMinBRN;
	private String xMaxBRN;
	private String yMaxBRN;

	/*
	 * Constructor that initialize the axis of all the Extra plots
	 */
	ExtraPlotInterface(String sEPtype, String[] xy) {
		
		type = sEPtype;
		if (sEPtype.compareTo(IParameters.SR)==0) {  //Signal Region
			xMinSR = xy[0];
			yMinSR = xy[1];
			xMaxSR = xy[2];
			yMaxSR = xy[3];
		} else if (sEPtype.compareTo(IParameters.BS)==0) {  //Background Summed
			xMinBS = xy[0];
			yMinBS = xy[1];
			xMaxBS = xy[2];
			yMaxBS = xy[3];
		} else if (sEPtype.compareTo(IParameters.SRB)==0) {    //Signal region with background
			xMinSRB = xy[0];
			yMinSRB = xy[1];
			xMaxSRB = xy[2];
			yMaxSRB = xy[3];
		} else if (sEPtype.compareTo(IParameters.NR)==0) {     //Normalization region
			xMinNR = xy[0];
			yMinNR = xy[1];
			xMaxNR = xy[2];
			yMaxNR = xy[3];
		} else if (sEPtype.compareTo(IParameters.BRN)==0) {    //Background region from normalization
			xMinBRN = xy[0];
			yMinBRN = xy[1];
			xMaxBRN = xy[2];
			yMaxBRN = xy[3];
		}		
	}

	public String getXMin() {
		
		if (type.compareTo(IParameters.SR)==0) {return xMinSR;}
		if (type.compareTo(IParameters.BS)==0) {return xMinBS;}
		return sNotDefined;
		
	}
	







}