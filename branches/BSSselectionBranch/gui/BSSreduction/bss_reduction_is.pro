FUNCTION IsXYRowTubePixelidBankInputCorrect, X=X,$
                                             Y=Y,$
                                             Row=Row,$
                                             Tube=Tube,$
                                             Pixelid=Pixelid,$
                                             Bank=Bank

IF (n_elements(X) EQ 1) THEN BEGIN
    IF (~(X GE 0 AND X LT 56)) THEN RETURN, 0
ENDIF

IF (n_elements(Y) EQ 1) THEN BEGIN
    IF (~(Y GE 0 AND Y LT 64)) THEN RETURN, 0
ENDIF

IF (n_elements(Row) EQ 1) THEN BEGIN
    IF (~(Row GE 0 AND Row LT 128)) THEN RETURN, 0
ENDIF

IF (n_elements(Tube) EQ 1) THEN BEGIN
    IF (~((Tube GE 0 AND Tube LT 56) OR $
          (Tube GE 64 AND Tube LT 120))) THEN RETURN, 0
ENDIF

IF (n_elements(PixelID) EQ 1) THEN BEGIN
    IF (~((PixelID GE 0 AND PixelID LT 3584) OR $
          (PixelID GE 4096 AND PixelID LT 7680))) THEN RETURN, 0
ENDIF

IF (n_elements(Bank) EQ 1) THEN BEGIN
    IF (~(Bank EQ 1 OR Bank EQ 2)) THEN RETURN, 0
ENDIF

RETURN, 1
END




FUNCTION isPixelExcludedSymbolFull, Event
id = widget_info(Event.top,find_by_uname='excluded_pixel_type')
widget_control, id, get_value=value
RETURN, value
END


;if button click or not
FUNCTION isButtonSelected, Event, uname
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, get_value=value
RETURN, value
END


;if button is activated
FUNCTION isButtonEnabled, Event, uname
id = widget_info(Event.top,find_by_uname=uname)
sensitiveStatus = widget_info(id,/sensitive)
RETURN, sensitiveStatus
END


;if button is click and activated
FUNCTION isButtonSelectedAndEnabled, Event, uname
IF ((isButtonSelected(event,uname) EQ 1) AND $
    isButtonEnabled(event,uname) EQ 1) THEN BEGIN
    return, 1
ENDIF ELSE BEGIN
    return, 0
ENDELSE
END
