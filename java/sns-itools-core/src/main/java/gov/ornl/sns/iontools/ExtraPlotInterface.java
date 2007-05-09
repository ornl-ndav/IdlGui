package gov.ornl.sns.iontools;

public class ExtraPlotInterface {

	//type of instance
	private String sNotDefined = "N/A";
	
	static boolean bSRplot  = false;
	static boolean bBSplot  = false;
	static boolean bSRBplot = false;
	static boolean bNRplot  = false;
	static boolean bBRNplot = false;
	
	//Signal Region 
	private static String xMinSR     = IParameters.NA;
	private static String yMinSR     = IParameters.NA;
	private static String xMaxSR     = IParameters.NA;
	private static String yMaxSR     = IParameters.NA;
	private static String FTxMinSR   = IParameters.NA;
	private static String FTyMinSR   = IParameters.NA;
	private static String FTxMaxSR   = IParameters.NA;
	private static String FTyMaxSR   = IParameters.NA;
	private static String xScaleSR   = IParameters.XSCALE;
	private static String yScaleSR   = IParameters.YSCALE;
	private static String FTxScaleSR = IParameters.XSCALE;
	private static String FTyScaleSR = IParameters.YSCALE;
	
	//Background Summed
	private static String xMinBS     = IParameters.NA;
	private static String yMinBS     = IParameters.NA;
	private static String xMaxBS     = IParameters.NA;
	private static String yMaxBS     = IParameters.NA;
	private static String FTxMinBS   = IParameters.NA;
	private static String FTyMinBS   = IParameters.NA;
	private static String FTxMaxBS   = IParameters.NA;
	private static String FTyMaxBS   = IParameters.NA;
	private static String xScaleBS   = IParameters.XSCALE;
	private static String yScaleBS   = IParameters.YSCALE;
	private static String FTxScaleBS = IParameters.XSCALE;
	private static String FTyScaleBS = IParameters.YSCALE;
	
	//Signal Region with Background
	private static String xMinSRB     = IParameters.NA;
	private static String yMinSRB     = IParameters.NA;
	private static String xMaxSRB     = IParameters.NA;
	private static String yMaxSRB     = IParameters.NA;
	private static String FTxMinSRB   = IParameters.NA;
	private static String FTyMinSRB   = IParameters.NA;
	private static String FTxMaxSRB   = IParameters.NA;
	private static String FTyMaxSRB   = IParameters.NA;
	private static String xScaleSRB   = IParameters.XSCALE;
	private static String yScaleSRB   = IParameters.YSCALE;
	private static String FTxScaleSRB = IParameters.XSCALE;
	private static String FTyScaleSRB = IParameters.YSCALE;
	
	//Normalization region
	private static String xMinNR     = IParameters.NA;
	private static String yMinNR     = IParameters.NA;
	private static String xMaxNR     = IParameters.NA;
	private static String yMaxNR     = IParameters.NA;
	private static String FTxMinNR   = IParameters.NA;
	private static String FTyMinNR   = IParameters.NA;
	private static String FTxMaxNR   = IParameters.NA;
	private static String FTyMaxNR   = IParameters.NA;
	private static String xScaleNR   = IParameters.XSCALE;
	private static String yScaleNR   = IParameters.YSCALE;
	private static String FTxScaleNR = IParameters.XSCALE;
	private static String FTyScaleNR = IParameters.YSCALE;

	//Background region from normalization
	private static String xMinBRN     = IParameters.NA;
	private static String yMinBRN     = IParameters.NA;
	private static String xMaxBRN     = IParameters.NA;
	private static String yMaxBRN     = IParameters.NA;
	private static String FTxMinBRN   = IParameters.NA;
	private static String FTyMinBRN   = IParameters.NA;
	private static String FTxMaxBRN   = IParameters.NA;
	private static String FTyMaxBRN   = IParameters.NA;
	private static String xScaleBRN   = IParameters.XSCALE;
	private static String yScaleBRN   = IParameters.YSCALE;
	private static String FTxScaleBRN = IParameters.XSCALE;
	private static String FTyScaleBRN = IParameters.YSCALE;

