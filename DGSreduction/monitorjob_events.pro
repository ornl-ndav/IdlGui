

PRO MonitorJob_Events, event

  thisEvent = TAG_NAMES(event, /STRUCTURE_NAME)

    
  IF thisEvent EQ 'WIDGET_TIMER' THEN BEGIN
    ; Get the info structure and copy it here
    WIDGET_CONTROL, event.top, GET_UVALUE=jobinfo ;, /NO_COPY
  
    ; Query the state of the jobs
    
    
    ; Update the GUI
    
    ; If all the jobs have finished launch the collector
    
    ; Put info back
    WIDGET_CONTROL, event.top, SET_UVALUE=jobinfo, /NO_COPY
    
    ; Reset the Timer
    WIDGET_CONTROL, event.top, TIMER=jobinfo.interval
  ENDIF



END