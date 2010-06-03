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

PRO make_Corrections_Tab, baseWidget, dgsr_cmd

  reductionTabBaseColumns = WIDGET_BASE(baseWidget, COLUMN=2)
  reductionTabCol1 = WIDGET_BASE(reductionTabBaseColumns, /COLUMN)
  reductionTabCol2 = WIDGET_BASE(reductionTabBaseColumns, /COLUMN)
  
  reductionTabCol1Row1 = WIDGET_BASE(reductionTabCol1, COLUMN=1)
  reductionTabCol1Row1Col1 = WIDGET_BASE(reductionTabCol1, COLUMN=1)
  ;reductionTabCol1Row2 = WIDGET_BASE(reductionTabCol1, /ROW)
  
  reductionTabCol2Row1 = WIDGET_BASE(reductionTabCol2, COLUMN=2)
  reductionTabCol2Row1Col1 = WIDGET_BASE(reductionTabCol2Row1, /COLUMN)
  reductionTabCol2Row1Col2 = WIDGET_BASE(reductionTabCol2Row1, /COLUMN)
  ;reductionTabCol2Row1Col1Row1 = WIDGET_BASE(reductionTabCol2Row1, /ROW)
  
  ;  reductionTabCol2Row2 = WIDGET_BASE(reductionTabCol2)
  ;  reductionTabCol2Row2Col1 = WIDGET_BASE(reductionTabCol2Row2, /COLUMN)
  
  ; == BACKGROUND FILES ==
  
  backfilesRow = WIDGET_BASE(reductionTabCol1Row1, /ROW)
  
  backfilesBase = WIDGET_BASE(backfilesRow)
  backfilesLabel = WIDGET_LABEL(backfilesBase, VALUE=' Background Files ', XOFFSET=5)
  backfilesLabelGeometry = WIDGET_INFO(backfilesLabel, /GEOMETRY)
  backfilesLabelGeometryYSize = backfilesLabelGeometry.ysize
  backfilesPrettyBase = WIDGET_BASE(backfilesBase, /FRAME, /COLUMN, $
    YOFFSET=backfilesLabelGeometryYSize/2, XPAD=10, YPAD=10 )
    
    
  backfilesOptionsBaseColumns = WIDGET_BASE(backfilesPrettyBase)
  
  ; Normalisation Files
  backfilesFilesBase = WIDGET_BASE(backfilesOptionsBaseColumns, /COLUMN, /ALIGN_RIGHT)
  
  emptycanbase = WIDGET_BASE(backfilesFilesBase,/row)
  emptycanFileID = CW_FIELD(emptycanbase, /ALL_EVENTS, TITLE="    Empty Can: ", UVALUE="DGSR_EMPTYCAN", $
    UNAME="DGSR_EMPTYCAN")
  emptycanBrowseButton = WIDGET_BUTTON(emptycanbase, VALUE=" Browse... ", UVALUE="DGS_BROWSE_EMPTYCAN", UNAME="DGS_BROWSE_EMPTYCAN")
  
  
  blackcanbase = WIDGET_BASE(backfilesFilesBase, /ROW)
  blackcanFileID = CW_FIELD(blackcanbase, /ALL_EVENTS, TITLE="    Black Can: ", UVALUE="DGSR_BLACKCAN", $
    UNAME="DGSR_BLACKCAN")
  blackcanBrowseButton = WIDGET_BUTTON(blackcanbase, VALUE=" Browse... ", UVALUE="DGS_BROWSE_BLACKCAN", UNAME="DGS_BROWSE_BLACKCAN")
  
  darkcurrentbase = WIDGET_BASE(backfilesFilesBase, /ROW)
  darkFileID = CW_FIELD(darkcurrentbase, /ALL_EVENTS,     TITLE=" Dark Current: ", UVALUE="DGSR_DARK", $
    UNAME="DGSR_DARK")
  darkBrowseButton = WIDGET_BUTTON(darkcurrentbase, VALUE=" Browse... ", UVALUE="DGS_BROWSE_DARK", UNAME="DGS_BROWSE_DARK")
  
  
  dataTransID = CW_FIELD(backfilesFilesBase, /ALL_EVENTS, TITLE="Transmission Coeff (Sample Background):", UVALUE="DGSR_DATA-TRANS", $
    UNAME="DGSR_DATA-TRANS", XSIZE=10) 
    
  ; == TOF CUTTING ==
  tofRow = WIDGET_BASE(reductionTabCol2Row1Col2, /ROW) ; Just for formatting
  
  tofcutBase = WIDGET_BASE(tofRow)
  tofcutLabel = WIDGET_LABEL(tofcutBase, Value=' TOF Spectrum Cutting ', XOFFSET=5)
  tofcutLabelGeomtry = WIDGET_INFO(tofcutLabel, /GEOMETRY)
  tofcutLabelGeomtryYSize = tofcutLabelGeomtry.ysize
  tofcutPrettyBase = WIDGET_BASE(tofcutBase, /FRAME, /COLUMN, $
    YOFFSET=tofcutLabelGeomtryYSize/2, XPAD=10, YPAD=10)
    
  tofcutRow = WIDGET_BASE(tofcutPrettyBase, /ROW)
  tofcutminID = CW_FIELD(tofcutRow, TITLE="Min:", UVALUE="DGSR_TOF-CUT-MIN", UNAME="DGSR_TOF-CUT-MIN", /ALL_EVENTS, XSIZE=17)
  tofcutmaxID = CW_FIELD(tofcutRow, TITLE="Max:", UVALUE="DGSR_TOF-CUT-MAX", UNAME="DGSR_TOF-CUT-MAX", /ALL_EVENTS, XSIZE=18)
  
  
  
  
  ; == TIB ==
  TIBrow = WIDGET_BASE(reductionTabCol2, /ROW)
  
  TIBbase = WIDGET_BASE(TIBrow)
  TIBlabel = WIDGET_LABEL(TIBbase, VALUE=' Time Independent Bkgrd ', XOFFSET=5)
  TIBlabelGeometry = WIDGET_INFO(TIBlabel, /GEOMETRY)
  TIBlabelGeometryYSize = TIBlabelGeometry.ysize
  TIBPrettyBase = WIDGET_BASE(TIBbase, /FRAME, /ROW, $
    YOFFSET=TIBlabelGeometryYSize/2, XPAD=10, YPAD=10)
    
  ; TIB Constant
  TIBConstantBase = WIDGET_BASE(TIBPrettyBase, /ALIGN_BOTTOM)
  TIBConstantBaseLabel = WIDGET_LABEL(TIBConstantBase, VALUE=' Constant ', XOFFSET=5)
  TIBConstantBaseLabelGeometry = WIDGET_INFO(TIBConstantBaseLabel, /GEOMETRY)
  TIBConstantBaseLabelGeometryYSize = TIBConstantBaseLabelGeometry.ysize
  TIBConstantPrettyBase = WIDGET_BASE(TIBConstantBase, /FRAME, /ROW, $
    YOFFSET=TIBConstantBaseLabelGeometryYSize/2, XPAD=10, YPAD=10)
  TIBconstID = CW_FIELD(TIBConstantPrettyBase, XSIZE=20, TITLE="", UVALUE="DGSR_TIBCONST", $
    UNAME="DGSR_TIBCONST", /ALL_EVENTS)
    
  label1 = WIDGET_LABEL(TIBPrettyBase, VALUE='  OR  ')
  
  ; TIB range
  TIBRangeBase = WIDGET_BASE(TIBPrettyBase)
  TIBRangeBaseLabel = WIDGET_LABEL(TIBRangeBase, VALUE=' Range ', XOFFSET=5)
  TIBRangeBaseLabelGeometry = WIDGET_INFO(TIBRangeBaseLabel, /GEOMETRY)
  TIBRangeBaseLabelGeometryYSize = TIBRangeBaseLabelGeometry.ysize
  TIBRangePrettyBase = WIDGET_BASE(TIBRangeBase, /FRAME, /ROW, $
    YOFFSET=TIBRangeBaseLabelGeometryYSize/2, XPAD=10, YPAD=10, SCR_XSIZE=393)
    
  TIBMinID = CW_FIELD(TIBRangePrettyBase, /ALL_EVENTS, TITLE="Min:", UVALUE="DGSR_TIB-MIN", $
    UNAME="DGSR_TIB-MIN", XSIZE=20)
  TIBMaxID = CW_FIELD(TIBRangePrettyBase, /ALL_EVENTS, TITLE=" Max:", UVALUE="DGSR_TIB-MAX", $
    UNAME="DGSR_TIB-MAX", XSIZE=20)
    
  ; Mask File
  maskRow = WIDGET_BASE(reductionTabCol1Row1, /ROW)
  
  maskBase = WIDGET_BASE(maskRow)
  maskLabel = WIDGET_LABEL(maskBase, VALUE=' Mask Selection ', XOFFSET=5)
  maskLabelGeometry = WIDGET_INFO(maskLabel, /GEOMETRY)
  maskLabelYSize = maskLabelGeometry.ysize
  maskPrettyBase = WIDGET_BASE(maskBase, /FRAME, /COLUMN, $
    YOFFSET=maskLabelYSize/2, YPAD=10, XPAD=10, $
    SCR_YSIZE=100)
    
  maskButtonRow = WIDGET_BASE(maskPrettyBase, /ROW, /EXCLUSIVE)
  ;maskID = WIDGET_BUTTON(maskButtonRow, VALUE='Vanadium Mask', UVALUE='DGSR_MASK', UNAME='DGSR_MASK')
  noHardMaskID = WIDGET_BUTTON(maskButtonRow, VALUE=' No Mask', $
    UVALUE='DGSR_NO_HARD_MASK', UNAME='DGSR_NO_HARD_MASK')
  hardMaskID = WIDGET_BUTTON(maskButtonRow, VALUE=' Default Mask', $
    UVALUE='DGSR_HARD_MASK', UNAME='DGSR_HARD_MASK')
  customMaskID = WIDGET_BUTTON(maskButtonRow, VALUE='Custom', $
    UVALUE='DGSR_CUSTOM_HARD_MASK', UNAME='DGSR_CUSTOM_HARD_MASK')
    
  ;maskFileID = CW_FIELD(maskRow, TITLE='Filename:', UVALUE='DGSR_MASK_FILENAME', /ALL_EVENTS)
    
  sourceMaskFilebase = WIDGET_BASE(maskPrettyBase, /ROW)
  sourceMaskFilenameID = CW_FIELD(sourceMaskFilebase, YSIZE=1, XSIZE=30, TITLE='Filename:', $
    UNAME='DGSR_SOURCE_MASKFILENAME', UVALUE='DGSR_SOURCE_MASKFILENAME', /ALL_EVENTS)
  sourceMaskFilenameBrowseButton = WIDGET_BUTTON(sourceMaskFilebase, VALUE=" Browse... ", $
    UVALUE="DGS_BROWSE_SOURCE_MASKFILENAME", UNAME="DGS_BROWSE_SOURCE_MASKFILENAME")
    
  ; == DEFAULTS ==
    
  ; Make 'Default' Hard mask the default
  WIDGET_CONTROL, hardMaskID, SET_BUTTON=1
  dgsr_cmd->SetProperty, HardMask=1
  ; Therefore also make the custom filename field inactive
  WIDGET_CONTROL, sourceMaskFilenameID, SENSITIVE=0
  WIDGET_CONTROL, sourceMaskFilenameBrowseButton, SENSITIVE=0
  
  ; Always turn on the vanadium mask
  dgsr_cmd->SetProperty, Mask=1
  
;WIDGET_CONTROL, maskID, MAP=0
;WIDGET_CONTROL, maskID, SENSITIVE=0, SET_BUTTON=1
  
  
;  GatherButton = WIDGET_BUTTON(ButtonRow, VALUE='GATHER (Only Run when SLURM Jobs Completed)', $
;    EVENT_PRO='DGSnorm_LaunchCollector', UNAME='DGSN_LAUNCH_COLLECTOR_BUTTON')
;  ; As by default we have 1 job - we should disable the collector button
;  WIDGET_CONTROL, GatherButton, SENSITIVE=0
  
  
  
END