	/*
	 * Constructor that initialize the axis of all the Extra plots
	 */
	ExtraPlotInterface(String sEPtype, String[] xy, String[] xyScale, boolean bFirstPlot) {
		
		if (bFirstPlot) {
			if (sEPtype.compareTo(IParameters.SR)==0) {  //Signal Region
				FTxMinSR = xy[0];
				FTyMinSR = xy[1];
				FTxMaxSR = xy[2];
				FTyMaxSR = xy[3];
				FTxScaleSR = xyScale[0];
				FTyScaleSR = xyScale[1];
			} else if (sEPtype.compareTo(IParameters.BS)==0) {  //Background Summed
				FTxMinBS = xy[0];
				FTyMinBS = xy[1];
				FTxMaxBS = xy[2];
				FTyMaxBS = xy[3];
				FTxScaleBS = xyScale[0];
				FTyScaleBS = xyScale[1];
			} else if (sEPtype.compareTo(IParameters.SRB)==0) {    //Signal region with background
				FTxMinSRB = xy[0];
				FTyMinSRB = xy[1];
				FTxMaxSRB = xy[2];
				FTyMaxSRB = xy[3];
				FTxScaleSRB = xyScale[0];
				FTyScaleSRB = xyScale[1];
			} else if (sEPtype.compareTo(IParameters.NR)==0) {     //Normalization region
				FTxMinNR = xy[0];
				FTyMinNR = xy[1];
				FTxMaxNR = xy[2];
				FTyMaxNR = xy[3];
				FTxScaleNR = xyScale[0];
				FTyScaleNR = xyScale[1];
			} else if (sEPtype.compareTo(IParameters.BRN)==0) {    //Background region from normalization
				FTxMinBRN = xy[0];
				FTyMinBRN = xy[1];
				FTxMaxBRN = xy[2];
				FTyMaxBRN = xy[3];
				FTxScaleBRN = xyScale[0];
				FTyScaleBRN = xyScale[1];
			}
		}
		
		if (sEPtype.compareTo(IParameters.SR)==0) {  //Signal Region
			xMinSR = xy[0];
			yMinSR = xy[1];
			xMaxSR = xy[2];
			yMaxSR = xy[3];
			xScaleSR = xyScale[0];
			yScaleSR = xyScale[1];
		} else if (sEPtype.compareTo(IParameters.BS)==0) {  //Background Summed
			xMinBS = xy[0];
			yMinBS = xy[1];
			xMaxBS = xy[2];
			yMaxBS = xy[3];
			xScaleBS = xyScale[0];
			yScaleBS = xyScale[1];
		} else if (sEPtype.compareTo(IParameters.SRB)==0) {    //Signal region with background
			xMinSRB = xy[0];
			yMinSRB = xy[1];
			xMaxSRB = xy[2];
			yMaxSRB = xy[3];
			xScaleSRB = xyScale[0];
			yScaleSRB = xyScale[1];
		} else if (sEPtype.compareTo(IParameters.NR)==0) {     //Normalization region
			xMinNR = xy[0];
			yMinNR = xy[1];
			xMaxNR = xy[2];
			yMaxNR = xy[3];
			xScaleNR = xyScale[0];
			yScaleNR = xyScale[1];
		} else if (sEPtype.compareTo(IParameters.BRN)==0) {    //Background region from normalization
			xMinBRN = xy[0];
			yMinBRN = xy[1];
			xMaxBRN = xy[2];
			yMaxBRN = xy[3];
			xScaleBRN = xyScale[0];
			yScaleBRN = xyScale[1];
		}
		
		//outputDebug();
		
	}

	public String getXMin(String type, boolean bFirstTime) {
		if (bFirstTime) {
			if (type.compareTo(IParameters.SR)==0)  {return FTxMinSR;}
			if (type.compareTo(IParameters.BS)==0)  {return FTxMinBS;}
			if (type.compareTo(IParameters.SRB)==0) {return FTxMinSRB;}
			if (type.compareTo(IParameters.NR)==0)  {return FTxMinNR;}
			if (type.compareTo(IParameters.BRN)==0) {return FTxMinBRN;}
		} 
		
		if (type.compareTo(IParameters.SR)==0)  {return xMinSR;}
		if (type.compareTo(IParameters.BS)==0)  {return xMinBS;}
		if (type.compareTo(IParameters.SRB)==0) {return xMinSRB;}
		if (type.compareTo(IParameters.NR)==0)  {return xMinNR;}
		if (type.compareTo(IParameters.BRN)==0) {return xMinBRN;}
		
		return sNotDefined;
	}
	
