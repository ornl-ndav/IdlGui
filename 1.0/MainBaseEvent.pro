PRO MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

CASE Event.id OF
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
    END
    
;1111111111111111111111111111111111111111111111111111111111111111111111111111111

;#1### NeXus Run Number ####
    widget_info(wWidget, FIND_BY_UNAME='nexus_run_number'): BEGIN
        LoadRunNumber, Event ;_Load
    END

    ELSE:
    
ENDCASE

END
