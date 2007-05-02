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

public class ParametersConfiguration {

    //parameters used to trigger or not some of the methods
    public boolean bFoundNexus                = false;
    static int Nx;
    static int Ny;
    static int iNtof;
    static int iY12;
    
    //initial state of variables after loading data for the firs time
    static boolean bLinearXAxisInitial;
    static boolean bLinearYAxisInitial;
    static String sXMaxInitial;
    static String sXMinInitial;
    static String sYMaxInitial;
    static String sYMinInitial;
    
    //reset for each event 
    static boolean bLinearXAxis;
    static boolean bLinearYAxis;
    static String sXMax;
    static String sXMin;
    static String sYMax;
    static String sYMin;
    
    
    
    
    
    
    
}
