;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'

;Makefile that automatically compile the necessary modules
;and create the VM file.
cd, IdlUtilitiesPath
.run system_utilities.pro
.run time.pro
.run IDL3columnsASCIIparser__define.pro
.run IDLsendLogBook__define.pro
.run IDLxmlParser__define.pro
.run logger.pro
.run CheckPackages.pro
.run is_monitor_flag_necessary.pro

;Build BSSreduction GUI
cd, CurrentFolder + '/BSSreductionGUI/'
.run MakeGuiMainTab.pro
.run MakeGuiSelectionTab.pro
.run MakeGuiSelectionOutputCountsVsTof

.run MakeGuiReduceTab.pro
.run MakeGuiReduceInputTab.pro
.run MakeGuiReduceInputTab1.pro
.run MakeGuiReduceInputTab2.pro
.run MakeGuiReduceInputTab3.pro
.run MakeGuiReduceInputTab4.pro
.run MakeGuiReduceInputTab5.pro
.run MakeGuiReduceInputTab6.pro
.run MakeGuiReduceInputTab7.pro
.run MakeGuiReduceInputTab8.pro
.run MakeGuiReduceClgXmlTab.pro
.run MakeGuiReduceClgXmlTab1.pro
.run MakeGuiReduceClgXmlTab2.pro
.run MakeGuiJobsStatus.pro
.run MakeGuiOutputTab.pro
.run MakeGuiLogBookTab.pro
.run MakeGuiNeXusRoiBase.pro
.run MakeGuiSelectionBase.pro
.run IDLscalingGUI__define.pro

;Build main procedures
cd, CurrentFolder
.run bss_reduction_time.pro
.run bss_reduction_put.pro
.run bss_reduction_get.pro
.run bss_reduction_is.pro
.run bss_reduction_nexus.pro
.run bss_reduction_utilities.pro
.run bss_reduction_Gui.pro

.run bss_reduction_LoadNexus.pro
.run bss_reduction_LoadNexusStep2.pro
.run bss_reduction_BrowseNexus.pro
.run bss_reduction_PlotBanks.pro
.run bss_reduction_DisplayXYBankPixelInfo.pro
.run bss_reduction_DisplayCountsVsTof.pro
.run bss_reduction_ZoomInCountsVsTof.pro
.run bss_reduction_ZoomInFullCountsVsTof.pro
.run bss_reduction_CountsVsTof.pro
.run bss_reduction_OutputCountsVsTof.pro
.run bss_reduction_UpdateFields.pro

.run bss_reduction_IncludeExcludeUtilities.pro
.run bss_reduction_IncludeExcludePixel.pro
.run bss_reduction_IncludeExclude.pro

.run bss_reduction_SaveRoiFile.pro
.run bss_reduction_LoadRoiFile.pro
.run bss_reduction_LogBook.pro
.run bss_reduction_ColorSelection.pro
.run bss_reduction_math.pro
.run bss_reduction_iterative_back.pro

.run bss_reduction_Reduce.pro
.run bss_reduction_ReduceTab1.pro
.run bss_reduction_ReduceTab2.pro
.run bss_reduction_ReduceGui.pro
.run bss_reduction_CommandLineGenerator.pro
.run bss_reduction_RunCommandLine.pro
.run bss_reduction_RunBatchCommandLine.pro
.run bss_reduction_IntermediatePlots.pro
.run bss_reduction_DisplayDRxmlConfigFile.pro
.run bss_reduction_JobStatus.pro
.run bss_reduction_CreateCommandLineFile.pro

;configuration
.run configuration_event.pro

;classes
.run IDLoutputFile__define.pro
.run IDLgetMetadata__define.pro
.run IDLplotTxt__define.pro
.run IDLcreateLogFile__define.pro
.run IDLaddBrowsedFilesToConfig__define.pro
.run IDLreadLogFile__define.pro
.run IDLmakeTree__define.pro
.run IDLrefreshTree__define.pro
.run IDLrefreshRoot__define.pro
.run IDLsendToGeek__define.pro
.run IDLremoveFolderFromConfig__define.pro
.run IDLxmlParser__define.pro

.run bss_reduction_Cleanup.pro
.run bss_reduction_Configuration.pro
.run bss_reduction_LDS.pro

.run MainBaseEvent.pro
.run bss_reduction_eventcb.pro
.run bss_reduction.pro



