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

PRO make_VanMask_Tab, baseWidget, dgsn_cmd

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
  
  reductionTabCol2Row2 = WIDGET_BASE(reductionTabCol2)
  reductionTabCol2Row2Col1 = WIDGET_BASE(reductionTabCol2Row2, /COLUMN)
  
  
  ; == RUN NUMBER and DETECTORS ==
  
  RunDetectorRow = WIDGET_BASE(reductionTabCol1Row1Col1, /ROW)
  
  dataSourceBase = WIDGET_BASE(RunDetectorRow)
  dataSourceLabel = WIDGET_LABEL(dataSourceBase, VALUE=' Vanadium Run Number ', XOFFSET=5)
  dataSourceLabelGeometry = WIDGET_INFO(dataSourceLabel, /GEOMETRY)
  dataSourceLabelGeometryYSize = dataSourceLabelGeometry.ysize
  dataSourcePrettyBase = WIDGET_BASE(dataSourceBase, /FRAME, /COLUMN, $
    YOFFSET=dataSourceLabelGeometryYSize/2, YPAD=10, XPAD=10)
    
  dataSourceRow = WIDGET_BASE(dataSourcePrettyBase, /ROW)
  runID= CW_FIELD(dataSourceRow, xsize=29, ysize=1, TITLE="", UVALUE="DGSN_DATARUN", $
    UNAME="DGSN_DATARUN", /ALL_EVENTS)
  checkfileButton = WIDGET_BUTTON(dataSourceRow, VALUE="Check File", UVALUE="DGSN_FINDNEXUS", SENSITIVE=0)
  
  detectorBankBase = WIDGET_BASE(RunDetectorRow)
  detectorBankLabel = WIDGET_LABEL(detectorBankBase, VALUE=' Detector Banks ', XOFFSET=5)
  detectorBankLabelGeometry = WIDGET_INFO(detectorBankLabel, /GEOMETRY)
  detectorBankLabelYSize = detectorBankLabelGeometry.ysize
  detectorBankPrettyBase = WIDGET_BASE(detectorBankBase, /FRAME, /COLUMN, $
    YOFFSET=detectorBankLabelYSize/2, YPAD=10, XPAD=10)
    
  detectorBank_TextBoxSize = 11
  
  detectorBankRow = WIDGET_BASE(detectorBankPrettyBase, /ROW)
  lbankID = CW_FIELD(detectorBankRow, XSIZE=detectorBank_TextBoxSize, /ALL_EVENTS, TITLE="", $
    UVALUE="DGSN_DATAPATHS_LOWER" , UNAME="DGSN_DATAPATHS_LOWER", /INTEGER)
  ubankID = CW_FIELD(detectorBankRow, XSIZE=detectorBank_TextBoxSize, /ALL_EVENTS, TITLE=" --> ", $
    UVALUE="DGSN_DATAPATHS_UPPER", $
    UNAME="DGSN_DATAPATHS_UPPER", /INTEGER)
    
    
    
    
  ; == Ei / T0 ==
    
  EiTzeroBase = WIDGET_BASE(reductionTabCol2Row1Col1, /ROW)
  
  EiTzero_TextBoxSize = 13
  
  eiBase = WIDGET_BASE(EiTzeroBase)
  eiLabel = WIDGET_LABEL(eiBase, Value=' Ei (meV) ', XOFFSET=5)
  eiLabelGeomtry = WIDGET_INFO(eiLabel, /GEOMETRY)
  eiLabelGeomtryYSize = eiLabelGeomtry.ysize
  eiPrettyBase = WIDGET_BASE(eiBase, /FRAME, /COLUMN, $
    YOFFSET=eiLabelGeomtryYSize/2, XPAD=10, YPAD=10)
  eiRow = WIDGET_BASE(eiPrettyBase, /ROW)
  eiID = CW_FIELD(eiRow, TITLE="", UVALUE="DGSN_EI", UNAME="DGSN_EI", /ALL_EVENTS, $
    XSIZE=EiTzero_TextBoxSize)
    
  tzeroBase = WIDGET_BASE(EiTzeroBase)
  tzeroLabel = WIDGET_LABEL(tzeroBase, Value=' T0 (usec) ', XOFFSET=5)
  tzeroLabelGeomtry = WIDGET_INFO(tzeroLabel, /GEOMETRY)
  tzeroLabelGeomtryYSize = tzeroLabelGeomtry.ysize
  tzeroPrettyBase = WIDGET_BASE(tzeroBase, /FRAME, /COLUMN, $
    YOFFSET=tzeroLabelGeomtryYSize/2, XPAD=10, YPAD=10)
  tzeroRow = WIDGET_BASE(tzeroPrettyBase, /ROW)
  tzeroID = CW_FIELD(tzeroRow, TITLE="", UVALUE="DGSN_TZERO", UNAME="DGSN_TZERO", /ALL_EVENTS, $
    XSIZE=EiTzero_TextBoxSize)
    
    
  ; == TOF CUTTING ==
  tofRow = WIDGET_BASE(reductionTabCol2Row1Col2, /ROW) ; Just for formatting
  
  tofcutBase = WIDGET_BASE(tofRow)
  tofcutLabel = WIDGET_LABEL(tofcutBase, Value=' TOF Spectrum Cutting ', XOFFSET=5)
  tofcutLabelGeomtry = WIDGET_INFO(tofcutLabel, /GEOMETRY)
  tofcutLabelGeomtryYSize = tofcutLabelGeomtry.ysize
  tofcutPrettyBase = WIDGET_BASE(tofcutBase, /FRAME, /COLUMN, $
    YOFFSET=tofcutLabelGeomtryYSize/2, XPAD=10, YPAD=10)
    
  tofcutRow = WIDGET_BASE(tofcutPrettyBase, /ROW)
  tofcutminID = CW_FIELD(tofcutRow, TITLE="Min:", UVALUE="DGSN_TOF-CUT-MIN", $
    UNAME="DGSN_TOF-CUT-MIN", /ALL_EVENTS, XSIZE=17)
  tofcutmaxID = CW_FIELD(tofcutRow, TITLE="Max:", UVALUE="DGSN_TOF-CUT-MAX", $
    UNAME="DGSN_TOF-CUT-MAX", /ALL_EVENTS, XSIZE=18)
    
    
  ; == Thresholds ==
  thresholdRow = WIDGET_BASE(reductionTabCol2Row1Col2, /ROW) ; Just for formatting
  
  thresholdBase = WIDGET_BASE(thresholdRow)
  thresholdLabel = WIDGET_LABEL(thresholdBase, Value=' Cut off Threshold ', XOFFSET=5)
  thresholdLabelGeomtry = WIDGET_INFO(thresholdLabel, /GEOMETRY)
  thresholdLabelGeomtryYSize = thresholdLabelGeomtry.ysize
  thresholdPrettyBase = WIDGET_BASE(thresholdBase, /FRAME, /COLUMN, $
    YOFFSET=tofcutLabelGeomtryYSize/2, XPAD=10, YPAD=10)
    
  thresholdValuesRow = WIDGET_BASE(thresholdPrettyBase, /ROW)
  tofcutminID = CW_FIELD(thresholdValuesRow, TITLE="Low:", UVALUE="DGSN_LO_THRESHOLD", $
    UNAME="DGSN_LO_THRESHOLD", /ALL_EVENTS, XSIZE=17)
  tofcutmaxID = CW_FIELD(thresholdValuesRow, TITLE="High:", UVALUE="DGSN_HI_THRESHOLD", $
    UNAME="DGSN_HI_THRESHOLD", /ALL_EVENTS, XSIZE=18)
    
    
    
  ; == NORMALISATION OPTIONS ==
    
  normRow = WIDGET_BASE(reductionTabCol1Row1Col1, /ROW)
  
  normBase = WIDGET_BASE(normRow)
  normLabel = WIDGET_LABEL(normBase, VALUE=' Normalisation ', XOFFSET=5)
  normLabelGeometry = WIDGET_INFO(normLabel, /GEOMETRY)
  normLabelGeometryYSize = normLabelGeometry.ysize
  normPrettyBase = WIDGET_BASE(normBase, /FRAME, /COLUMN, $
    YOFFSET=normLabelGeometryYSize/2, XPAD=10, YPAD=10, $
    SCR_XSIZE=550)
    
  normOptionsBaseColumns = WIDGET_BASE(normPrettyBase, COLUMN=2)
  normOptionsBaseColumn1 = WIDGET_BASE(normOptionsBaseColumns, /COLUMN)
  normOptionsBaseColumn2 = WIDGET_BASE(normOptionsBaseColumns, /COLUMN)
  normOptionsBaseRow1 = WIDGET_BASE(normPrettyBase, /ROW)
  normOptionsBaseRow2 = WIDGET_BASE(normPrettyBase, /ROW)
  
  normOptionsBase = WIDGET_BASE(normOptionsBaseColumn1, /NONEXCLUSIVE)
  noMon_Button = WIDGET_BUTTON(normOptionsBase, VALUE='No Monitor Normalisation', $
    UVALUE='DGSN_NO-MON-NORM', UNAME='DGSN_NO-MON-NORM')
  pc_button = WIDGET_BUTTON(normOptionsBase, VALUE='Proton Charge Normalisation', $
    UVALUE='DGSN_PC-NORM', UNAME='DGSN_PC-NORM')
    
  normButton = Widget_Button(normOptionsBase, Value='White Beam Normalisation', UVALUE='DGSN_WHITE_NORM', $
    UNAME='DGSN_WHITE_NORM')
    
  ; We also set the default value to be 1, which is the same as in reductioncmd::init
  monitorNumberID = CW_FIELD(normOptionsBaseColumn1, TITLE="Monitor Number:", UVALUE="DGSN_USMON", $
    UNAME="DGSN_USMON", VALUE=1, /INTEGER, /ALL_EVENTS, XSIZE=5)
    
  ; Normalisation Files
  normFilesBase = WIDGET_BASE(normOptionsBaseColumn2, /COLUMN, /ALIGN_RIGHT)
  ;normFileID = CW_FIELD(normFilesBase, XSIZE=30, /ALL_EVENTS,     TITLE="Normalisation: ", UVALUE="DGSN_NORM")
  emptycanFileID = CW_FIELD(normFilesBase, XSIZE=30, /ALL_EVENTS, TITLE="    Empty Can: ", $
    UVALUE="DGSN_EMPTYCAN", UNAME="DGSN_EMPTYCAN")
  blackcanFileID = CW_FIELD(normFilesBase, XSIZE=30, /ALL_EVENTS, TITLE="    Black Can: ", $
    UVALUE="DGSN_BLACKCAN", UNAME="DGSN_BLACKCAN")
  darkFileID = CW_FIELD(normFilesBase, XSIZE=30, /ALL_EVENTS,     TITLE=" Dark Current: ", $
    UVALUE="DGSN_DARK", UNAME="DGSN_DARK")
    
  ; == Transmission Corrections ==
  transBase = WIDGET_BASE(normOptionsBaseRow2, /ALIGN_BOTTOM)
  transBaseLabel = WIDGET_LABEL(transBase, VALUE=' Transmission Corrections ', XOFFSET=5)
  transBaseLabelGeometry = WIDGET_INFO(transBaseLabel, /GEOMETRY)
  transBaseLabelGeometryYSize = transBaseLabelGeometry.ysize
  transPrettyBase = WIDGET_BASE(transBase, /FRAME, /ROW, $
    YOFFSET=transBaseLabelGeometryYSize/2, XPAD=10, YPAD=10, SCR_XSIZE=513)
    
  normTransID = CW_FIELD(transPrettyBase, /ALL_EVENTS, TITLE="Norm Coeff:", UVALUE="DGSN_NORM-TRANS", $
    UNAME="DGSN_NORM-TRANS", XSIZE=22)
  detEffID = CW_FIELD(transPrettyBase, /ALL_EVENTS, TITLE="Detector Eff:", UVALUE="DGSN_DET-EFF", $
    UNAME="DGSN_DET-EFF", XSIZE=22)
    
  ; Monitor integration range
  monitorRangeBase = WIDGET_BASE(normOptionsBaseRow1, /ALIGN_BOTTOM)
  monitorRangeBaseLabel = WIDGET_LABEL(monitorRangeBase, VALUE=' Monitor Integration Range (usec) ', XOFFSET=5)
  monitorRangeBaseLabelGeometry = WIDGET_INFO(monitorRangeBaseLabel, /GEOMETRY)
  monitorRangeBaseLabelGeometryYSize = monitorRangeBaseLabelGeometry.ysize
  monitorRangePrettyBase = WIDGET_BASE(monitorRangeBase, /FRAME, /ROW, $
    YOFFSET=monitorRangeBaseLabelGeometryYSize/2, XPAD=10, YPAD=10)
    
  monMinID = CW_FIELD(monitorRangePrettyBase, /ALL_EVENTS, TITLE="Min:", UVALUE="DGSN_MON-INT-MIN", $
    UNAME="DGSN_MON-INT-MIN", XSIZE=10)
  monMaxID = CW_FIELD(monitorRangePrettyBase, /ALL_EVENTS, TITLE="Max:", UVALUE="DGSN_MON-INT-MAX", $
    UNAME="DGSN_MON-INT-MAX", XSIZE=10)
    
  ; Norm integration range
  normRangeBase = WIDGET_BASE(normOptionsBaseRow1, UNAME="DGSN_NORM-INT-RANGE", /ALIGN_BOTTOM)
  normRangeBaseLabel = WIDGET_LABEL(normRangeBase, VALUE=' Normalisation Integration Range (meV) ', $
    UNAME="DGSN_NORM-INT-RANGE_LABEL", XOFFSET=5)
  normRangeBaseLabelGeometry = WIDGET_INFO(normRangeBaseLabel, /GEOMETRY)
  normRangeBaseLabelGeometryYSize = normRangeBaseLabelGeometry.ysize
  normRangePrettyBase = WIDGET_BASE(normRangeBase, /FRAME, /ROW, $
    YOFFSET=normRangeBaseLabelGeometryYSize/2, XPAD=10, YPAD=10)
    
  normMinID = CW_FIELD(normRangePrettyBase, /ALL_EVENTS, TITLE="Min:", UVALUE="DGSN_NORM-INT-MIN", $
    UNAME="DGSN_NORM-INT-MIN", XSIZE=10)
  normMaxID = CW_FIELD(normRangePrettyBase, /ALL_EVENTS, TITLE="Max:", UVALUE="DGSN_NORM-INT-MAX", $
    UNAME="DGSN_NORM-INT-MAX", XSIZE=10)
    
    
  ; == ROI ==
    
  ; ROI
  roiBase = WIDGET_BASE(reductionTabCol2Row1Col1)
  roiLabel = WIDGET_LABEL(roiBase, VALUE=' Region-of-Interest ', XOFFSET=5)
  roiLabelGeometry = WIDGET_INFO(roiLabel, /GEOMETRY)
  roiLabelYSize = roiLabelGeometry.ysize
  roiPrettyBase = WIDGET_BASE(roiBase, /FRAME, /COLUMN, $
    YOFFSET=roiLabelYSize/2, YPAD=10, XPAD=10)
  roiRow = WIDGET_BASE(roiPrettyBase, ROW=1)
  roiFileID = CW_FIELD(roiRow, TITLE='Filename: ', UVALUE='DGSN_ROI_FILENAME', $
    UNAME='DGSN_ROI_FILENAME', /ALL_EVENTS, XSIZE=25)
    
    
  ; == TIB ==
    
  TIBrow = WIDGET_BASE(reductionTabCol2Row2Col1, /ROW)
  
  TIBbase = WIDGET_BASE(TIBrow)
  TIBlabel = WIDGET_LABEL(TIBbase, VALUE=' Time Independent Bkgrd ', XOFFSET=5)
  TIBlabelGeometry = WIDGET_INFO(TIBlabel, /GEOMETRY)
  TIBlabelGeometryYSize = TIBlabelGeometry.ysize
  TIBPrettyBase = WIDGET_BASE(TIBbase, /FRAME, /ROW, $
    YOFFSET=TIBlabelGeometryYSize/2, XPAD=10, YPAD=10, SCR_XSIZE=535)
    
  ; TIB Constant
  TIBConstantBase = WIDGET_BASE(TIBPrettyBase, /ALIGN_BOTTOM)
  TIBConstantBaseLabel = WIDGET_LABEL(TIBConstantBase, VALUE=' Constant ', XOFFSET=5)
  TIBConstantBaseLabelGeometry = WIDGET_INFO(TIBConstantBaseLabel, /GEOMETRY)
  TIBConstantBaseLabelGeometryYSize = TIBConstantBaseLabelGeometry.ysize
  TIBConstantPrettyBase = WIDGET_BASE(TIBConstantBase, /FRAME, /ROW, $
    YOFFSET=TIBConstantBaseLabelGeometryYSize/2, XPAD=10, YPAD=10)
  TIBconstID = CW_FIELD(TIBConstantPrettyBase, XSIZE=15, TITLE="", UVALUE="DGSN_TIBCONST", $
    UNAME="DGSN_TIBCONST", /ALL_EVENTS)
    
  label1 = WIDGET_LABEL(TIBPrettyBase, VALUE=' OR ')
  
  ; TIB range
  TIBRangeBase = WIDGET_BASE(TIBPrettyBase, /ALIGN_BOTTOM)
  TIBRangeBaseLabel = WIDGET_LABEL(TIBRangeBase, VALUE=' Range ', XOFFSET=5)
  TIBRangeBaseLabelGeometry = WIDGET_INFO(TIBRangeBaseLabel, /GEOMETRY)
  TIBRangeBaseLabelGeometryYSize = TIBRangeBaseLabelGeometry.ysize
  TIBRangePrettyBase = WIDGET_BASE(TIBRangeBase, /FRAME, /ROW, $
    YOFFSET=TIBRangeBaseLabelGeometryYSize/2, XPAD=10, YPAD=10, $
    SCR_XSIZE=318)
    
  TIBMinID = CW_FIELD(TIBRangePrettyBase, /ALL_EVENTS, TITLE="Min:", UVALUE="DGSN_TIB-MIN", $
    UNAME="DGSN_TIB-MIN", XSIZE=15)
  TIBMaxID = CW_FIELD(TIBRangePrettyBase, /ALL_EVENTS, TITLE="Max:", UVALUE="DGSN_TIB-MAX", $
    UNAME="DGSN_TIB-MAX", XSIZE=15)
    
    
    
  ; Output Formats Pretty Frame
  outputRow = WIDGET_BASE(reductionTabCol2Row2Col1, /ROW)
  formatBase = WIDGET_BASE(outputRow)
  formatLabel = WIDGET_LABEL(formatBase, value=' Output Formats ', XOFFSET=5)
  formatLabelGeometry = WIDGET_INFO(formatLabel, /GEOMETRY)
  formatLabelYSize = formatLabelGeometry.ysize
  
  ; Output Formats Selection Boxes
  outputBase = Widget_Base(formatBase, /COLUMN,  /FRAME, $
    YOFFSET=formatLabelYSize/2, YPAD=10, XPAD=10)
  outputBaseColumns = WIDGET_BASE(outputBase, COLUMN=3)
  outputBaseCol1 = WIDGET_BASE(outputBaseColumns, /NONEXCLUSIVE)
  outputBaseCol2 = WIDGET_BASE(outputBaseColumns, /NONEXCLUSIVE)
  outputBaseCol3 = WIDGET_BASE(outputBaseColumns)
  outputBaseRow = WIDGET_BASE(outputBase, /ROW)
  
  ; Column #1
  ;speButton = Widget_Button(outputBaseCol1, Value='SPE/PHX', UVALUE='DGSN_MAKE_SPE')
  ;qvectorButton = Widget_Button(outputBaseCol1, Value='Qvector', UVALUE='DGSN_MAKE_QVECTOR')
  ;fixedButton = Widget_Button(outputBaseCol1, Value='Fixed Grid', UVALUE='DGSN_MAKE_FIXED', UNAME='DGSN_MAKE_FIXED')
  ; Column #2
  tofButton = Widget_Button(outputBaseCol2, Value='Combined Time-of-Flight', UVALUE='DGSN_MAKE_COMBINED_TOF', $
    UNAME='DGSN_MAKE_COMBINED_TOF')
    
  waveButton = Widget_Button(outputBaseCol2, Value='Combined Wavelength', UVALUE='DGSN_MAKE_COMBINED_WAVE', $
    UNAME='DGSN_MAKE_COMBINED_WAVE')
  tibButton = WIDGET_BUTTON(outputBaseCol2, VALUE='TIB constant per pixels', UVALUE='DGSN_DUMP_TIB', $
    UNAME='DGSN_DUMP_TIB')
    
  ; Column #3
  ; Output Options Pretty Frame
  formatOptionsBase = WIDGET_BASE(outputBaseCol3)
  formatOptionsLabel = WIDGET_LABEL(formatOptionsBase, value=' Combined Wavelength Range ', XOFFSET=5)
  formatOptionsLabelGeometry = WIDGET_INFO(formatOptionsLabel, /GEOMETRY)
  formatOptionsLabelYSize = formatOptionsLabelGeometry.ysize
  formatOptionsPrettyBase = Widget_Base(formatOptionsBase, COLUMN=1, Scr_XSize=330, /FRAME, $
    YOFFSET=formatOptionsLabelYSize/2, YPAD=10, XPAD=10)
    
  ; Combined Wavelength Range Base
  formatOptionsPrettyBaseWavelengthRow = WIDGET_BASE(formatOptionsPrettyBase, /ROW, $
    UNAME="DGSN_COMBINED_WAVELENGTH_RANGE")
  minWavelengthID = CW_FIELD(formatOptionsPrettyBaseWavelengthRow, TITLE="Min:", $
    XSIZE=7, UVALUE="DGSN_LAMBDA_MIN", UNAME="DGSN_LAMBDA_MIN", /ALL_EVENTS)
  maxWavelengthID = CW_FIELD(formatOptionsPrettyBaseWavelengthRow, TITLE="Max:", $
    XSIZE=7, UVALUE="DGSN_LAMBDA_MAX", UNAME="DGSN_LAMBDA_MAX", /ALL_EVENTS)
  stepWavelengthID = CW_FIELD(formatOptionsPrettyBaseWavelengthRow, TITLE="Step:", $
    XSIZE=7, UVALUE="DGSN_LAMBDA_STEP", UNAME="DGSN_LAMBDA_STEP", /ALL_EVENTS)
    
  ; == DEFAULTS ==
    
  ; Don't enable wavelength range until it's selected.
  WIDGET_CONTROL, formatOptionsPrettyBaseWavelengthRow, SENSITIVE=0
  
  ; Disable some of the inputs until something has been defined in the DGSN_NORM field.
  ;WIDGET_CONTROL, normRangeBase, SENSITIVE=0
  
  ; Disable Proton Charge Norm until No-Monitor Norm is selected
  WIDGET_CONTROL, pc_button, SENSITIVE=0
  
  
  ; Lets create a set of tabs
  
  ; === Message Tabs ===
  reductionMessageTabsID = WIDGET_TAB(baseWidget)
  
  ; Check the DGSR command
  status=dgsn_cmd->Check()
  
  MessageBoxSize = 200
  
  ; Info Messages Tab
  InfoTab = WIDGET_BASE(reductionMessageTabsID, TITLE='Messages')
  infoMessagesID = WIDGET_TEXT(InfoTab, XSIZE=MessageBoxSize, YSIZE=6, /SCROLL, /WRAP, $
    VALUE=status.message, UNAME='DGSN_INFO_TEXT')
    
  ; Reduction Tab
  CommandTab = WIDGET_BASE(reductionMessageTabsID, Title='Command to execute', /COLUMN)
  ;textID = WIDGET_LABEL(baseWidget, VALUE='Command to execute:', /ALIGN_LEFT)
  outputID= WIDGET_TEXT(CommandTab, xsize=MessageBoxSize, ysize=6, /SCROLL, /WRAP, $
    VALUE=dgsn_cmd->generate(), UNAME='DGSN_CMD_TEXT')
    
    
  ButtonRow = WIDGET_BASE(baseWidget, /ROW, /ALIGN_RIGHT)
  
  ;  GatherButton = WIDGET_BUTTON(ButtonRow, VALUE='GATHER (Only Run when SLURM Jobs Completed)', $
  ;    EVENT_PRO='DGSnorm_LaunchCollector', UNAME='DGSN_LAUNCH_COLLECTOR_BUTTON')
  ;  ; As by default we have 1 job - we should disable the collector button
  ;  WIDGET_CONTROL, GatherButton, SENSITIVE=0
  
  ; Define a Run button
  executeID = WIDGET_BUTTON(ButtonRow, Value=' EXECUTE >>> ', $
    EVENT_PRO='DGSnorm_Execute', UNAME='DGSN_EXECUTE_BUTTON')
    
END