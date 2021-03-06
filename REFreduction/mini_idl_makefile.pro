;==============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================
;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder
IdlUtilitiesPath = "utilities/"

;Makefile that automatically compile the necessary modules
;and create the VM file.
cd, CurrentFolder + '/utilities'
.run nexus_utilities.pro
.run get.pro
.run system_utilities.pro
.run nexus_utilities.pro
.run math_conversion.pro
.run time.pro
.run list_of_proposal.pro
.run IDLxmlParser__define.pro

;Build REFreduction GUI
cd, CurrentFolder + '/REFreductionGUI/'
.run MakeGuiInstrumentSelection.pro

;Build miniREFreduction GUI
cd, CurrentFolder + '/miniREFreductionGUI/'
.run miniMakeGuiMainTab.pro
.run miniMakeGuiNexusInterface.pro
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
.run miniMakeGuiEmptyCellTab.pro

.run miniMakeGuiReduceTab.pro
.run miniMakeGuiEmptyCell.pro
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
.run ref_reduction_put.pro
.run ref_reduction_is.pro
.run ref_reduction_time.pro
.run tvread.pro

.run ref_reduction_DumpBinary.pro
.run ref_reduction_Plot2DDataFile.pro
.run ref_reduction_Plot1DDataFile.pro
.run ref_reduction_Plot1D2DDataFile.pro
.run ref_reduction_LoadDataFile.pro
.run ref_reduction_NXsummary.pro
.run ref_reduction_Plot2DNormalizationFile.pro
.run ref_reduction_Plot1DNormalizationFile.pro
.run ref_reduction_Plot1D2DNormalizationFile.pro
.run ref_reduction_LoadNormalizationFile.pro
.run ref_reduction_Zoom.pro
.run ref_reduction_RescaleDataPlot.pro
.run ref_reduction_RescaleData1D3DPlot.pro
.run ref_reduction_RescaleData2D3DPlot.pro
.run ref_reduction_RescaleNormalizationPlot.pro
.run ref_reduction_RescaleNormalization1D3DPlot.pro
.run ref_reduction_RescaleNormalization2D3DPlot.pro
.run ref_reduction_browse_nexus.pro
.run ref_reduction_PlotEmptyCell.pro
.run ref_reduction_output_empty_cell.pro
.run ref_reduction_empty_cell.pro
.run ref_reduction_sf_empty_cell.pro

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
.run ref_reduction_jpeg.pro

.run IDLgetMetadata__define.pro
.run ref_reduction_BatchTab.pro
.run ref_reduction_BatchDataNorm.pro
.run IDLparseCommandLine__define.pro
.run IDLupdateGui__define.pro
.run ref_reduction_BatchRepopulateGui.pro
.run ref_reduction_LogBookInterface.pro
.run IDLcreateXMLJobFile__define.pro
.run IDLsendLogBook__define.pro
.run checking_packages.pro
.run checking_packages_gui.pro
.run packages_required.pro
.run ref_reduction_configuration.pro

.run MainBaseEvent.pro
.run ref_reduction_tab.pro
.run ref_reduction_eventcb.pro
.run mini_ref_reduction.pro



