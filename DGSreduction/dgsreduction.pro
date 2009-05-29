;+
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
    'DGS_DATAPATHS_LOWER': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=lowerValue
      dgscmd->SetProperty, LowerBank=lowerValue
    END
    'DGS_DATAPATHS_UPPER': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=upperValue
      dgscmd->SetProperty, UpperBank=upperValue
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
      print, 'DGS_ET_MIN'
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
      print, 'DGS_LAMBDA_MIN'
    END
    'DGS_LAMBDA_MAX': BEGIN
      ; Maximum Wavelength
      print, 'DGS_LAMBDA_MAX'
    END
    'DGS_LAMBDA_STEP': BEGIN
      ; Wavelength Step size
      print, 'DGS_LAMBDA_STEP'
    END
    'DGS_Q_MIN': BEGIN
      ; Minimum Q
      print, 'DGS_Q_MIN'
    END
    'DGS_Q_MAX': BEGIN
      ; Maximum Q
      print, 'DGS_Q_MAX'
    END
    'DGS_Q_STEP': BEGIN
      ; Q Step size
      print, 'DGS_Q_STEP'
    END
    'DGS_JOBS': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      if (myValue ne "") AND (myValue GT 0) AND (myValue LT info.max_jobs) then begin
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
  reductionTLB = WIDGET_BASE(tabID, Title='Reduction',/COLUMN)
  
  row1 = widget_base(reductionTLB, /ROW)
  runID= CW_FIELD(row1, xsize=30, ysize=1, TITLE="Run Number:", UVALUE="DGS_DATARUN", /ALL_EVENTS)
  jobID = CW_FIELD(row1, TITLE="        No. of Jobs:", UVALUE="DGS_JOBS", VALUE=1, /INTEGER, /ALL_EVENTS)
  
  row2 = widget_base(reductionTLB, /ROW)
  lbankID = CW_FIELD(row2, /ALL_EVENTS, TITLE="Detector Banks from", UVALUE="DGS_DATAPATHS_LOWER" ,/INTEGER)
  ubankID = CW_FIELD(row2, /ALL_EVENTS, TITLE=" to ", UVALUE="DGS_DATAPATHS_UPPER", /INTEGER)
  
  row3 = widget_base(reductionTLB, /ROW)
  
  ; Output Formats Pretty Frame
  formatBase = WIDGET_BASE(row3)
  formatLabel = WIDGET_LABEL(formatBase, value=' Output Formats ', XOFFSET=5)
  formatLabelGeometry = WIDGET_INFO(formatLabel, /GEOMETRY)
  formatLabelYSize = formatLabelGeometry.ysize
  ; Output Formats Selection Boxes
  outputBase = Widget_Base(formatBase, COLUMN=1, Scr_XSize=225, /FRAME, $
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
  
  ; Energy Transfer Range Base
  formatOptionsPrettyBaseEnergyRow = WIDGET_BASE(formatOptionsPrettyBase, /ROW, UNAME="DGS_ET_RANGE")
  minEnergyID = CW_FIELD(formatOptionsPrettyBaseEnergyRow, TITLE="Energy Min:", $
        XSIZE=8, UVALUE="DGS_ET_MIN", /ALL_EVENTS)
  maxEnergyID = CW_FIELD(formatOptionsPrettyBaseEnergyRow, TITLE="Max:", $
        XSIZE=8, UVALUE="DGS_ET_MAX", /ALL_EVENTS)
  stepEnergyID = CW_FIELD(formatOptionsPrettyBaseEnergyRow, TITLE="Step:", $
        XSIZE=8, UVALUE="DGS_ET_STEP", /ALL_EVENTS)

  ; Q Range Base
  formatOptionsPrettyBaseQRow = WIDGET_BASE(formatOptionsPrettyBase, /ROW, UNAME="DGS_Q_RANGE")
  minMomentumID = CW_FIELD(formatOptionsPrettyBaseQRow, TITLE="Q Min:", $
        XSIZE=8, UVALUE="DGS_Q_MIN")
  maxMomentumID = CW_FIELD(formatOptionsPrettyBaseQRow, TITLE="Max:", $
        XSIZE=8, UVALUE="DGS_Q_MAX")
  stepMomentumID = CW_FIELD(formatOptionsPrettyBaseQRow, TITLE="Step:", $
        XSIZE=8, UVALUE="DGS_Q_STEP")

  ; Combined Wavelength Range Base
  formatOptionsPrettyBaseWavelengthRow = WIDGET_BASE(formatOptionsPrettyBase, /ROW, UNAME="DGS_COMBINED_WAVELENGTH_RANGE")
  minWavelengthID = CW_FIELD(formatOptionsPrettyBaseWavelengthRow, TITLE="Wavelength Min:", $
        XSIZE=8, UVALUE="DGS_LAMBDA_MIN")
  maxWavelengthID = CW_FIELD(formatOptionsPrettyBaseWavelengthRow, TITLE="Max:", $
        XSIZE=8, UVALUE="DGS_LAMBDA_MAX")
  stepWavelengthID = CW_FIELD(formatOptionsPrettyBaseWavelengthRow, TITLE="Step:", $
        XSIZE=8, UVALUE="DGS_LAMBDA_STEP")
  
  
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
    max_jobs:1000, $  ; Maximum number of jobs (to stop a large -ve Integer becoming a valid number in the input box!)
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