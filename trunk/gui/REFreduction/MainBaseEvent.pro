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
        REFreductionEventcb_LoadAndPlotDataFile, Event
    end

;1D plot of DATA
    widget_info(wWidget, FIND_BY_UNAME='load_data_D_draw'): begin
        if( Event.type EQ 0 )then begin
            if (Event.press EQ 1) then $
                REFreduction_DataSelectionPressLeft, Event ;left button
            if (Event.press EQ 4) then $
              REFreduction_DataselectionPressRight, Event ;right button
        endif
        if (Event.type EQ 1) then $ ;release
          REFreduction_DataSelectionRelease, Event
        if (Event.type EQ 2) then $ ;move
          REFreduction_DataSelectionMove, Event
    end
    
    
;LOAD NORMALIZATION file button
    widget_info(wWidget, FIND_BY_UNAME='load_normalization_run_number_button'): begin
        REFreductionEventcb_LoadAndPlotNormalizationFile, Event
    end

;LOAD NORMALIZATION file button
    widget_info(wWidget, FIND_BY_UNAME='new_load_data_run_number_text_field'): begin
       print, 'here'
    end


;**REDUCE TAB**

;**PLOTS TAB**

;**LOG_BOOK TAB**

;**SETTINGS TAB**

    ELSE:
    
ENDCASE

END
