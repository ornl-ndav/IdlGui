package gov.ornl.sns.iontools;

public class ExtraPlotInterface {

	//type of instance
	private String sNotDefined = "N/A";
	
	//Signal Region 
	private static String xMinSR =  IParameters.NA;
	private static String yMinSR =  IParameters.NA;
	private static String xMaxSR =  IParameters.NA;
	private static String yMaxSR =  IParameters.NA;
	private static String FTxMinSR = IParameters.NA;
	private static String FTyMinSR =  IParameters.NA;
	private static String FTxMaxSR =  IParameters.NA;
	private static String FTyMaxSR =  IParameters.NA;
	
	//Background Summed
	private static String xMinBS =  IParameters.NA;
	private static String yMinBS =  IParameters.NA;
	private static String xMaxBS =  IParameters.NA;
	private static String yMaxBS =  IParameters.NA;
	private static String FTxMinBS =  IParameters.NA;
	private static String FTyMinBS =  IParameters.NA;
	private static String FTxMaxBS =  IParameters.NA;
	private static String FTyMaxBS =  IParameters.NA;
	
	//Signal Region with Background
	private static String xMinSRB =  IParameters.NA;
	private static String yMinSRB =  IParameters.NA;
	private static String xMaxSRB =  IParameters.NA;
	private static String yMaxSRB =  IParameters.NA;
	private static String FTxMinSRB =  IParameters.NA;
	private static String FTyMinSRB =  IParameters.NA;
	private static String FTxMaxSRB =  IParameters.NA;
	private static String FTyMaxSRB =  IParameters.NA;
	
	//Normalization region
	private static String xMinNR =  IParameters.NA;
	private static String yMinNR =  IParameters.NA;
	private static String xMaxNR =  IParameters.NA;
	private static String yMaxNR =  IParameters.NA;
	private static String FTxMinNR =  IParameters.NA;
	private static String FTyMinNR =  IParameters.NA;
	private static String FTxMaxNR =  IParameters.NA;
	private static String FTyMaxNR =  IParameters.NA;

	//Background region from normalization
	private static String xMinBRN =  IParameters.NA;
	private static String yMinBRN =  IParameters.NA;
	private static String xMaxBRN =  IParameters.NA;
	private static String yMaxBRN =  IParameters.NA;
	private static String FTxMinBRN =  IParameters.NA;
	private static String FTyMinBRN =  IParameters.NA;
	private static String FTxMaxBRN =  IParameters.NA;
	private static String FTyMaxBRN =  IParameters.NA;

