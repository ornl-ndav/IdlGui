PRO BSSselection_DisplayCountsVsTof, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve bank, x and y infos
bank = getBankValue(Event)
X    = getXValue(Event)
Y    = getYValue(Event)

(*global).counts_vs_tof_x = X
(*global).counts_vs_tof_y = Y
(*global).counts_vs_tof_bank = bank

IF (bank EQ 1) THEN BEGIN ;bank1
    bank = (*(*global).bank1)
ENDIF ELSE BEGIN ;bank2
    bank = (*(*global).bank2)
ENDELSE

data = bank(*,Y,X)

;plot data (counts vs tof)
view_info = widget_info(Event.top,FIND_BY_UNAME='counts_vs_tof_draw')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id

plot, data, POSITION=[0.1,0.1,0.95,0.99]

END
