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

PRO MonitorJob, Group_Leader=group_leader, $
    Title=title, $
    JobName=jobname, $
    RunNumber=runnumber
    
  IF N_ELEMENTS(Title) EQ 0 THEN title = "Monitor Job"
  IF N_ELEMENTS(JobName) EQ 0 THEN JobName = ""
  IF N_ELEMENTS(RunNumber) EQ 0 THEN RunNumber = 0
  
  
  ; Define the TLB.
  tlb = WIDGET_BASE(COLUMN=1, TITLE=title, /FRAME)
  
  sometext = WIDGET_LABEL(tlb, VALUE="Job")
  
  jobnameID = CW_FIELD(tlb, TITLE="Job Name:", VALUE=jobname, /ALL_EVENTS)
  
  ; Realise the widget hierarchy
  WIDGET_CONTROL, tlb, /REALIZE
  
  jobinfo = { name:jobname, $
    interval:2.0 }    ; Timer interval
    
  WIDGET_CONTROL, tlb, TIMER=jobinfo.interval
  
  ; Set the jobinfo structure
  WIDGET_CONTROL, tlb, SET_UVALUE=jobinfo, /NO_COPY
  
  XMANAGER, 'monitorjob', tlb, GROUP_LEADER=group_leader, $
    EVENT_HANDLER='MonitorJob_Events', /NO_BLOCK
    
  print, 'sadasdas'
  
END