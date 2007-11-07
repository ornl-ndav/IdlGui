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


PRO BSSselection_LinLogFullCountsVsTof, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get current selected value (lin or log)
CurrentValueSelected = getFullLinLogValue(Event)
PrevValueSelected = (*global).PrevFullLinLogValue

IF (CurrentValueSelected NE PrevValueSelected) THEN BEGIN
    (*global).PrevFullLinLogValue = CurrentValueSelected
    
;replot counts vs tof
    BSSselection_DisplayFullCountsVsTof, Event, CurrentValueSelected

ENDIF
END



;type=0 -> linear | type=1 -> log
PRO BSSselection_DisplayFullCountsVsTof, Event, type

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

data = (*(*global).full_counts_vs_tof_data)

view_info = widget_info(Event.top,FIND_BY_UNAME='full_counts_vs_tof_draw')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id

IF (type EQ 0) THEN BEGIN
    plot, data, POSITION=[0.1,0.1,0.95,0.99]
ENDIF ELSE BEGIN
    plot, data, POSITION=[0.1,0.1,0.95,0.99], /YLOG, MIN_VALUE=0.1
ENDELSE
END




PRO BSSselection_PlotCountsVsTofOfSelection, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

bank1 = (*(*global).bank1)
bank2 = (*(*global).bank2)
pixel_excluded = (*(*global).pixel_excluded)

;initialize counts vs tof array
TOF_sz = (size(bank1))(1)
data = lonarr(TOF_sz)

sz = (size(pixel_excluded))(1)
total_pixel_excluded = total(pixel_excluded) ;number of pixel excluded

IF (total_pixel_excluded GE 4096) THEN BEGIN ;less pixel excluded than included
    data = lonarr(TOF_sz)
END

FOR i=0,(sz-1) DO BEGIN
    IF (total_pixel_excluded LT 4096) THEN BEGIN ;less pixel excluded than included
        IF (pixel_excluded[i] EQ 1) THEN BEGIN ;add data to final array
            XY = getXYfromPixelID_Untouched(i)
            IF (i LT 4096) THEN BEGIN
                bank1[*,XY[1],XY[0]]=0
            ENDIF ELSE BEGIN
                bank2[*,XY[1],XY[0]]=0
            ENDELSE
        ENDIF
    ENDIF ELSE BEGIN            ;more pixel excluded than included
        IF (pixel_excluded[i] EQ 0) THEN BEGIN
            XY = getXYfromPixelID_Untouched(i)

            IF (i LT 4096) THEN BEGIN
                data += bank1[*,XY[1],XY[0]]
            ENDIF ELSE BEGIN
                data += bank2[*,XY[1],XY[0]]
            ENDELSE
        ENDIF
    ENDELSE
ENDFOR

IF (total_pixel_excluded LT 4096) THEN BEGIN ;less pixel excluded than included
    data1 = total(bank1,2)
    data1 = total(data1,2)
    
    data2 = total(bank2,2)
    data2 = total(data2,2)
            
    data = data1 + data2
ENDIF

(*(*global).full_counts_vs_tof_data) = data

view_info = widget_info(Event.top,FIND_BY_UNAME='full_counts_vs_tof_draw')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id

;check status of lin/log
CurrentValueSelected = getFullLinLogValue(Event)
IF (CurrentValueSelected EQ 0) THEN BEGIN ;lin
    plot, data, POSITION=[0.1,0.1,0.95,0.99]
ENDIF ELSE BEGIN
    plot, data, POSITION=[0.1,0.1,0.95,0.99], /YLOG, MIN_VALUE=0.1
ENDELSE

END


;plot full counts_vs_tof
PRO BSSselection_PlotFullCountsVsTof, Event
BSSselection_PlotCountsVsTofOfSelection, Event
END




