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

;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

;build the utilities
@main_idl_makefile_utilities.pro

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
.run miniMakeGuiInstrumentSelection.pro
.run mini_auto_cleaning_base_gui.pro

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

;build the main procedures
cd, CurrentFolder
@main_idl_makefile.pro
.run mini_ref_reduction_v15.pro



