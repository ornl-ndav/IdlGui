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

PRO DGSreduction_TLB_Events, event
  thisEvent = TAG_NAMES(event, /STRUCTURE_NAME)
  
  ; Get the info structure
  WIDGET_CONTROL, event.top, GET_UVALUE=info, /NO_COPY
  
  ; extract the command object into a separate
  dgsr_cmd = info.dgsr_cmd    ; ReductionCMD object
  dgsn_cmd = info.dgsn_cmd   ; NormCMD object
  
  ; Print the busy flag
  ;dgsr_cmd->GetProperty, busy=busy
  ;print, 'Busy=',busy
  
  WIDGET_CONTROL, event.id, GET_UVALUE=myUVALUE
  
  ; Check that we actually got something back in the UVALUE
  IF N_ELEMENTS(myUVALUE) EQ 0 THEN myUVALUE="NOTHING"
  
  ; Start the handler for the DGSN_* events
  IF STRMID(myUVALUE, 0, 4) EQ 'DGSN' THEN BEGIN
    dgsnorm_events, event, dgsn_cmd
    ; Now set the UVALUE we are checking to 'NOTHING' so
    ; we don't get caught by the default on the next CASE statement
    myUVALUE = "NOTHING"
  ENDIF
  
  
  ; Start the handler for the DGSR_* events
  IF STRMID(myUVALUE, 0, 4) EQ 'DGSR' THEN BEGIN
    dgsreduction_events, event, dgsr_cmd
    ; Now set the UVALUE we are checking to 'NOTHING' so
    ; we don't get caught by the default on the next CASE statement
    myUVALUE = "NOTHING"
  ENDIF
  
  
  CASE myUVALUE OF
    'INSTRUMENT_SELECTED': BEGIN
    
      dgsr_cmd->SetProperty, Instrument=event.STR
      
      ; Update the default number of jobs
      jobs_ID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGS_REDUCTION_JOBS')
      dgsr_cmd->GetProperty, Jobs=njobs
      WIDGET_CONTROL, jobs_ID, SET_VALUE=njobs
      ; Hack to get correct number of jobs into dgsn_cmd on instrument
      ; selection. 2zr Mar 5, 2010
      dgsn_cmd->SetProperty, Jobs=njobs
      
      ; Set the default detector banks
      lowerbank_ID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGSR_DATAPATHS_LOWER')
      upperbank_ID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGSR_DATAPATHS_UPPER')
      WIDGET_CONTROL, lowerbank_ID, GET_VALUE=lowerbank
      WIDGET_CONTROL, upperbank_ID, GET_VALUE=upperbank
      ; Get the detector bank limits for the current beamline
      bank = getDetectorBankRange(event.STR)
      ;IF (lowerbank LE 0) THEN BEGIN
      WIDGET_CONTROL, lowerbank_ID, SET_VALUE=bank.lower
      dgsr_cmd->SetProperty, LowerBank=bank.lower
      ;ENDIF
      ;IF (upperbank LE 0) THEN BEGIN
      WIDGET_CONTROL, upperbank_ID, SET_VALUE=bank.upper
      dgsr_cmd->SetProperty, UpperBank=bank.upper
      ;ENDIF
      
      ; Now do same for 'Vanadium Mask' Tab
      dgsn_cmd->SetProperty, Instrument=event.STR
      ; Set the default detector banks
      lowerbank_norm_ID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGSN_DATAPATHS_LOWER')
      upperbank_norm_ID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGSN_DATAPATHS_UPPER')
      WIDGET_CONTROL, lowerbank_norm_ID, GET_VALUE=lowerbank
      WIDGET_CONTROL, upperbank_norm_ID, GET_VALUE=upperbank
      ; Get the detector bank limits for the current beamline
      bank = getDetectorBankRange(event.STR)
      ;IF (lowerbank LE 0) THEN BEGIN
      WIDGET_CONTROL, lowerbank_norm_ID, SET_VALUE=bank.lower
      dgsn_cmd->SetProperty, LowerBank=bank.lower
      ;ENDIF
      ;IF (upperbank LE 0) THEN BEGIN
      WIDGET_CONTROL, upperbank_norm_ID, SET_VALUE=bank.upper
      dgsn_cmd->SetProperty, UpperBank=bank.upper
    ;ENDIF
    END
    
    'DGS_REDUCTION_JOBS': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      if (myValue NE "") AND (myValue GT 0) AND (myValue LT info.max_jobs) then begin
        dgsr_cmd->SetProperty, Jobs=myValue
        dgsn_cmd->SetProperty, Jobs=myValue
        ; If we are doing more than 1 job, we also need to set the --split option
        IF (myValue GT 1) THEN dgsr_cmd->SetProperty, Split=1
        ; Do the same for the dgs_norm command
        IF (myValue GT 1) THEN dgsn_cmd->SetProperty, Split=1
        
        ; But if we are only doing 1 then we don't!
        IF (myValue EQ 1) THEN dgsr_cmd->SetProperty, Split=0
        ; Do the same for the dgs_norm command
        IF (myValue EQ 1) THEN dgsn_cmd->SetProperty, Split=0
      endif
      
    ; Disable the "Launch Collector" button if there is only one job
    ;      dgsr_collector_button = WIDGET_INFO(event.top,FIND_BY_UNAME='DGSR_LAUNCH_COLLECTOR_BUTTON')
    ;      IF (myValue EQ 1) THEN BEGIN
    ;        WIDGET_CONTROL, dgsr_collector_button, SENSITIVE=0
    ;      ENDIF ELSE BEGIN
    ;         WIDGET_CONTROL, dgsr_collector_button, SENSITIVE=1
    ;      ENDELSE
      
    END
    'DGS_SLURM_QUEUE': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      ;TODO: Check to see if the QUEUE name is valid.
      print, "Setting SLURM queue to be ", myValue
      dgsr_cmd->SetProperty, Queue=myValue
    END
    'DGS_AUTO_SLURM': BEGIN
      IF (event.select EQ 1) THEN BEGIN
        ; If we are using the auto queue, get the default queue...
        dgsr_cmd->GetProperty, Instrument=instrument
        default_queue = GetDefaultSlurmQueue(instrument)
        dgsr_cmd->SetProperty, Queue=default_queue
        ; then set the SLURM queue text field
        ;print, 'AUTO'
        slurm_queue_ID = WIDGET_INFO(event.top, FIND_BY_UNAME='DGS_SLURM_QUEUE')
        dgsr_cmd->GetProperty, Queue=currentSQ
        WIDGET_CONTROL, slurm_queue_ID, SET_VALUE=currentSQ
      ENDIF
    END
    'DGS_CUSTOM_SLURM': BEGIN
      IF (event.select EQ 1) THEN BEGIN
      ;print, 'CUSTOM'
      ; Do nothing!
      ENDIF
    END
    'DGS_OUTPUT_PREFIX': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      print,'Custom Dir = ', myValue
      ; Update the command object... if the directory exists
     ; directoryValid = FILE_TEST(myValue, /DIRECTORY, /WRITE)
     ; IF (directoryValid EQ 1) THEN BEGIN
     ;   print,'Setting output prefix = ',myvalue
        dgsr_cmd->SetProperty, OutputOverride=myValue
     ; ENDIF
    END
    'DGS_AUTO_OUTPUT_PREFIX': BEGIN
      ; For auto prefix - just use relay on whatever is returned by get_output_directory()
      IF (event.select EQ 1) THEN BEGIN
        dgsr_cmd->SetProperty, OutputOverride=''
      ENDIF
    END
    'DGS_FORCE_HOME_OUTPUT': BEGIN
      dgsr_cmd->SetProperty, UseHome=event.SELECT
    END
    'DGS_CUSTOM_OUTPUT_PREFIX': BEGIN
      IF (event.select EQ 1) THEN BEGIN
        ; Get the value from the GUI
        outputPrefixID = WIDGET_INFO(event.top, FIND_BY_UNAME='DGS_OUTPUT_PREFIX')
        WIDGET_CONTROL, outputPrefixID, GET_VALUE=myValue
        ; Update the command object... if the directory exists
       ; directoryValid = FILE_TEST(myValue, /DIRECTORY, /WRITE)
       ; IF (directoryValid EQ 1) THEN BEGIN
          dgsr_cmd->SetProperty, OutputOverride=myValue
       ; ENDIF
      ENDIF
    END
    'DGS_TIMING_ON': BEGIN
      dgsr_cmd->SetProperty, Timing=event.SELECT
    END
    'DGS_TIMING_OFF': BEGIN
    ; Don't need to do anything in here as the buttons
    ; are EXCLUSIVE so the ON button with set the correct
    ; flag on the command object automatically.
    END
    'DGS_CORNER_GEOMETRY': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      print, "Setting Corner Geometry queue to be ", myValue
      dgsr_cmd->SetProperty, CornerGeometry=myValue
    END
    'DGS_AUTO_CORNERGEOM': BEGIN
      IF (event.select EQ 1) THEN BEGIN
        ; If Auto - then disable the input field
        corner_geometry_ID = WIDGET_INFO(event.top, FIND_BY_UNAME='DGS_CORNER_GEOMETRY')
        WIDGET_CONTROL, corner_geometry_ID, SENSITIVE=0
        
        ; If we are using the auto file, get the default filename...
        dgsr_cmd->GetProperty, Instrument=instrument
        default_cornergeom = GetCornerGeometryFile(instrument, RUNNUMBER=dgsr_cmd->GetRunNumber())
        dgsr_cmd->SetProperty, CornerGeometry=default_cornergeom
        ; then set the Filename text field
        dgsr_cmd->GetProperty, CornerGeometry=currentCG
        WIDGET_CONTROL, corner_geometry_ID, SET_VALUE=currentCG
      ENDIF
    END
    'DGS_CUSTOM_CORNERGEOM': BEGIN
      IF (event.select EQ 1) THEN BEGIN
        corner_geometry_ID = WIDGET_INFO(event.top, FIND_BY_UNAME='DGS_CORNER_GEOMETRY')
        WIDGET_CONTROL, corner_geometry_ID, SENSITIVE=1
      ; Do nothing!
      ENDIF
    END
    'DGS_INST_GEOMETRY': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      print, "Setting Instrument Geometry queue to be ", myValue
      dgsr_cmd->SetProperty, InstGeometry=myValue
    END
    'DGS_AUTO_INSTGEOM': BEGIN
      IF (event.select EQ 1) THEN BEGIN
        ; If Auto - then disable the input field
        inst_geometry_ID = WIDGET_INFO(event.top, FIND_BY_UNAME='DGS_INST_GEOMETRY')
        WIDGET_CONTROL, inst_geometry_ID, SENSITIVE=0
        ; If we are using the automatic setting, then the default is no overriding geometry!
        dgsr_cmd->SetProperty, InstGeometry=''
        WIDGET_CONTROL, inst_geometry_ID, SET_VALUE=''
      ENDIF
    END
    'DGS_CUSTOM_INSTGEOM': BEGIN
      IF (event.select EQ 1) THEN BEGIN
        inst_geometry_ID = WIDGET_INFO(event.top, FIND_BY_UNAME='DGS_INST_GEOMETRY')
        WIDGET_CONTROL, inst_geometry_ID, SENSITIVE=1
      ; Do nothing!
      ENDIF
    END
    'DGS_PROTON_UNITS_COULOMB': BEGIN
      IF (event.select EQ 1) THEN BEGIN
        ;print, 'Setting Units = C'
        dgsr_cmd->SetProperty, ProtonCurrentUnits="C"
        dgsn_cmd->SetProperty, ProtonCurrentUnits="C"
      ENDIF
    END
    'DGS_PROTON_UNITS_MILLICOULOMB': BEGIN
      IF (event.select EQ 1) THEN BEGIN
        ;     print, 'Setting Units = C'
        dgsr_cmd->SetProperty, ProtonCurrentUnits="mC"
        dgsn_cmd->SetProperty, ProtonCurrentUnits="mC"
      ENDIF
    END
    'DGS_PROTON_UNITS_MICROCOULOMB': BEGIN
      IF (event.select EQ 1) THEN BEGIN
        ;    print, 'Setting Units = C'
        dgsr_cmd->SetProperty, ProtonCurrentUnits="uC"
        dgsn_cmd->SetProperty, ProtonCurrentUnits="uC"
      ENDIF
    END
    'DGS_PROTON_UNITS_PICOCOULOMB': BEGIN
      IF (event.select EQ 1) THEN BEGIN
        ;   print, 'Setting Units = <none>'
        dgsr_cmd->SetProperty, ProtonCurrentUnits=""
        dgsn_cmd->SetProperty, ProtonCurrentUnits=""
      ENDIF
    END
    'DGS_NORMLOC_INST_SHARED': BEGIN
      dgsr_cmd->SetProperty, NormLocation='INST'
      dgsn_cmd->SetProperty, NormLocation='INST'
    END
    'DGS_NORMLOC_PROP_SHARED': BEGIN
      dgsr_cmd->SetProperty, NormLocation='PROP'
      dgsn_cmd->SetProperty, NormLocation='PROP'
    END
    'DGS_NORMLOC_HOME_DIR': BEGIN
      dgsr_cmd->SetProperty, NormLocation='HOME'
      dgsn_cmd->SetProperty, NormLocation='HOME'
    END
    'NOTHING': BEGIN
    END
    ELSE: BEGIN
      ; Do nowt
      print, '*** UVALUE: ' + myUVALUE + ' not handled! ***'
    END
    
  ENDCASE
  
  ; Do a sanity check
  status = dgsr_cmd->check()
  dgsn_status = dgsn_cmd->check()
  
  ; Disable the "Launch Collector" button if we are not ok to run!
  ;  dgsr_collector_button = WIDGET_INFO(event.top,FIND_BY_UNAME='DGSR_LAUNCH_COLLECTOR_BUTTON')
  ;  WIDGET_CONTROL, dgsr_collector_button, SENSITIVE=status.ok
  ; Disable the "Launch Collector" button if we are not ok to run!
  ;  dgsn_collector_button = WIDGET_INFO(event.top,FIND_BY_UNAME='DGSN_LAUNCH_COLLECTOR_BUTTON')
  ;  WIDGET_CONTROL, dgsn_collector_button, SENSITIVE=dgsn_status.ok
  
  ; Find the Messages Window (DGSR)
  dgsr_info_outputID = WIDGET_INFO(event.top, FIND_BY_UNAME='DGSR_INFO_TEXT')
  WIDGET_CONTROL, dgsr_info_outputID, SET_VALUE=status.message
  ; Find the Messages Window (DGSR)
  dgsn_info_outputID = WIDGET_INFO(event.top, FIND_BY_UNAME='DGSN_INFO_TEXT')
  WIDGET_CONTROL, dgsn_info_outputID, SET_VALUE=dgsn_status.message
  
  ; Also Enable/Disable the DGSR Execute button
  dgsr_executeID = WIDGET_INFO(event.top, FIND_BY_UNAME='DGSR_EXECUTE_BUTTON')
  WIDGET_CONTROL, dgsr_executeID, SENSITIVE=status.ok
  ; Also Enable/Disable the DGSN Execute button
  dgsn_executeID = WIDGET_INFO(event.top, FIND_BY_UNAME='DGSN_EXECUTE_BUTTON')
  WIDGET_CONTROL, dgsn_executeID, SENSITIVE=dgsn_status.ok
  
  ; Find the output window (DGS)
  dgs_cmd_outputID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGSR_CMD_TEXT')
  ; Update the output command window
  WIDGET_CONTROL, dgs_cmd_outputID, SET_VALUE=dgsr_cmd->generate()
  ; Find the output window (DGSN)
  dgsn_cmd_outputID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGSN_CMD_TEXT')
  ; Update the output command window
  WIDGET_CONTROL, dgsn_cmd_outputID, SET_VALUE=dgsn_cmd->generate()
  
  ; Update the feedback for were we are going to write the results
  ; On the Reduction Tab...
  reduction_output_dir_ID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGSR_OUTPUT_DIRECTORY_LABEL')
  WIDGET_CONTROL, reduction_output_dir_ID, SET_VALUE=dgsr_cmd->GetReductionOutputDirectory()
  ; ... and on the settings tab.
  settings_output_dir_ID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGS_OUTPUT_DIRECTORY_LABEL')
  WIDGET_CONTROL, settings_output_dir_ID, SET_VALUE=dgsr_cmd->GetReductionOutputDirectory()
  
  ; Update the name of the SLURM queue (on the Settings Tab)
  slurm_queue_ID = WIDGET_INFO(event.top, FIND_BY_UNAME='DGS_SLURM_QUEUE')
  customSlurmQueueID = WIDGET_INFO(event.top, FIND_BY_UNAME='DGS_CUSTOM_SLURM')
  pressed = WIDGET_INFO(customSlurmQueueID, /BUTTON_SET)
  WIDGET_CONTROL, slurm_queue_ID, SENSITIVE=pressed
  ; Only bother updating the SLURM queue field if we are on automatic
  IF (pressed NE 1) THEN BEGIN
    dgsr_cmd->GetProperty, Queue=currentSQ
    WIDGET_CONTROL, slurm_queue_ID, SET_VALUE=currentSQ
  ENDIF
  
  ; Update the output prefix (on the Settings Tab)
  outputPrefixID = WIDGET_INFO(event.top, FIND_BY_UNAME='DGS_OUTPUT_PREFIX')
  customOutputPrefixButtonID = WIDGET_INFO(event.top, FIND_BY_UNAME='DGS_CUSTOM_OUTPUT_PREFIX')
  pressed = WIDGET_INFO(customOutputPrefixButtonID, /BUTTON_SET)
  WIDGET_CONTROL, outputPrefixID, SENSITIVE=pressed
  
  
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
