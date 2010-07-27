;==============================================================================

PRO graph, Event
  IDLsendToGeek_addLogBookText, Event, "graph function called"
  WIDGET_CONTROL, /HOURGLASS
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  cmbInst = WIDGET_INFO(Event.top, FIND_BY_UNAME='cmbInst')
  cmbPlot = WIDGET_INFO(Event.top, FIND_BY_UNAME='linlog')
  cmbDPath = WIDGET_INFO(Event.top, FIND_BY_UNAME='cmbDPath')
  cmbRebin = WIDGET_INFO(Event.top, FIND_BY_UNAME='cmbRebin')
  INSTRUMENT = WIDGET_INFO(cmbInst, /COMBOBOX_GETTEXT)
  dPath = WIDGET_INFO(cmbDPath, /COMBOBOX_GETTEXT)
  plot = WIDGET_INFO(cmbPlot, /COMBOBOX_GETTEXT)
  a = double(WIDGET_INFO(cmbRebin, /COMBOBOX_GETTEXT))
  rebin = [a,a]
  
  IDLsendToGeek_addLogBookText, Event, string(rebin)
  
  file_name = $
    '/SNS/users/dfp/IdlGui/trunk/plotInstrument/InstrumentData.xml'
  file = OBJ_NEW('PlotData', file_name)
  
  
  IF (*global).testing then begin
  ;(*global).path = "/SNS/users/dfp/IdlGui/trunk/plotInstrument/NeXus/BSS_3753.nxs"
  ;(*global).path = "/SNS/users/dfp/IdlGui/trunk/plotInstrument/NeXus/CNCS_355.nxs"
  ;(*global).path = "/SNS/EQSANS/2009_2_6_SCI/1/112/NeXus/EQSANS_112.nxs"
  ;(*global).path = "/SNS/users/dfp/IdlGui/trunk/plotInstrument/NeXus/ARCS_3481.nxs"
  ENDIF
  
  IDLsendToGeek_addLogBookText, Event, 'path: ' + (*global).path
  
  error = 0
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    IDLsendToGeek_addLogBookText, Event, "GRAPHING ERROR!!!"
    IDLsendToGeek_addLogBookText, Event, STRING(error)
  ENDIF ELSE BEGIN
    text = file -> Graph((*global).path, INSTRUMENT, rebin, plot, dPath)
    IDLsendToGeek_addLogBookText, Event, STRING(text)
  ENDELSE
  
  WIDGET_CONTROL, HOURGLASS=0
  IDLsendToGeek_addLogBookText, Event, "done"
END



PRO findByRunNbr, Event
  ;get global structure
  WIDGET_CONTROL, /HOURGLASS
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  cmbInst = WIDGET_INFO(Event.top, FIND_BY_UNAME='cmbInst')
  textBox = WIDGET_INFO(Event.top, FIND_BY_UNAME='txtRunNbr')
  INSTRUMENT = WIDGET_INFO(cmbInst, /COMBOBOX_GETTEXT)
  WIDGET_CONTROL,textBox, GET_VALUE = runNbr
  
  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    IDLsendToGeek_addLogBookText, Event, "ERROR!!!"
    IDLsendToGeek_addLogBookText, Event, STRING(error)
  ENDIF ELSE BEGIN
    command = 'findnexus -f SNS -i ' + instrument + ' ' + runNbr
    IDLsendToGeek_addLogBookText, Event, command
    SPAWN, command, path
    IDLsendToGeek_addLogBookText, Event, "========="
    
    IF (path NE '') THEN BEGIN
      (*global).path = path
    END
  ENDELSE
  IDLsendToGeek_addLogBookText, Event, 'path: ' + (*global).path
  
  WIDGET_CONTROL, HOURGLASS=0
END

PRO fileBrowse, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  path = (*global).work_path
  
  title = 'Select a NeXus File to Load'
  filter = '*.nxs'
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  
  file_name = DIALOG_PICKFILE(FILTER=filter,$
    GET_PATH=new_path,$
    /MUST_EXIST,$
    PATH=path,$
    TITLE=title,$
    /READ,$
    DIALOG_PARENT=id)
    
  (*global).work_path = new_path
  
  IF (file_name NE '') THEN BEGIN
    (*global).path = file_name
  ENDIF
  
  
  IDLsendToGeek_addLogBookText, Event, 'path: ' + (*global).path
END

PRO MAIN_BASE_EVENT, event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  wWidget =  Event.top            ;widget id
  
  
  
  
  CASE Event.id OF
  
    WIDGET_INFO(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
    END
    
    ;Load Command Line File Button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='loadFile'): BEGIN
      fileBrowse, Event ;_browse
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='txtRunNbr'): BEGIN
      findByRunNbr, Event
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='Search'): BEGIN
      findByRunNbr, Event
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='graph'): BEGIN
      graph, Event
    END
;    WIDGET_INFO(wWidget, FIND_BY_UNAME='cmbInst'): BEGIN
;      findByRunNbr, Event
;    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='send_to_geek_button'): BEGIN
      SendToGeek, Event
    END
    
    
    
    ELSE:
    
  ENDCASE
  
  
  
END