	/*
	 * Constructor that initialize the axis of all the Extra plots
	 */
	ExtraPlotInterface(String sEPtype, String[] xy, boolean bFirstPlot) {
		
		if (bFirstPlot) {
			if (sEPtype.compareTo(IParameters.SR)==0) {  //Signal Region
				FTxMinSR = xy[0];
				FTyMinSR = xy[1];
				FTxMaxSR = xy[2];
				FTyMaxSR = xy[3];
			} else if (sEPtype.compareTo(IParameters.BS)==0) {  //Background Summed
				FTxMinBS = xy[0];
				FTyMinBS = xy[1];
				FTxMaxBS = xy[2];
				FTyMaxBS = xy[3];
			} else if (sEPtype.compareTo(IParameters.SRB)==0) {    //Signal region with background
				FTxMinSRB = xy[0];
				FTyMinSRB = xy[1];
				FTxMaxSRB = xy[2];
				FTyMaxSRB = xy[3];
			} else if (sEPtype.compareTo(IParameters.NR)==0) {     //Normalization region
				FTxMinNR = xy[0];
				FTyMinNR = xy[1];
				FTxMaxNR = xy[2];
				FTyMaxNR = xy[3];
			} else if (sEPtype.compareTo(IParameters.BRN)==0) {    //Background region from normalization
				FTxMinBRN = xy[0];
				FTyMinBRN = xy[1];
				FTxMaxBRN = xy[2];
				FTyMaxBRN = xy[3];
			}
		} else {
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
	}

	public String getXMin(String type, boolean bFirstTime) {
		if (bFirstTime) {
			if (type.compareTo(IParameters.SR)==0)  {return FTxMinSR;}
			if (type.compareTo(IParameters.BS)==0)  {return FTxMinBS;}
			if (type.compareTo(IParameters.SRB)==0) {return FTxMinSRB;}
			if (type.compareTo(IParameters.NR)==0)  {return FTxMinNR;}
			if (type.compareTo(IParameters.BRN)==0) {return FTxMinBRN;}
		} else {
			if (type.compareTo(IParameters.SR)==0)  {return xMinSR;}
			if (type.compareTo(IParameters.BS)==0)  {return xMinBS;}
			if (type.compareTo(IParameters.SRB)==0) {return xMinSRB;}
			if (type.compareTo(IParameters.NR)==0)  {return xMinNR;}
			if (type.compareTo(IParameters.BRN)==0) {return xMinBRN;}
		}
		return sNotDefined;
	}
	
	public String getYMin(String type, boolean bFirstTime) {
		if (bFirstTime) {
			if (type.compareTo(IParameters.SR)==0)  {return FTyMinSR;}
			if (type.compareTo(IParameters.BS)==0)  {return FTyMinBS;}
			if (type.compareTo(IParameters.SRB)==0) {return FTyMinSRB;}
			if (type.compareTo(IParameters.NR)==0)  {return FTyMinNR;}
			if (type.compareTo(IParameters.BRN)==0) {return FTyMinBRN;}
		} else {
			if (type.compareTo(IParameters.SR)==0)  {return yMinSR;}
			if (type.compareTo(IParameters.BS)==0)  {return yMinBS;}
			if (type.compareTo(IParameters.SRB)==0) {return yMinSRB;}
			if (type.compareTo(IParameters.NR)==0)  {return yMinNR;}
			if (type.compareTo(IParameters.BRN)==0) {return yMinBRN;}
		}
		return sNotDefined;
	}

	public String getXMax(String type, boolean bFirstTime) {
		if (bFirstTime) {
			if (type.compareTo(IParameters.SR)==0)  {return FTxMaxSR;}
			if (type.compareTo(IParameters.BS)==0)  {return FTxMaxBS;}
			if (type.compareTo(IParameters.SRB)==0) {return FTxMaxSRB;}
			if (type.compareTo(IParameters.NR)==0)  {return FTxMaxNR;}
			if (type.compareTo(IParameters.BRN)==0) {return FTxMaxBRN;}
		} else {
			if (type.compareTo(IParameters.SR)==0)  {return xMaxSR;}
			if (type.compareTo(IParameters.BS)==0)  {return xMaxBS;}
			if (type.compareTo(IParameters.SRB)==0) {return xMaxSRB;}
			if (type.compareTo(IParameters.NR)==0)  {return xMaxNR;}
			if (type.compareTo(IParameters.BRN)==0) {return xMaxBRN;}
		}
		return sNotDefined;
	}

	public String getYMax(String type, boolean bFirstTime) {
		if (bFirstTime) {
			if (type.compareTo(IParameters.SR)==0)  {return FTyMaxSR;}
			if (type.compareTo(IParameters.BS)==0)  {return FTyMaxBS;}
			if (type.compareTo(IParameters.SRB)==0) {return FTyMaxSRB;}
			if (type.compareTo(IParameters.NR)==0)  {return FTyMaxNR;}
			if (type.compareTo(IParameters.BRN)==0) {return FTyMaxBRN;}
		} else {
			if (type.compareTo(IParameters.SR)==0)  {return yMaxSR;}
			if (type.compareTo(IParameters.BS)==0)  {return yMaxBS;}
			if (type.compareTo(IParameters.SRB)==0) {return yMaxSRB;}
			if (type.compareTo(IParameters.NR)==0)  {return yMaxNR;}
			if (type.compareTo(IParameters.BRN)==0) {return yMaxBRN;}
		}
		return sNotDefined;
	}

}