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

PRO make_VanMask_Tab, baseWidget, dgsncmd

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
  dataSourceLabel = WIDGET_LABEL(dataSourceBase, VALUE=' Run Number ', XOFFSET=5)
  dataSourceLabelGeometry = WIDGET_INFO(dataSourceLabel, /GEOMETRY)
  dataSourceLabelGeometryYSize = dataSourceLabelGeometry.ysize
  dataSourcePrettyBase = WIDGET_BASE(dataSourceBase, /FRAME, /COLUMN, $
        YOFFSET=dataSourceLabelGeometryYSize/2, YPAD=10, XPAD=10)
  
  dataSourceRow = WIDGET_BASE(dataSourcePrettyBase, /ROW)
  runID= CW_FIELD(dataSourceRow, xsize=29, ysize=1, TITLE="", UVALUE="DGS_DATARUN", /ALL_EVENTS, /LONG)
  checkfileButton = WIDGET_BUTTON(dataSourceRow, VALUE="Check File", UVALUE="DGS_FINDNEXUS", SENSITIVE=0)

  detectorBankBase = WIDGET_BASE(RunDetectorRow)
  detectorBankLabel = WIDGET_LABEL(detectorBankBase, VALUE=' Detector Banks ', XOFFSET=5)
  detectorBankLabelGeometry = WIDGET_INFO(detectorBankLabel, /GEOMETRY)
  detectorBankLabelYSize = detectorBankLabelGeometry.ysize
  detectorBankPrettyBase = WIDGET_BASE(detectorBankBase, /FRAME, /COLUMN, $
        YOFFSET=detectorBankLabelYSize/2, YPAD=10, XPAD=10)
  
  detectorBank_TextBoxSize = 11
  
  detectorBankRow = WIDGET_BASE(detectorBankPrettyBase, /ROW)
  lbankID = CW_FIELD(detectorBankRow, XSIZE=detectorBank_TextBoxSize, /ALL_EVENTS, TITLE="", $ 
    UVALUE="DGS_DATAPATHS_LOWER" , UNAME="DGS_DATAPATHS_LOWER", /INTEGER)
  ubankID = CW_FIELD(detectorBankRow, XSIZE=detectorBank_TextBoxSize, /ALL_EVENTS, TITLE=" --> ", $
    UVALUE="DGS_DATAPATHS_UPPER", $
    UNAME="DGS_DATAPATHS_UPPER", /INTEGER)  
  
  
    
  
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
  eiID = CW_FIELD(eiRow, TITLE="", UVALUE="DGS_EI", /ALL_EVENTS, $
    XSIZE=EiTzero_TextBoxSize)

  tzeroBase = WIDGET_BASE(EiTzeroBase)
  tzeroLabel = WIDGET_LABEL(tzeroBase, Value=' T0 (usec) ', XOFFSET=5)
  tzeroLabelGeomtry = WIDGET_INFO(tzeroLabel, /GEOMETRY)
  tzeroLabelGeomtryYSize = tzeroLabelGeomtry.ysize
  tzeroPrettyBase = WIDGET_BASE(tzeroBase, /FRAME, /COLUMN, $
        YOFFSET=tzeroLabelGeomtryYSize/2, XPAD=10, YPAD=10)
  tzeroRow = WIDGET_BASE(tzeroPrettyBase, /ROW)
  tzeroID = CW_FIELD(tzeroRow, TITLE="", UVALUE="DGS_TZERO", /ALL_EVENTS, $
    XSIZE=EiTzero_TextBoxSize)




; == ENERGY TRANSFER RANGE ==
  
  energyRow = WIDGET_BASE(reductionTabCol2Row1Col2, /ROW) ; Just for formatting
  
  rangesBase = WIDGET_BASE(energyRow)
  rangesLabel = WIDGET_LABEL(rangesBase, value=' Energy Transfer Range (meV) ', XOFFSET=5)
  rangesLabelGeometry = WIDGET_INFO(rangesLabel, /GEOMETRY)
  rangesLabelYSize = rangesLabelGeometry.ysize
  rangesPrettyBase = WIDGET_BASE(rangesBase, /FRAME, /ROW, $
        YOFFSET=rangesLabelYSize/2, YPAD=10, XPAD=10)
  
  ; Energy Transfer Range Row
  EnergyRangeRow = WIDGET_BASE(rangesPrettyBase, /ROW, UNAME="DGS_ET_RANGE")
  minEnergyID = CW_FIELD(EnergyRangeRow, TITLE="Min:", $
        XSIZE=8, UVALUE="DGS_ET_MIN", /ALL_EVENTS)
  maxEnergyID = CW_FIELD(EnergyRangeRow, TITLE="Max:", $
        XSIZE=8, UVALUE="DGS_ET_MAX", /ALL_EVENTS)
  stepEnergyID = CW_FIELD(EnergyRangeRow, TITLE="Step:", $
        XSIZE=8, UVALUE="DGS_ET_STEP", /ALL_EVENTS)

