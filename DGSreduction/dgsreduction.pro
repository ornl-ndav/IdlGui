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
  
  ; Get the queue name
  dgscmd->GetProperty, Queue=queue
  ; Get the instrument name
  dgscmd->GetProperty, Instrument=instrument
  ; Get the detector bank limits
  dgscmd->GetProperty, LowerBank=lowerbank
  dgscmd->GetProperty, UpperBank=upperbank
  ; Get the Run Number (the first integer in the datarun)
  runnumber = dgscmd->GetRunNumber()
  ; Number of Jobs
  dgscmd->GetProperty, Jobs=jobs
  
  jobcmd = "sbatch -p " + queue + " " 
  
  ; Array for job numbers
  jobIDs = STRARR(N_ELEMENTS(commands))
  
  ; Loop over the command array
  for index = 0L, N_ELEMENTS(commands)-1 do begin
  
    jobname = instrument + "_" + runnumber + "_bank" + $
      Construct_DataPaths(lowerbank, upperbank, index+1, jobs)
  
    cmd = jobcmd + "--job-name=" + jobname + " " + commands[index]
    ; TODO: For now let's just dump the commands into a file
    
    if (index EQ 0) then begin
      spawn, "echo " + cmd + " > /tmp/commands"
    endif else begin
      spawn, "echo " + cmd + " >> /tmp/commands"
    endelse

    ;spawn, cmd

  endfor
  
  ; Put info back
  WIDGET_CONTROL, event.top, SET_UVALUE=info, /NO_COPY
  
  ; Start the sub window widget
  ;MonitorJob, Group_Leader=event.top, JobName="My first jobby"
  
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
  dgsncmd = info.dgsncmd
  
  WIDGET_CONTROL, event.id, GET_UVALUE=myUVALUE
  
  ; Check that we actually got something back in the UVALUE
  IF N_ELEMENTS(myUVALUE) EQ 0 THEN myUVALUE="NOTHING"
  
  CASE myUVALUE OF
    'INSTRUMENT_SELECTED': BEGIN
      dgscmd->SetProperty, Instrument=event.STR
      ; Set the default detector banks if they aren't already set
      lowerbank_ID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGS_DATAPATHS_LOWER')
      upperbank_ID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGS_DATAPATHS_UPPER')
      WIDGET_CONTROL, lowerbank_ID, GET_VALUE=lowerbank
      WIDGET_CONTROL, upperbank_ID, GET_VALUE=upperbank
      ; Get the detector bank limits for the current beamline
      bank = getDetectorBankRange(event.STR)
      IF (lowerbank LE 0) THEN BEGIN 
        WIDGET_CONTROL, lowerbank_ID, SET_VALUE=bank.lower
        dgscmd->SetProperty, LowerBank=bank.lower
      ENDIF
      IF (upperbank LE 0) THEN BEGIN 
        WIDGET_CONTROL, upperbank_ID, SET_VALUE=bank.upper
        dgscmd->SetProperty, UpperBank=bank.upper
      ENDIF
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
    'DGS_MASK': BEGIN
      ;WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      ; TODO: Check filename exists before setting the property!
      dgscmd->SetProperty, Mask=event.SELECT
    END
    'DGS_HARD_MASK': BEGIN
      ;WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      ; TODO: Check filename exists before setting the property!
      dgscmd->SetProperty, HardMask=event.SELECT
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
    'DGSREDUCTION_JOBS': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      if (myValue NE "") AND (myValue GT 0) AND (myValue LT info.max_jobs) then begin
        dgscmd->SetProperty, Jobs=myValue
        ; If we are doing more than 1 job, we also need to set the --split option
        IF (myValue GT 1) THEN dgscmd->SetProperty, Split=1
        ; But if we are only doing 1 then we don't!
        IF (myValue EQ 1) THEN dgscmd->SetProperty, Split=0
      endif
      
      ; Disable the "Launch Collector" button if there is only one job
      dgs_collector_button = WIDGET_INFO(event.top,FIND_BY_UNAME='DGS_LAUNCH_COLLECTOR_BUTTON')
      
      IF (myValue EQ 1) THEN BEGIN
        WIDGET_CONTROL, dgs_collector_button, SENSITIVE=0
      ENDIF ELSE BEGIN
         WIDGET_CONTROL, dgs_collector_button, SENSITIVE=1
      ENDELSE
    END
    'NOTHING': BEGIN
    END
  ENDCASE 
  
  ; Find the output window (DGS)
  dgs_cmd_outputID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGS_CMD')
  ; Update the output command window
  WIDGET_CONTROL, dgs_cmd_outputID, SET_VALUE=dgscmd->generate()
  
  ; Find the output window (DGSN)
  dgsn_cmd_outputID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGSN_CMD')
  ; Update the output command window
  WIDGET_CONTROL, dgsn_cmd_outputID, SET_VALUE=dgsncmd->generate()
  
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

PRO DGSreduction, DGScmd=dgscmd, $
      DGSNcmd=dgsncmd, $
      _Extra=extra

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
  IF N_ELEMENTS(dgsncmd) EQ 0 THEN dgsncmd = OBJ_NEW("ReductionCMD")
  
  ; Define the TLB.
  tlb = WIDGET_BASE(COLUMN=1, TITLE=title, /FRAME)
  
  toprow = WIDGET_BASE(tlb, /ROW)
  textID = WIDGET_LABEL(toprow, VALUE='Please select an instrument --> ')
  instrumentID = WIDGET_COMBOBOX(toprow, UVALUE="INSTRUMENT_SELECTED", $
    VALUE=[' ','ARCS','CNCS','SEQUOIA'], $
    XSIZE=90, YSIZE=10)
  
