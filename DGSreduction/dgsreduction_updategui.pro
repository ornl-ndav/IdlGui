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

PRO DGSreduction_UpdateGUI, widgetBase

  ;print, '==UpdateGUI=='
  ;help,/str,event

  ; Get the info structure
  WIDGET_CONTROL, widgetBase, GET_UVALUE=info, /NO_COPY
  
  ; extract the command object into a separate
  dgsr_cmd = info.dgsr_cmd    ; ReductionCMD object
  
  ; === Update Common Stuff ===
  ; Instrument
  widget_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='INSTRUMENT_SELECTED')
  dgsr_cmd->GetProperty, Instrument=myValue
  
  ; Hack for SEQ
  IF (myValue EQ 'SEQ') THEN myValue = 'SEQUOIA'
  
  IF STRLEN(myValue) GT 1 THEN BEGIN
    WIDGET_CONTROL, widget_ID, GET_VALUE=instruments
    WIDGET_CONTROL, widget_ID, SET_COMBOBOX_SELECT=(WHERE(instruments EQ myValue))
  ENDIF
  
  ; Number of Jobs
  widget_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_REDUCTION_JOBS')
  dgsr_cmd->GetProperty, Jobs=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ;  IF (myValue GT 1) THEN BEGIN
  ;    dgsr_collector_button = WIDGET_INFO(widgetBase,FIND_BY_UNAME='DGSR_LAUNCH_COLLECTOR_BUTTON')
  ;    WIDGET_CONTROL, dgsr_collector_button, SENSITIVE=1
  ;    dgsn_collector_button = WIDGET_INFO(widgetBase,FIND_BY_UNAME='DGSN_LAUNCH_COLLECTOR_BUTTON')
  ;    WIDGET_CONTROL, dgsn_collector_button, SENSITIVE=1
  ;  ENDIF
  
  ; === Update the Reduction Tab ===
  DGSR_UpdateGUI, widgetBase, dgsr_cmd
  
  ; Get the value of the normlocation and set it in the command objects
  ;  widget_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_NORMLOC_INST_SHARED')
  ;  state = WIDGET_INFO(widget_ID, /BUTTON_SET)
  ;  IF (state EQ 1) THEN BEGIN
  ;    dgsr_cmd->SetProperty, NormLocation='INST'
  ;  ENDIF
  ;  widget_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_NORMLOC_PROP_SHARED')
  ;  state = WIDGET_INFO(widget_ID, /BUTTON_SET)
  ;  IF (state EQ 1) THEN BEGIN
  ;    dgsr_cmd->SetProperty, NormLocation='PROP'
  ;  ENDIF
  ;  widget_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_NORMLOC_HOME_DIR')
  ;  state = WIDGET_INFO(widget_ID, /BUTTON_SET)
  ;  IF (state EQ 1) THEN BEGIN
  ;    dgsr_cmd->SetProperty, NormLocation='HOME'
  ;  ENDIF
  
  ; Normalisation Directory
  dgsr_cmd->GetProperty, NormLocation=myValue
  case (myValue) of
    'INST': begin
      widget_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_NORMLOC_INST_SHARED')
      WIDGET_CONTROL, widget_ID, SET_BUTTON=1
    end
    'PROP': begin
      widget_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_NORMLOC_PROP_SHARED')
      WIDGET_CONTROL, widget_ID, SET_BUTTON=1
    END
    'HOME': BEGIN
      widget_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_NORMLOC_HOME_DIR')
      WIDGET_CONTROL, widget_ID, SET_BUTTON=1
    END
    ELSE: BEGIN
    END
  ENDCASE
  
  ; Proton Beam Units
  dgsr_cmd->GetProperty, ProtonCurrentUnits=myValue
  case (myValue) of
    'C': begin
      widget_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_PROTON_UNITS_COULOMB')
      WIDGET_CONTROL, widget_ID, SET_BUTTON=1
    end
    'mC': begin
      widget_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_PROTON_UNITS_MILLICOULOMB')
      WIDGET_CONTROL, widget_ID, SET_BUTTON=1
    END
    'uC': BEGIN
      widget_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_PROTON_UNITS_MICROCOULOMB')
      WIDGET_CONTROL, widget_ID, SET_BUTTON=1
    END
    ELSE: BEGIN
      widget_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_PROTON_UNITS_PICOCOULOMB')
      WIDGET_CONTROL, widget_ID, SET_BUTTON=1
    END
  ENDCASE
   
  ; Output Directory
  
  ; Corner Geometry
  
  ; Instrument Geometry
  
  ; SLURM Queue
  
  
  ; dgs_reduction timing
  widget_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_TIMING_ON')
  dgsr_cmd->GetProperty, Timing=myValue
  WIDGET_CONTROL, widget_ID, SET_BUTTON=myValue
  IF (myValue EQ 0) THEN BEGIN
    widget_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_TIMING_OFF')
    WIDGET_CONTROL, widget_ID, SET_BUTTON=1
  ENDIF
  
  ; Update the Norm Mask Tab
  DGSN_UpdateGUI, widgetBase, dgsr_cmd
  
  
  dgsr_status = dgsr_cmd->Check()
  
  dgsn_status = dgsr_cmd->CheckNorm()
  
  ; Find the Status message window
  dgsr_infoID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGSR_INFO_TEXT')
  WIDGET_CONTROL, dgsr_infoID, SET_VALUE=dgsr_status.message
  
  ; Find the Norm Status message window
  dgsn_infoID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGSN_INFO_TEXT')
  WIDGET_CONTROL, dgsr_infoID, SET_VALUE=dgsn_status.message
  
  ; Put info back
  WIDGET_CONTROL, widgetBase, SET_UVALUE=info, /NO_COPY
  
END
