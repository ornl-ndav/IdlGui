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

PRO DGSreduction_Execute, event

  ; Error Handling
  catch, theError
  IF theError NE 0 THEN BEGIN
    catch, /cancel
    ok = ERROR_MESSAGE(!ERROR_STATE.MSG + ' Returning...', TRACEBACK=1, /error)
    return
  ENDIF

  ; Get the info structure and copy it here
  WIDGET_CONTROL, event.top, GET_UVALUE=info, /NO_COPY
  dgscmd = info.dgscmd
  
  ; Do some sanity checking.
  
  ; First lets check that an instrument has been selected!
  dgscmd->GetProperty, Instrument=instrument
  IF (STRLEN(instrument) LT 2) THEN BEGIN
    ; First put back the info structure
    WIDGET_CONTROL, event.top, SET_UVALUE=info, /NO_COPY 
    ; Then show an error message!   
    ok=ERROR_MESSAGE("Please select an Instrument from the list.", /INFORMATIONAL)
    return
  END
  
  ; Generate the array of commands to run
  commands = dgscmd->generate()
  
  ; Loop over the command array
  for index = 0L, N_ELEMENTS(commands)-1 do begin
    cmd = commands[index]
    ; TODO: For now let's just dump the commands into a file
    spawn, "echo " + cmd + " >> /tmp/commands"
  endfor
  
  ; Put info back
  WIDGET_CONTROL, event.top, SET_UVALUE=info, /NO_COPY
  
END

;---------------------------------------------------------

PRO DGSreduction_Quit, event
  WIDGET_CONTROL, event.top, /DESTROY
END

;---------------------------------------------------------

