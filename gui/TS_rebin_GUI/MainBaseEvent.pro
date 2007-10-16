PRO MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

CASE Event.id OF
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
    end

;run number
    Widget_Info(wWidget, FIND_BY_UNAME='runs'): begin
        ts_rebin_ValidateGoButtonAndBuildCMD, Event
    end

;instrument
    Widget_Info(wWidget, FIND_BY_UNAME='instrument'): begin
        ts_rebin_ValidateGoButtonAndBuildCMD, Event
    end

;Bin width
    Widget_Info(wWidget, FIND_BY_UNAME='bin_width'): begin
        ts_rebin_ValidateGoButtonAndBuildCMD, Event
    end

;Staging area text 
    Widget_Info(wWidget, FIND_BY_UNAME='staging_area_path'): begin
        ts_rebin_ValidateGoButtonAndBuildCMD, Event
    end

;Staging area button
    Widget_Info(wWidget, FIND_BY_UNAME='staging_area_button'): begin
        ts_rebin_StagingArea, Event
        ts_rebin_ValidateGoButtonAndBuildCMD, Event
    end

;Output path text
    Widget_Info(wWidget, FIND_BY_UNAME='output_path'): begin
        ts_rebin_ValidateGoButtonAndBuildCMD, Event
    end

;Output path button
    Widget_Info(wWidget, FIND_BY_UNAME='output_path_button'): begin
        ts_rebin_OutputPath, Event
        ts_rebin_ValidateGoButtonAndBuildCMD, Event
    end

;go button
    Widget_Info(wWidget, FIND_BY_UNAME='go'): begin
        ts_rebin_RunCMD, event
    end

    ELSE:
    
ENDCASE


END
