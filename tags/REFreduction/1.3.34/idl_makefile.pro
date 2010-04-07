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

;Makefile that automatically compile the necessary modules
;and create the VM file.
@main_idl_makefile_utilities.pro

;Build REFreduction GUI
cd, CurrentFolder + '/REFreductionGUI/'
.run MakeGuiMainTab.pro
.run MakeGuiLoadTab.pro
.run MakeGuiNexusInterface.pro
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
.run MakeGuiEmptyCellTab.pro
.run MakeGuiInstrumentSelection.pro
.run auto_cleaning_base_gui.pro

.run MakeGuiReduceTab.pro
.run MakeGuiEmptyCell.pro
.run MakeGuiReduceDataBase.pro
.run MakeGuiReduceNormalizationBase.pro
.run MakeGuiReduceQbase.pro
.run MakeGuiReduceDetectorBase.pro
.run MakeGuiReduceIntermediatePlotBase.pro
.run MakeGuiReduceOther.pro
.run MakeGuiReduceInfo.pro

.run MakeGuiPlotsTab.pro
.run MakeGuiPlotsMainIntermediatesBases.pro
.run MakeGuiBatchTab.pro
.run MakeGuiLogBookTab.pro

.run 

;Build main procedures
cd, CurrentFolder
@main_idl_makefile.pro
.run ref_reduction.pro
