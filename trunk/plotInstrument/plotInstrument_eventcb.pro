;==============================================================================

;PRO send_to_geek, Event
;;  cmd_file = getTextFieldValue(Event,'cl_file_name_label')
;;  IF (cmd_file NE 'N/A') THEN BEGIN
;;    list_of_files = [cmd_file]
;;    IDLsendLogBook_SendToGeek, Event, $
;;      LIST_OF_FILES_TO_TAR=list_of_files
;;  ENDIF ELSE BEGIN
;;    IDLsendLogBook_SendToGeek, Event
;;  ENDELSE
;END
;
;;;------------------------------------------------------------------------------
;;PRO MAIN_REALIZE, wWidget
;;  ;indicate initialization with hourglass icon
;;  WIDGET_CONTROL,/HOURGLASS
;;
;;  ;tlb = get_tlb(wWidget)
;;
;;  ;turn off hourglass
;;  WIDGET_CONTROL,HOURGLASS=0
;;END



PRO setConstants, Event
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  cmbInst = WIDGET_INFO(Event.top, FIND_BY_UNAME='cmbInst')
  cmbDPath = WIDGET_INFO(Event.top, FIND_BY_UNAME= "cmbDPath")
  instrument = WIDGET_INFO(cmbInst, /COMBOBOX_GETTEXT)
  
  CASE instrument OF
  
    "REF_L": BEGIN
      PRINT, 'SETTING CONSTANSTS FOR REF_L'
      X = 304
      Y = 256
      R = 2
      dPath = ['/entry/instrument/bank1/data']
      
    END
    
    "REF_M": BEGIN
      PRINT, 'SETTING CONSTANSTS FOR REF_M'
      X = 256
      Y = 304
      R = 2
      dPath = ['/entry-Off_Off/instrument/bank1/data', $
        '/entry-Off_On/instrument/bank1/data', $
        '/entry-On_Off/instrument/bank1/data', $
        '/entry-On_On/instrument/bank1/data']
        
    END
    
    ELSE: BEGIN
      X = 0
      Y = 0
      R = 0
      dPath = ['']
    END
    
  ENDCASE
  
  (*global).instConst.X = X
  (*global).instConst.Y = Y
  (*global).instConst.rebinBy = R
  WIDGET_CONTROL, cmbDPath, SET_VALUE = dPath
  
END


PRO updatePath, Event
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  idPath = WIDGET_INFO(Event.top, FIND_BY_UNAME="pathLabel")
  IF (*global).path NE "" THEN BEGIN
    WIDGET_CONTROL, idPath, SET_VALUE = "Path: " + (*global).path
    setConstants, Event
  ENDIF ELSE BEGIN
    WIDGET_CONTROL, idPath, SET_VALUE = "Path: no path"
  ENDELSE
END



PRO findByRunNbr, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  cmbInst = WIDGET_INFO(Event.top, FIND_BY_UNAME='cmbInst')
  textBox = WIDGET_INFO(Event.top, FIND_BY_UNAME='txtRunNbr')
  INSTRUMENT = WIDGET_INFO(cmbInst, /COMBOBOX_GETTEXT)
  WIDGET_CONTROL,textBox, GET_VALUE = runNbr
  
  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    print, "ERROR!!!"
    print, error
  ENDIF ELSE BEGIN
    command = 'findnexus -f SNS -i ' + instrument + ' ' + runNbr
    print, command
    SPAWN, command, path
    IF (path NE '') THEN BEGIN
      (*global).path = path
      print, (*global).path
    END
  ENDELSE
  updatePath, Event
  
END

PRO fileBrowse, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  path = '~/'
  
  
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
    
  IF (file_name NE '') THEN BEGIN
    (*global).path = file_name
    
    
    
  ;file_name = "/SNS/users/dfp/IdlGui/trunk/plotInstrument/NeXus/BSS_3753.nxs"
    
    
    
  ;    ;data = readFile(Event, file_name)
  ;    fileStruct = H5_PARSE(file_name)
  ;    ;browse = H5_BROWSER(file_name)
  ;    help, fileStruct, /structure
  ;    structFields = tag_names(filestruct)
  ;    fileFields = structFields[where(strmatch(structfields, '_*') NE 1)]
  ;    print, fileFields
    
  ENDIF
  updatePath, Event
END
;-------------------------------------------------------------------------------

PRO readFile, Event
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  cmbDPath = WIDGET_INFO(Event.top, FIND_BY_UNAME= "cmbDPath")
  dPath = WIDGET_INFO(cmbDPath, /COMBOBOX_GETTEXT)
  
  ;for testing
    ;PATH = "/SNS/BSS/IPTS-842/7/1215/NeXus/BSS_1215.nxs"
  path = (*global).path
  
  ;TESTING
  ;PATH = "/SNS/REF_L/2007_2_4B_SCI/2/3132/NeXus/REF_L_3132.nxs"
  
  
  not_hdf5_format = 0
  CATCH, not_hdf5_format
  IF (not_hdf5_format NE 0) THEN BEGIN
    CATCH,/CANCEL
    ;display message about invalid file format
    print, "ERROR **********"
    print, not_hdf5_format
  ENDIF ELSE BEGIN
    print, 'opening file...'
    print, path
    fileID    = H5F_OPEN(path)
    print, 'fileID'
    print, fileID
    print, 'opening data path...'
    print, dpath
    help, dpath
    fieldID = H5D_OPEN(fileID,dPath)
    print, 'fieldID'
    print, fieldID
    data = H5D_READ(fieldID)
    help, data
    print, 'copied data...'
    H5D_CLOSE, fieldID
    H5F_CLOSE, fileID
    
    print, "saving data"
    (*global).data = ptr_new(data)
    graph, Event
    
  ENDELSE
  
  
  
;RETURN, data
END

PRO graph, Event
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  print, "recalculating"
  r = (*global).instConst.rebinBy
  X = (*global).instConst.X
  Y = (*global).instConst.Y
  rX = X * r
  rY = Y * r
  help, rX, rY
  
  data = TOTAL(*(*global).data, 1)
  help, data
  
  print, n_elements(DATA)
  
  T_2d_data = REBIN(TRANSPOSE(data), rY, rX)
  help, t_2d_data
  print, 'graphing'
  WINDOW, 0, XSIZE = rY, YSIZE = rX, TITLE = (*global).path
  TVSCL, T_2d_data
END

;------------------------------------------------------------------------------
PRO plotInstrument_eventcb, event
END

