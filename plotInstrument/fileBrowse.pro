;==============================================================================

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
    
    ;data = readFile(Event, file_name)
    fileStruct = H5_PARSE(file_name)
    ;browse = H5_BROWSER(file_name)
    help, fileStruct, /structure
    structFields = tag_names(filestruct)
    fileFields = structFields[where(strmatch(structfields, '_*') NE 1)]
    print, fileFields
    
  ENDIF
  
END
;-------------------------------------------------------------------------------

FUNCTION readFile, Event, path
  not_hdf5_format = 0
  CATCH, not_hdf5_format
  IF (not_hdf5_format NE 0) THEN BEGIN
    CATCH,/CANCEL
    ;display message about invalid file format
    print, "ERROR **********"
    print, not_hdf5_format
    RETURN, 0
  ENDIF ELSE BEGIN
    print, 'opening file...'
    fileID    = H5F_OPEN(path)
    print, 'fileID'
    print, fileID
    data_path = '/entry/instrument/bank1/data'
    print, 'opening data path...'
    fieldID = H5D_OPEN(fileID,data_path)
    print, 'fieldID'
    print, fieldID
    data = H5D_READ(fieldID)
    help, data
    ;    print, data
    print, 'copied data...'
    H5D_CLOSE, fieldID
    
  ; H5D_CLOSE, fileID
    
    
  ENDELSE
  RETURN, data
END