; == MOMENTUM (Q) TRANSFER RANGE ==
  QRow = WIDGET_BASE(reductionTabCol2Row1Col2, /ROW) ; Just for formatting

  QrangesBase = WIDGET_BASE(QRow)
  QrangesLabel = WIDGET_LABEL(QrangesBase, value=' Q-Range (1/Angstroms) ', XOFFSET=5)
  QrangesLabelGeometry = WIDGET_INFO(QrangesLabel, /GEOMETRY)
  QrangesLabelYSize = QrangesLabelGeometry.ysize
  QrangesPrettyBase = WIDGET_BASE(QrangesBase, /FRAME, /COLUMN, $
        YOFFSET=rangesLabelYSize/2, YPAD=10, XPAD=10)
        
  ; Q Range Base
  QRangeRow = WIDGET_BASE(QrangesPrettyBase, /ROW, UNAME="DGS_Q_RANGE")
  minMomentumID = CW_FIELD(QRangeRow, TITLE="Min:", $
        XSIZE=8, UVALUE="DGS_Q_MIN", /ALL_EVENTS)
  maxMomentumID = CW_FIELD(QRangeRow, TITLE="Max:", $
        XSIZE=8, UVALUE="DGS_Q_MAX", /ALL_EVENTS)
  stepMomentumID = CW_FIELD(QRangeRow, TITLE="Step:", $
        XSIZE=8, UVALUE="DGS_Q_STEP", /ALL_EVENTS) 
  
