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
  ; Get the info structure and copy it here
  WIDGET_CONTROL, event.top, GET_UVALUE=info, /NO_COPY
  dgscmd = info.dgscmd
  
  ; Do some sanity checking.
  
  ; First lets check that an instrument has been selected!
  dgscmd->GetProperty, Instrument=instrument
  IF (STRLEN(instrument) LT 2) THEN ok=ERROR_MESSAGE("Please select an Instrument from the list.")
  
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
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
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
    ; Also make the
    END
    'DGS_JOBS': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      if (myValue ne "") OR (myValue ne 0) then begin
        dgscmd->SetProperty, Jobs=myValue
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
  jobID = CW_FIELD(row1, TITLE="No. of Jobs:", UVALUE="DGS_JOBS", VALUE=1, /INTEGER, /ALL_EVENTS)
  
  row2 = widget_base(reductionTLB, /ROW)
  lbankID = CW_FIELD(row2, /ALL_EVENTS, TITLE="Detector Banks from", UVALUE="DGS_DATAPATHS_LOWER" ,/INTEGER)
  ubankID = CW_FIELD(row2, /ALL_EVENTS, TITLE=" to ", UVALUE="DGS_DATAPATHS_UPPER", /INTEGER)
  
  row3 = widget_base(reductionTLB, /ROW)
  
  
  formatsBase = WIDGET_BASE(reductionTLB)
  formatsLabel = WIDGET_LABEL(formatsBase, value=' Output Formats ', XOFFSET=5)
  formatsLabelGeometry = WIDGET_INFO(formatsLabel, /GEOMETRY)
  formatsLabelYSize = formatsLabelGeometry.ysize
  outputBase = Widget_Base(formatsBase, COLUMN=1, Scr_XSize=400, /FRAME, $
    YOFFSET=formatsLabelYSize/2, YPAD=10, XPAD=10, SCR_YSIZE=500)
  outputTLB = WIDGET_BASE(outputBase, /NONEXCLUSIVE)
  speButton = Widget_Button(outputTLB, Value='SPE/PHX', UVALUE='DGS_MAKE_SPE')
  qvectorButton = Widget_Button(outputTLB, Value='Qvector', UVALUE='DGS_MAKE_QVECTOR')
  fixedButton = Widget_Button(outputTLB, Value='Fixed Grid', UVALUE='DGS_MAKE_FIXED', UNAME='DGS_MAKE_FIXED')
  etButton = Widget_Button(outputTLB, Value='Combined Energy Transfer', UVALUE='DGS_MAKE_COMBINED_ET')
  tofButton = Widget_Button(outputTLB, Value='Combined Time-of-Flight', UVALUE='DGS_MAKE_COMBINED_TOF')
  waveButton = Widget_Button(outputTLB, Value='Combined Wavelength', UVALUE='DGS_MAKE_COMBINED_WAVE')
  
  ;minWavelengthID = CW_FIELD(waveBase, TITLE="Min:", XSIZE=10)
  ;maxWavelengthID = CW_FIELD(waveBase, TITLE="Max:", XSIZE=10)
  
  ; Set the default(s) as on - to match the defaults in the ReductionCMD class.
  Widget_Control, speButton, SET_BUTTON=1
  
  ; Cannot have the fixed grid without the Qvector
  WIDGET_CONTROL, fixedButton, SENSITIVE=0
  
  ;WIDGET_CONTROL, wavebase, SENSITIVE=0
 
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
    ucams:ucams, $
    title:title, $
    outputID:outputID, $
    lbankID:lbankID, $
    ubankID:ubankID, $
    fixedButton:fixedButton, $
    extra:ptr_new(extra) $
    }
    
  ; Store the info structure in the user value of the TLB.  Turn keyboard focus events on.
  WIDGET_CONTROL, tlb, SET_UVALUE=info, /NO_COPY, /KBRD_FOCUS_EVENTS
  
  ; Setup the event loop and register the application with the window manager.
  XMANAGER, 'dgsredction', tlb, EVENT_HANDLER='DGSreduction_TLB_Events', $
    /NO_BLOCK, CLEANUP='DGSreduction_Cleanup', GROUP_LEADER=group_leader
    
END