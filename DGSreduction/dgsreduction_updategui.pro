PRO DGSreduction_UpdateGUI, event

  print, '==UpdateGUI=='
  help,/str,event

  ; Get the info structure
  WIDGET_CONTROL, event.top, GET_UVALUE=info, /NO_COPY

  ; extract the command object into a separate
  dgsr_cmd = info.dgsr_cmd    ; ReductionCMD object
  dgsn_cmd = info.dgsn_cmd   ; NormCMD object

  ; === Update Common Stuff ===
  ; Instrument
  widget_ID = WIDGET_INFO(event.top, FIND_BY_UNAME='INSTRUMENT_SELECTED')
  dgsr_cmd->GetProperty, Instrument=myValue
  IF STRLEN(myValue) GT 1 THEN $
    WIDGET_CONTROL, widget_ID, SET_VALUE=myValue

  ; Number of Jobs
  widget_ID = WIDGET_INFO(event.top, FIND_BY_UNAME='DGS_REDUCTION_JOBS')
  dgsr_cmd->GetProperty, Jobs=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
 
  ; === Update the Reduction Tab ===
  DGSR_UpdateGUI, event.top, dgsr_cmd
  
  ; Update the Norm Mask Tab
  DGSN_UpdateGUI, event.top, dgsn_cmd

  ; Put info back
  WIDGET_CONTROL, event.top, SET_UVALUE=info, /NO_COPY

END