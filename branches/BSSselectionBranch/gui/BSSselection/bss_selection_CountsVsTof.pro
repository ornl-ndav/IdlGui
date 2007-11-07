PRO BSSselection_LinLogCountsVsTof, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get current selected value (lin or log)
CurrentValueSelected = getLinLogValue(Event)
PrevValueSelected = (*global).PrevLinLogValue

IF (CurrentValueSelected NE PrevValueSelected) THEN BEGIN
    (*global).PrevLinLogValue = CurrentValueSelected
    
;replot counts vs tof
    BSSselection_DisplayCountsVsTof, Event

ENDIF

END
