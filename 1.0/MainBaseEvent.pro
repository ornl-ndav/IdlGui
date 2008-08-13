PRO MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

CASE Event.id OF
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
    END
    
;111111111111111111111111111111111111111111111111111111111111111111111111111111

;Browse ASCII file button
    Widget_Info(wWidget, FIND_BY_UNAME='browse_ascii_file_button'): BEGIN
        browse_ascii_file, Event ;_browse_ascii
    END



;- LOG BOOK - LOG BOOK - LOG BOOK - LOG BOOK - LOG BOOK - LOG BOOK - LOG BOOK 
    Widget_Info(wWidget, FIND_BY_UNAME='send_to_geek_button'): BEGIN
        SendToGeek, Event ;_IDLsendToGeek
    END

    ELSE:
    
ENDCASE

END
