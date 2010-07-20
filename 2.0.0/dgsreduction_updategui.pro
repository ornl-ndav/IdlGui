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
  dgsr_cmd->GetProperty, OutputOverride=myValue
  outputPrefixID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_OUTPUT_PREFIX')
  ; Make the custom field insensitive ... we can enable is later if we need to
  WIDGET_CONTROL, outputPrefixID, SENSITIVE=0
  
  IF STRLEN(myValue) EQ 0 THEN BEGIN
    ; If the Override Output doesn't contain owt then we are using the 'auto' setting
    widget_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_AUTO_OUTPUT_PREFIX')
    WIDGET_CONTROL, widget_ID, SET_BUTTON=1
  ENDIF ELSE BEGIN
    ; If OutputOverride contains something, then use the custom setting
    widget_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_CUSTOM_OUTPUT_PREFIX')
    WIDGET_CONTROL, widget_ID, SET_BUTTON=1
    ; Also make the custom field sensitive
    WIDGET_CONTROL, outputPrefixID, SENSITIVE=1
    ; And set the value
    WIDGET_CONTROL, outputPrefixID, SET_VALUE=myValue
  ENDELSE
  
  ; Finally check to see if we have 'forced' the use of the home directory
  widget_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_FORCE_HOME_OUTPUT')
  dgsr_cmd->GetProperty, UseHome=myValue
  WIDGET_CONTROL, widget_ID, SET_BUTTON=myValue
  
  ; Corner Geometry
  corner_geometry_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_CORNER_GEOMETRY')
  corner_geometry_browse_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_BROWSE_CORNER_GEOMETRY')
  dgsr_cmd->GetProperty, CornerGeometry=myValue
  ; May as well set the gui text field with this value
  WIDGET_CONTROL, corner_geometry_ID, SET_VALUE=myValue
  ; But make it insensitive..
  WIDGET_CONTROL, corner_geometry_ID, SENSITIVE=0
  WIDGET_CONTROL, corner_geometry_browse_ID, SENSITIVE=0
  ; Now we need to work out if this file is the default one or not ?
  default_cornergeom = Get_CornerGeometryFile(instrument, RUNNUMBER=dgsr_cmd->GetRunNumber())
  IF (myValue EQ default_cornergeom) THEN BEGIN
    ; We are using the auto value
    widget_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_AUTO_CORNERGEOM')
    WIDGET_CONTROL, widget_ID, SET_BUTTON=1
  ENDIF ELSE BEGIN
    ; Using Custom
    widget_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_CUSTOM_CORNERGEOM')
    WIDGET_CONTROL, widget_ID, SET_BUTTON=1
    ; Also make the file field active
    WIDGET_CONTROL, corner_geometry_ID, SENSITIVE=1
    WIDGET_CONTROL, corner_geometry_browse_ID, SENSITIVE=1
  ENDELSE
  
  ; Instrument Geometry
  inst_geometry_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_INST_GEOMETRY')
  inst_geometry_browse_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_BROWSE_INST_GEOMETRY')
  
  dgsr_cmd->GetProperty, InstGeometry=myValue
  ; May as well set the gui text field with this value
  WIDGET_CONTROL, inst_geometry_ID, SET_VALUE=myValue
  ; But make it insensitive..
  WIDGET_CONTROL, inst_geometry_ID, SENSITIVE=0
  WIDGET_CONTROL, inst_geometry_browse_ID, SENSITIVE=0
  ; Now we need to work out if this file is the default one or not ?
  IF STRLEN(myValue) EQ 0 THEN BEGIN
    ; We are using the auto value
    widget_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_AUTO_INSTGEOM')
    WIDGET_CONTROL, widget_ID, SET_BUTTON=1
  ENDIF ELSE BEGIN
    ; Using Custom
    widget_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_CUSTOM_INSTGEOM')
    WIDGET_CONTROL, widget_ID, SET_BUTTON=1
    ; Also make the file field active
    WIDGET_CONTROL, inst_geometry_ID, SENSITIVE=1
    WIDGET_CONTROL, inst_geometry_browse_ID, SENSITIVE=1
  ENDELSE
  
  
  ; SLURM Queue
  slurm_queue_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_SLURM_QUEUE')
  dgsr_cmd->GetProperty, Queue=myValue
  ; May as well set the gui text field with this value
  WIDGET_CONTROL, slurm_queue_ID, SET_VALUE=myValue
  ; But make it insensitive..
  WIDGET_CONTROL, slurm_queue_ID, SENSITIVE=0
  ; Now we need to work out if this file is the default one or not ?
  default_queue = Get_DefaultSlurmQueue(instrument)
  IF (myValue EQ default_queue) THEN BEGIN
    ; We are using the auto value
    widget_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_AUTO_SLURM')
    WIDGET_CONTROL, widget_ID, SET_BUTTON=1
  ENDIF ELSE BEGIN
    ; Using Custom
    widget_ID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGS_CUSTOM_SLURM')
    WIDGET_CONTROL, widget_ID, SET_BUTTON=1
    ; Also make the file field active
    WIDGET_CONTROL, slurm_queue_ID, SENSITIVE=1
  ENDELSE
  
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
