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

;+
; :Description:
;    Sets the DataRun property of the command object
;
; :Params:
;    event
;
; :Author: scu
;-
FUNCTION DGSreduction_dgs_DataRun, event

    ; Get the info structure and copy it here
    WIDGET_CONTROL, event.top, GET_UVALUE=info, /NO_COPY

    WIDGET_CONTROL, event.ID, GET_VALUE=val

    dgscmd=info.dgscmd
    dgscmd->SetProperty, DataRun=val
    
    ; Update the command window.
    WIDGET_CONTROL, info.outputID, SET_VALUE=dgscmd->generate()

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
  tlb = WIDGET_BASE(COLUMN=1, TITLE=title)
  
  
  
  ; Define a Quit button
  quitID = WIDGET_BUTTON(tlb, Value='Quit', EVENT_PRO='DGSreduction_Quit')
  
  ; Tabs
  tabID = WIDGET_TAB(tlb)
  
  ; Reduction Tab
  reductionID = WIDGET_BASE(tabID, Title='Reduction')
  runID= WIDGET_TEXT(reductionID, /EDITABLE, EVENT_PRO='DGSreduction_dgs_DataRun')
  
  ; normalisation tab
  normID = WIDGET_BASE(tabID, Title='Normalisation')
  label = WIDGET_LABEL(normID, VALUE="Nothing to see here!")
  
  utilsID = WIDGET_BASE(tabID, Title='Utilities')
  label = WIDGET_LABEL(utilsID, VALUE="Nothing to see here!")
  
  outputID= WIDGET_TEXT(tlb, /EDITABLE, VALUE=dgscmd->generate())
  
  ; Realise the widget hierarchy
  WIDGET_CONTROL, tlb, /REALIZE
  
  info = { dgscmd:dgscmd, $
    ucams:ucams, $
    title:title, $
    outputID:outputID, $
    extra:ptr_new(extra) $
    }
    
  ; Store the info structure in the user value of the TLB.  Turn keyboard focus events on.
  WIDGET_CONTROL, tlb, SET_UVALUE=info, /NO_COPY, /KBRD_FOCUS_EVENTS
  
  ; Setup the event loop and register the application with the window manager.
  XMANAGER, 'dgsredction', tlb, EVENT_HANDLER='DGSreduction_TLB_Events', $
    /NO_BLOCK, CLEANUP='DGSreduction_Cleanup', GROUP_LEADER=group_leader
    
END