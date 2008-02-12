FUNCTION StringSplit, delimiter, text
RETURN, strsplit(text, delimiter,/extract)
END



FUNCTION CreateList, text2
ON_IOERROR, L1 ;in case one of the variable can't be converted
;into an int
FixText2 = Fix(Text2)
min = MIN(FixText2,MAX=max)
list = lonarr(1)
list[0] = min
FOR i=1,(max-min) DO BEGIN
    list = [list,min+i]
ENDFOR
RETURN, list
return, [val1,val2]
L1: return, ''
END



FUNCTION RetrieveList, text
;parse according to ','
text1 = StringSplit(',',text)
;parse accordint to '-'
sz = (size(text1))(1)
FOR i=0,(sz-1) DO BEGIN
    text2 = StringSplit('-',text1[i])
    sz = (size(text2))(1)
    IF (sz GT 1) THEN BEGIN ;'10-15'
        list_to_add = CreateList(text2)
        IF (list_to_add NE [''] OR $
            list_to_add[0] EQ 0) THEN BEGIN
            list_to_add = string(list_to_add)
            IF (i EQ 0) THEN BEGIN ;only for first iteration
                List = list_to_add
            ENDIF ELSE BEGIN
                List = [List, list_to_add]
            ENDELSE
        ENDIF
    ENDIF ELSE BEGIN ;10
        IF (i EQ 0) THEN BEGIN ;only for first iteration
            List = text2
        ENDIF ELSE BEGIN
            List = [List, text2]
        ENDELSE
    ENDELSE
ENDFOR
return, List
END



PRO AddListToExcludeList, Event, PixelidListInt
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

pixel_excluded = (*(*global).pixel_excluded)
TotalPixels = (*global).TotalPixels

sz = (size(PixelidListInt))(1)
FOR i=0,(sz-1) DO BEGIN
    IF (PixelidListInt[i] LE (TotalPixels)) THEN BEGIN
        pixel_excluded[PixelidListInt[i]] = 1
    ENDIF
ENDFOR
(*(*global).pixel_excluded) = pixel_excluded

END



PRO RemoveListToExcludeList, Event, PixelidListInt
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

pixel_excluded = (*(*global).pixel_excluded)
TotalPixels = (*global).TotalPixels

sz = (size(PixelidListInt))(1)
FOR i=0,(sz-1) DO BEGIN
    IF (PixelidListInt[i] LT (TotalPixels)) THEN BEGIN
        pixel_excluded[PixelidListInt[i]] = 0
    ENDIF
ENDFOR
(*(*global).pixel_excluded) = pixel_excluded

END


PRO AddRowToExcludeList, Event, RowListInt
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

pixel_excluded = (*(*global).pixel_excluded)
TotalRows = (*global).TotalRows

sz = (size(RowListInt))(1)
FOR i=0,(sz-1) DO BEGIN
    
    IF (RowListINT[i] LT TotalRows) THEN BEGIN
        
        IF (RowListINT[i] GT 63) THEN BEGIN
            offset = 4096-64
        ENDIF ELSE BEGIN
            offset = 0
        ENDELSE
        FOR j=0,55 DO BEGIN
            pixel_excluded[(RowListInt[i])+j*64+offset] = 1
        ENDFOR
    ENDIF

ENDFOR
(*(*global).pixel_excluded) = pixel_excluded
END



PRO RemoveRowToExcludeList, Event, RowListInt
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

pixel_excluded = (*(*global).pixel_excluded)
TotalRows = (*global).TotalRows

sz = (size(RowListInt))(1)
FOR i=0,(sz-1) DO BEGIN
    
    IF (RowListINT[i] LT TotalRows) THEN BEGIN
        
        IF (RowListINT[i] GT 63) THEN BEGIN
            offset = 4096
        ENDIF ELSE BEGIN
            offset = 0
        ENDELSE
        
        FOR j=0,56 DO BEGIN
            pixel_excluded[RowListInt[i]+j*64+offset] = 0
        ENDFOR

    ENDIF

ENDFOR
(*(*global).pixel_excluded) = pixel_excluded
END


PRO AddTubeToExcludeList, Event, TubeListInt
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

pixel_excluded = (*(*global).pixel_excluded)
TotalTubes = (*global).TotalTubes

sz = (size(TubeListInt))(1)
FOR i=0,(sz-1) DO BEGIN
    
    IF (TubeListInt[i] LT TotalTubes) THEN BEGIN

        FOR j=0,63 DO BEGIN
            pixel_excluded[TubeListInt[i]*64+j] = 1
        ENDFOR

    ENDIF

ENDFOR
(*(*global).pixel_excluded) = pixel_excluded
END



PRO RemoveTubeToExcludeList, Event, TubeListInt
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

pixel_excluded = (*(*global).pixel_excluded)
TotalTubes = (*global).TotalTubes

sz = (size(TubeListInt))(1)
FOR i=0,(sz-1) DO BEGIN
    
    IF (TubeListInt[i] LT TotalTubes) THEN BEGIN
        
        FOR j=0,63 DO BEGIN
            pixel_excluded[TubeListInt[i]*64+j] = 0
        ENDFOR

    ENDIF

ENDFOR
(*(*global).pixel_excluded) = pixel_excluded
END



PRO AddPixelsToExcludedList, Event, Counts
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

pixel_excluded = (*(*global).pixel_excluded)

;check value that are <= Counts in bank1
bank1_integrated_counts = (*(*global).bank1_sum)
sz_1 = (size(bank1_integrated_counts))(1) * (size(bank1_integrated_counts))(2)
FOR i=0,(sz_1-1) DO BEGIN
    IF (bank1_integrated_counts[i] LE Counts) THEN BEGIN
        pixel_excluded[i]=1
    ENDIF 
ENDFOR

print, sz_1
;check value that are <= Counts in bank2
bank2_integrated_counts = (*(*global).bank2_sum)
sz_2 = (size(bank2_integrated_counts))(1) * (size(bank2_integrated_counts))(2)
FOR i=0,(sz_2-1) DO BEGIN
    IF (bank2_integrated_counts[i] LE Counts) THEN BEGIN
        pixel_excluded[i+4096] = 1
    ENDIF
ENDFOR
(*(*global).pixel_excluded) = pixel_excluded

END
