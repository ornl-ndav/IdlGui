PRO DGSreduction_UpdateGUI, widgetBase

  ;print, '==UpdateGUI=='
  ;help,/str,event

  ; Get the info structure
  WIDGET_CONTROL, widgetBase, GET_UVALUE=info, /NO_COPY

  ; extract the command object into a separate
  dgsr_cmd = info.dgsr_cmd    ; ReductionCMD object
  dgsn_cmd = info.dgsn_cmd   ; NormCMD object

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
 
  IF (myValue GT 1) THEN BEGIN
    dgsr_collector_button = WIDGET_INFO(widgetBase,FIND_BY_UNAME='DGSR_LAUNCH_COLLECTOR_BUTTON')
    WIDGET_CONTROL, dgsr_collector_button, SENSITIVE=1
  ENDIF
 
  ; === Update the Reduction Tab ===
  DGSR_UpdateGUI, widgetBase, dgsr_cmd
  
  ; Update the Norm Mask Tab
  DGSN_UpdateGUI, widgetBase, dgsn_cmd

  
  status = dgsr_cmd->Check()
  
  ; Find the Status message window
  dgsr_infoID = WIDGET_INFO(widgetBase, FIND_BY_UNAME='DGSR_INFO_TEXT')
  WIDGET_CONTROL, dgsr_infoID, SET_VALUE=status.message

  ; Put info back
  WIDGET_CONTROL, widgetBase, SET_UVALUE=info, /NO_COPY

END