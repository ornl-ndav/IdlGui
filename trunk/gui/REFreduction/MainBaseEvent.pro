PRO MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

CASE Event.id OF
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
    end

;**LOAD TAB**
;LOAD DATA file button    

    widget_info(wWidget, FIND_BY_UNAME='load_data_run_number_button'): begin
        REFreduction_LoadDataFile, Event
    end

;**REDUCE TAB**

;**PLOTS TAB**

;**LOG_BOOK TAB**

;**SETTINGS TAB**

    ELSE:
    
ENDCASE

END
