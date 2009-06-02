FUNCTION Construct_DataPaths, lower, upper, job, totaljobs

  ; Sanity checking
  IF (lower EQ "") THEN lower = -1  
  IF (upper EQ "") THEN upper = -1
  
  
  ; Work out what the lower/upper are for this jo

  IF (lower NE -1) AND (upper NE -1) THEN BEGIN
    banks_per_job = (float((upper - lower + 1)) / TotalJobs)
    ;print, (upper - lower + 1)
    ;print, banks_per_job, TotalJobs
    this_lower = ceil((job-1)*banks_per_job)+1
    this_upper = ceil(job*banks_per_job)
    IF (this_upper GT upper) THEN this_upper = upper
    IF (job EQ TotalJobs) THEN this_upper = upper
    datapaths=STRCOMPRESS(STRING(this_lower), /REMOVE_ALL) + "-" $
        + STRCOMPRESS(STRING(this_upper), /REMOVE_ALL)
    RETURN, datapaths
  ENDIF
  
  IF (lower NE -1) AND (upper EQ -1) THEN BEGIN
    RETURN, STRING(STRCOMPRESS(lower, /REMOVE_ALL))
  ENDIF
  
  IF (lower EQ -1) AND (upper NE -1) THEN BEGIN
    RETURN, STRING(STRCOMPRESS(upper, /REMOVE_ALL))
  ENDIF

  RETURN, ""
 
END
