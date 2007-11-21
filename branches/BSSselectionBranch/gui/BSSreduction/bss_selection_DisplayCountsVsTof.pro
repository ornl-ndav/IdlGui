PRO BSSselection_DisplayCountsVsTof, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve bank, x and y infos
bank    = getBankValue(Event)
X       = getXValue(Event)
Y       = getYValue(Event)
PixelID = getPixelIDvalue(Event)

;display X, Y, Bank and pixelID value in counts vs tof info box
putCountsVsTofBankValue, Event, bank[0]
putCountsVsTofXValue, Event, X[0]
putCountsVsTofYValue, Event, Y[0]
putCountsVsTofPixelIDValue, Event, PixelID[0]

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

IF ((*global).PrevLinLogValue) THEN BEGIN ;log
    plot, data, POSITION=[0.1,0.1,0.95,0.99], /YLOG, MIN_VALUE=0.1
ENDIF ELSE BEGIN
    plot, data, POSITION=[0.1,0.1,0.95,0.99]
ENDELSE

END