;  jobBase = WIDGET_BASE(toprow, /ALIGN_RIGHT)
;  jobLabel = WIDGET_LABEL(jobBase, VALUE=' Job Submission ', XOFFSET=5)
;  jobLabelGeometry = WIDGET_INFO(jobLabel, /GEOMETRY)
;  jobLabelGeometryYSize = jobLabelGeometry.ysize
;  jobPrettyBase = WIDGET_BASE(jobBase, /FRAME, $
;        YOFFSET=jobLabelGeometryYSize/2, XPAD=10, YPAD=10)
  jobID = CW_FIELD(toprow, TITLE="                      No. of Jobs:", $
        UVALUE="DGSREDUCTION_JOBS", $
        VALUE=1, /INTEGER, /ALL_EVENTS)
  
  ; Tabs
  tabID = WIDGET_TAB(tlb)
  
  ; Reduction Tab
  reductionTabBase = WIDGET_BASE(tabID, Title='Reduction', /COLUMN)
  make_Reduction_Tab, reductionTabBase, dgscmd
  
  ; normalisation tab
  vanmaskTabBase = WIDGET_BASE(tabID, Title='Vanadium Mask', /COLUMN)
  make_VanMask_Tab, vanmaskTabBase, dgscmd
  
  
  
  
  
  logTab = WIDGET_BASE(tabID, Title='Log')
  label = WIDGET_LABEL(logTab, VALUE="Nothing to see here!")
  logbookID = WIDGET_TEXT(logTab, xsize=80, ysize=20, /SCROLL, /WRAP, $
    UNAME='DGSREDUCTION_LOGBOOK')
    
    
  ;wMainButtons = WIDGET_BASE(tlb, /ROW)
  mainButtonsColumns = WIDGET_BASE(tlb, COLUMN=3)
  mainButtonsCol1 = WIDGET_BASE(mainButtonsColumns, /ROW)
  mainButtonsCol2 = WIDGET_BASE(mainButtonsColumns, /ROW)  
  mainButtonsCol3 = WIDGET_BASE(mainButtonsColumns, /ROW)  
  mainButtonsCol1Row1 = WIDGET_BASE(mainButtonsCol1, /ROW, /ALIGN_LEFT)
  mainButtonsCol2Row1 = WIDGET_BASE(mainButtonsCol2, /ROW)
  mainButtonsCol3Row1 = WIDGET_BASE(mainButtonsCol3, /ROW, /ALIGN_RIGHT, XOFFSET=750)
  
  ; Define a Quit button
  quitID = WIDGET_BUTTON(mainButtonsCol1Row1, Value=' QUIT ', EVENT_PRO='DGSreduction_Quit')
  
  ; Define an export to script button
  ;exportScriptID = WIDGET_BUTTON(mainButtonsCol2Row1, VALUE='Export to Script', $
  ;  EVENT_PRO='DGSreduction_ExportScript')
  
  ; Define a save button
  ;saveID = WIDGET_BUTTON(mainButtonsCol3, VALUE='Save Parameters', $
  ;  EVENT_PRO='DGSreduction_SaveParameters')
  
  launchJobMonitorButton = WIDGET_BUTTON(mainButtonsCol2Row1, VALUE='Launch SLURM Monitor', $
    EVENT_PRO='DGSreduction_LaunchJobMonitor', UNAME='DGS_LAUNCH_JOBMONITOR_BUTTON')
  
  GatherButton = WIDGET_BUTTON(mainButtonsCol2Row1, VALUE='GATHER (Only Run when SLURM Jobs Completed)', $
    EVENT_PRO='DGSreduction_LaunchCollector', UNAME='DGS_LAUNCH_COLLECTOR_BUTTON')
  ; As by default we have 1 job - we should disable the collector button
  WIDGET_CONTROL, GatherButton, SENSITIVE=0 
  
  ; Define a Run button
  executeID = WIDGET_BUTTON(mainButtonsCol3Row1, Value=' EXECUTE >>> ', $
    EVENT_PRO='DGSreduction_Execute', UNAME='DGS_EXECUTE_BUTTON')
  
  ; Realise the widget hierarchy
  WIDGET_CONTROL, tlb, /REALIZE
  
  info = { dgscmd:dgscmd, $
    dgsncmd:dgsncmd, $
    application:application, $
    version:version, $
    max_jobs:1000, $  ; Max No. of jobs (to stop a large -ve Integer becoming a valid number in the input box!)
    ucams:ucams, $
    title:title, $
    extra:ptr_new(extra) $
    }
    
  ; Store the info structure in the user value of the TLB.  Turn keyboard focus events on.
  WIDGET_CONTROL, tlb, SET_UVALUE=info, /NO_COPY, /KBRD_FOCUS_EVENTS
  
  ; Setup the event loop and register the application with the window manager.
  XMANAGER, 'dgsreduction', tlb, EVENT_HANDLER='DGSreduction_TLB_Events', $
    /NO_BLOCK, CLEANUP='DGSreduction_Cleanup', GROUP_LEADER=group_leader
    
  ;send message to log current run of application
  logger, APPLICATION=application, VERSION=version, UCAMS=ucams
  
  ; Print a lovely welcome!
  ;write2log, 'Welcome to DGSreduction..."
END