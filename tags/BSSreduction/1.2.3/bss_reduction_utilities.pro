FUNCTION ConvertListToInt, list
list_size = (size(list))(1)
j=0
FOR i=0,(list_size-1) DO BEGIN

    ON_IOERROR, L1     ;in case one of the variable can't be converted
    val = Fix(list[i])

    IF (j EQ 0) THEN BEGIN
        FinalList = [val]
        j++
    ENDIF ELSE BEGIN
        FinalList = [FinalList, val]
    ENDELSE

    L1: continue

ENDFOR
RETURN, FinalList
END
