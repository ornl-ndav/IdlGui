PRO BSSselection_UpdatePixelIDField, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve bank, x and y infos
bank = getBankValue(Event)
X    = getXValue(Event)
Y    = getYValue(Event)

(*global).counts_vs_tof_bank = bank
(*global).counts_vs_tof_x    = X
(*global).counts_vs_tof_y    = Y

;calculate pixelid
pixelid = CalculatePixelID(Event, bank, X, Y)
;display pixelid info
PutPixelIDValue, Event, pixelid

END


PRO BSSselection_UpdateXYBankFields, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve pixelID value
pixelid = getPixelIDvalue(Event)

;determine X, Y and bank info
IF (pixelid LT 4096) THEN BEGIN
    bank = 1
ENDIF ELSE BEGIN
    bank = 2
    pixelid -= 4096
ENDELSE
y = (pixelid MOD 64)
x = (pixelid / 64)

;put value in the cw_fields
putXValue, Event, x
putYValue, Event, y
putBankValue, Event, bank

END



PRO BSSselection_UpdateRowTubefield, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve bank, x and y infos
bank = getBankValue(Event)
X    = getXValue(Event)
Y    = getYValue(Event)

IF (bank EQ 1) THEN BEGIN ;row=Y and tube=X
    row = Y
    tube = X
ENDIF ELSE BEGIN
    row = Y + 64
    tube = X + 64
ENDELSE

;update row and tube
putRowValue, Event, row
putTubeValue, Event, tube

END
