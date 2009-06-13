PRO MonitorJob, Group_Leader=group_leader, $
  Title=title, $
  JobName=jobname 
  
  IF N_ELEMENTS(Title) EQ 0 THEN title = "Monitor Job"
  IF N_ELEMENTS(JobName) EQ 0 THEN JobName = ""


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