PRO DGSreduction_TLB_Events, event
  thisEvent = TAG_NAMES(event, /STRUCTURE_NAME)
  
  ; Get the info structure
  WIDGET_CONTROL, event.top, GET_UVALUE=info, /NO_COPY
  
  ; extract the command object into a separate
  dgscmd=info.dgscmd
  
  WIDGET_CONTROL, event.id, GET_UVALUE=myUVALUE
  
  ; Check that we actually got something back in the UVALUE
  IF N_ELEMENTS(myUVALUE) EQ 0 THEN myUVALUE="NOTHING"
  
  CASE myUVALUE OF
    'INSTRUMENT_SELECTED': BEGIN
      dgscmd->SetProperty, Instrument=event.STR
    END
    'DGS_DATARUN': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      ;print, 'DGS_DATARUN'
      dgscmd->SetProperty, DataRun=myValue
    END
    'DGS_EI': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgscmd->SetProperty, Ei=myValue
    END
    'DGS_TZERO': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgscmd->SetProperty, Tzero=myValue      
    END
    'DGS_FINDNEXUS': BEGIN
      dgscmd->GetProperty, Instrument=instrument
      dgscmd->GetProperty, DataRun=run_number
      ; TODO: Sort out findnexus
      ;nxsfile = findnexus(RUN_NUMBER=run_number, INSTRUMENT=instrument)
    END
    'DGS_DATAPATHS_LOWER': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=lowerValue
      dgscmd->SetProperty, LowerBank=lowerValue
    END
    'DGS_DATAPATHS_UPPER': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=upperValue
      dgscmd->SetProperty, UpperBank=upperValue
    END
    'DGS_ROI_FILENAME': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      ; TODO: Check filename exists before setting the property!
      dgscmd->SetProperty, ROIfile=myValue
    END
    'DGS_MASK_FILENAME': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      ; TODO: Check filename exists before setting the property!
      dgscmd->SetProperty, MaskFile=myValue
    END
    'DGS_MAKE_SPE': BEGIN
      dgscmd->SetProperty, SPE=event.SELECT
    END
    'DGS_MAKE_QVECTOR': BEGIN
      dgscmd->SetProperty, Qvector=event.SELECT
      fixedGrid_ID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGS_MAKE_FIXED')
      ; Make the Fixed Grid output selection active if Qvector is selected.
      WIDGET_CONTROL, fixedGrid_ID, SENSITIVE=event.SELECT
    END
    'DGS_MAKE_FIXED': BEGIN
      dgscmd->SetProperty, Fixed=event.SELECT
    END
    'DGS_MAKE_COMBINED_ET': BEGIN
      dgscmd->SetProperty, DumpEt=event.SELECT
    END
    'DGS_MAKE_COMBINED_TOF': BEGIN
      dgscmd->SetProperty, DumpTOF=event.SELECT
    END
    'DGS_MAKE_COMBINED_WAVE': BEGIN
      dgscmd->SetProperty, DumpWave=event.SELECT
      ; Also make the wavelength range fields active (or inactive!)
      wavelengthRange_ID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGS_COMBINED_WAVELENGTH_RANGE')
      WIDGET_CONTROL, wavelengthRange_ID, SENSITIVE=event.SELECT
    END
    'DGS_DUMP_NORM': BEGIN
      dgscmd->SetProperty, DumpNorm=event.SELECT
    END
    'DGS_ET_MIN': BEGIN
      ; Minimum Energy Transfer
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgscmd->SetProperty, EnergyBins_Min=myValue
    END
    'DGS_ET_MAX': BEGIN
      ; Maximum Energy Transfer
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgscmd->SetProperty, EnergyBins_Max=myValue
    END
    'DGS_ET_STEP': BEGIN
      ; Energy Transfer Step size
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgscmd->SetProperty, EnergyBins_Step=myValue
    END
    'DGS_LAMBDA_MIN': BEGIN
      ; Minimum Wavelength
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgscmd->SetProperty, LambdaBins_Min=myValue
    END
    'DGS_LAMBDA_MAX': BEGIN
      ; Maximum Wavelength
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgscmd->SetProperty, LambdaBins_Max=myValue
    END
    'DGS_LAMBDA_STEP': BEGIN
      ; Wavelength Step size
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgscmd->SetProperty, LambdaBins_Step=myValue
    END
    'DGS_Q_MIN': BEGIN
      ; Minimum Q
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgscmd->SetProperty, QBins_Min=myValue
    END
    'DGS_Q_MAX': BEGIN
      ; Maximum Q
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgscmd->SetProperty, QBins_Max=myValue
    END
    'DGS_Q_STEP': BEGIN
      ; Q Step size
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgscmd->SetProperty, QBins_Step=myValue
    END
    'DGS_NO-MON-NORM': BEGIN
      dgscmd->SetProperty, NoMonitorNorm=event.SELECT
      ; Also make the Proton Charge Norm active
      pcnorm_ID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGS_PC-NORM')
      WIDGET_CONTROL, pcnorm_ID, SENSITIVE=event.SELECT
    END
    'DGS_PC-NORM': BEGIN
      dgscmd->SetProperty, PCnorm=event.SELECT
    END
    'DGS_LAMBDA-RATIO': BEGIN
      dgscmd->SetProperty, LambdaRatio=event.SELECT
    END
    'DGS_USMON': BEGIN
      ; Upstream Monitor Number (usualy 1)
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgscmd->SetProperty, USmonPath=STRCOMPRESS(myValue, /REMOVE_ALL)
    END
    'DGS_NORM': BEGIN
      ; Norm Filename
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgscmd->SetProperty, Normalisation=myValue      
    END    
    'DGS_EMPTYCAN': BEGIN
      ; Empty Can Filename
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgscmd->SetProperty, EmptyCan=myValue      
    END    
    'DGS_BLACKCAN': BEGIN
      ; Black Can Filename
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgscmd->SetProperty, BlackCan=myValue      
    END    
    'DGS_DARK': BEGIN
      ; Dark Current Filename
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgscmd->SetProperty, Dark=myValue      
    END
    'DGS_TIBCONST': BEGIN
      ; Time Independent Background Constant
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgscmd->SetProperty, TIBconst=myValue
    END
    'DGS_NORM-INT-MIN': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgscmd->SetProperty, NormRange_Min=myValue
    END
    'DGS_NORM-INT-MAX': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgscmd->SetProperty, NormRange_Max=myValue
    END
    'DGS_MON-INT-MIN': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgscmd->SetProperty, MonRange_Min=myValue
    END
    'DGS_MON-INT-MAX': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgscmd->SetProperty, MonRange_Max=myValue
    END
    'DGS_TOF-CUT-MIN': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgscmd->SetProperty, Tmin=myValue
    END
    'DGS_TOF-CUT-MAX': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgscmd->SetProperty, Tmax=myValue
    END
    'DGS_JOBS': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      if (myValue NE "") AND (myValue GT 0) AND (myValue LT info.max_jobs) then begin
        dgscmd->SetProperty, Jobs=myValue
        ; If we are doing more than 1 job, we also need to set the --split option
        IF (myValue GT 1) THEN dgscmd->SetProperty, Split=1
        ; But if we are only doing 1 then we don't!
        IF (myValue EQ 1) THEN dgscmd->SetProperty, Split=0
      endif
    END
    'NOTHING': BEGIN
    END
  ENDCASE
  
  ; Update the output command window
  WIDGET_CONTROL, info.outputID, SET_VALUE=dgscmd->generate()
  
  ; Put info back
  WIDGET_CONTROL, event.top, SET_UVALUE=info, /NO_COPY
  
  
  IF thisEvent EQ 'WIDGET_BASE' THEN BEGIN
    ; Get the info structure and copy it here
    WIDGET_CONTROL, event.top, GET_UVALUE=info, /NO_COPY
    
    ;TODO: Logic for resizing
    
    ; Put info back
    WIDGET_CONTROL, event.top, SET_UVALUE=info, /NO_COPY
  ENDIF
  
  IF thisEvent EQ 'WIDGET_KBRD_FOCUS' THEN BEGIN
    ; if losing focus - do nowt
    IF event.enter EQ 0 THEN RETURN
    
    ; Get the info structure and copy it here
    WIDGET_CONTROL, event.top, GET_UVALUE=info, /NO_COPY
    
    ;TODO: Logic for keyboard events
    
    ; Put info back
    WIDGET_CONTROL, event.top, SET_UVALUE=info, /NO_COPY
    
  ENDIF
  
