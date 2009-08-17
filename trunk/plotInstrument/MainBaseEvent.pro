;==============================================================================

PRO MAIN_BASE_event, Event

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
      INSTRUMENT = WIDGET_INFO(WIDGET_INFO(wWidget, FIND_BY_UNAME='instChoice'), /COMBOBOX_GETTEXT)
      WIDGET_CONTROL,Event.id, GET_VALUE = runNbr

      command = 'findnexus -f SNS -i ' + instrument + ' ' + runNbr
      print, command
      SPAWN, command, path
      IF (path NE '') THEN BEGIN
        (*global).path = path
        print, (*global).path
      END
    END
    
    
    ELSE:
    
  ENDCASE
  
END
