;+
; :Description:
;    Returns the string representation of the datapaths.
;    e.g. "1-23" or "001-023"
;
; :Params:
;    lower
;    upper
;    job
;    totaljobs
;
; :Keywords:
;    PAD - pads with 0's to return a 3-character string
;
; :Author: scu
;-
FUNCTION Construct_DataPaths, lower, upper, job, totaljobs, PAD=pad

  ; Sanity checking
  IF N_ELEMENTS(lower) EQ 0 THEN lower = 0
  IF N_ELEMENTS(upper) EQ 0 THEN upper = 0
  
  ; If either of the banks are -ve, then ignore
  IF (lower LT 0) THEN lower = 0
  IF (upper LT 0) THEN upper = 0
  
  ; Work out what the lower/upper are for this jo

  IF (lower NE 0) AND (upper NE 0) THEN BEGIN
    IF (totaljobs EQ 1) THEN BEGIN
      this_lower = lower
      this_upper = upper
    ENDIF ELSE BEGIN
      banks_per_job = ceil(float((upper - lower + 1)) / TotalJobs)
      ;print, (upper - lower + 1)
      ;print, banks_per_job, TotalJobs
      this_lower = ceil((job-1)*banks_per_job)+lower
      this_upper = ceil(job*banks_per_job)+(lower-1)
      IF (this_upper GT upper) THEN this_upper = upper
      IF (job EQ TotalJobs) THEN this_upper = upper
    ENDELSE
    
    IF KEYWORD_SET(PAD) THEN BEGIN
      this_lower = formatBankNumber(this_lower)
      this_upper = formatBankNumber(this_upper)
      
    ENDIF
  
    datapaths=STRCOMPRESS(STRING(this_lower), /REMOVE_ALL) + "-" $
        + STRCOMPRESS(STRING(this_upper), /REMOVE_ALL)
    RETURN, datapaths
  ENDIF
  
  IF (lower NE 0) AND (upper EQ 0) THEN BEGIN
    IF KEYWORD_SET(PAD) THEN BEGIN
      RETURN, formatBankNumber(lower)
    ENDIF ELSE BEGIN
      RETURN, STRING(STRCOMPRESS(lower, /REMOVE_ALL))
    ENDELSE
  ENDIF
  
  IF (lower EQ 0) AND (upper NE 0) THEN BEGIN
      IF KEYWORD_SET(PAD) THEN BEGIN
      RETURN, formatBankNumber(lower)
    ENDIF ELSE BEGIN
      RETURN, STRING(STRCOMPRESS(upper, /REMOVE_ALL))
    ENDELSE
  ENDIF

  RETURN, ""
 
END
