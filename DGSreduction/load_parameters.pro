pro load_parameters, event, Filename=filename

  IF N_ELEMENTS(filename) EQ 0 THEN BEGIN
    filename = DIALOG_PICKFILE(Filter='*.sav')
  ENDIF

  print, 'Loading ALL parameters from ' + filename

  ;IF N_ELEMENTS(filename) EQ 0 THEN filename = '~/.sns/dgsreduction/dgs.par'
 
   ; Get the info structure
  WIDGET_CONTROL, event.top, GET_UVALUE=info, /NO_COPY
  
  RESTORE, FILENAME=filename
  
  info.dgsr_cmd = dgsr_cmd
  info.dgsn_cmd = dgsn_cmd
  
  ; Find the output window (DGS)
  dgs_cmd_outputID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGSR_CMD_TEXT')
  ; Update the output command window
  WIDGET_CONTROL, dgs_cmd_outputID, SET_VALUE=dgsr_cmd->generate()
  
  ; Find the output window (DGSN)
  dgsn_cmd_outputID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGSN_CMD_TEXT')
  ; Update the output command window
  WIDGET_CONTROL, dgsn_cmd_outputID, SET_VALUE=dgsn_cmd->generate()
    
  ; Put info back
  WIDGET_CONTROL, event.top, SET_UVALUE=info, /NO_COPY

  ; Now lets update the GUI
  DGSreduction_UpdateGUI, event

end