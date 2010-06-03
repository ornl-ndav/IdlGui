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
; :Author: scu (campbellsi@ornl.gov)
;-
;---------------------------------------------------------

PRO make_Normalisation_Tab, baseWidget, dgs_cmd



  normTabBaseColumns = WIDGET_BASE(baseWidget, COLUMN=2)
  normTabCol1 = WIDGET_BASE(normTabBaseColumns, /COLUMN)
  normTabCol2 = WIDGET_BASE(normTabBaseColumns, /COLUMN)
  
  
  ; == VANADIUM OPTIONS ==
  
  vanadiumRow = WIDGET_BASE(normTabCol1, /ROW)
  
  vanadiumBase = WIDGET_BASE(vanadiumRow)
  vanadiumLabel = WIDGET_LABEL(vanadiumBase, VALUE=' Vanadium ', XOFFSET=5)
  vanadiumLabelGeometry = WIDGET_INFO(vanadiumLabel, /GEOMETRY)
  vanadiumLabelGeometryYSize = vanadiumLabelGeometry.ysize
  vanadiumPrettyBase = WIDGET_BASE(vanadiumBase, /FRAME, /COLUMN, $
    YOFFSET=vanadiumLabelGeometryYSize/2, XPAD=10, YPAD=10, $
    SCR_XSIZE=550)
    
  vanadiumCol = WIDGET_BASE(vanadiumPrettyBase, /COLUMN)
  
  normfilebase = WIDGET_BASE(vanadiumCol, /ROW)
  normFileID = CW_FIELD(normfilebase, XSIZE=30, /ALL_EVENTS,     TITLE="          Vanadium: ", UVALUE="DGSR_NORMRUN", $
    UNAME="DGSR_NORMRUN")
  ;  normemptycanbrowserbutton = WIDGET_BUTTON(normfilebase, VALUE=' Browse... ', $
  ;    UNAME='DGS_BROWSE_NORMRUN', UVALUE='DGS_BROWSE_NORMRUN')
    
  normemptycanbase = WIDGET_BASE(vanadiumCol, /ROW)
  normemptycanFileID = CW_FIELD(normemptycanbase, XSIZE=30, /ALL_EVENTS, TITLE="Vanadium Empty Can: ", $
    UVALUE="DGSR_NORMEMPTYCAN", UNAME="DGSR_NORMEMPTYCAN")
  normemptycanbrowserbutton = WIDGET_BUTTON(normemptycanbase, VALUE=' Browse... ', $
    UNAME='DGS_BROWSE_NORMEMPTYCAN', UVALUE='DGS_BROWSE_NORMEMPTYCAN')
    
    
  vanadiumOptionsBase = WIDGET_BASE(normfilebase, /NONEXCLUSIVE)
  normButton = Widget_Button(vanadiumOptionsBase, Value='White Beam Run', UVALUE='DGSN_WHITE_NORM', $
    UNAME='DGSN_WHITE_NORM')
    
  ; Norm integration range
  normRangeBase = WIDGET_BASE(vanadiumCol, UNAME="DGSN_NORM-INT-RANGE")
  normRangeBaseLabel = WIDGET_LABEL(normRangeBase, VALUE=' Normalisation Integration Range (meV) ', $
    UNAME="DGSN_NORM-INT-RANGE_LABEL", XOFFSET=5)
  normRangeBaseLabelGeometry = WIDGET_INFO(normRangeBaseLabel, /GEOMETRY)
  normRangeBaseLabelGeometryYSize = normRangeBaseLabelGeometry.ysize
  normRangePrettyBase = WIDGET_BASE(normRangeBase, /FRAME, /ROW, $
    YOFFSET=normRangeBaseLabelGeometryYSize/2, XPAD=10, YPAD=10)
    
  normMinID = CW_FIELD(normRangePrettyBase, /ALL_EVENTS, TITLE="Min:", UVALUE="DGSR_NORM-INT-MIN", $
    UNAME="DGSR_NORM-INT-MIN")
  normMaxID = CW_FIELD(normRangePrettyBase, /ALL_EVENTS, TITLE="Max:", UVALUE="DGSR_NORM-INT-MAX", $
    UNAME="DGSR_NORM-INT-MAX")
    
  normTransID = CW_FIELD(vanadiumCol, /ALL_EVENTS, TITLE="Transmission Coeff (Van Background):", UVALUE="DGSR_NORM-TRANS", $
    UNAME="DGSR_NORM-TRANS", XSIZE=22)
    
  ; Define a Norm Run button
  executeNormID = WIDGET_BUTTON(vanadiumCol, Value=' Process Vanadium Now >>> ', $
    EVENT_PRO='DGSnorm_Execute', UNAME='DGSN_EXECUTE_BUTTON')
    
    
  ; == Thresholds ==
  thresholdRow = WIDGET_BASE(normTabCol1, /ROW) ; Just for formatting
  
  thresholdBase = WIDGET_BASE(thresholdRow)
  thresholdLabel = WIDGET_LABEL(thresholdBase, Value=' Cut off Threshold ', XOFFSET=5)
  thresholdLabelGeomtry = WIDGET_INFO(thresholdLabel, /GEOMETRY)
  thresholdLabelGeomtryYSize = thresholdLabelGeomtry.ysize
  thresholdPrettyBase = WIDGET_BASE(thresholdBase, /FRAME, /COLUMN, $
    YOFFSET=thresholdLabelGeomtryYSize/2, XPAD=10, YPAD=10)
    
  thresholdValuesRow = WIDGET_BASE(thresholdPrettyBase, /ROW)
  tofcutminID = CW_FIELD(thresholdValuesRow, TITLE="Low:", UVALUE="DGSN_LO_THRESHOLD", $
    UNAME="DGSN_LO_THRESHOLD", /ALL_EVENTS, XSIZE=17)
  tofcutmaxID = CW_FIELD(thresholdValuesRow, TITLE="High:", UVALUE="DGSN_HI_THRESHOLD", $
    UNAME="DGSN_HI_THRESHOLD", /ALL_EVENTS, XSIZE=18)
    
  ; == NORMALISATION OPTIONS ==
    
  normRow = WIDGET_BASE(normTabCol2, /ROW)
  
  normBase = WIDGET_BASE(normRow)
  normLabel = WIDGET_LABEL(normBase, VALUE=' Normalisation ', XOFFSET=5)
  normLabelGeometry = WIDGET_INFO(normLabel, /GEOMETRY)
  normLabelGeometryYSize = normLabelGeometry.ysize
  normPrettyBase = WIDGET_BASE(normBase, /FRAME, /COLUMN, $
    YOFFSET=normLabelGeometryYSize/2, XPAD=10, YPAD=10)
    
  normOptionsBaseColumns = WIDGET_BASE(normPrettyBase, COLUMN=2)
  normOptionsBaseColumn1 = WIDGET_BASE(normOptionsBaseColumns, /COLUMN)
  normOptionsBaseColumn2 = WIDGET_BASE(normOptionsBaseColumns, /COLUMN)
  normOptionsBaseRow1 = WIDGET_BASE(normPrettyBase, /ROW)
  normOptionsBaseRow2 = WIDGET_BASE(normPrettyBase, /ROW)
  
  normOptionsBase = WIDGET_BASE(normOptionsBaseColumn1, /NONEXCLUSIVE)
  noMon_Button = WIDGET_BUTTON(normOptionsBase, VALUE='No Monitor Normalisation', $
    UVALUE='DGSR_NO-MON-NORM', UNAME='DGSR_NO-MON-NORM')
  pc_button = WIDGET_BUTTON(normOptionsBase, VALUE='Proton Charge Normalisation', $
    UVALUE='DGSR_PC-NORM', UNAME='DGSR_PC-NORM')
  lambdaratioID = WIDGET_BUTTON(normOptionsBase, VALUE='Ki/Kf Scaling', $
    UVALUE='DGSR_LAMBDA-RATIO', UNAME='DGSR_LAMBDA-RATIO')
    
  monitorNumberID = CW_FIELD(normOptionsBaseColumn1, TITLE="Monitor Number:", UVALUE="DGSR_USMON", $
    UNAME="DGSR_USMON", VALUE=1, /INTEGER, /ALL_EVENTS, XSIZE=5)
  ; Also set the default monitor in the ReductionCmd Class
  dgs_cmd->SetProperty, USmonPath=1
  
  
  ; == Transmission Corrections ==
  transBase = WIDGET_BASE(normOptionsBaseRow2, /ALIGN_BOTTOM)
  transBaseLabel = WIDGET_LABEL(transBase, VALUE=' Transmission Corrections ', XOFFSET=5)
  transBaseLabelGeometry = WIDGET_INFO(transBaseLabel, /GEOMETRY)
  transBaseLabelGeometryYSize = transBaseLabelGeometry.ysize
  transPrettyBase = WIDGET_BASE(transBase, /FRAME, /ROW, $
    YOFFSET=transBaseLabelGeometryYSize/2, XPAD=10, YPAD=10)
  ;    YOFFSET=transBaseLabelGeometryYSize/2, XPAD=10, YPAD=10, SCR_XSIZE=513)
    
  ;  normTransID = CW_FIELD(transPrettyBase, /ALL_EVENTS, TITLE="Norm Coeff:", UVALUE="DGSR_NORM-TRANS", $
  ;    UNAME="DGSR_NORM-TRANS", XSIZE=10)
  detEffID = CW_FIELD(transPrettyBase, /ALL_EVENTS, TITLE="Detector Efficiency:", UVALUE="DGSR_DET-EFF", $
    UNAME="DGSR_DET-EFF")
    
    
  ; Monitor integration range
  monitorRangeBase = WIDGET_BASE(normOptionsBaseRow1, /ALIGN_BOTTOM)
  monitorRangeBaseLabel = WIDGET_LABEL(monitorRangeBase, VALUE=' Monitor Integration Range (usec) ', XOFFSET=5)
  monitorRangeBaseLabelGeometry = WIDGET_INFO(monitorRangeBaseLabel, /GEOMETRY)
  monitorRangeBaseLabelGeometryYSize = monitorRangeBaseLabelGeometry.ysize
  monitorRangePrettyBase = WIDGET_BASE(monitorRangeBase, /FRAME, /ROW, $
    YOFFSET=monitorRangeBaseLabelGeometryYSize/2, XPAD=10, YPAD=10)
    
  monMinID = CW_FIELD(monitorRangePrettyBase, /ALL_EVENTS, TITLE="Min:", UVALUE="DGSR_MON-INT-MIN", $
    UNAME="DGSR_MON-INT-MIN", XSIZE=10)
  monMaxID = CW_FIELD(monitorRangePrettyBase, /ALL_EVENTS, TITLE="Max:", UVALUE="DGSR_MON-INT-MAX", $
    UNAME="DGSR_MON-INT-MAX", XSIZE=10)
    
    
    
  ; == DEFAULTS ==
    
  ; Disable Proton Charge Norm until No-Monitor Norm is selected
  WIDGET_CONTROL, pc_button, SENSITIVE=0
  
  NormStatus = dgs_cmd->checkNorm()
  WIDGET_CONTROL, executeNormID, SENSITIVE=Normstatus.ok
  
END