	public String getYMin(String type, boolean bFirstTime) {
		if (bFirstTime) {
			if (type.compareTo(IParameters.SR)==0)  {return FTyMinSR;}
			if (type.compareTo(IParameters.BS)==0)  {return FTyMinBS;}
			if (type.compareTo(IParameters.SRB)==0) {return FTyMinSRB;}
			if (type.compareTo(IParameters.NR)==0)  {return FTyMinNR;}
			if (type.compareTo(IParameters.BRN)==0) {return FTyMinBRN;}
		}
		if (type.compareTo(IParameters.SR)==0)  {return yMinSR;}
		if (type.compareTo(IParameters.BS)==0)  {return yMinBS;}
		if (type.compareTo(IParameters.SRB)==0) {return yMinSRB;}
		if (type.compareTo(IParameters.NR)==0)  {return yMinNR;}
		if (type.compareTo(IParameters.BRN)==0) {return yMinBRN;}
		
		return sNotDefined;
	}

	public String getXMax(String type, boolean bFirstTime) {
		if (bFirstTime) {
			if (type.compareTo(IParameters.SR)==0)  {return FTxMaxSR;}
			if (type.compareTo(IParameters.BS)==0)  {return FTxMaxBS;}
			if (type.compareTo(IParameters.SRB)==0) {return FTxMaxSRB;}
			if (type.compareTo(IParameters.NR)==0)  {return FTxMaxNR;}
			if (type.compareTo(IParameters.BRN)==0) {return FTxMaxBRN;}
		}
		if (type.compareTo(IParameters.SR)==0)  {return xMaxSR;}
		if (type.compareTo(IParameters.BS)==0)  {return xMaxBS;}
		if (type.compareTo(IParameters.SRB)==0) {return xMaxSRB;}
		if (type.compareTo(IParameters.NR)==0)  {return xMaxNR;}
		if (type.compareTo(IParameters.BRN)==0) {return xMaxBRN;}
		
		return sNotDefined;
	}

	public String getYMax(String type, boolean bFirstTime) {
		if (bFirstTime) {
			if (type.compareTo(IParameters.SR)==0)  {return FTyMaxSR;}
			if (type.compareTo(IParameters.BS)==0)  {return FTyMaxBS;}
			if (type.compareTo(IParameters.SRB)==0) {return FTyMaxSRB;}
			if (type.compareTo(IParameters.NR)==0)  {return FTyMaxNR;}
			if (type.compareTo(IParameters.BRN)==0) {return FTyMaxBRN;}
		}
		if (type.compareTo(IParameters.SR)==0)  {return yMaxSR;}
		if (type.compareTo(IParameters.BS)==0)  {return yMaxBS;}
		if (type.compareTo(IParameters.SRB)==0) {return yMaxSRB;}
		if (type.compareTo(IParameters.NR)==0)  {return yMaxNR;}
		if (type.compareTo(IParameters.BRN)==0) {return yMaxBRN;}
		
		return sNotDefined;
	}

	public String getxScale(String type, boolean bFirstTime) {
		if (bFirstTime) {
			if (type.compareTo(IParameters.SR)==0)  {return FTxScaleSR;}
			if (type.compareTo(IParameters.BS)==0)  {return FTxScaleBS;}
			if (type.compareTo(IParameters.SRB)==0) {return FTxScaleSRB;}
			if (type.compareTo(IParameters.NR)==0)  {return FTxScaleNR;}
			if (type.compareTo(IParameters.BRN)==0) {return FTxScaleBRN;}
		}
		if (type.compareTo(IParameters.SR)==0)  {return xScaleSR;}
		if (type.compareTo(IParameters.BS)==0)  {return xScaleBS;}
		if (type.compareTo(IParameters.SRB)==0) {return xScaleSRB;}
		if (type.compareTo(IParameters.NR)==0)  {return xScaleNR;}
		if (type.compareTo(IParameters.BRN)==0) {return xScaleBRN;}
		
		return sNotDefined;
	}

	public String getyScale(String type, boolean bFirstTime) {
		if (bFirstTime) {
			if (type.compareTo(IParameters.SR)==0)  {return FTyScaleSR;}
			if (type.compareTo(IParameters.BS)==0)  {return FTyScaleBS;}
			if (type.compareTo(IParameters.SRB)==0) {return FTyScaleSRB;}
			if (type.compareTo(IParameters.NR)==0)  {return FTyScaleNR;}
			if (type.compareTo(IParameters.BRN)==0) {return FTyScaleBRN;}
		}
		if (type.compareTo(IParameters.SR)==0)  {return yScaleSR;}
		if (type.compareTo(IParameters.BS)==0)  {return yScaleBS;}
		if (type.compareTo(IParameters.SRB)==0) {return yScaleSRB;}
		if (type.compareTo(IParameters.NR)==0)  {return yScaleNR;}
		if (type.compareTo(IParameters.BRN)==0) {return yScaleBRN;}
		
		return sNotDefined;
	}

