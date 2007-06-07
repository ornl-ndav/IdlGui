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

public class PixelInfo {

	private double dDistanceFromXBorder;
	private double dDistanceFromXCenter;
	private double dDistanceFromYBorder;
	private double dDistanceFromYCenter;
	private int iCenterPixelXLeft;
	private int iCenterPixelXRight;
	private int iCenterPixelYLeft;
	private int iCenterPixelYRight;
	
	public PixelInfo(int x, int y, String instrument) {
		
		setCenterPixelData(instrument);
		setDistanceFromXBorder(x);
		setDistanceFromXCenter(x);
		setDistanceFromYBorder(x);
		setDistanceFromYCenter(x);
	}
	
	private void setCenterPixelData(String instrument) {
		if (instrument.compareTo(IParameters.REF_L) == 0) {
			iCenterPixelXLeft = IParameters.CENTER_PIXEL_X_LEFT_REF_L;
			iCenterPixelXRight = IParameters.CENTER_PIXEL_X_RIGHT_REF_L;
			iCenterPixelYLeft = IParameters.CENTER_PIXEL_Y_LEFT_REF_L;
			iCenterPixelYRight = IParameters.CENTER_PIXEL_Y_RIGHT_REF_L;
		} else {
			iCenterPixelXLeft = IParameters.CENTER_PIXEL_X_LEFT_REF_M;
			iCenterPixelXRight = IParameters.CENTER_PIXEL_X_RIGHT_REF_M;
			iCenterPixelYLeft = IParameters.CENTER_PIXEL_Y_LEFT_REF_M;
			iCenterPixelYRight = IParameters.CENTER_PIXEL_Y_RIGHT_REF_M;
		}
	}
	
	private void setDistanceFromXBorder(int x) {
		dDistanceFromXBorder = IParameters.PIXEL_SIZE_MM * x; 
	}
	
	private void setDistanceFromXCenter(int x) {
		double dXDiff;
		if (x <= iCenterPixelXLeft) {
			dXDiff = iCenterPixelXLeft - x;
		} else {
			dXDiff = x - iCenterPixelXRight;
		}
		dDistanceFromXCenter = IParameters.HALF_PIXEL_SIZE_MM + dXDiff * IParameters.PIXEL_SIZE_MM;
	}

	private void setDistanceFromYBorder(int y) {
		dDistanceFromYBorder = IParameters.PIXEL_SIZE_MM * y;
	}
	
	private void setDistanceFromYCenter(int y) {
		double dYDiff;
		if (y <= iCenterPixelYLeft) {
			dYDiff = iCenterPixelYLeft - y;
		} else {
			dYDiff = y - iCenterPixelYRight;
		}
		dDistanceFromYCenter = IParameters.HALF_PIXEL_SIZE_MM + dYDiff * IParameters.PIXEL_SIZE_MM;
	}

	public double[] getPixelInfo() {
		double [] dPixelInfoArray = {dDistanceFromXBorder, dDistanceFromXCenter, dDistanceFromYBorder, dDistanceFromYCenter};
		return dPixelInfoArray;
	}
}
