;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder
IdlUtilitiesPath = "utilities/"

;Makefile that automatically compile the necessary modules
;and create the VM file.
cd, CurrentFolder + '/utilities'
.run system_utilities.pro
.run nexus_utilities.pro
.run math_conversion.pro

;Build REFreduction GUI
cd, CurrentFolder + '/REFreductionGUI/'
.run MakeGuiInstrumentSelection.pro

;Build miniREFreduction GUI
cd, CurrentFolder + '/miniREFreductionGUI/'
.run miniMakeGuiMainTab.pro
.run miniMakeGuiLoadTab.pro
.run miniMakeGuiLoadDataNormalizationTab.pro
.run miniMakeGuiLoadDataTab.pro
.run miniMakeGuiLoadData1D2DTab.pro
.run miniMakeGuiLoadData1DTab.pro
.run miniMakeGuiLoadData1D_3D_Tab.pro
.run miniMakeGuiLoadData2DTab.pro
.run miniMakeGuiLoadData2D_3D_Tab.pro
.run miniMakeGuiLoadNormalizationTab.pro
.run miniMakeGuiLoadNormalization1D2DTab.pro
.run miniMakeGuiLoadNormalization1DTab.pro
.run miniMakeGuiLoadNormalization1D_3D_Tab.pro
.run miniMakeGuiLoadNormalization2DTab.pro
.run miniMakeGuiLoadNormalization2D_3D_Tab.pro

.run miniMakeGuiReduceTab.pro
.run miniMakeGuiReduceDataBase.pro
.run miniMakeGuiReduceNormalizationBase.pro
.run miniMakeGuiReduceQbase.pro
.run miniMakeGuiReduceDetectorBase.pro
.run miniMakeGuiReduceIntermediatePlotBase.pro
.run miniMakeGuiReduceOther.pro
.run miniMakeGuiReduceInfo.pro

.run miniMakeGuiPlotsTab.pro
.run miniMakeGuiPlotsMainIntermediatesBases.pro

.run miniMakeGuiBatchTab.pro

.run miniMakeGuiLogBookTab.pro

;Build main procedures
cd, CurrentFolder
.run ref_reduction_string.pro
.run ref_reduction_get.pro
.run ref_reduction_put.pro
.run ref_reduction_is.pro
.run ref_reduction_time.pro

.run ref_reduction_DumpBinary.pro
.run ref_reduction_LoadDataFile.pro
.run ref_reduction_NXsummary.pro
.run ref_reduction_Plot1D2DDataFile.pro
.run ref_reduction_Plot2DDataFile.pro
.run ref_reduction_Plot1DDataFile.pro
.run ref_reduction_LoadNormalizationFile.pro
.run ref_reduction_Plot1D2DNormalizationFile.pro
.run ref_reduction_Plot2DNormalizationFile.pro
.run ref_reduction_Plot1DNormalizationFile.pro
.run ref_reduction_Zoom.pro
.run ref_reduction_RescaleDataPlot.pro
.run ref_reduction_RescaleData1D3DPlot.pro
.run ref_reduction_RescaleData2D3DPlot.pro
.run ref_reduction_RescaleNormalizationPlot.pro
.run ref_reduction_RescaleNormalization1D3DPlot.pro
.run ref_reduction_RescaleNormalization2D3DPlot.pro

.run ref_reduction_DataMouseSelection.pro
.run ref_reduction_NormMouseSelection.pro
.run ref_reduction_DataBackgroundPeakSelection.pro
.run ref_reduction_NormBackgroundPeakSelection.pro
.run ref_reduction_CreateBackgroundROIFile.pro
.run ref_reduction_CreateBackgroundROIFileName.pro
.run ref_reduction_DisplayPreviewOfRoiFile.pro
.run ref_reduction_LoadBackgroundSelection.pro
.run ref_reduction_ManuallyMoveBackPeakSelection.pro

.run ref_reduction_GUIinteraction.pro
.run ref_reduction_UpdateDataNormGui.pro
.run ref_reduction_UpdateReduceTabGui.pro
.run ref_reduction_UpdatePlotsTabGui.pro
.run ref_reduction_CommandLineIntermediatePlotsGenerator.pro
.run ref_reduction_CommandLineGenerator.pro
.run ref_reduction_ReplaceRunNumber.pro
.run ref_reduction_RunCommandLine.pro
.run ref_reduction_LoadMainOutputFile.pro
.run ref_reduction_LoadXmlOutputFile.pro
.run ref_reduction_LoadIntermediateFiles.pro
.run ref_reduction_PlotOutputFiles.pro
.run ref_reduction_DisplayMetadataFile.pro
.run ref_reduction_SaveFileInfo.pro
.run ref_reduction_OverwriteInstrumentGeometry.pro
.run ref_reduction_CL.pro
.run ref_reduction_OutputPath.pro

.run IDLgetMetadata__define.pro
.run ref_reduction_BatchTab.pro
.run ref_reduction_BatchDataNorm.pro
.run IDLparseCommandLine__define.pro
.run IDLupdateGui__define.pro
.run ref_reduction_BatchRepopulateGui.pro

.run ref_reduction_LogBookInterface.pro

.run MainBaseEvent.pro
.run ref_reduction_eventcb.pro
.run mini_ref_reduction.pro
