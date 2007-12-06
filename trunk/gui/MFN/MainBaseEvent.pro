PRO MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

CASE Event.id OF
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
    END
    
;Instrument
    widget_info(wWidget, FIND_BY_UNAME='instrument_droplist'): begin
        validateOrNotSecondPath, Event
    end

;Run Number 
    widget_info(wWidget, FIND_BY_UNAME='run_number_cw_field'): begin
        run_number, Event       ;in mfn_eventcb.pro
        validateOrNotGoButton, Event
    end
    
;Output path
    widget_info(wWidget, FIND_BY_UNAME='output_button'): begin
        output_path, Event      ;in mfn_eventcb.pro
        validateOrNotGoButton, Event
    end
    
;Output path text
    widget_info(wWidget, FIND_BY_UNAME='output_path_text'): begin
        validateOrNotGoButton, Event
    end
    
;Output path
    widget_info(wWidget, FIND_BY_UNAME='output_button2'): begin
        output_path2, Event     ;in mfn_eventcb.pro
    end
    
;Create NeXus
    widget_info(wWidget, FIND_BY_UNAME='create_nexus_button'): begin
        CreateNexus, Event
    end

    ELSE:
    
ENDCASE

END
