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

import java.awt.Color;

public class UpdateDataReductionRunNumberTextField {

	static String runNumberTextField = "";
	static boolean addRunNumberValue = false;
	
	static void updateDataReductionRunNumbers(String runNumberValue){
		
		//retrieve active tab (Add NeXus and Go or GO sequentially and value of text field
		if (CheckDataReductionButtonValidation.bAddNexusAndGo) {
			runNumberTextField = CheckDataReductionButtonValidation.sAddNexusAndGoString;
			DataReduction.runsAddTextField.setBackground(Color.WHITE);
		} else {
		    runNumberTextField = CheckDataReductionButtonValidation.sGoSequentiallyString;
		    DataReduction.runsSequenceTextField.setBackground(Color.WHITE);
		}

		if (!runNumberTextField.contains(runNumberValue)) { //run number not found in text field so far
			//check if run number is not inside a sequence of runs (1999-2002)

			if (runNumberTextField.contains(IParameters.SEQUENCE_SEPARATOR)) { //there is at least one sequence of runs
			
				String[]  tmp = runNumberTextField.split(",");

				//get size of tmp string array
				int tmpSize = tmp.length;
								
				for (int i=0 ; i<tmpSize ; i++) { 
				
					String[] tmp1 = tmp[i].split(IParameters.SEQUENCE_SEPARATOR);
					int tmp1Size = tmp1.length;
					
					if (tmp1Size > 1) { //if there is a seqence
					
						int runNumber1 = Integer.parseInt(tmp1[0].trim());
						int runNumber2 = Integer.parseInt(tmp1[1].trim());
						int iRunNumberValue = Integer.parseInt(runNumberValue.trim());
						
						if (runNumber1 <= runNumber2) {

							//check if runNumberValue is in the range runNumber1 -> runNumber2
							if (iRunNumberValue >= runNumber1 && iRunNumberValue <= runNumber2) {
								//runNumberValue is already in one of the sequence
								return;
							}
							
						} else {
							
							//check if runNumberValue is in the range runNumber2->runNumber1
							if (iRunNumberValue >= runNumber2 && iRunNumberValue <= runNumber1) {
								//runNumberValue is already in one of the sequence
								return;
							}
						}
								
					} 
				}
			}
				
			//run number is not part of the text field - we can add it
			if (CheckDataReductionButtonValidation.bAddNexusAndGo) {

				if (CheckDataReductionButtonValidation.sAddNexusAndGoString.compareTo("") == 0) {
					CheckDataReductionButtonValidation.sAddNexusAndGoString = runNumberValue;
				} else {
					CheckDataReductionButtonValidation.sAddNexusAndGoString += "," + runNumberValue;
				}
			} else {

				if (CheckDataReductionButtonValidation.sGoSequentiallyString.compareTo("") == 0) {
					CheckDataReductionButtonValidation.sGoSequentiallyString = runNumberValue;
				} else {
					CheckDataReductionButtonValidation.sGoSequentiallyString += "," + runNumberValue;
				}
			}		
			
		} else { //run number found in the text right away
			return;
		}
			
	}
		
}
	

