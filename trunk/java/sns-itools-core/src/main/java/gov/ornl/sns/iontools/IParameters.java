/*
 * Copyright (c) 2007, J.-C. Bilheux <bilheuxjm@ornl.gov>
 * Spallation Neutron Source at Oak Ridge National Laboratory
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
package gov.ornl.sns.iontools;

public interface IParameters {
	
		static final boolean DEBUG = false;
		
		static final String NA = "N/A";
	
		static final String DEFAULT_INSTRUMENT = "REF_L";
		static final String REF_L              = "REF_L";
		static final String REF_M              = "REF_M";
		
		static final double PIXEL_SIZE_MM           = 0.7; 
		static final double HALF_PIXEL_SIZE_MM      = PIXEL_SIZE_MM / 2;
		static final int CENTER_PIXEL_X_LEFT_REF_M  = 151;
		static final int CENTER_PIXEL_X_RIGHT_REF_M = 152;
		static final int CENTER_PIXEL_Y_LEFT_REF_M  = 127;
		static final int CENTER_PIXEL_Y_RIGHT_REF_M = 128;
		static final int CENTER_PIXEL_X_LEFT_REF_L  = 127;
		static final int CENTER_PIXEL_X_RIGHT_REF_L = 128;
		static final int CENTER_PIXEL_Y_LEFT_REF_L  = 151;
		static final int CENTER_PIXEL_Y_RIGHT_REF_L = 152;
		
		//REF_L Data Reduction command line - flags 
		static final String REF_L_DATA_REDUCTION_CMD 	= "reflect_tofred";
		
		//Data reducton command line -flags
		static final String NORMALIZATION_FLAG 		    = "--norm=";
		static final String INSTRUMENT_GEOMETRY_FLAG 	= "--inst_geom=";
		static final String COMBINE_FLAG 				= "--combine";
		static final String SIGNAL_ROI_FILE_FLAG 		= "--signal-roi-file=";
		static final String BKG_ROI_FILE_FLAG 	      	= "--bkg-roi-file=";
		static final String NO_BKG_FLAG  				= "--no-bkg";
		static final String NO_NORM_BKG             	= "--no-norm-bkg";
		static final String DUMP_SPECULAR               = "--dump-specular";
		static final String DUMP_SUB                    = "--dump-sub";
		static final String DUMP_NORM                   = "--dump-norm";
		static final String DUMP_NORM_BKG            	= "--dump-norm-bkg";

		//Extra plots extension
		static final String SR_EXTENSION                = ".sdc";
		static final String BS_EXTENSION                = ".bkg";
		static final String SRB_EXTENSION               = ".sub";
		static final String NR_EXTENSION                = ".nom";
		static final String BRN_EXTENSION               = ".bnm";
		
		//Extra plots file names
		static final String SR_TITLE       = "Signal Region";
		static final String BS_TITLE       = "Background";
		static final String SRB_TITLE      = "Signal Region with Background";
		static final String NR_TITLE       = "Normalization region";
		static final String BRN_TITLE      = "Background region from Normalization";
				
		//Extra plots type
		static final String SR				= "SR";
		static final String BS				= "BS";
		static final String SRB             = "SRB";
		static final String NR              = "NR";
		static final String BRN             = "BRN";
		
		//Extra plots and Data Reduction scaling factor
		static final String LINEAR          = "linear";
		static final String LOG10           = "log10";
		static final String XSCALE          = "linear";
		static final String YSCALE          = "log10";
		
		//Size of data reduction graphical window
		static final int DATA_REDUCTION_PLOT_X	            = 650;
		static final int DATA_REDUCTION_PLOT_Y              = 500;
		
		//Size of extra plots graphical window
		static final int EXTRA_PLOTS_X     					= 650;
		static final int EXTRA_PLOTS_Y                      = 500;
		
		//data reduction plot interaction
		static final int yAxisMin               = 0;
		static final int yAxisMax               = 200;
		static final int yAxisInit              = 1;
		static final int xAxisMin               = 0;
		static final int xAxisMax               = 200;
		static final int xAxisInit              = 1;
				
		//constants used to define the main graphical display size
	 	//REF_L
		static final int NxRefl        			= 256;
	    static final int NxReflMin              = 0;
	    static final int NxReflMax              = 256;
		static final int NyRefl                 = 304;
	    static final int NyReflMin 				= 0;
	    static final int NyReflMax			    = 304;
	    
	    //REF_M
	    static final int NxRefm                 = 304;
	    static final int NxRefmMin              = 0;
	    static final int NxRefmMax              = (303-255);
	    static final int NyRefm                 = 256;
	    static final int NyRefmMin              = 0;
	    static final int NyRefmMax              = (303-255);

	    static final String SIGNAL_STRING          = "signal";
	    static final String BACK1_STRING           = "back1";
	    static final String BACK2_STRING           = "back2";
	    static final String BACK_STRING            = "back";
	    static final String INFO_STRING            = "info";
	    
	    static final String PATH_TO_HOME           = "/SNS/users/";
	    static final String SEQUENCE_SEPARATOR     = "-";
	    static final String WORKING_PATH           = "~/local";

	    static final int LOADCT_DEFAULT_INDEX      = 39;
	    static final String[] LOADCT_NAME          = {"Black/White", 
	    											  "Blue/White", 
	    											  "Green/Red/Blue/White",
	    											  "Red Temperature",
	    											  "Blue/Green/Red/Yellow",
	    											  "Std Gamma-II",
	    											  "Prism",
	    											  "Red/Purple",
	    											  "Green/White Linear",
	    											  "Green/White Exponential",
	    											  "Green/Pink",
	    											  "Blue/Red",
	    											  "16 Level",
	    											  "Rainbow",
	    											  "Steps",
	    											  "Stern Special",
	    											  "Haze",
	    											  "Blue/Pastel/Red",
	    											  "Pastels",
	    											  "Hue Sat Lightness",
	    											  "Hue Sat Lightness",
	    											  "Hue Sat Value 1",
	    											  "Hue Sat Value 2",
	    											  "Purple/Red + Stri",
	    											  "Beach",
	    											  "Mac Style",
	    											  "Eos A",
	    											  "Eos B",
	    											  "Hardcandy",
	    											  "Nature",
	    											  "Ocean",
	    											  "Peppermint",
	    											  "Plasma",
	    											  "Blue/Red",
	    											  "Rainbow",
	    											  "Blue Waves",
	    											  "Volcano",
	    											  "Waves",
	    											  "Rainbow18",
	    											  "Rainbow + White",
	    											  "Rainbow + Black"};
	    											  
}
