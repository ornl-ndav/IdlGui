PRO DGSR_UpdateGUI, tlb, dgsr_cmd

  ; Run Number
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSR_DATARUN')
  dgsr_cmd->GetProperty, DataRun=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue

  
  

END