package gov.ornl.sns.iontools;

import java.awt.event.*;

public class SuperEventHandler extends DataReduction {

	static void lookForEvent(ActionEvent evt) {
		
		if ("signalPidFileButton".equals(evt.getActionCommand())) {
			SaveSignalPidFileAction.signalPidFileButton();
		}
		
		if (IParameters.DEBUG) {DebuggingTools.displayData();}
   	   	
	   	if ("loadctComboBox".equals(evt.getActionCommand())) {
	   		String cmdLoadct = SubmitLoadct.createLoadctCmd();

	   	//main plot run in another thread
			SubmitLoadct run = new SubmitLoadct(cmdLoadct);
			Thread runThread = new Thread(run,"Loadct plot in progress");
			runThread.start();
	   		
	   	}
	   		   	
		if ("clearSignalPidFileButton".equals(evt.getActionCommand())) {
			SaveSignalPidFileAction.clearSignalPidFileAction();
			doBox();
		}
		
		if ("backgroundPidFileButton".equals(evt.getActionCommand())) {
			SaveBackgroundPidFileAction.backgroundPidFileButton();
		}
		
		if ("clearBackPidFileButton".equals(evt.getActionCommand())) {
			SaveBackgroundPidFileAction.clearBackgroundPidFileAction();
			doBox();
		}
			
		if ("xValidateButton".equals(evt.getActionCommand()) ||
			"yValidateButton".equals(evt.getActionCommand()) ||
			"xMaxTextField".equals(evt.getActionCommand()) ||
			"xMinTextField".equals(evt.getActionCommand()) ||
			"yMaxTextField".equals(evt.getActionCommand()) ||
			"yMinTextField".equals(evt.getActionCommand())) {
			if (liveParameters.isCombineDataSpectrum()) { //combine plots
				UpdateDataReductionPlotCombineInterface.validateDataReductionPlotCombineXYAxis();
			} else { //uncombine plot
				UpdateDataReductionPlotUncombineInterface.validateDataReductionPlotUncombineXYAxis();
			}
		}
			
		if ("xResetButton".equals(evt.getActionCommand())) {
			UpdateDataReductionPlotCombineInterface.resetDataReductionPlotCombineXAxis();
		}
		
		if ("yResetButton".equals(evt.getActionCommand())) {
			if (liveParameters.isCombineDataSpectrum()) { //combine plots
				UpdateDataReductionPlotCombineInterface.resetDataReductionPlotCombineYAxis();
			} else {
				UpdateDataReductionPlotUncombineInterface.resetDataReductionPlotUncombineYAxis();
			}
		}
		
		if ("wavelengthMinTextField".equals(evt.getActionCommand())) {
			WavelengthAction.validatingWavelengthMinText();
		}
		
		if ("wavelengthMaxTextField".equals(evt.getActionCommand())) {
			WavelengthAction.validatingWavelengthMaxText();
		}
		
		if ("wavelengthWidthTextField".equals(evt.getActionCommand())) {
			WavelengthAction.validatingWavelengthWidthText();
		}
		
		if ("detectorAngleTextField".equals(evt.getActionCommand())) {
			DetectorAngleAction.validatingDetectorAngleText();
		}
		
		if ("detectorAnglePMTextField".equals(evt.getActionCommand())) {
			DetectorAngleAction.validatingDetectorAnglePMText();
		}
		
		if ("yesNormalization".equals(evt.getActionCommand())) {
		  	NormalizationAction.yesNormalization();
		}

		if ("noNormalization".equals(evt.getActionCommand())) {
		   	NormalizationAction.noNormalization();
		}
		    
		if ("normalizationTextField".equals(evt.getActionCommand())) {
		   	NormalizationAction.yesNormalization();
		}

		if ("yesBackground".equals(evt.getActionCommand())) {
			extraPlotsBSCheckBox.setEnabled(true);
		}

		if ("noBackground".equals(evt.getActionCommand())) {
			extraPlotsBSCheckBox.setEnabled(false);
		}

		if ("yesNormBackground".equals(evt.getActionCommand())) {
			extraPlotsBRNCheckBox.setEnabled(true);
		}

		if ("noNormBackground".equals(evt.getActionCommand())) {
			extraPlotsBRNCheckBox.setEnabled(false);
		}

		if ("yesIntermediate".equals(evt.getActionCommand())) {
			intermediateButton.setEnabled(true);
		}

		if ("noIntermediate".equals(evt.getActionCommand())) {
			intermediateButton.setEnabled(false);
		}

		if ("intermediateButton".equals(evt.getActionCommand())) {
			tabbedPane.setSelectedIndex(3);
		}
		    
		/* Settings tab */
		if ("settingsValidateButton".equals(evt.getActionCommand())) {
			tabbedPane.setSelectedIndex(0);
			dataReductionTabbedPane.setSelectedIndex(0);	
		}
		
		if ("settingsSelectAllButton".equals(evt.getActionCommand())) {
			SettingsPanelAction.selectAllSettingsTab();
		}
		
		if ("settingsUnselectAllButton".equals(evt.getActionCommand())) {
			SettingsPanelAction.unselectAllSettingsTab();
		}
		
		if ("yesCombineSpectrum".equals(evt.getActionCommand())) {
		   	CheckDataReductionButtonValidation.bCombineDataSpectrum = true;
		   	CheckGUI.enableDataReductionPlotXAxis();
		}

		if ("noCombineSpectrum".equals(evt.getActionCommand())) {
		   	if (DataReduction.instrument.compareTo(IParameters.REF_M)==0) { //REF_M
		   		DataReduction.yesCombineSpectrumRadioButton.setSelected(true);
		   	} else {
		   		CheckDataReductionButtonValidation.bCombineDataSpectrum = false;
		   	}
			CheckGUI.disableDataReductionPlotXAxis();
		}
		    
		if ("yesInstrumentGeometry".equals(evt.getActionCommand())) {
		   	InstrumentGeometryAction.yesInstrumentGeometry();
		}

		if ("noInstrumentGeometry".equals(evt.getActionCommand())) {
		   	InstrumentGeometryAction.noInstrumentGeometry();
		}

		if ("instrumentGeometryButton".equals(evt.getActionCommand())) {
		}

		if ("instrumentGeometryTextField".equals(evt.getActionCommand())) {
		   	InstrumentGeometryAction.yesInstrumentGeometry();	    		
		}

		if ("startDataReductionButton".equals(evt.getActionCommand())) {
		    	
			String cmd_local = CreateCmdAndRunDataReduction.createDataReductionCmd();
		  	cmd_local += ExtraPlots.createIDLcmd();  //add extra plot
		    
			//main plot run in another thread
			SubmitDataReduction run = new SubmitDataReduction(cmd_local);
			Thread runThread = new Thread(run,"Data Reduction in progess");
			runThread.start();

		}
		    
		//if one of the intermediate check box is check
		if ("plot1".equals(evt.getActionCommand())) {
		}

		if ("instrumentREFL".equals(evt.getActionCommand())) {
		   	DataReduction.displayInstrumentLogo(0);
		  	instrument = IParameters.REF_L;
		  	CheckGUI.populateCheckDataReductionButtonValidationParameters();
		  	c_plot_REFL.setVisible(true);
		  	c_plot_REFM.setVisible(false);
		  	c_plot = c_plot_REFL;
		  	UpdateMainGUI.prepareGUI();
		  	DataReduction.initializeParameters();
		}

		if ("instrumentREFM".equals(evt.getActionCommand())) {
		   	displayInstrumentLogo(1);
		   	instrument = IParameters.REF_M;
		   	CheckGUI.populateCheckDataReductionButtonValidationParameters();
		   	c_plot_REFL.setVisible(false);
		  	c_plot_REFM.setVisible(true);
		  	c_plot = c_plot_REFM;
		  	UpdateMainGUI.prepareGUI();
		  	initializeParameters();
		}

		if ("preferencesMenuItem".equals(evt.getActionCommand())) {
		//    preferencesFrame.setVisible(true);
		}

		if ("signalSelection".equals(evt.getActionCommand())) {
			modeSelected = "signalSelection";
		}
		    
		if ("back1Selection".equals(evt.getActionCommand())) {
			modeSelected = "back1Selection";
		}
		    
		if ("back2Selection".equals(evt.getActionCommand())) {
			modeSelected = "back2Selection";
		}
		    
		if ("info".equals(evt.getActionCommand())) {
			modeSelected = "info";
		}
		    
		if ("runsAddTextField".equals(evt.getActionCommand())) {
		}
		    
		if ("runsSequenceTextField".equals(evt.getActionCommand())) {
		}

		if ("runNumberTextField".equals(evt.getActionCommand())) {
		    
			//reset color of all tabs
			TabUtils.removedAllTabColor();
			
			//retrive value of run number
			DataReduction.runNumberValue = DataReduction.runNumberTextField.getText();
						
			if (runNumberValue.compareTo("") != 0) {   //plot only if there is a run number
		
					//remove or not parameters we don't want anymore
				ParametersToKeep.refreshGuiWithParametersToKeep();
				
				ionInstrument = new com.rsi.ion.IONVariable(instrument);
				user = new com.rsi.ion.IONVariable(ucams); 
				ionLoadct = new com.rsi.ion.IONVariable(loadctComboBox.getSelectedIndex());
				ionWorkingPathSession = new com.rsi.ion.IONVariable(ParametersToKeep.sSessionWorkingDirectory);
				
				c_ionCon.setDrawable(c_plot);
		    		    	
				String cmd = "result = plot_data( " + runNumberValue + ", " + 
				ionInstrument + ", " + user + "," + ionLoadct;
				cmd += "," + ionWorkingPathSession + ")";

				//main plot run in another thread
				SubmitPlot run = new SubmitPlot(cmd);
				Thread runThread = new Thread(run,"plot in progress");
				runThread.start();
				
			}	
		}		

		if ("xValidateButtonEP".equals(evt.getActionCommand()) || 
			"yValidateButtonEP".equals(evt.getActionCommand()) ||
			"xMinTextFieldEP".equals(evt.getActionCommand()) ||
			"xMaxTextFieldEP".equals(evt.getActionCommand()) ||
			"yMinTextFieldEP".equals(evt.getActionCommand()) ||
			"yMaxTextFieldEP".equals(evt.getActionCommand())) {
			bEPFirstTime = false;
			UpdateExtraPlotsInterface.updateExtraPlotsGUI();
		}
		
		if ("xResetButtonEP".equals(evt.getActionCommand()) ||
		    "yResetButtonEP".equals(evt.getActionCommand())) {	
			UpdateExtraPlotsInterface.refreshExtraPlotsGUI();
		}
			
		if (CheckDataReductionButtonValidation.checkDataReductionButtonStatus()) {
			startDataReductionButton.setEnabled(true);
		} else {
			startDataReductionButton.setEnabled(false);
		}

		if ("replotSelectionButton".equals(evt.getActionCommand())) {
			doBox();
		}

		
	}
	
}
