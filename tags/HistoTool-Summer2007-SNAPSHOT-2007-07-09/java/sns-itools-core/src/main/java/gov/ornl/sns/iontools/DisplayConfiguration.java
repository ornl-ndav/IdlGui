package gov.ornl.sns.iontools;

import gov.ornl.sns.iontools.IParameters;

public class DisplayConfiguration {

	private String instrument;
	
	private int Nx;
	private int NxMin;
	private int NxMax;
	private int Ny;	
	private int NyMin;
	private int NyMax;
				
/**
 * Constructor that initialize the instrument name
 * @param inst
 */
	public DisplayConfiguration(String inst) {
			this.instrument = inst;
	}
	
	/**
	 * This method returns the number of pixels in the x-axis direction according to 
	 * the name of the instrument
	 * @return the number of pixels in the x-axis
	 */
	public int retrieveNx() {
		if (this.instrument.compareTo("REF_L") == 0) {
			Nx = IParameters.NxRefl;
		} else if (this.instrument.compareTo("REF_M") == 0) {
			Nx = IParameters.NxRefm;
		}	
		return Nx;
	}		

	/**
	 * This method returns the number of pixels in the y-axis direction according to
	 * the name of the instrument
	 * @return the number of pixel in the y-axis
	 */
	public int retrieveNy () {
		if (this.instrument.compareTo("REF_L") == 0) {
			Ny = IParameters.NyRefl;
		} else if (this.instrument.compareTo("REF_M") == 0) {
			Ny = IParameters.NyRefm;
		}	
		return Ny;
	}

	/**
	 * This method returns the Nx minimum used by the selection tool in the
	 * main graphical window
	 * @return NxMin
	 */
	public int retrieveNxMin() {
		if (this.instrument.compareTo("REF_L") == 0) {
			NxMin = IParameters.NxReflMin;
		} else if (this.instrument.compareTo("REF_M") == 0) {
			NxMin = IParameters.NxRefmMin;
		}
		return NxMin;
	}
	
	/**
	 * This method returns the Nx maximum used by the selection tool in the
	 * main graphical window
	 * @return NxMax
	 */
	public int retrieveNxMax() {
		if (this.instrument.compareTo("REF_L") == 0) {
			NxMax = IParameters.NxReflMax;
		} else if (this.instrument.compareTo("REF_M") == 0) {
			NxMax = IParameters.NxRefmMax;
		}
		return NxMax;
	}
	
	/**
	 * This method returns the Ny minimum used by the selection tool in the
	 * main graphical window
	 * @return NyMin
	 */
	public int retrieveNyMin() {
		if (this.instrument.compareTo("REF_L") == 0) {
			NyMin = IParameters.NyReflMin;
		} else if (this.instrument.compareTo("REF_M") == 0) {
			NyMin = IParameters.NyRefmMin;
		}
		return NyMin;
	}

	/**
	 * This method returns the Ny minimum used by the selection tool in the
	 * main graphical window
	 * @return NyMin
	 */
	public int retrieveNyMax() {
		if (this.instrument.compareTo("REF_L") == 0) {
			NyMax = IParameters.NyReflMax;
		} else if (this.instrument.compareTo("REF_M") == 0) {
			NyMax = IParameters.NyRefmMax;
		}
		return NyMax;
	}
	
}
