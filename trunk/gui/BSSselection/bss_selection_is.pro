FUNCTION IsXYRowTubePixelidBankInputCorrect, X=X,$
                                             Y=Y,$
                                             Row=Row,$
                                             Tube=Tube,$
                                             Pixelid=Pixelid,$
                                             Bank=Bank

IF (n_elements(X) EQ 1) THEN BEGIN
    IF (~(X GE 0 AND X LT 56)) THEN return, 0
ENDIF

IF (n_elements(Y) EQ 1) THEN BEGIN
    IF (~(Y GE 0 AND Y LT 64)) THEN return, 0
ENDIF

IF (n_elements(Row) EQ 1) THEN BEGIN
    IF (~(Row GE 0 AND Row LT 128)) THEN return, 0
ENDIF

IF (n_elements(Tube) EQ 1) THEN BEGIN
    IF (~((Tube GE 0 AND Tube LT 56) OR $
          (Tube GE 64 AND Tube LT 120))) THEN return, 0
ENDIF

IF (n_elements(PixelID) EQ 1) THEN BEGIN
    IF (~((PixelID GE 0 AND PixelID LT 3584) OR $
          (PixelID GE 4096 AND PixelID LT 7680))) THEN return, 0
ENDIF

IF (n_elements(Bank) EQ 1) THEN BEGIN
    IF (~(Bank EQ 1 OR Bank EQ 2)) THEN return, 0
ENDIF

return, 1
END
