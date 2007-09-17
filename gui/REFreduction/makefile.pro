;$Id$

;Makefile that automatically compile the necessary modules
;and create the VM file.
cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/utilities/"
.run system_utilities.pro

cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/REFreduction/utilities/"
.run nexus_utilities.pro

cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/REFreduction/REFreductionGUI/"
.run MakeGuiMainTab.pro
.run MakeGuiLoadTab.pro
.run MakeGuiLoadDataNormalizationTab.pro
.run MakeGuiLoadDataTab.pro
.run MakeGuiLoadData1D2DTab.pro
.run MakeGuiLoadData1DTab.pro
.run MakeGuiLoadData1D_3D_Tab.pro
.run MakeGuiLoadData2DTab.pro
.run MakeGuiLoadData2D_3D_Tab.pro
.run MakeGuiLoadNormalizationTab.pro
.run MakeGuiLoadNormalization1D2DTab.pro
.run MakeGuiLoadNormalization1DTab.pro
.run MakeGuiLoadNormalization1D_3D_Tab.pro
.run MakeGuiLoadNormalization2DTab.pro
.run MakeGuiLoadNormalization2D_3D_Tab.pro
.run MakeGuiInstrumentSelection.pro

.run MakeGuiReduceTab.pro
.run MakeGuiReduceDataBase.pro
.run MakeGuiReduceNormalizationBase.pro
.run MakeGuiReduceQbase.pro
.run MakeGuiReduceDetectorBase.pro
.run MakeGuiReduceIntermediatePlotBase.pro
.run MakeGuiReduceOther.pro
.run MakeGuiReduceInfo.pro

.run MakeGuiPlotsTab.pro
.run MakeGuiPlotsMainIntermediatesBases.pro

.run MakeGuiLogBookTab.pro
.run MakeGuiSettingsTab.pro
	
cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/REFreduction/"
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
.run ref_reduction_RescaleNormalizationPlot.pro
.run ref_reduction_RescaleData1D3DPlot.pro
.run ref_reduction_RescaleNormalization1D3DPlot.pro

.run ref_reduction_DataMouseSelection.pro
.run ref_reduction_NormMouseSelection.pro
.run ref_reduction_DataBackgroundPeakSelection.pro
.run ref_reduction_NormBackgroundPeakSelection.pro
.run ref_reduction_CreateBackgroundROIFile.pro
.run ref_reduction_CreateBackgroundROIFileName.pro
.run ref_reduction_DisplayPreviewOfRoiFile.pro
.run ref_reduction_LoadBackgroundSelection.pro

.run ref_reduction_GUIinteraction.pro
.run ref_reduction_UpdateDataNormGui.pro
.run ref_reduction_UpdateReduceTabGui.pro
.run ref_reduction_UpdatePlotsTabGui.pro
.run ref_reduction_CommandLineIntermediatePlotsGenerator.pro
.run ref_reduction_CommandLineGenerator.pro
.run ref_reduction_RunCommandLine.pro
.run ref_reduction_LoadMainOutputFile.pro
.run ref_reduction_LoadXmlOutputFile.pro
.run ref_reduction_LoadIntermediateFiles.pro
.run ref_reduction_PlotOutputFiles.pro
.run ref_reduction_DisplayMetadataFile.pro
.run ref_reduction_SaveFileInfo.pro
.run ref_reduction_OverwriteInstrumentGeometry.pro

.run ref_reduction_LogBookInterface.pro

.run ref_reduction_eventcb.pro
.run ref_reduction.pro
.run MainBaseEvent.pro

;resolve_routine, "ref_reduction", /either
resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either
resolve_routine, "STRSPLIT", /either
resolve_routine, "read_bmp",/either
resolve_routine, "loadct",/either
resolve_routine, "xloadct",/either
resolve_routine, "xregistered",/either
resolve_routine, "errplot",/either
resolve_routine, "uniq",/either
resolve_routine, "ZOOM",/either
resolve_routine, "CW_FIELD",/either

save,/routines,filename="ref_reduction.sav"
exit

