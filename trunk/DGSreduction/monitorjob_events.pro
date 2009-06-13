

PRO MonitorJob_Events, event

  thisEvent = TAG_NAMES(event, /STRUCTURE_NAME)

  ; Get the info structure and copy it here
  WIDGET_CONTROL, event.top, GET_UVALUE=jobinfo ;, /NO_COPY
  
  ; Extract the structure into some local variables
  ;interval = job
  
  ; Put info back
  ;WIDGET_CONTROL, event.top, SET_UVALUE=jobinfo, /NO_COPY
    
  IF thisEvent EQ 'WIDGET_TIMER' THEN BEGIN
    ; Reset the Timer
    WIDGET_CONTROL, event.top, TIMER=jobinfo.interval
  ENDIF



END