; == TOF CUTTING ==
  tofRow = WIDGET_BASE(reductionTabCol2Row1Col2, /ROW) ; Just for formatting
    
  tofcutBase = WIDGET_BASE(tofRow)
  tofcutLabel = WIDGET_LABEL(tofcutBase, Value=' TOF Spectrum Cutting ', XOFFSET=5)
  tofcutLabelGeomtry = WIDGET_INFO(tofcutLabel, /GEOMETRY)
  tofcutLabelGeomtryYSize = tofcutLabelGeomtry.ysize
  tofcutPrettyBase = WIDGET_BASE(tofcutBase, /FRAME, /COLUMN, $
        YOFFSET=tofcutLabelGeomtryYSize/2, XPAD=10, YPAD=10)

  tofcutRow = WIDGET_BASE(tofcutPrettyBase, /ROW)
  tofcutminID = CW_FIELD(tofcutRow, TITLE="Min:", UVALUE="DGS_TOF-CUT-MIN", /ALL_EVENTS, XSIZE=17)
  tofcutmaxID = CW_FIELD(tofcutRow, TITLE="Max:", UVALUE="DGS_TOF-CUT-MAX", /ALL_EVENTS, XSIZE=18)  


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
  normOptionsBaseRow = WIDGET_BASE(normPrettyBase, /ROW)
  
  normOptionsBase = WIDGET_BASE(normOptionsBaseColumn1, /NONEXCLUSIVE)
  noMon_Button = WIDGET_BUTTON(normOptionsBase, VALUE='No Monitor Normalisation', $
        UVALUE='DGS_NO-MON-NORM')
  pc_button = WIDGET_BUTTON(normOptionsBase, VALUE='Proton Charge Normalisation', $
        UVALUE='DGS_PC-NORM', UNAME='DGS_PC-NORM')
  lambdaratioID = WIDGET_BUTTON(normOptionsBase, VALUE='Lambda Ratio Scaling', $ 
        UVALUE='DGS_LAMBDA-RATIO')
  
  ; We also set the default value to be 1, which is the same as in reductioncmd::init
  monitorNumberID = CW_FIELD(normOptionsBaseColumn1, TITLE="Monitor Number:", UVALUE="DGS_USMON", VALUE=1, /INTEGER, /ALL_EVENTS, XSIZE=5)

  ; Normalisation Files
  normFilesBase = WIDGET_BASE(normOptionsBaseColumn2, /COLUMN, /ALIGN_RIGHT)
  normFileID = CW_FIELD(normFilesBase, XSIZE=30, /ALL_EVENTS,     TITLE="Normalisation: ", UVALUE="DGS_NORM")
  emptycanFileID = CW_FIELD(normFilesBase, XSIZE=30, /ALL_EVENTS, TITLE="    Empty Can: ", UVALUE="DGS_EMPTYCAN")
  blackcanFileID = CW_FIELD(normFilesBase, XSIZE=30, /ALL_EVENTS, TITLE="    Black Can: ", UVALUE="DGS_BLACKCAN")
  darkFileID = CW_FIELD(normFilesBase, XSIZE=30, /ALL_EVENTS,     TITLE=" Dark Current: ", UVALUE="DGS_DARK")

  TIBrow = WIDGET_BASE(normOptionsBaseColumn2, /ROW)
  TIBconstID = CW_FIELD(TIBrow, XSIZE=22, TITLE="Time Independent Bkgrd: ", UVALUE="DGS_TIBCONST", /ALL_EVENTS)

  
  ; Monitor integration range
  monitorRangeBase = WIDGET_BASE(normOptionsBaseRow, /ALIGN_BOTTOM)
  monitorRangeBaseLabel = WIDGET_LABEL(monitorRangeBase, VALUE=' Monitor Integration Range (usec) ', XOFFSET=5)
  monitorRangeBaseLabelGeometry = WIDGET_INFO(monitorRangeBaseLabel, /GEOMETRY)
  monitorRangeBaseLabelGeometryYSize = monitorRangeBaseLabelGeometry.ysize
  monitorRangePrettyBase = WIDGET_BASE(monitorRangeBase, /FRAME, /ROW, $
      YOFFSET=monitorRangeBaseLabelGeometryYSize/2, XPAD=10, YPAD=10)
  
  monMinID = CW_FIELD(monitorRangePrettyBase, /ALL_EVENTS, TITLE="Min:", UVALUE="DGS_MON-INT-MIN", XSIZE=10)
  monMaxID = CW_FIELD(monitorRangePrettyBase, /ALL_EVENTS, TITLE="Max:", UVALUE="DGS_MON-INT-MAX", XSIZE=10)
  
   ; Norm integration range
  normRangeBase = WIDGET_BASE(normOptionsBaseRow, UNAME="DGS_NORM-INT-RANGE", /ALIGN_BOTTOM)
  normRangeBaseLabel = WIDGET_LABEL(normRangeBase, VALUE=' Normalisation Integration Range (meV) ', XOFFSET=5)
  normRangeBaseLabelGeometry = WIDGET_INFO(normRangeBaseLabel, /GEOMETRY)
  normRangeBaseLabelGeometryYSize = normRangeBaseLabelGeometry.ysize
  normRangePrettyBase = WIDGET_BASE(normRangeBase, /FRAME, /ROW, $
      YOFFSET=normRangeBaseLabelGeometryYSize/2, XPAD=10, YPAD=10)
  
  normMinID = CW_FIELD(normRangePrettyBase, /ALL_EVENTS, TITLE="Min:", UVALUE="DGS_NORM-INT-MIN", XSIZE=10)
  normMaxID = CW_FIELD(normRangePrettyBase, /ALL_EVENTS, TITLE="Max:", UVALUE="DGS_NORM-INT-MAX", XSIZE=10)
            

