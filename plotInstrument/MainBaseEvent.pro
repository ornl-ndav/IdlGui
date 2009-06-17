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
    
   
       
    ELSE:
    
  ENDCASE
  
END
