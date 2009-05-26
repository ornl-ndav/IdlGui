FUNCTION Construct_DataPaths, lower, upper, job, totaljobs

  
  ; Work out what the lower/upper are for this jo

  IF (lower NE -1) AND (upper NE -1) THEN BEGIN
    banks_per_job = (float((upper - lower + 1)) / TotalJobs)
    ;print, (upper - lower + 1)
    ;print, banks_per_job, TotalJobs
    this_lower = ceil((job-1)*banks_per_job)+1
    this_upper = ceil(job*banks_per_job)
    IF (this_upper GT upper) THEN this_upper = upper
    IF (job EQ TotalJobs) THEN this_upper = upper
    datapaths=STRCOMPRESS(STRING(this_lower)) + "-" $
        + STRCOMPRESS(STRING(this_upper))
    RETURN, datapaths
  ENDIF
  
  IF (lower NE -1) AND (upper EQ -1) THEN BEGIN
    RETURN, STRING(lower)
  ENDIF
  
  IF (lower EQ -1) AND (upper NE -1) THEN BEGIN
    RETURN, STRING(upper)
  ENDIF

  RETURN, ""
 
END
