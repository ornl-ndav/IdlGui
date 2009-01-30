PRO MAIN_BASE_event, Event
 
;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

wWidget =  Event.top            ;widget id

CASE Event.id OF
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
    END
    
;- LOG BOOK - LOG BOOK - LOG BOOK - LOG BOOK - LOG BOOK - LOG BOOK - LOG BOOK 
    WIDGET_INFO(wWidget, FIND_BY_UNAME='send_to_geek_button'): BEGIN
    END

    ELSE:
    
ENDCASE

END
