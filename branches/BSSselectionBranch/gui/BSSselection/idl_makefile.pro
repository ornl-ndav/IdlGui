;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder
IdlUtilitiesPath = "../utilities"

;Makefile that automatically compile the necessary modules
;and create the VM file.
;cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/utilities/"
cd, IdlUtilitiesPath
.run system_utilities.pro

;Build BSSselection GUI
cd, CurrentFolder + '/BSSselectionGUI/'
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
.run MakeGuiReduceClgXmlTab.pro
.run MakeGuiReduceClgXmlTab1.pro
.run MakeGuiReduceClgXmlTab2.pro

.run MakeGuiLogBookTab.pro
.run MakeGuiNeXusRoiBase.pro
.run MakeGuiSelectionBase.pro

;Build main procedures
cd, CurrentFolder
.run bss_selection_put.pro
.run bss_selection_get.pro
.run bss_selection_is.pro
.run bss_selection_nexus.pro
.run bss_selection_utilities.pro
.run bss_selection_Gui.pro
.run bss_selection_time.pro

.run bss_selection_LoadNexus.pro
.run bss_selection_LoadNexusStep2.pro
.run bss_selection_BrowseNexus.pro
.run bss_selection_PlotBanks.pro
.run bss_selection_DisplayXYBankPixelInfo.pro
.run bss_selection_DisplayCountsVsTof.pro
.run bss_selection_ZoomInCountsVsTof.pro
.run bss_selection_ZoomInFullCountsVsTof.pro
.run bss_selection_CountsVsTof.pro
.run bss_selection_OutputCountsVsTof.pro
.run bss_selection_UpdateFields.pro

.run bss_selection_IncludeExcludeUtilities.pro
.run bss_selection_IncludeExcludePixel.pro
.run bss_selection_IncludeExclude.pro

.run bss_selection_SaveRoiFile.pro
.run bss_selection_LoadRoiFile.pro
.run bss_selection_LogBook.pro
.run bss_selection_ColorSelection.pro

.run bss_selection_Reduce.pro
.run bss_selection_ReduceTab1.pro
.run bss_selection_ReduceGui.pro
.run bss_selection_CommandLineGenerator.pro

.run MainBaseEvent.pro
.run bss_selection_eventcb.pro
.run bss_selection.pro
