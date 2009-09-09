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


PRO findByRunNbr, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  choiceBox = WIDGET_INFO(Event.top, FIND_BY_UNAME='instChoice')
  textBox = WIDGET_INFO(Event.top, FIND_BY_UNAME='txtRunNbr')
  INSTRUMENT = WIDGET_INFO(choiceBox, /COMBOBOX_GETTEXT)
  WIDGET_CONTROL,textBox, GET_VALUE = runNbr
  
  command = 'findnexus -f SNS -i ' + instrument + ' ' + runNbr
  print, command
  SPAWN, command, path
  IF (path NE '') THEN BEGIN
    (*global).path = path
    print, (*global).path
  END
END

PRO fileBrowse, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  path = (*global).path
  
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
    (*global).path = new_path
    
    
    
    ;file_name = "/SNS/users/dfp/IdlGui/trunk/plotInstrument/NeXus/BSS_3753.nxs"
    
    print, file_name
    
  ;    ;data = readFile(Event, file_name)
  ;    fileStruct = H5_PARSE(file_name)
  ;    ;browse = H5_BROWSER(file_name)
  ;    help, fileStruct, /structure
  ;    structFields = tag_names(filestruct)
  ;    fileFields = structFields[where(strmatch(structfields, '_*') NE 1)]
  ;    print, fileFields
    
  ENDIF
  
END
;-------------------------------------------------------------------------------

PRO readFile, Event
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;for testing
  path = "/SNS/users/dfp/IdlGui/trunk/plotInstrument/NeXus/REF_M_5094.nxs"
  not_hdf5_format = 0
  CATCH, not_hdf5_format
  IF (not_hdf5_format NE 0) THEN BEGIN
    CATCH,/CANCEL
    ;display message about invalid file format
    print, "ERROR **********"
    print, not_hdf5_format
  ;   RETURN, 0
  ENDIF ELSE BEGIN
    print, 'opening file...'
    fileID    = H5F_OPEN(path)
    print, 'fileID'
    print, fileID
    data_path = '/entry-On_On/instrument/bank1/data'
    print, 'opening data path...'
    fieldID = H5D_OPEN(fileID,data_path)
    print, 'fieldID'
    print, fieldID
    data = H5D_READ(fieldID)
    help, data
    ;    print, data
    print, 'copied data...'
    H5D_CLOSE, fieldID
    H5F_CLOSE, fileID
    
    print, "saving data"
  ENDELSE
  
  (*global).data = ptr_new(data)
  graph, Event
  
;RETURN, data
END

PRO graph, Event
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  print, "graph"
  data = TOTAL(*(*global).data, 1)
  help, data
  T_2d_data = REBIN(TRANSPOSE(data), 304*10, 256*10)
  help, t_2d_data
  TVSCL, T_2d_data 
END

;------------------------------------------------------------------------------
PRO plotInstrument_eventcb, event
END

