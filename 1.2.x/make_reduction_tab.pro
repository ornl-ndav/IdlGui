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

PRO make_Reduction_Tab, baseWidget, dgsr_cmd

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
  
  reductionTabCol2Row2 = WIDGET_BASE(reductionTabCol2, /COLUMN)
  reductionTabCol2Row2Col1 = WIDGET_BASE(reductionTabCol2Row2, /COLUMN)
  
  
  ; == RUN NUMBER and DETECTORS ==
  
  RunDetectorRow = WIDGET_BASE(reductionTabCol1Row1Col1, /ROW)
  
  dataSourceBase = WIDGET_BASE(RunDetectorRow)
  dataSourceLabel = WIDGET_LABEL(dataSourceBase, VALUE=' Run Number ', XOFFSET=5)
  dataSourceLabelGeometry = WIDGET_INFO(dataSourceLabel, /GEOMETRY)
  dataSourceLabelGeometryYSize = dataSourceLabelGeometry.ysize
  dataSourcePrettyBase = WIDGET_BASE(dataSourceBase, /FRAME, /COLUMN, $
    YOFFSET=dataSourceLabelGeometryYSize/2, YPAD=10, XPAD=10)
    
  dataSourceRow = WIDGET_BASE(dataSourcePrettyBase, /ROW)
  datarunID= CW_FIELD(dataSourceRow, xsize=29, ysize=1, TITLE="", UVALUE="DGSR_DATARUN", UNAME='DGSR_DATARUN', $
    /ALL_EVENTS)
  datarun_cwp_id = CW_FIELD(dataSourceRow, xsize=5, ysize=1, TITLE="", UVALUE="DGSR_DATA_CWP", UNAME='DGSR_DATA_CWP', $
    /ALL_EVENTS)
    
  livefileButton = WIDGET_BUTTON(dataSourceRow, VALUE="Live NeXus", UVALUE="DGSR_LIVENEXUS", UNAME="DGSR_LIVENEXUS")
  ;checkfileButton = WIDGET_BUTTON(dataSourceRow, VALUE="Check File", UVALUE="DGSR_FINDNEXUS", SENSITIVE=0)
  
  dataSourceHint1 = '1,4-6 will add run 1,4,5,6 together.'
  dataSourceHint2 = '1:3 will process runs 1,2,3 separately.'
  
  ;  dataSourceStatusCol = WIDGET_BASE(dataSourcePrettyBase, /COLUMN)
  ;  dataSourceStatus1 = WIDGET_LABEL(dataSourcePrettyBase, VALUE=dataSourceHint1 ,ALIGN_LEFT=1)
  ;  dataSourceStatus2 = WIDGET_LABEL(dataSourcePrettyBase, VALUE=dataSourceHint2, ALIGN_LEFT=1)
  
  
  detectorBankBase = WIDGET_BASE(RunDetectorRow)
  detectorBankLabel = WIDGET_LABEL(detectorBankBase, VALUE=' Detector Banks ', XOFFSET=5)
  detectorBankLabelGeometry = WIDGET_INFO(detectorBankLabel, /GEOMETRY)
  detectorBankLabelYSize = detectorBankLabelGeometry.ysize
  detectorBankPrettyBase = WIDGET_BASE(detectorBankBase, /FRAME, /COLUMN, $
    YOFFSET=detectorBankLabelYSize/2, YPAD=10, XPAD=10)
    
  detectorBank_TextBoxSize = 11
  
  detectorBankRow = WIDGET_BASE(detectorBankPrettyBase, /ROW)
  lbankID = CW_FIELD(detectorBankRow, XSIZE=detectorBank_TextBoxSize, /ALL_EVENTS, TITLE="", $
    UVALUE="DGSR_DATAPATHS_LOWER" , UNAME="DGSR_DATAPATHS_LOWER", /INTEGER)
  ubankID = CW_FIELD(detectorBankRow, XSIZE=detectorBank_TextBoxSize, /ALL_EVENTS, TITLE=" --> ", $
    UVALUE="DGSR_DATAPATHS_UPPER", $
    UNAME="DGSR_DATAPATHS_UPPER", /INTEGER)
    
    
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
  eiID = CW_FIELD(eiRow, TITLE="", UVALUE="DGSR_EI", UNAME='DGSR_EI', /ALL_EVENTS, $
    XSIZE=EiTzero_TextBoxSize)
    
  eiGuessButtonID = WIDGET_BUTTON(eiPrettyBase, VALUE='Estimate Ei', $
    UVALUE='DGSR_EI_GUESS', UNAME='DGSR_EI_GUESS')
    
  tzeroBase = WIDGET_BASE(EiTzeroBase)
  tzeroLabel = WIDGET_LABEL(tzeroBase, Value=' T0 (usec) ', XOFFSET=5)
  tzeroLabelGeomtry = WIDGET_INFO(tzeroLabel, /GEOMETRY)
  tzeroLabelGeomtryYSize = tzeroLabelGeomtry.ysize
  tzeroPrettyBase = WIDGET_BASE(tzeroBase, /FRAME, /COLUMN, $
    YOFFSET=tzeroLabelGeomtryYSize/2, XPAD=10, YPAD=10)
  tzeroRow = WIDGET_BASE(tzeroPrettyBase, /ROW)
  tzeroID = CW_FIELD(tzeroRow, TITLE="", UVALUE="DGSR_TZERO", UNAME='DGSR_TZERO', /ALL_EVENTS, $
    XSIZE=EiTzero_TextBoxSize)
    
  tzeroGuessButtonID = WIDGET_BUTTON(tzeroPrettyBase, VALUE='Estimate T0', $
    UVALUE='DGSR_TZERO_GUESS', UNAME='DGSR_TZERO_GUESS')
    
    
    
  ; == ENERGY TRANSFER RANGE ==
    
  energyRow = WIDGET_BASE(reductionTabCol2Row1Col2, /ROW) ; Just for formatting
  
  rangesBase = WIDGET_BASE(energyRow)
  rangesLabel = WIDGET_LABEL(rangesBase, value=' Energy Transfer Range (meV) ', XOFFSET=5)
  rangesLabelGeometry = WIDGET_INFO(rangesLabel, /GEOMETRY)
  rangesLabelYSize = rangesLabelGeometry.ysize
  rangesPrettyBase = WIDGET_BASE(rangesBase, /FRAME, /ROW, $
    YOFFSET=rangesLabelYSize/2, YPAD=10, XPAD=10)
    
  ; Energy Transfer Range Row
  EnergyRangeRow = WIDGET_BASE(rangesPrettyBase, /ROW, UNAME="DGSR_ET_RANGE")
  minEnergyID = CW_FIELD(EnergyRangeRow, TITLE="Min:", $
    XSIZE=8, UVALUE="DGSR_ET_MIN", UNAME="DGSR_ET_MIN", /ALL_EVENTS)
  maxEnergyID = CW_FIELD(EnergyRangeRow, TITLE="Max:", $
    XSIZE=8, UVALUE="DGSR_ET_MAX", UNAME="DGSR_ET_MAX", /ALL_EVENTS)
  stepEnergyID = CW_FIELD(EnergyRangeRow, TITLE="Step:", $
    XSIZE=8, UVALUE="DGSR_ET_STEP", UNAME="DGSR_ET_STEP", /ALL_EVENTS)
    
  ; == MOMENTUM (Q) TRANSFER RANGE ==
  QRow = WIDGET_BASE(reductionTabCol2Row1Col2, /ROW) ; Just for formatting
  
  QrangesBase = WIDGET_BASE(QRow)
  QrangesLabel = WIDGET_LABEL(QrangesBase, value=' Q-Range (1/Angstroms) ', XOFFSET=5)
  QrangesLabelGeometry = WIDGET_INFO(QrangesLabel, /GEOMETRY)
  QrangesLabelYSize = QrangesLabelGeometry.ysize
  QrangesPrettyBase = WIDGET_BASE(QrangesBase, /FRAME, /COLUMN, $
    YOFFSET=rangesLabelYSize/2, YPAD=10, XPAD=10)
    
  ; Q Range Base
  QRangeRow = WIDGET_BASE(QrangesPrettyBase, /ROW, UNAME="DGSR_Q_RANGE")
  minMomentumID = CW_FIELD(QRangeRow, TITLE="Min:", $
    XSIZE=8, UVALUE="DGSR_Q_MIN", UNAME="DGSR_Q_MIN", /ALL_EVENTS)
  maxMomentumID = CW_FIELD(QRangeRow, TITLE="Max:", $
    XSIZE=8, UVALUE="DGSR_Q_MAX", UNAME="DGSR_Q_MAX", /ALL_EVENTS)
  stepMomentumID = CW_FIELD(QRangeRow, TITLE="Step:", $
    XSIZE=8, UVALUE="DGSR_Q_STEP", UNAME="DGSR_Q_STEP", /ALL_EVENTS)
    
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
  
  ; == SAMPLE ORIENTATION ==
  angleRow = WIDGET_BASE(reductionTabCol1Row1Col1, /ROW)
  
  angleBase = WIDGET_BASE(angleRow)
  angleLabel = WIDGET_LABEL(angleBase, VALUE=' Sample Orientation ', XOFFSET=5)
  angleLabelGeometry = WIDGET_INFO(angleLabel, /GEOMETRY)
  angleLabelGeometryYSize = angleLabelGeometry.ysize
  anglePrettyBase = WIDGET_BASE(angleBase, /FRAME, /COLUMN, $
    YOFFSET=angleLabelGeometryYSize/2, XPAD=10, YPAD=10, $
    SCR_XSIZE=550)
    
  angleinputsRow = WIDGET_BASE(anglePrettyBase, /ROW)
  seblockID = CW_FIELD(angleinputsRow, TITLE="SE Block Name:", $
    UVALUE="DGSR_SEBLOCK", UNAME="DGSR_SEBLOCK", /ALL_EVENTS, XSIZE=30)
  angleoffsetID = CW_FIELD(angleinputsRow, TITLE="Offset (degrees):", $
    UVALUE="DGSR_ANGLE_OFFSET", UNAME="DGSR_ANGLE_OFFSET", /ALL_EVENTS, XSIZE=13)
    
  angleStatusRow = WIDGET_BASE(anglePrettyBase)
  angleStatusID = WIDGET_LABEL(angleStatusRow, VALUE= "The value for psi = ANGLE + OFFSET", UNAME="DGSR_ANGLE_STATUS")
  ;
  ;  ; For now - let's disable the angle input
  ;  WIDGET_CONTROL, angleRow, SENSITIVE=0
  
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
    UVALUE='DGSR_NO-MON-NORM', UNAME='DGSR_NO-MON-NORM')
  pc_button = WIDGET_BUTTON(normOptionsBase, VALUE='Proton Charge Normalisation', $
    UVALUE='DGSR_PC-NORM', UNAME='DGSR_PC-NORM')
  lambdaratioID = WIDGET_BUTTON(normOptionsBase, VALUE='Lambda Ratio Scaling', $
    UVALUE='DGSR_LAMBDA-RATIO', UNAME='DGSR_LAMBDA-RATIO')
    
  monitorNumberID = CW_FIELD(normOptionsBaseColumn1, TITLE="Monitor Number:", UVALUE="DGSR_USMON", $
    UNAME="DGSR_USMON", VALUE=1, /INTEGER, /ALL_EVENTS, XSIZE=5)
  ; Also set the default monitor in the ReductionCmd Class
  dgsr_cmd->SetProperty, USmonPath=1
  
  cwpButton = WIDGET_BUTTON(normOptionsBase, VALUE='Auto Wandering Phase', $
    UVALUE='DGSR_CWP', UNAME='DGSR_CWP')
    
  ; Normalisation Files
  normFilesBase = WIDGET_BASE(normOptionsBaseColumn2, /COLUMN, /ALIGN_RIGHT)
  normFileID = CW_FIELD(normFilesBase, XSIZE=30, /ALL_EVENTS,     TITLE="Normalisation: ", UVALUE="DGSR_NORMRUN", $
    UNAME="DGSR_NORMRUN")
  emptycanbase = WIDGET_BASE(normFilesBase,/row)
  emptycanFileID = CW_FIELD(emptycanbase, XSIZE=20, /ALL_EVENTS, TITLE="    Empty Can: ", UVALUE="DGSR_EMPTYCAN", $
    UNAME="DGSR_EMPTYCAN")
  emptycanTzeroID = CW_FIELD(emptycanbase, XSIZE=5, /ALL_EVENTS, TITLE='', UVALUE="DGSR_EMPTYCAN_CWP", $
    UNAME="DGSR_EMPTYCAN_CWP")
    
  blackcanbase = WIDGET_BASE(normFilesBase, /ROW)
  blackcanFileID = CW_FIELD(blackcanbase, XSIZE=20, /ALL_EVENTS, TITLE="    Black Can: ", UVALUE="DGSR_BLACKCAN", $
    UNAME="DGSR_BLACKCAN")
  blackcanTzeroID = CW_FIELD(blackcanbase, XSIZE=5, /ALL_EVENTS, TITLE='', UVALUE="DGSR_BLACKCAN_CWP", $
    UNAME="DGSR_BLACKCAN_CWP")
    
  darkFileID = CW_FIELD(normFilesBase, XSIZE=30, /ALL_EVENTS,     TITLE=" Dark Current: ", UVALUE="DGSR_DARK", $
    UNAME="DGSR_DARK")
    
  ; == Transmission Corrections ==
  transBase = WIDGET_BASE(normOptionsBaseRow2, /ALIGN_BOTTOM)
  transBaseLabel = WIDGET_LABEL(transBase, VALUE=' Transmission Corrections ', XOFFSET=5)
  transBaseLabelGeometry = WIDGET_INFO(transBaseLabel, /GEOMETRY)
  transBaseLabelGeometryYSize = transBaseLabelGeometry.ysize
  transPrettyBase = WIDGET_BASE(transBase, /FRAME, /ROW, $
    YOFFSET=transBaseLabelGeometryYSize/2, XPAD=10, YPAD=10, SCR_XSIZE=450)
  ;    YOFFSET=transBaseLabelGeometryYSize/2, XPAD=10, YPAD=10, SCR_XSIZE=513)
    
  dataTransID = CW_FIELD(transPrettyBase, /ALL_EVENTS, TITLE="Data Coeff:", UVALUE="DGSR_DATA-TRANS", $
    UNAME="DGSR_DATA-TRANS", XSIZE=10)
  ;  normTransID = CW_FIELD(transPrettyBase, /ALL_EVENTS, TITLE="Norm Coeff:", UVALUE="DGSR_NORM-TRANS", $
  ;    UNAME="DGSR_NORM-TRANS", XSIZE=10)
  detEffID = CW_FIELD(transPrettyBase, /ALL_EVENTS, TITLE="Detector Eff:", UVALUE="DGSR_DET-EFF", $
    UNAME="DGSR_DET-EFF", XSIZE=10)
    
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
    
  ; Norm integration range
  ;  normRangeBase = WIDGET_BASE(normOptionsBaseRow1, UNAME="DGSR_NORM-INT-RANGE", /ALIGN_BOTTOM)
  ;  normRangeBaseLabel = WIDGET_LABEL(normRangeBase, VALUE=' Normalisation Integration Range (meV) ', XOFFSET=5)
  ;  normRangeBaseLabelGeometry = WIDGET_INFO(normRangeBaseLabel, /GEOMETRY)
  ;  normRangeBaseLabelGeometryYSize = normRangeBaseLabelGeometry.ysize
  ;  normRangePrettyBase = WIDGET_BASE(normRangeBase, /FRAME, /ROW, $
  ;    YOFFSET=normRangeBaseLabelGeometryYSize/2, XPAD=10, YPAD=10)
  ;
  ;  normMinID = CW_FIELD(normRangePrettyBase, /ALL_EVENTS, TITLE="Min:", UVALUE="DGSR_NORM-INT-MIN", $
  ;    UNAME="DGSR_NORM-INT-MIN", XSIZE=10)
  ;  normMaxID = CW_FIELD(normRangePrettyBase, /ALL_EVENTS, TITLE="Max:", UVALUE="DGSR_NORM-INT-MAX", $
  ;    UNAME="DGSR_NORM-INT-MAX", XSIZE=10)
    
    
  ; == ROI and MASKS ==
    
  ; Mask File
  maskRow = WIDGET_BASE(reductionTabCol2Row1Col1, /ROW)
  
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
    
  sourceMaskFilenameID = CW_FIELD(maskPrettyBase, YSIZE=1, XSIZE=30, TITLE='Filename:', $
    UNAME='DGSR_SOURCE_MASKFILENAME', UVALUE='DGSR_SOURCE_MASKFILENAME', /ALL_EVENTS)
    
  ; Make 'Default' Hard mask the default
  WIDGET_CONTROL, hardMaskID, SET_BUTTON=1
  dgsr_cmd->SetProperty, HardMask=1
  ; Therefore also make the custom filename field inactive
  WIDGET_CONTROL, sourceMaskFilenameID, SENSITIVE=0
  
  ; Always turn on the vanadium mask
  dgsr_cmd->SetProperty, Mask=1
  
  ;WIDGET_CONTROL, maskID, MAP=0
  ;WIDGET_CONTROL, maskID, SENSITIVE=0, SET_BUTTON=1
  
  ; ROI
  roiBase = WIDGET_BASE(reductionTabCol1Row1Col1)
  roiLabel = WIDGET_LABEL(roiBase, VALUE=' Region-of-Interest ', XOFFSET=5)
  roiLabelGeometry = WIDGET_INFO(roiLabel, /GEOMETRY)
  roiLabelYSize = roiLabelGeometry.ysize
  roiPrettyBase = WIDGET_BASE(roiBase, /FRAME, /COLUMN, $
    YOFFSET=roiLabelYSize/2, YPAD=10, XPAD=10)
  roiRow = WIDGET_BASE(roiPrettyBase, ROW=1)
  roiFileID = CW_FIELD(roiRow, TITLE='Filename: ', UVALUE='DGSR_ROI_FILENAME', $
    UNAME='DGSR_ROI_FILENAME', /ALL_EVENTS, XSIZE=20)
    
  ; == TIB ==
  TIBrow = WIDGET_BASE(reductionTabCol2Row2Col1, /ROW)
  
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
    
    
  ; Output Formats Pretty Frame
  outputRow = WIDGET_BASE(reductionTabCol2Row2Col1, /ROW)
  formatBase = WIDGET_BASE(outputRow)
  formatLabel = WIDGET_LABEL(formatBase, value=' Output Formats ', XOFFSET=5)
  formatLabelGeometry = WIDGET_INFO(formatLabel, /GEOMETRY)
  formatLabelYSize = formatLabelGeometry.ysize
  
  ; Output Formats Selection Boxes
  outputBase = Widget_Base(formatBase, /COLUMN,  /FRAME, $
    YOFFSET=formatLabelYSize/2, YPAD=10, XPAD=10)
  outputBaseColumns = WIDGET_BASE(outputBase, COLUMN=2)
  outputButtonColumns = WIDGET_BASE(outputBaseColumns, COLUMN=2)
  outputBaseCol1 = WIDGET_BASE(outputButtonColumns, /NONEXCLUSIVE)
  outputBaseCol2 = WIDGET_BASE(outputButtonColumns, /NONEXCLUSIVE)
  outputBaseCol3 = WIDGET_BASE(outputBaseColumns, /COLUMN)
  outputBaseRow = WIDGET_BASE(outputBase, /ROW)
  
  ; Column #1
  speButton = Widget_Button(outputBaseCol1, Value='SPE/PHX', UVALUE='DGSR_MAKE_SPE', UNAME='DGSR_MAKE_SPE')
  qvectorButton = Widget_Button(outputBaseCol1, Value='Qvector', UVALUE='DGSR_MAKE_QVECTOR', UNAME='DGSR_MAKE_QVECTOR')
  fixedButton = Widget_Button(outputBaseCol1, Value='Fixed Grid', UVALUE='DGSR_MAKE_FIXED', UNAME='DGSR_MAKE_FIXED')
  tibButton = WIDGET_BUTTON(outputBaseCol1, VALUE='TIB const', UVALUE='DGSR_DUMP_TIB', UNAME='DGSR_DUMP_TIB')
  ; Column #2
  etButton = Widget_Button(outputBaseCol2, Value='Combined Energy Transfer', UVALUE='DGSR_MAKE_COMBINED_ET', $
    UNAME='DGSR_MAKE_COMBINED_ET')
  tofButton = Widget_Button(outputBaseCol2, Value='Combined Time-of-Flight', UVALUE='DGSR_MAKE_COMBINED_TOF', $
    UNAME='DGSR_MAKE_COMBINED_TOF')
  ;normButton = Widget_Button(outputBaseCol2, Value='Vanadium Normalisation', UVALUE='DGSR_DUMP_NORM', $
  ;  UNAME='DGSR_DUMP_NORM')
  waveButton = Widget_Button(outputBaseCol2, Value='Combined Wavelength', UVALUE='DGSR_MAKE_COMBINED_WAVE', $
    UNAME='DGSR_MAKE_COMBINED_WAVE')
  dosButton = WIDGET_BUTTON(outputBaseCol2, VALUE='Phonon DOS', UVALUE='DGSR_PHONON_DOS', UNAME='DGSR_PHONON_DOS')
  
  ; User Specified Output Directory Label
  userLabelID = CW_FIELD(outputBaseRow, TITLE='Output Dir Label:', XSIZE=50, $
    UVALUE='DGSR_USER_LABEL', UNAME='DGSR_USER_LABEL', /ALL_EVENTS)
    
  ; Column #3
  ; Combined Wavelength Output Option Pretty Frame
  formatOptionsBase = WIDGET_BASE(outputBaseCol3)
  formatOptionsLabel = WIDGET_LABEL(formatOptionsBase, value=' Combined Wavelength Range ', XOFFSET=5)
  formatOptionsLabelGeometry = WIDGET_INFO(formatOptionsLabel, /GEOMETRY)
  formatOptionsLabelYSize = formatOptionsLabelGeometry.ysize
  formatOptionsPrettyBase = Widget_Base(formatOptionsBase, COLUMN=1, Scr_XSize=330, /FRAME, $
    YOFFSET=formatOptionsLabelYSize/2, YPAD=10, XPAD=10)
    
  ; Combined Wavelength Range Base
  formatOptionsPrettyBaseWavelengthRow = WIDGET_BASE(formatOptionsPrettyBase, /ROW, $
    UNAME="DGSR_COMBINED_WAVELENGTH_RANGE")
  minWavelengthID = CW_FIELD(formatOptionsPrettyBaseWavelengthRow, TITLE="Min:", $
    XSIZE=7, UVALUE="DGSR_LAMBDA_MIN", UNAME="DGSR_LAMBDA_MIN", /ALL_EVENTS)
  maxWavelengthID = CW_FIELD(formatOptionsPrettyBaseWavelengthRow, TITLE="Max:", $
    XSIZE=7, UVALUE="DGSR_LAMBDA_MAX", UNAME="DGSR_LAMBDA_MAX", /ALL_EVENTS)
  stepWavelengthID = CW_FIELD(formatOptionsPrettyBaseWavelengthRow, TITLE="Step:", $
    XSIZE=7, UVALUE="DGSR_LAMBDA_STEP", UNAME="DGSR_LAMBDA_STEP", /ALL_EVENTS)
    
  ; Debye Waller Factor Pretty Frame
  debyeWallerBase = WIDGET_BASE(outputBaseCol3)
  debyeWallerLabel = WIDGET_LABEL(debyeWallerBase, VALUE=' Debye-Waller Factor ', XOFFSET=5)
  debyeWallerLabelGeometry = WIDGET_INFO(debyeWallerLabel, /GEOMETRY)
  debyeWallerLabelYSize = debyeWallerLabelGeometry.ysize
  debyeWallerPrettyBase = WIDGET_BASE(debyeWallerBase, COLUMN=1, SCR_XSIZE=330, /FRAME, $
    YOFFSET=debyeWallerLabelYSize/2, YPAD=10, XPAD=10)
  ; Debye Waller Factor inputs
  debyeWallerPrettyBaseInputRow = WIDGET_BASE(debyeWallerPrettyBase, /ROW, UNAME='DGSR_DEBYE_WALLER_FACTOR')
  factorID = CW_FIELD(debyeWallerPrettyBaseInputRow, TITLE="Factor:", UVALUE="DGSR_DWF", UNAME="DGSR_DWF", $
    /ALL_EVENTS, XSIZE=13, VALUE='0.0')
  ;factorErrorID = CW_FIELD(debyeWallerPrettyBaseInputRow, TITLE="Error:", UVALUE="DGSR_DWF_ERROR", $
  ;  UNAME="DGSR_DWF_ERROR", /ALL_EVENTS, XSIZE=13, VALUE='0.0')
    
    
  outputFeedbackRow = WIDGET_BASE(reductionTabCol2Row2Col1, /ROW)
  outputDirectoryLabel1 = WIDGET_LABEL(outputFeedbackRow, VALUE='Current output will be written to ')
  outputDirectoryLabel2 = WIDGET_LABEL(outputFeedbackRow, VALUE='<unknown>', $
    UNAME='DGSR_OUTPUT_DIRECTORY_LABEL', $
    XSIZE=300, ALIGN_LEFT=1)
    
  ; == DEFAULTS ==
    
  ; Set the default(s) as on - to match the defaults in the ReductionCMD class.
  Widget_Control, speButton, SET_BUTTON=1
  
  ; Cannot have the fixed grid without the Qvector
  ; Get the state of the qvectorbutton first
  
  qvector_status = WIDGET_INFO(qvectorButton, /BUTTON_SET)
  ; Now set the sensitivity of the fixed Grid button
  WIDGET_CONTROL, fixedButton, SENSITIVE=qvector_status
  
  ; Don't enable the Debye-Waller Factor until it's selected
  WIDGET_CONTROL, debyeWallerPrettyBaseInputRow, SENSITIVE=0
  
  ; Don't enable wavelength range until it's selected.
  WIDGET_CONTROL, formatOptionsPrettyBaseWavelengthRow, SENSITIVE=0
  
  ; Disable some of the inputs until something has been defined in the DGSR_NORM field.
  ;WIDGET_CONTROL, normRangeBase, SENSITIVE=0
  
  ; Disable Proton Charge Norm until No-Monitor Norm is selected
  WIDGET_CONTROL, pc_button, SENSITIVE=0
  
  ; Lets create a set of tabs
  
  ; === Message Tabs ===
  reductionMessageTabsID = WIDGET_TAB(baseWidget)
  
  ; Check the DGSR command
  status=dgsr_cmd->Check()
  
  MessageBoxSize = 200
  
  ; Info Messages Tab
  InfoTab = WIDGET_BASE(reductionMessageTabsID, TITLE='Messages')
  infoMessagesID = WIDGET_TEXT(InfoTab, XSIZE=MessageBoxSize, YSIZE=6, /SCROLL, /WRAP, $
    VALUE=status.message, UNAME='DGSR_INFO_TEXT')
    
  ; Reduction Tab
  CommandTab = WIDGET_BASE(reductionMessageTabsID, Title='Command to execute', /COLUMN)
  ;textID = WIDGET_LABEL(baseWidget, VALUE='Command to execute:', /ALIGN_LEFT)
  outputID= WIDGET_TEXT(CommandTab, xsize=MessageBoxSize, ysize=6, /SCROLL, /WRAP, $
    VALUE=dgsr_cmd->generate(), UNAME='DGSR_CMD_TEXT')
    
  ; === BUTTONS ===
    
    
  ButtonRow = WIDGET_BASE(baseWidget, /ROW, /ALIGN_RIGHT)
  ;
  ;  GatherButton = WIDGET_BUTTON(ButtonRow, VALUE='GATHER (Only Run when SLURM Jobs Completed)', $
  ;    EVENT_PRO='DGSreduction_LaunchCollector', UNAME='DGSR_LAUNCH_COLLECTOR_BUTTON')
  ;  ; As by default we have 1 job - we should disable the collector button
  ;  WIDGET_CONTROL, GatherButton, SENSITIVE=0
  
  ; Define a Run button
  executeID = WIDGET_BUTTON(ButtonRow, Value=' EXECUTE >>> ', $
    EVENT_PRO='DGSreduction_Execute', UNAME='DGSR_EXECUTE_BUTTON')
    
  WIDGET_CONTROL, executeID, SENSITIVE=status.ok
  
END
