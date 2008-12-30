PRO BSSreduction_UpdatePixelIDField, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve bank, x and y infos
bank = getBankValue(Event)
X    = getXValue(Event)
Y    = getYValue(Event)

IF (IsXYRowTubePixelidBankInputCorrect(X=X,$
                                       Y=Y,$
                                       Bank=bank)) THEN BEGIN

    (*global).counts_vs_tof_bank = bank
    (*global).counts_vs_tof_x    = X
    (*global).counts_vs_tof_y    = Y
    
;calculate pixelid
    pixelid = CalculatePixelID(Event, bank, X, Y)
;display pixelid info
    PutPixelIDValue, Event, pixelid

ENDIF

END


PRO BSSreduction_UpdateXYBankFromRowTubeFields, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get row value
row = getRowValue(Event)
;get tube value
tube = getTubeValue(Event)

IF (IsXYRowTubePixelidBankInputCorrect(Row=Row,$
                                       Tube=Tube)) THEN BEGIN

    IF (row LT 64) THEN BEGIN
        Y = row
        bank = 1
    ENDIF ELSE BEGIN
        Y = row - 64
        bank = 2
    ENDELSE
    
    IF (tube LT 64) THEN BEGIN
        X = tube
    ENDIF ELSE BEGIN
        X = tube - 64
    ENDELSE
    
;update bank, X, Y
;put value in the cw_fields
    putXValue, Event, X
    putYValue, Event, Y
    putBankValue, Event, bank

ENDIF
    
END



PRO BSSreduction_UpdateXYBankFields, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve pixelID value
pixelid = getPixelIDvalue(Event)

IF (IsXYRowTubePixelidBankInputCorrect(Pixelid=Pixelid)) THEN BEGIN
    
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
    
ENDIF

END



PRO BSSreduction_UpdateRowTubefield, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve bank, x and y infos
bank = getBankValue(Event)
X    = getXValue(Event)
Y    = getYValue(Event)

IF (IsXYRowTubePixelidBankInputCorrect(X=X,$
                                       Y=Y,$
                                       Bank=bank)) THEN BEGIN

    IF (bank EQ 1) THEN BEGIN   ;row=Y and tube=X
        row = Y
        tube = X
    ENDIF ELSE BEGIN
        row = Y + 64
        tube = X + 64
    ENDELSE
    
;update row and tube
    putRowValue, Event, row
    putTubeValue, Event, tube

ENDIF

END
