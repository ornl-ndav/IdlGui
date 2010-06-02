;+
; :Description:
;    Takes the string entered in the GUI and expands it to return an array of run numbers.
;    There will be one element for each separate run number.
;    e.g. 1,2,4 returns an 3-element array [1,2,4]
;         1-5 returns a 5-element array [1,2,3,4,5]
;
; :Params:
;    RunString - the string containing the run numbers from the GUI widget
;
; :Author: scu
;-
FUNCTION ExpandIndividualRunNumbers, RunString

  ; Calculate how many Reduction jobs we are doing
  DataRunString = STRSPLIT(RunString, ",", /EXTRACT)
  
  ; Now lets loop over the individual runs to see if they need to be split out more
  FOR i = 0L, N_ELEMENTS(DATARUNSTRING)-1 DO BEGIN
  
    temp = STRSPLIT(DATARUNSTRING[i], "-", /EXTRACT)
    
    ; If the temp array is more than 2 elements long, it means that we have more
    ; than one ':' in the section.  This is an error.
    IF (N_ELEMENTS(temp) GT 2) THEN BEGIN
      RETURN, ['ERROR',"There is a problem parsing your run numbers.  You have specified too many -'s."]
    END
    
    ; Have we found a "-" ?
    IF (N_ELEMENTS(temp) EQ 2) THEN BEGIN
      ; Expand the sequence
      first = LONG(temp[0])
      last = LONG(temp[1])
      FOR j = first, last DO BEGIN
        IF (j EQ LONG(first)) THEN BEGIN
          temp = [STRCOMPRESS(STRING(j), /REMOVE_ALL)]
        ENDIF ELSE BEGIN
          temp = [temp,[STRCOMPRESS(STRING(j), /REMOVE_ALL)]]
        ENDELSE
      ENDFOR
    ENDIF
    
    IF (i EQ 0) THEN BEGIN
      RunsArray = temp
    ENDIF ELSE BEGIN
      RunsArray = [RunsArray, [temp]]
    ENDELSE
    
  ENDFOR
  
  
  RETURN, RunsArray
  
END