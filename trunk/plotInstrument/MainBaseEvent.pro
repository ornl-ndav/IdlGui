;==============================================================================

PRO graph, Event
  print, "graph function called"
  WIDGET_CONTROL, /HOURGLASS
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  cmbInst = WIDGET_INFO(Event.top, FIND_BY_UNAME='cmbInst')
  cmbPlot = WIDGET_INFO(Event.top, FIND_BY_UNAME='linlog')
  cmbRebin = WIDGET_INFO(Event.top, FIND_BY_UNAME='cmbRebin')
  INSTRUMENT = WIDGET_INFO(cmbInst, /COMBOBOX_GETTEXT)
  plot = WIDGET_INFO(cmbPlot, /COMBOBOX_GETTEXT)
  a = fix(WIDGET_INFO(cmbRebin, /COMBOBOX_GETTEXT))
  rebin = [a,a]
  print, rebin
  
  file_name = $
    '/SNS/users/dfp/IdlGui/trunk/plotInstrument/InstrumentData.xml'
  file = OBJ_NEW('PlotData', file_name)
  print, (*global).path
  
  ;DEBUG /remove
  (*global).path = "/SNS/users/dfp/IdlGui/trunk/plotInstrument/NeXus/BSS_3753.nxs"
  ;(*global).path = "/SNS/users/dfp/IdlGui/trunk/plotInstrument/NeXus/CNCS_355.nxs"
  ;(*global).path = "/SNS/EQSANS/2009_2_6_SCI/1/112/NeXus/EQSANS_112.nxs"
  ;(*global).path = "/SNS/users/dfp/IdlGui/trunk/plotInstrument/NeXus/ARCS_3481.nxs"
  
  text = file -> Graph((*global).path, INSTRUMENT, rebin, plot)
  WIDGET_CONTROL, HOURGLASS=0
  print, "done"
END

PRO updatePath, Event
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  idPath = WIDGET_INFO(Event.top, FIND_BY_UNAME="pathLabel")
  IF (*global).path NE "" THEN BEGIN
    WIDGET_CONTROL, idPath, SET_VALUE = "Path: " + (*global).path
  ENDIF ELSE BEGIN
    WIDGET_CONTROL, idPath, SET_VALUE = "Path: no path"
  ENDELSE
END

PRO findByRunNbr, Event
  ;get global structure
  WIDGET_CONTROL, /HOURGLASS
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  cmbInst = WIDGET_INFO(Event.top, FIND_BY_UNAME='cmbInst')
  textBox = WIDGET_INFO(Event.top, FIND_BY_UNAME='txtRunNbr')
  INSTRUMENT = WIDGET_INFO(cmbInst, /COMBOBOX_GETTEXT)
  WIDGET_CONTROL,textBox, GET_VALUE = runNbr
  
  ;  error = 0
  ;  CATCH, error
  ;  IF (error NE 0) THEN BEGIN
  ;    CATCH,/CANCEL
  ;    print, "ERROR!!!"
  ;    print, error
  ;  ENDIF ELSE BEGIN
  command = 'findnexus -f SNS -i ' + instrument + ' ' + runNbr
  print, command
  SPAWN, command, path
  print, "========="
  
  IF (path NE '') THEN BEGIN
    (*global).path = path
    print, (*global).path
  END
  ;ENDELSE
  updatePath, Event
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
  
  
  updatePath, Event
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
    WIDGET_INFO(wWidget, FIND_BY_UNAME='cmbInst'): BEGIN
      findByRunNbr, Event
    END
    
    
    ELSE:
    
  ENDCASE
  
;updateStatus, Event
  
  
END