; == ROI and MASKS ==
    
   ; Mask File
  maskRow = WIDGET_BASE(reductionTabCol2Row1Col1, /ROW)
   
  maskBase = WIDGET_BASE(maskRow)
  maskLabel = WIDGET_LABEL(maskBase, VALUE=' Data Selection ', XOFFSET=5)
  maskLabelGeometry = WIDGET_INFO(maskLabel, /GEOMETRY)
  maskLabelYSize = maskLabelGeometry.ysize
  maskPrettyBase = WIDGET_BASE(maskBase, /FRAME, /COLUMN, $
        YOFFSET=maskLabelYSize/2, YPAD=10, XPAD=10, $
        SCR_YSIZE=145)
  
  maskRow = WIDGET_BASE(maskPrettyBase, /ROW, /NONEXCLUSIVE)
  maskID = WIDGET_BUTTON(maskRow, VALUE='Vanadium Mask', UVALUE='DGS_MASK')
  hardMaskID = WIDGET_BUTTON(maskRow, VALUE=' HARD Mask', UVALUE='DGS_HARD_MASK')
  ;maskFileID = CW_FIELD(maskRow, TITLE='Filename:', UVALUE='DGS_MASK_FILENAME', /ALL_EVENTS)
 
   ; ROI
  roiBase = WIDGET_BASE(maskPrettyBase)
  roiLabel = WIDGET_LABEL(roiBase, VALUE=' Region-of-Interest ', XOFFSET=5)
  roiLabelGeometry = WIDGET_INFO(roiLabel, /GEOMETRY)
  roiLabelYSize = roiLabelGeometry.ysize
  roiPrettyBase = WIDGET_BASE(roiBase, /FRAME, /COLUMN, $
        YOFFSET=roiLabelYSize/2, YPAD=10, XPAD=10)
  roiRow = WIDGET_BASE(roiPrettyBase, ROW=1)
  roiFileID = CW_FIELD(roiRow, TITLE='Filename: ', UVALUE='DGS_ROI_FILENAME', $
    /ALL_EVENTS, XSIZE=20)
  
  

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
  speButton = Widget_Button(outputBaseCol1, Value='SPE/PHX', UVALUE='DGS_MAKE_SPE')
  qvectorButton = Widget_Button(outputBaseCol1, Value='Qvector', UVALUE='DGS_MAKE_QVECTOR')
  fixedButton = Widget_Button(outputBaseCol1, Value='Fixed Grid', UVALUE='DGS_MAKE_FIXED', UNAME='DGS_MAKE_FIXED')
  ; Column #2
  etButton = Widget_Button(outputBaseCol2, Value='Combined Energy Transfer', UVALUE='DGS_MAKE_COMBINED_ET')
  tofButton = Widget_Button(outputBaseCol2, Value='Combined Time-of-Flight', UVALUE='DGS_MAKE_COMBINED_TOF')
  normButton = Widget_Button(outputBaseCol2, Value='Vanadium Normalisation', UVALUE='DGS_DUMP_NORM')
  waveButton = Widget_Button(outputBaseCol2, Value='Combined Wavelength', UVALUE='DGS_MAKE_COMBINED_WAVE')
  ; Column #3
  ; Output Options Pretty Frame
  formatOptionsBase = WIDGET_BASE(outputBaseCol3)
  formatOptionsLabel = WIDGET_LABEL(formatOptionsBase, value=' Combined Wavelength Range ', XOFFSET=5)
  formatOptionsLabelGeometry = WIDGET_INFO(formatOptionsLabel, /GEOMETRY)
  formatOptionsPrettyBase = Widget_Base(formatOptionsBase, COLUMN=1, Scr_XSize=330, /FRAME, $
    YOFFSET=formatLabelYSize/2, YPAD=10, XPAD=10)

  ; Combined Wavelength Range Base
  formatOptionsPrettyBaseWavelengthRow = WIDGET_BASE(formatOptionsPrettyBase, /ROW, $
    UNAME="DGS_COMBINED_WAVELENGTH_RANGE")
  minWavelengthID = CW_FIELD(formatOptionsPrettyBaseWavelengthRow, TITLE="Min:", $
        XSIZE=7, UVALUE="DGS_LAMBDA_MIN", /ALL_EVENTS)
  maxWavelengthID = CW_FIELD(formatOptionsPrettyBaseWavelengthRow, TITLE="Max:", $
        XSIZE=7, UVALUE="DGS_LAMBDA_MAX", /ALL_EVENTS)
  stepWavelengthID = CW_FIELD(formatOptionsPrettyBaseWavelengthRow, TITLE="Step:", $
        XSIZE=7, UVALUE="DGS_LAMBDA_STEP", /ALL_EVENTS)
  
; == DEFAULTS ==
  
  ; Set the default(s) as on - to match the defaults in the ReductionCMD class.
  Widget_Control, speButton, SET_BUTTON=1

  ; Cannot have the fixed grid without the Qvector
  WIDGET_CONTROL, fixedButton, SENSITIVE=0
  
  ; Don't enable wavelength range until it's selected.
  WIDGET_CONTROL, formatOptionsPrettyBaseWavelengthRow, SENSITIVE=0
   
  ; Disable some of the inputs until something has been defined in the DGS_NORM field.
  WIDGET_CONTROL, normRangeBase, SENSITIVE=0
  
  ; Disable Proton Charge Norm until No-Monitor Norm is selected
  WIDGET_CONTROL, pc_button, SENSITIVE=0


  textID = WIDGET_LABEL(baseWidget, VALUE='Command to execute:', /ALIGN_LEFT)
  outputID= WIDGET_TEXT(baseWidget, /EDITABLE, xsize=80, ysize=6, /SCROLL, /WRAP, $
    VALUE=dgsncmd->generate(), UNAME='DGSN_CMD')

END