	private static void outputDebug() {
	
		System.out.println("xMinSR: " + xMinSR);
		System.out.println("yMinSR: " + yMinSR);
		System.out.println("xMaxSR: " + xMaxSR);
		System.out.println("yMaxSR: " + yMaxSR);
		System.out.println("FTxMinSR: " + FTxMinSR);
		System.out.println("FTyMinSR: " + FTyMinSR);
		System.out.println("FTxMaxSR: " + FTxMaxSR);
		System.out.println("FTyMaxSR: " + FTyMaxSR);
		System.out.println("xScaleSR: " + xScaleSR);
		System.out.println("yScaleSR: " + yScaleSR);
		System.out.println("FTxScaleSR: " + FTxScaleSR);
		System.out.println("FTyScaleSR: " + FTyScaleSR);
				
		System.out.println("xMinBS: " + xMinBS);
		System.out.println("yMinBS: " + yMinBS);
		System.out.println("xMaxBS: " + xMaxBS);
		System.out.println("yMaxBS: " + yMaxBS);
		System.out.println("FTxMinBS: " + FTxMinBS);
		System.out.println("FTyMinBS: " + FTyMinBS);
		System.out.println("FTxMaxBS: " + FTxMaxBS);
		System.out.println("FTyMaxBS: " + FTyMaxBS);
		System.out.println("xScaleBS: " + xScaleBS);
		System.out.println("yScaleBS: " + yScaleBS);
		System.out.println("FTxScaleBS: " + FTxScaleBS);
		System.out.println("FTyScaleBS: " + FTyScaleBS);
		
		System.out.println("xMinSRB: " + xMinSRB);
		System.out.println("yMinSRB: " + yMinSRB);
		System.out.println("xMaxSRB: " + xMaxSRB);
		System.out.println("yMaxSRB: " + yMaxSRB);
		System.out.println("FTxMinSRB: " + FTxMinSRB);
		System.out.println("FTyMinSRB: " + FTyMinSRB);
		System.out.println("FTxMaxSRB: " + FTxMaxSRB);
		System.out.println("FTyMaxSRB: " + FTyMaxSRB);
		System.out.println("xScaleSRB: " + xScaleSRB);
		System.out.println("yScaleSRB: " + yScaleSRB);
		System.out.println("FTxScaleSRB: " + FTxScaleSRB);
		System.out.println("FTyScaleSRB: " + FTyScaleSRB);
		
		System.out.println("xMinNR: " + xMinNR);
		System.out.println("yMinNR: " + yMinNR);
		System.out.println("xMaxNR: " + xMaxNR);
		System.out.println("yMaxNR: " + yMaxNR);
		System.out.println("FTxMinNR: " + FTxMinNR);
		System.out.println("FTyMinNR: " + FTyMinNR);
		System.out.println("FTxMaxNR: " + FTxMaxNR);
		System.out.println("FTyMaxNR: " + FTyMaxNR);
		System.out.println("xScaleNR: " + xScaleNR);
		System.out.println("yScaleNR: " + yScaleNR);
		System.out.println("FTxScaleNR: " + FTxScaleNR);
		System.out.println("FTyScaleNR: " + FTyScaleNR);
		
		System.out.println("xMinBRN: " + xMinBRN);
		System.out.println("yMinBRN: " + yMinBRN);
		System.out.println("xMaxBRN: " + xMaxBRN);
		System.out.println("yMaxBRN: " + yMaxBRN);
		System.out.println("FTxMinBRN: " + FTxMinBRN);
		System.out.println("FTyMinBRN: " + FTyMinBRN);
		System.out.println("FTxMaxBRN: " + FTxMaxBRN);
		System.out.println("FTyMaxBRN: " + FTyMaxBRN);
		System.out.println("xScaleBRN: " + xScaleBRN);
		System.out.println("yScaleBRN: " + yScaleBRN);
		System.out.println("FTxScaleBRN: " + FTxScaleBRN);
		System.out.println("FTyScaleBRN: " + FTyScaleBRN);
				
	}
	
}