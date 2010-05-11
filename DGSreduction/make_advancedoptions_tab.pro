;+
; :Copyright:
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
; Copyright (c) 2009, Spallation Neutron Source, Oak Ridge National Lab,
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
; :Description:
;    Constructs the Settings Tab for the given command object 'myCommandObj'
;    and as a child of 'baseWidget'.
;
; :Params:
;    baseWidget
;    myCommandObj
;
; :Author: scu
;-
PRO make_advancedoptions_tab, baseWidget, myCommandObj

  settingsTabBaseColumns = WIDGET_BASE(baseWidget, COLUMN=2)
  settingsTabCol1 = WIDGET_BASE(settingsTabBaseColumns, /COLUMN)
  settingsTabCol2 = WIDGET_BASE(settingsTabBaseColumns, /COLUMN)
  
  ; == Wandering Phase ==
  cwpRow = WIDGET_BASE(settingsTabCol1, /ROW)
  cwpBase = WIDGET_BASE(cwpRow)
  cwpLabel = WIDGET_LABEL(cwpBase, VALUE=' Wandering Phase Correction ', XOFFSET=5)
  cwpLabelGeometry = WIDGET_INFO(cwpLabel, /GEOMETRY)
  cwpLabelGeometryYSize = cwpLabelGeometry.ysize
  cwpPrettyBase = WIDGET_BASE(cwpBase, /FRAME, /COLUMN, $
    YOFFSET=cwpLabelGeometryYSize/2, XPAD=10, YPAD=10)
    
  cwpOptionsBaseColumns = WIDGET_BASE(cwpPrettyBase)
  
  cwpFilesBase = WIDGET_BASE(cwpOptionsBaseColumns, /COLUMN, /ALIGN_RIGHT)
  
  cwpOptionsBase = WIDGET_BASE(cwpFilesBase, /NONEXCLUSIVE)
  cwpButton = WIDGET_BUTTON(cwpOptionsBase, VALUE='Auto Wandering Phase', $
    UVALUE='DGSR_CWP', UNAME='DGSR_CWP')
    
  datarun_cwp_id = CW_FIELD(cwpFilesBase, TITLE=' Sample Run Offsets:', UVALUE="DGSR_DATA_CWP", UNAME='DGSR_DATA_CWP', $
    /ALL_EVENTS)
  emptycanTzeroID = CW_FIELD(cwpFilesBase, /ALL_EVENTS, TITLE='  Empty Can Offsets:', UVALUE="DGSR_EMPTYCAN_CWP", $
    UNAME="DGSR_EMPTYCAN_CWP")
  blackcanTzeroID = CW_FIELD(cwpFilesBase, /ALL_EVENTS, TITLE='  Black Can Offsets:', UVALUE="DGSR_BLACKCAN_CWP", $
    UNAME="DGSR_BLACKCAN_CWP")
    
  ; ROI
  roiBase = WIDGET_BASE(settingsTabCol1)
  roiLabel = WIDGET_LABEL(roiBase, VALUE=' Region-of-Interest ', XOFFSET=5)
  roiLabelGeometry = WIDGET_INFO(roiLabel, /GEOMETRY)
  roiLabelYSize = roiLabelGeometry.ysize
  roiPrettyBase = WIDGET_BASE(roiBase, /FRAME, /COLUMN, $
    YOFFSET=roiLabelYSize/2, YPAD=10, XPAD=10)
  roiRow = WIDGET_BASE(roiPrettyBase, ROW=1)
  roiFileID = CW_FIELD(roiRow, TITLE='Filename: ', UVALUE='DGSR_ROI_FILENAME', $
    UNAME='DGSR_ROI_FILENAME', /ALL_EVENTS, XSIZE=20)
    
    
  ; === Proton Current Units ===
  protonUnitsBase = WIDGET_BASE(settingsTabCol2)
  protonUnitsLabel = WIDGET_LABEL(protonUnitsBase, VALUE=' Proton Current Units ', XOFFSET=5)
  protonUnitsLabelGeometry = WIDGET_INFO(protonUnitsLabel, /GEOMETRY)
  protonUnitsLabelYSize = protonUnitsLabelGeometry.ysize
  protonUnitsPrettyBase = WIDGET_BASE(protonUnitsBase, /FRAME, /ROW, XPAD=10, YPAD=10, $
    YOFFSET=protonUnitsLabelYSize/2.0)
    
  protonUnitsColumn = WIDGET_BASE(protonUnitsPrettyBase, /COLUMN)
  protonUnitsButtons = WIDGET_BASE(protonUnitsColumn, EXCLUSIVE=1)
  
  coulombButtonID = WIDGET_BUTTON(protonUnitsButtons, VALUE='Coulombs (Recommended)', $
    UNAME='DGS_PROTON_UNITS_COULOMB', UVALUE='DGS_PROTON_UNITS_COULOMB')
  millCoulombButtonID = WIDGET_BUTTON(protonUnitsButtons, VALUE='Milli-Coulombs (mC)', $
    UNAME='DGS_PROTON_UNITS_MILLICOULOMB', UVALUE='DGS_PROTON_UNITS_MILLICOULOMB')
  microCoulombButtonID = WIDGET_BUTTON(protonUnitsButtons, VALUE='Micro-Coulombs (uC)', $
    UNAME='DGS_PROTON_UNITS_MICROCOULOMB', UVALUE='DGS_PROTON_UNITS_MICROCOULOMB')
  picoCoulombButtonID = WIDGET_BUTTON(protonUnitsButtons, VALUE='Pico-Coulombs (pC)', $
    UNAME='DGS_PROTON_UNITS_PICOCOULOMB', UVALUE='DGS_PROTON_UNITS_PICOCOULOMB')
    
  ; Make 'Coulombs' the default
  WIDGET_CONTROL, coulombButtonID, SET_BUTTON=1
  myCommandObj->SetProperty, ProtonCurrentUnits='C'
  
  ; === dgs_reduction timing ===
  timingBase = WIDGET_BASE(settingsTabCol2)
  timingLabel = WIDGET_LABEL(timingBase, VALUE=' Diagnostic Timing ', XOFFSET=5)
  timingLabelGeometry = WIDGET_INFO(timingLabel, /GEOMETRY)
  timingLabelYSize = timingLabelGeometry.ysize
  timingPrettyBase = WIDGET_BASE(timingBase, /FRAME, /ROW, XPAD=10, YPAD=10, YOFFSET=timingLabelYSize/2.0)
  timingRow = WIDGET_BASE(timingPrettyBase, /ROW)
  timingButtons = WIDGET_BASE(timingRow, /ROW, EXCLUSIVE=1)
  timingOnID = WIDGET_BUTTON(timingButtons, Value=' ON  ', UNAME='DGS_TIMING_ON', UVALUE='DGS_TIMING_ON')
  timingOffID = WIDGET_BUTTON(timingButtons, Value=' OFF  ', UNAME='DGS_TIMING_OFF', UVALUE='DGS_TIMING_OFF')
  ; Make off the default
  WIDGET_CONTROL, timingOffID, SET_BUTTON=1
  
END