END

;---------------------------------------------------------

PRO DGSreduction_Cleanup, tlb
  WIDGET_CONTROL, tlb, GET_UVALUE=info, /NO_COPY
  IF N_ELEMENTS(info) EQ 0 THEN RETURN
  
  ; Free up the pointers
  ;  PTR_FREE, info.dgscmd
  PTR_FREE, info.extra
END

;---------------------------------------------------------

PRO DGSreduction, dgscmd, _Extra=extra

  ; Program Details
  APPLICATION       = 'DGSreduction'
  VERSION           = '0.0.1'
  
  Catch, errorStatus
  
  ; Error handler
  if (errorStatus ne 0) then begin
    Catch, /CANCEL
    ok = ERROR_MESSAGE(TRACEBACK=1)
  endif
  
  ; Get the UCAMS
  ucams = GETENV('USER')
  
  ; Set the application title
  title = APPLICATION + ' (' + VERSION + ') as ' + ucams
  
  IF N_ELEMENTS(dgscmd) EQ 0 THEN dgscmd = OBJ_NEW("ReductionCMD")
  
  ; Define the TLB.
  tlb = WIDGET_BASE(COLUMN=1, TITLE=title, /FRAME)
  
  toprow = WIDGET_BASE(tlb, /ROW)
  textID = WIDGET_LABEL(toprow, VALUE='Please select an instrument --> ')
  instrumentID = WIDGET_COMBOBOX(toprow, UVALUE="INSTRUMENT_SELECTED", VALUE=[' ','ARCS','CNCS','SEQUOIA'], XSIZE=90)
  
  ; Tabs
  tabID = WIDGET_TAB(tlb)
  
  ; Reduction Tab
  reductionTabBase = WIDGET_BASE(tabID, Title='Reduction', COLUMN=2)
  
  reductionTabRow1 = WIDGET_BASE(reductionTabBase, /ROW)
  reductionTabRow2 = WIDGET_BASE(reductionTabBase, /ROW)
  
  dataSourceBase = WIDGET_BASE(reductionTabRow1)
  dataSourceLabel = WIDGET_LABEL(dataSourceBase, VALUE=' Run Number ', XOFFSET=5)
  dataSourceLabelGeometry = WIDGET_INFO(dataSourceLabel, /GEOMETRY)
  dataSourceLabelGeometryYSize = dataSourceLabelGeometry.ysize
  dataSourcePrettyBase = WIDGET_BASE(dataSourceBase, /FRAME, /COLUMN, $
        YOFFSET=dataSourceLabelGeometryYSize/2, YPAD=10, XPAD=10)
  
  dataSourceRow = WIDGET_BASE(dataSourcePrettyBase, /ROW)
  runID= CW_FIELD(dataSourceRow, xsize=30, ysize=1, TITLE="", UVALUE="DGS_DATARUN", /ALL_EVENTS)
  findNexusButton = WIDGET_BUTTON(dataSourceRow, VALUE="Find File", UVALUE="DGS_FINDNEXUS", SENSITIVE=0)

  detectorBankBase = WIDGET_BASE(reductionTabRow1)
  detectorBankLabel = WIDGET_LABEL(detectorBankBase, VALUE=' Detector Banks ', XOFFSET=5)
  detectorBankLabelGeometry = WIDGET_INFO(detectorBankLabel, /GEOMETRY)
  detectorBankLabelYSize = detectorBankLabelGeometry.ysize
  detectorBankPrettyBase = WIDGET_BASE(detectorBankBase, /FRAME, /COLUMN, $
        YOFFSET=detectorBankLabelYSize/2, YPAD=10, XPAD=10)
  
  detectorBankRow = WIDGET_BASE(detectorBankPrettyBase, /ROW)
  lbankID = CW_FIELD(detectorBankRow, XSIZE=15, /ALL_EVENTS, TITLE="", UVALUE="DGS_DATAPATHS_LOWER" ,/INTEGER)
  ubankID = CW_FIELD(detectorBankRow, XSIZE=15, /ALL_EVENTS, TITLE=" --> ", UVALUE="DGS_DATAPATHS_UPPER", /INTEGER)  
  
  
  eiBase = WIDGET_BASE(reductionTabRow1)
  eiLabel = WIDGET_LABEL(eiBase, Value=' Ei (meV) ', XOFFSET=5)
  eiLabelGeomtry = WIDGET_INFO(eiLabel, /GEOMETRY)
  eiLabelGeomtryYSize = eiLabelGeomtry.ysize
  eiPrettyBase = WIDGET_BASE(eiBase, /FRAME, /COLUMN, $
        YOFFSET=eiLabelGeomtryYSize/2, XPAD=10, YPAD=10)
  eiRow = WIDGET_BASE(eiPrettyBase, /ROW)
  eiID = CW_FIELD(eiRow, TITLE="", UVALUE="DGS_EI", /ALL_EVENTS)

  tzeroBase = WIDGET_BASE(reductionTabBase)
  tzeroLabel = WIDGET_LABEL(tzeroBase, Value=' T0 (usec) ', XOFFSET=5)
  tzeroLabelGeomtry = WIDGET_INFO(tzeroLabel, /GEOMETRY)
  tzeroLabelGeomtryYSize = tzeroLabelGeomtry.ysize
  tzeroPrettyBase = WIDGET_BASE(tzeroBase, /FRAME, /COLUMN, $
        YOFFSET=tzeroLabelGeomtryYSize/2, XPAD=10, YPAD=10)
  tzeroID = CW_FIELD(tzeroPrettyBase, TITLE="", UVALUE="DGS_TZERO", /ALL_EVENTS)

  tofcutBase = WIDGET_BASE(reductionTabBase)
  tofcutLabel = WIDGET_LABEL(tofcutBase, Value=' TOF Spectrum Cutting ', XOFFSET=5)
  tofcutLabelGeomtry = WIDGET_INFO(tofcutLabel, /GEOMETRY)
  tofcutLabelGeomtryYSize = tofcutLabelGeomtry.ysize
  tofcutPrettyBase = WIDGET_BASE(tofcutBase, /FRAME, /COLUMN, $
        YOFFSET=tofcutLabelGeomtryYSize/2, XPAD=10, YPAD=10)
  tofcutRow = WIDGET_BASE(tofcutPrettyBase, /ROW)
  tofcutminID = CW_FIELD(tofcutRow, TITLE="Min:", UVALUE="DGS_TOF-CUT-MIN", /ALL_EVENTS)
  tofcutmaxID = CW_FIELD(tofcutRow, TITLE="Max:", UVALUE="DGS_TOF-CUT-MAX", /ALL_EVENTS)
  

  normBase = WIDGET_BASE(reductionTabRow2)
  normLabel = WIDGET_LABEL(normBase, VALUE=' Normalisation ', XOFFSET=5)
  normLabelGeometry = WIDGET_INFO(normLabel, /GEOMETRY)
  normLabelGeometryYSize = normLabelGeometry.ysize
  normPrettyBase = WIDGET_BASE(normBase, /FRAME, COLUMN=2, $
        YOFFSET=normLabelGeometryYSize/2, XPAD=10, YPAD=10)
  
  normOptionsBaseColumn1 = WIDGET_BASE(normPrettyBase, /COLUMN)

  normOptionsBaseColumn2 = WIDGET_BASE(normPrettyBase, /COLUMN)
  
  
  normOptionsBase = WIDGET_BASE(normOptionsBaseColumn1, /NONEXCLUSIVE)
  noMon_Button = WIDGET_BUTTON(normOptionsBase, VALUE='No Monitor Normalisation', $
        UVALUE='DGS_NO-MON-NORM')
  pc_button = WIDGET_BUTTON(normOptionsBase, VALUE='Proton Charge Normalisation', $
        UVALUE='DGS_PC-NORM', UNAME='DGS_PC-NORM')
  lambdaratioID = WIDGET_BUTTON(normOptionsBase, VALUE='Lambda Ratio Scaling', $ 
        UVALUE='DGS_LAMBDA-RATIO')
  
  monitorNumberID = CW_FIELD(normOptionsBaseColumn1, TITLE="Monitor Number:", UVALUE="DGS_USMON", VALUE=1, /INTEGER, /ALL_EVENTS, XSIZE=5)
  ; Also set the default monitor in the ReductionCmd Class
  dgscmd->SetProperty, USmonPath=1
  
  ; Normalisation Files
  normFilesBase = WIDGET_BASE(normOptionsBaseColumn2, /COLUMN)
  normFileID = CW_FIELD(normFilesBase, XSIZE=30, /ALL_EVENTS,     TITLE="Normalisation:", UVALUE="DGS_NORM")
  emptycanFileID = CW_FIELD(normFilesBase, XSIZE=30, /ALL_EVENTS, TITLE="    Empty Can:", UVALUE="DGS_EMPTYCAN")
  blackcanFileID = CW_FIELD(normFilesBase, XSIZE=30, /ALL_EVENTS, TITLE="    Black Can:", UVALUE="DGS_BLACKCAN")
  darkFileID = CW_FIELD(normFilesBase, XSIZE=30, /ALL_EVENTS,     TITLE=" Dark Current:", UVALUE="DGS_DARK")

  TIBconstID = CW_FIELD(normOptionsBaseColumn2, XSIZE=21, TITLE=" Time Independent Bkgrd:", UVALUE="DGS_TIBCONST", /ALL_EVENTS)

  
  ; Monitor integration range
  monitorRangeBase = WIDGET_BASE(normOptionsBaseColumn1, /ALIGN_BOTTOM)
  monitorRangeBaseLabel = WIDGET_LABEL(monitorRangeBase, VALUE=' Monitor Integration Range (usec) ', XOFFSET=5)
  monitorRangeBaseLabelGeometry = WIDGET_INFO(monitorRangeBaseLabel, /GEOMETRY)
  monitorRangeBaseLabelGeometryYSize = monitorRangeBaseLabelGeometry.ysize
  monitorRangePrettyBase = WIDGET_BASE(monitorRangeBase, /FRAME, /ROW, $
      YOFFSET=monitorRangeBaseLabelGeometryYSize/2, XPAD=10, YPAD=10)
  
  monMinID = CW_FIELD(monitorRangePrettyBase, /ALL_EVENTS, TITLE="Min:", UVALUE="DGS_MON-INT-MIN")
  monMaxID = CW_FIELD(monitorRangePrettyBase, /ALL_EVENTS, TITLE="Max:", UVALUE="DGS_MON-INT-MAX")
  
   ; Norm integration range
  normRangeBase = WIDGET_BASE(normOptionsBaseColumn1, UNAME="DGS_NORM-INT-RANGE", /ALIGN_BOTTOM)
  normRangeBaseLabel = WIDGET_LABEL(normRangeBase, VALUE=' Normalisation Integration Range (meV) ', XOFFSET=5)
  normRangeBaseLabelGeometry = WIDGET_INFO(normRangeBaseLabel, /GEOMETRY)
  normRangeBaseLabelGeometryYSize = normRangeBaseLabelGeometry.ysize
  normRangePrettyBase = WIDGET_BASE(normRangeBase, /FRAME, /ROW, $
      YOFFSET=normRangeBaseLabelGeometryYSize/2, XPAD=10, YPAD=10)
  
  normMinID = CW_FIELD(normRangePrettyBase, /ALL_EVENTS, TITLE="Min:", UVALUE="DGS_NORM-INT-MIN")
  normMaxID = CW_FIELD(normRangePrettyBase, /ALL_EVENTS, TITLE="Max:", UVALUE="DGS_NORM-INT-MAX")
            
  
  ; Disable some of the inputs until something has been defined in the DGS_NORM field.
  WIDGET_CONTROL, normRangeBase, SENSITIVE=0
  
  ; Disable Proton Charge Norm until No-Monitor Norm is selected
  WIDGET_CONTROL, pc_button, SENSITIVE=0
    
  ; ROI
  roiBase = WIDGET_BASE(reductionTabBase)
  roiLabel = WIDGET_LABEL(roiBase, VALUE=' Region-of-Interest ', XOFFSET=5)
  roiLabelGeometry = WIDGET_INFO(roiLabel, /GEOMETRY)
  roiLabelYSize = roiLabelGeometry.ysize
  roiPrettyBase = WIDGET_BASE(roiBase, /FRAME, /COLUMN, $
        YOFFSET=roiLabelYSize/2, YPAD=10, XPAD=10)
  roiRow = WIDGET_BASE(roiPrettyBase, /ROW)
  roiFileID = CW_FIELD(roiRow, TITLE='Filename:', UVALUE='DGS_ROI_FILENAME', /ALL_EVENTS)
  
    jobBase = WIDGET_BASE(reductionTabBase)
  jobLabel = WIDGET_LABEL(jobBase, VALUE=' Job Submission ', XOFFSET=5)
  jobLabelGeometry = WIDGET_INFO(jobLabel, /GEOMETRY)
  jobLabelGeometryYSize = jobLabelGeometry.ysize
  jobPrettyBase = WIDGET_BASE(jobBase, /FRAME, /COLUMN, $
        YOFFSET=jobLabelGeometryYSize/2, XPAD=10, YPAD=10)
  jobID = CW_FIELD(jobPrettyBase, TITLE="No. of Jobs:", UVALUE="DGS_JOBS", $
        VALUE=1, /INTEGER, /ALL_EVENTS)
  
   ; Mask File
  maskBase = WIDGET_BASE(reductionTabBase)
  maskLabel = WIDGET_LABEL(maskBase, VALUE=' Mask ', XOFFSET=5)
  maskLabelGeometry = WIDGET_INFO(maskLabel, /GEOMETRY)
  maskLabelYSize = maskLabelGeometry.ysize
  maskPrettyBase = WIDGET_BASE(maskBase, /FRAME, /COLUMN, $
        YOFFSET=maskLabelYSize/2, YPAD=10, XPAD=10)
  
  maskRow = WIDGET_BASE(maskPrettyBase, /ROW)
  maskFileID = CW_FIELD(maskRow, TITLE='Filename:', UVALUE='DGS_MASK_FILENAME', /ALL_EVENTS)
  
  rangesBase = WIDGET_BASE(reductionTabBase)
  rangesLabel = WIDGET_LABEL(rangesBase, value=' Energy Transfer Range (meV) ', XOFFSET=5)
  rangesLabelGeometry = WIDGET_INFO(rangesLabel, /GEOMETRY)
  rangesLabelYSize = rangesLabelGeometry.ysize
  rangesPrettyBase = WIDGET_BASE(rangesBase, /FRAME, /COLUMN, $
        YOFFSET=rangesLabelYSize/2, YPAD=10, XPAD=10)
   
  ; Energy Transfer Range Row
  EnergyRangeRow = WIDGET_BASE(rangesPrettyBase, /ROW, UNAME="DGS_ET_RANGE")
  minEnergyID = CW_FIELD(EnergyRangeRow, TITLE="Min:", $
        XSIZE=8, UVALUE="DGS_ET_MIN", /ALL_EVENTS)
  maxEnergyID = CW_FIELD(EnergyRangeRow, TITLE="Max:", $
        XSIZE=8, UVALUE="DGS_ET_MAX", /ALL_EVENTS)
  stepEnergyID = CW_FIELD(EnergyRangeRow, TITLE="Step:", $
        XSIZE=8, UVALUE="DGS_ET_STEP", /ALL_EVENTS)

  QrangesBase = WIDGET_BASE(reductionTabBase)
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
   
  
  row3 = widget_base(reductionTabBase, COLUMN=1)
  
  
  
  ; Output Formats Pretty Frame
  formatBase = WIDGET_BASE(row3)
  formatLabel = WIDGET_LABEL(formatBase, value=' Output Formats ', XOFFSET=5)
  formatLabelGeometry = WIDGET_INFO(formatLabel, /GEOMETRY)
  formatLabelYSize = formatLabelGeometry.ysize
  ; Output Formats Selection Boxes
  outputBase = Widget_Base(formatBase, COLUMN=2,  /FRAME, $
    YOFFSET=formatLabelYSize/2, YPAD=10, XPAD=10, /NONEXCLUSIVE)
  speButton = Widget_Button(outputBase, Value='SPE/PHX', UVALUE='DGS_MAKE_SPE')
  qvectorButton = Widget_Button(outputBase, Value='Qvector', UVALUE='DGS_MAKE_QVECTOR')
  fixedButton = Widget_Button(outputBase, Value='Fixed Grid', UVALUE='DGS_MAKE_FIXED', UNAME='DGS_MAKE_FIXED')
  etButton = Widget_Button(outputBase, Value='Combined Energy Transfer', UVALUE='DGS_MAKE_COMBINED_ET')
  tofButton = Widget_Button(outputBase, Value='Combined Time-of-Flight', UVALUE='DGS_MAKE_COMBINED_TOF')
  waveButton = Widget_Button(outputBase, Value='Combined Wavelength', UVALUE='DGS_MAKE_COMBINED_WAVE')
  normButton = Widget_Button(outputBase, Value='Vanadium Normalisation', UVALUE='DGS_DUMP_NORM')
  
  
  ; Output Options Pretty Frame
  formatOptionsBase = WIDGET_BASE(row3)
  formatOptionsLabel = WIDGET_LABEL(formatOptionsBase, value=' Output Options ', XOFFSET=5)
  formatOptionsLabelGeometry = WIDGET_INFO(formatOptionsLabel, /GEOMETRY)
  formatOptionsPrettyBase = Widget_Base(formatOptionsBase, COLUMN=1, Scr_XSize=400, /FRAME, $
    YOFFSET=formatLabelYSize/2, YPAD=10, XPAD=10)

  ; Combined Wavelength Range Base
  formatOptionsPrettyBaseWavelengthRow = WIDGET_BASE(formatOptionsPrettyBase, /ROW, UNAME="DGS_COMBINED_WAVELENGTH_RANGE")
  minWavelengthID = CW_FIELD(formatOptionsPrettyBaseWavelengthRow, TITLE="Wavelength Min:", $
        XSIZE=8, UVALUE="DGS_LAMBDA_MIN", /ALL_EVENTS)
  maxWavelengthID = CW_FIELD(formatOptionsPrettyBaseWavelengthRow, TITLE="Max:", $
        XSIZE=8, UVALUE="DGS_LAMBDA_MAX", /ALL_EVENTS)
  stepWavelengthID = CW_FIELD(formatOptionsPrettyBaseWavelengthRow, TITLE="Step:", $
        XSIZE=8, UVALUE="DGS_LAMBDA_STEP", /ALL_EVENTS)
  
  
  ; Set the default(s) as on - to match the defaults in the ReductionCMD class.
  Widget_Control, speButton, SET_BUTTON=1

  
  ; Cannot have the fixed grid without the Qvector
  WIDGET_CONTROL, fixedButton, SENSITIVE=0
  
  ; Don't enable wavelength range until it's selected.
  WIDGET_CONTROL, formatOptionsPrettyBaseWavelengthRow, SENSITIVE=0
 
  ; normalisation tab
  normID = WIDGET_BASE(tabID, Title='Normalisation')
  label = WIDGET_LABEL(normID, VALUE="Nothing to see here!")
  
  utilsID = WIDGET_BASE(tabID, Title='Utilities')
  label = WIDGET_LABEL(utilsID, VALUE="Nothing to see here!")
  
  textID = WIDGET_LABEL(tlb, VALUE='Command to execute:', /ALIGN_LEFT)
  outputID= WIDGET_TEXT(tlb, /EDITABLE, xsize=80, ysize=10, /SCROLL, /WRAP, $
    VALUE=dgscmd->generate())
    
    
    
  wMainButtons = WIDGET_BASE(tlb, /ROW)
  ; Define a Run button
  executeID = WIDGET_BUTTON(wMainButtons, Value='Execute', EVENT_PRO='DGSreduction_Execute')
  ; Define a Quit button
  quitID = WIDGET_BUTTON(wMainButtons, Value='Quit', EVENT_PRO='DGSreduction_Quit', /ALIGN_RIGHT)
  
  ; Realise the widget hierarchy
  WIDGET_CONTROL, tlb, /REALIZE
  
  info = { dgscmd:dgscmd, $
    application:application, $
    version:version, $
    max_jobs:1000, $  ; Max No. of jobs (to stop a large -ve Integer becoming a valid number in the input box!)
    ucams:ucams, $
    title:title, $
    outputID:outputID, $
    lbankID:lbankID, $
    ubankID:ubankID, $
    extra:ptr_new(extra) $
    }
    
  ; Store the info structure in the user value of the TLB.  Turn keyboard focus events on.
  WIDGET_CONTROL, tlb, SET_UVALUE=info, /NO_COPY, /KBRD_FOCUS_EVENTS
  
  ; Setup the event loop and register the application with the window manager.
  XMANAGER, 'dgsredction', tlb, EVENT_HANDLER='DGSreduction_TLB_Events', $
    /NO_BLOCK, CLEANUP='DGSreduction_Cleanup', GROUP_LEADER=group_leader
    
END