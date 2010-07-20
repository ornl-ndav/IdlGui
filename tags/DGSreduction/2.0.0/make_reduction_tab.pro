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
  
  ;  reductionTabCol2Row2 = WIDGET_BASE(reductionTabCol2, /COLUMN)
  ;  reductionTabCol2Row2Col1 = WIDGET_BASE(reductionTabCol2Row2, /COLUMN)
  
  
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
    
  dataSourceBrowseButton = WIDGET_BUTTON(dataSourceRow, VALUE=' Browse... ', $
    UVALUE='DGS_BROWSE_DATARUN', UNAME='DGS_BROWSE_DATARUN')
    
  livefileButton = WIDGET_BUTTON(dataSourceRow, VALUE=" Live NeXus ", UVALUE="DGSR_LIVENEXUS", UNAME="DGSR_LIVENEXUS")
  
  dataSourceHint1 = '1,4-6 will add run 1,4,5,6 together.'
  dataSourceHint2 = '1:3 will process runs 1,2,3 separately.'
  
  ;    dataSourceStatusCol = WIDGET_BASE(dataSourcePrettyBase, /COLUMN)
  ;    dataSourceStatus1 = WIDGET_LABEL(dataSourcePrettyBase, VALUE=dataSourceHint1 ,ALIGN_LEFT=1)
  ;    dataSourceStatus2 = WIDGET_LABEL(dataSourcePrettyBase, VALUE=dataSourceHint2, ALIGN_LEFT=1)
  ;
  
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
    
  energyRow = WIDGET_BASE(reductionTabCol2Row1Col1, /ROW) ; Just for formatting
  
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
    
  ; TODO: Add label that indicates that these are bin boundaries.
    
  ; == MOMENTUM (Q) TRANSFER RANGE ==
  QRow = WIDGET_BASE(reductionTabCol2Row1Col1, /ROW) ; Just for formatting
  
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
    
  ; == OUTPUT LABEL ==
  OutputLabelRow = WIDGET_BASE(reductionTabCol2Row1Col1, /ROW) ; Just for formatting
  
  OutputLabelBase = WIDGET_BASE(OutputLabelRow)
  OutputLabel_Label = WIDGET_LABEL(OutputLabelBase, value=' Output Directory Label ', XOFFSET=5)
  OutputLabel_LabelGeometry = WIDGET_INFO(OutputLabel_Label, /GEOMETRY)
  OutputLabel_LabelYSize = OutputLabel_LabelGeometry.ysize
  OutputLabelPrettyBase = WIDGET_BASE(OutputLabelBase, /FRAME, /COLUMN, $
    YOFFSET=OutputLabel_LabelYSize/2, YPAD=10, XPAD=10)
    
  ; User Specified Output Directory Label
  userLabelID = CW_FIELD(OutputLabelPrettyBase, TITLE='', XSIZE=50, $
    UVALUE='DGSR_USER_LABEL', UNAME='DGSR_USER_LABEL', /ALL_EVENTS)
    
  outputFeedbackRow = WIDGET_BASE(OutputLabelPrettyBase, /COLUMN)
  ;outputDirectoryLabel1 = WIDGET_LABEL(outputFeedbackRow, VALUE='Current output will be written to ')
  outputDirectoryLabel2 = WIDGET_LABEL(outputFeedbackRow, VALUE='<unknown>', $
    UNAME='DGSR_OUTPUT_DIRECTORY_LABEL', $
    XSIZE=300, ALIGN_LEFT=1)
    
    
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
    
  ; Output Formats Pretty Frame
  outputRow = WIDGET_BASE(reductionTabCol1Row1Col1, /ROW)
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
    
    
  ;
  ;  ; For now - let's disable the angle input
  ;  WIDGET_CONTROL, angleRow, SENSITIVE=0
    
    
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
  
  
  
; == DEFAULTS ==
  
  
  
; Disable some of the inputs until something has been defined in the DGSR_NORM field.
;WIDGET_CONTROL, normRangeBase, SENSITIVE=0
  
  
  
; Lets create a set of tabs
  
  
  
  
  
  
END