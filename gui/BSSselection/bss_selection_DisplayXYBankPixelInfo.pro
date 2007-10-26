FUNCTION CalculatePixelID, Event, bank, x, y

IF (bank eq 1) then begin ;bank1

    return, (x*64+y)

ENDIF ELSE BEGIN ;bank2

    return, (x*64+y) + 4096
    
ENDELSE

END


PRO BSSselection_DisplayXYBankPixelInfo, Event, bank

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

x=(event.X)/(*global).Xfactor
y=(event.y)/(*global).Yfactor

IF (bank EQ 'bank1') THEN BEGIN ;bank1
    bank = 1
ENDIF ELSE BEGIN ;bank2
    bank = 2
ENDELSE

;display bank info
PutBankValue, Event, bank

;display X info
PutXValue, Event, x

;display Y info
PutYValue, Event, y

;calculate pixelid
pixelid = CalculatePixelID(Event, bank, x, y)
;display pixelid info
PutPixelIDValue, Event, pixelid

END
