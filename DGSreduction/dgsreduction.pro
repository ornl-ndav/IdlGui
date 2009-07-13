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
  dgsr_cmd = info.dgsr_cmd
  
  ; Do some sanity checking.
  
  ; First lets check that an instrument has been selected!
  dgsr_cmd->GetProperty, Instrument=instrument
  IF (STRLEN(instrument) LT 2) THEN BEGIN
    ; First put back the info structure
    WIDGET_CONTROL, event.top, SET_UVALUE=info, /NO_COPY 
    ; Then show an error message!   
    ok=ERROR_MESSAGE("Please select an Instrument from the list.", /INFORMATIONAL)
    return
  END
  
  ; Generate the array of commands to run
  commands = dgsr_cmd->generate()
  
  ; Get the queue name
  dgsr_cmd->GetProperty, Queue=queue
  ; Get the instrument name
  dgsr_cmd->GetProperty, Instrument=instrument
  ; Get the detector bank limits
  dgsr_cmd->GetProperty, LowerBank=lowerbank
  dgsr_cmd->GetProperty, UpperBank=upperbank
  ; Get the Run Number (the first integer in the datarun)
  runnumber = dgsr_cmd->GetRunNumber()
  ; Number of Jobs
  dgsr_cmd->GetProperty, Jobs=jobs
  
  jobcmd = "sbatch -p " + queue + " " 
  
  ; Log Directory
  cd, CURRENT=thisDir
  logDir = '/SNS/users/' + info.username + '/results/' + $
    instrument + '/' + runnumber + '/logs'
  ; Make the directory
  spawn, 'mkdir -p ' + logDir

  ; Array for job numbers
  jobIDs = STRARR(N_ELEMENTS(commands))

  ; Make sure that the output directory exists
  outputDir = '~/results/' + instrument + '/' + runnumber
  spawn, 'mkdir -p ' + outputDir
 
 
  ; Check for existance of SPE file and ask if the user wants to override it.
  ; (only check if we are asking to produce an SPE file)
  ;if (
 
  ; Loop over the command array
  for index = 0L, N_ELEMENTS(commands)-1 do begin
  
    jobname = instrument + "_" + runnumber + "_bank" + $
      Construct_DataPaths(lowerbank, upperbank, index+1, jobs, /PAD)
    
    logfile = logDir + '/' + instrument + '_bank' + $
      Construct_DataPaths(lowerbank, upperbank, index+1, jobs, /PAD) + $
      '.log'
  
    cmd = jobcmd + " --output=" + logfile + $
        " --job-name=" + jobname + $
 	" " + commands[index]
    
    if (index EQ 0) then begin
      spawn, "echo " + cmd + " > /tmp/" + info.username + "_commands"
    endif else begin
      spawn, "echo " + cmd + " >> /tmp/" + info.username + "_commands"
    endelse

    ; Actually Launch the jobs
    spawn, cmd

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

PRO DGSnorm_Execute, event

  ; Error Handling
  catch, theError
  IF theError NE 0 THEN BEGIN
    catch, /cancel
    ok = ERROR_MESSAGE(!ERROR_STATE.MSG + ' Returning...', TRACEBACK=1, /error)
    return
  ENDIF

  ; Get the info structure and copy it here
  WIDGET_CONTROL, event.top, GET_UVALUE=info, /NO_COPY
  dgsn_cmd = info.dgsn_cmd
  
  ; Do some sanity checking.
  
  ; First lets check that an instrument has been selected!
  dgsn_cmd->GetProperty, Instrument=instrument
  IF (STRLEN(instrument) LT 2) THEN BEGIN
    ; First put back the info structure
    WIDGET_CONTROL, event.top, SET_UVALUE=info, /NO_COPY 
    ; Then show an error message!   
    ok=ERROR_MESSAGE("Please select an Instrument from the list.", /INFORMATIONAL)
    return
  END
  
  ; Generate the array of commands to run
  commands = dgsn_cmd->generate()
  
  ; Get the queue name
  dgsn_cmd->GetProperty, Queue=queue
  ; Get the instrument name
  dgsn_cmd->GetProperty, Instrument=instrument
  ; Get the detector bank limits
  dgsn_cmd->GetProperty, LowerBank=lowerbank
  dgsn_cmd->GetProperty, UpperBank=upperbank
  ; Get the Run Number (the first integer in the datarun)
  runnumber = dgsn_cmd->GetRunNumber()
  ; Number of Jobs
  dgsn_cmd->GetProperty, Jobs=jobs
  
  jobcmd = "sbatch -p " + queue + " " 
  
  ; Log Directory
  cd, CURRENT=thisDir
    logDir = '/SNS/users/' + info.username + '/results/' + $
   instrument + '/' + runnumber + '/logs'
   
  ; Make the directory
  spawn, 'mkdir -p ' + logDir

  ; Array for job numbers
  jobIDs = STRARR(N_ELEMENTS(commands))

  ; Make sure that the output directory exists
  outputDir = '~/results/' + instrument + '/' + runnumber
  spawn, 'mkdir -p ' + outputDir
 
  ; Loop over the command array
  for index = 0L, N_ELEMENTS(commands)-1 do begin
  
    jobname = instrument + "_" + runnumber + "_bank" + $
      Construct_DataPaths(lowerbank, upperbank, index+1, jobs, /PAD)
    
    logfile = logDir + '/' + instrument + '_bank' + $
      Construct_DataPaths(lowerbank, upperbank, index+1, jobs, /PAD) + $
      '.log'
  
    cmd = jobcmd + " --output=" + logfile + $
        " --job-name=" + jobname + $
  " " + commands[index]
    
    if (index EQ 0) then begin
      spawn, "echo " + cmd + " > /tmp/" + info.username + "_norm_commands"
    endif else begin
      spawn, "echo " + cmd + " >> /tmp/" + info.username + "_norm_commands"
    endelse

    ; Actually Launch the jobs
    spawn, cmd

  endfor
  
  ; Put info back
  WIDGET_CONTROL, event.top, SET_UVALUE=info, /NO_COPY
  
  ; Start the sub window widget
  ;MonitorJob, Group_Leader=event.top, JobName="My first jobby"
  
END

;---------------------------------------------------------

;---------------------------------------------------------

PRO DGSreduction_Cleanup, tlb
  WIDGET_CONTROL, tlb, GET_UVALUE=info, /NO_COPY
  IF N_ELEMENTS(info) EQ 0 THEN RETURN
  
  ; Free up the pointers
  ;  PTR_FREE, info.dgsr_cmd
  PTR_FREE, info.extra
END

;---------------------------------------------------------

PRO DGSreduction, DGSR_cmd=dgsr_cmd, $
      DGSN_cmd=dgsn_cmd, $
      _Extra=extra

  ; Program Details
  APPLICATION       = 'DGSreduction'
  VERSION           = '0.9.0'
  
  Catch, errorStatus
  
  ; Error handler
  if (errorStatus ne 0) then begin
    Catch, /CANCEL
    ok = ERROR_MESSAGE(TRACEBACK=1)
  endif
  
  ; Get the UCAMS
  username = GETENV('USER')
  
  ; Are we going to print lots of messages
  debug = 0
  
  ; Set the application title
  title = APPLICATION + ' (' + VERSION + ') as ' + username
  
  IF N_ELEMENTS(dgsr_cmd) EQ 0 THEN dgsr_cmd = OBJ_NEW("ReductionCMD")
  IF N_ELEMENTS(dgsn_cmd) EQ 0 THEN dgsn_cmd = OBJ_NEW("NormCMD")
  
  ; Define the TLB.
  tlb = WIDGET_BASE(COLUMN=1, TITLE=title, /FRAME, MBAR=menubarID)
  
  ; Define the menus
  
  ; File Menu
  fileMenuID = WIDGET_BUTTON(menubarID, VALUE='File')
  loadMenuID = WIDGET_BUTTON(fileMenuID, VALUE='Load...', EVENT_PRO='DGSreduction_LoadParameters')
  saveMenuID = WIDGET_BUTTON(fileMenuID, VALUE='Save...', EVENT_PRO='save_parameters')
  quitMenuID = WIDGET_BUTTON(fileMenuID, VALUE='Quit', EVENT_PRO='DGSreduction_Quit', /SEPARATOR)
  
  ; Actions Menu
  actionMenuID = WIDGET_BUTTON(menubarID, VALUE='Actions')
  executeReductionMenuID = WIDGET_BUTTON(actionMenuID, VALUE='Execute Reduction', $
    EVENT_PRO='DGSreduction_Execute')
  gatherReductionMenuID = WIDGET_BUTTON(actionMenuID, VALUE='Gather Reduction', $
    EVENT_PRO='DGSreduction_LaunchCollector')
  
  executeNormMenuID = WIDGET_BUTTON(actionMenuID, VALUE='Execute Vanadium Mask Generation', $
    EVENT_PRO='DGSnorm_Execute', /SEPARATOR)
  gatherNormMenuID = WIDGET_BUTTON(actionMenuID, VALUE='Gather Vanadium Mask Generation', $
    EVENT_PRO='DGSnorm_LaunchCollector', /SEPARATOR)
  
  
  ; Monitoring Menu
  monitoringMenuID = WIDGET_BUTTON(menubarID, VALUE='Monitoring')
  launchJobMonitorMenuID = WIDGET_BUTTON(monitoringMenuID, VALUE='Launch SLURM Monitor', $
    EVENT_PRO='DGSreduction_LaunchJobMonitor')
  
  
  
  ; Help Menu
  helpMenuID = WIDGET_BUTTON(menubarID, VALUE='Help')
  helpfileMenuID = WIDGET_BUTTON(helpMenuID, VALUE='Sorry no help available at the moment')
    
  
  toprow = WIDGET_BASE(tlb, COLUMN=4)
  
  instrumentSelectRow = WIDGET_BASE(toprow, /ROW)
  textID = WIDGET_LABEL(instrumentSelectRow, VALUE='Please select an instrument --> ')
  instrumentID = WIDGET_COMBOBOX(instrumentSelectRow, UVALUE="INSTRUMENT_SELECTED", $
    UNAME='INSTRUMENT_SELECTED', VALUE=[' ','ARCS','CNCS','SEQUOIA'], $
    XSIZE=90, YSIZE=30)
  
;  jobBase = WIDGET_BASE(toprow, /ALIGN_RIGHT)
;  jobLabel = WIDGET_LABEL(jobBase, VALUE=' Job Submission ', XOFFSET=5)
;  jobLabelGeometry = WIDGET_INFO(jobLabel, /GEOMETRY)
;  jobLabelGeometryYSize = jobLabelGeometry.ysize
;  jobPrettyBase = WIDGET_BASE(jobBase, /FRAME, $
;        YOFFSET=jobLabelGeometryYSize/2, XPAD=10, YPAD=10)
  jobID = CW_FIELD(toprow, TITLE="                      No. of Jobs:", $
        UVALUE="DGS_REDUCTION_JOBS", UNAME='DGS_REDUCTION_JOBS', $
        VALUE=1, /INTEGER, /ALL_EVENTS)
 
  paddingText = "                       "
  paddingLabel = WIDGET_LABEL(toprow, VALUE=paddingText)

  WFONT = '-*-HELVETICA-BOLD-R-NORMAL-*-12-*-*-*-*-*-*-*'

  warningBase = WIDGET_BASE(toprow, /COLUMN)

  warningText1 = "DANGER: This is a very early development version."
  warningText2 = "It WILL crash - there is no sanity checking at the moment."
  warningText3 = "Otherwise, enjoy! and please be kind :-)"

  ;warningLabel1 = WIDGET_LABEL(warningBase, VALUE=warningText1, font=wfont)
  ;warningLabel2 = WIDGET_LABEL(warningBase, VALUE=warningText2)
  ;warningLabel3 = WIDGET_LABEL(warningBase, VALUE=warningText3)
 
  ; Tabs
  tabID = WIDGET_TAB(tlb)
  
  ; Reduction Tab
  reductionTabBase = WIDGET_BASE(tabID, Title='Reduction', /COLUMN)
  make_Reduction_Tab, reductionTabBase, dgsr_cmd
  
  ; normalisation tab
  vanmaskTabBase = WIDGET_BASE(tabID, Title='Vanadium Mask', /COLUMN)
  ;label = WIDGET_LABEL(vanmaskTabBase, VALUE="Nothing to see here! - Move along :-)")
  make_VanMask_Tab, vanmaskTabBase, dgsn_cmd
 
; Remove the LOG Tab (for the moment) as we are not using it!  
;  logTab = WIDGET_BASE(tabID, Title='Log')
;  label = WIDGET_LABEL(logTab, VALUE="Nothing to see here!")
;  logbookID = WIDGET_TEXT(logTab, xsize=80, ysize=20, /SCROLL, /WRAP, $
;    UNAME='DGS_REDUCTION_LOGBOOK')
    
    
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
  
  ;TODO: Save Defaults
;  saveDefaultsButton = WIDGET_BUTTON(mainButtonsCol1Row1, VALUE='Save Current Values as Default', $
;    UNAME='DGS_SAVE_DEFAULTS', EVENT_PRO='DGSreduction_save_defaults')
  
  ; Define an export to script button
  ;exportScriptID = WIDGET_BUTTON(mainButtonsCol2Row1, VALUE='Export to Script', $
  ;  EVENT_PRO='DGSreduction_ExportScript')
  
  ; Define a save button
  ;saveID = WIDGET_BUTTON(mainButtonsCol3, VALUE='Save Parameters', $
  ;  EVENT_PRO='DGSreduction_SaveParameters')
  
  launchJobMonitorButton = WIDGET_BUTTON(mainButtonsCol2Row1, VALUE='Launch SLURM Monitor', $
    EVENT_PRO='DGSreduction_LaunchJobMonitor', UNAME='DGS_LAUNCH_JOBMONITOR_BUTTON')
    
  saveParametersButton = WIDGET_BUTTON(mainButtonsCol2Row1, VALUE='SAVE ALL Parameters', $
    UNAME='DGS_SAVEPARAMETERS', EVENT_PRO='save_parameters')
  
  loadParametersButton = WIDGET_BUTTON(mainButtonsCol2Row1, VALUE='LOAD ALL Parameters', $
    UNAME='DGS_LOADPARAMETERS', EVENT_PRO='DGSreduction_LoadParameters')
  
  ;TODO: Load in the default Value

  
  ; Realise the widget hierarchy
  WIDGET_CONTROL, tlb, /REALIZE
  
  info = { dgsr_cmd:dgsr_cmd, $
    dgsn_cmd:dgsn_cmd, $
    application:application, $
    version:version, $
    debug:debug, $
    max_jobs:1000, $  ; Max No. of jobs (to stop a large -ve Integer becoming a valid number in the input box!)
    username:username, $
    title:title, $
    extra:ptr_new(extra) $
    }
    
  ; Store the info structure in the user value of the TLB.  Turn keyboard focus events on.
  WIDGET_CONTROL, tlb, SET_UVALUE=info, /NO_COPY, /KBRD_FOCUS_EVENTS
  
  ; Setup the event loop and register the application with the window manager.
  XMANAGER, 'dgsreduction', tlb, EVENT_HANDLER='DGSreduction_TLB_Events', $
    /NO_BLOCK, CLEANUP='DGSreduction_Cleanup', GROUP_LEADER=group_leader
    
  ;send message to log current run of application
  logger, APPLICATION=application, VERSION=version, UCAMS=username
  
  ; Print a lovely welcome!
  ;write2log, 'Welcome to DGSreduction..."
END
