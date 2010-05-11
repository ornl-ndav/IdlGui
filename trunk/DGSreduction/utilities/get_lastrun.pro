function get_lastrun, instrument

  Catch, theError
  IF theError NE 0 THEN BEGIN
    CATCH, /CANCEL
    ; If we have an error, then just return a sensible default
    return, '0'
  ENDIF
  
  lastrun_exe = 'lastrun'
  lastrun_cmd = lastrun_exe + " " + instrument
  ; Actually run the command
  spawn, lastrun_cmd, listening
  
  ;listening="facil=SNS, inst=CNCS, lastrun=11217"
  
  position = STRPOS(listening, "lastrun=")
  ; Now add on the length of "lastrun="
  position += 8
  
  runstring = STRCOMPRESS(STRMID(listening, position), /REMOVE_ALL)
  
  return, runstring
end
