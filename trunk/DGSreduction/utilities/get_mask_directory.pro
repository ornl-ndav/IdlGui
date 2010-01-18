function get_mask_directory, instrument, run, HOME=HOME, OVERRIDE=OVERRIDE

  UNKNOWN = 0

  IF KEYWORD_SET(OVERRIDE) THEN BEGIN
    ; only return the override if it contains something!
    IF STRLEN(OVERRIDE) GE 1 THEN BEGIN
      ; Let's check to see if the directory exists
      directoryThere = FILE_TEST(OVERRIDE, /DIRECTORY)
      ; Make it if it doesn't exists (and we have asked for it to be created)
      return, OVERRIDE
    ENDIF
  ENDIF
  
  IF N_ELEMENTS(instrument) EQ 0 THEN UNKNOWN=1
  IF N_ELEMENTS(runnumber) EQ 0 THEN UNKNOWN=1
  
  ; If we don't know what the instrument or run number is then just write to
  ; the ~/results directory!
  IF (UNKNOWN EQ 1) THEN BEGIN
    output_directory  = '/SNS/users/' + get_ucams() + '/mask'
    return, output_directory
  ENDIF
  
  IF KEYWORD_SET(HOME) THEN BEGIN
    ; If we want to force the results to go into the users home directory
    ; then the easist way is the just set the proposal=0
    proposal = '0'
  ENDIF ELSE BEGIN
    beamtimeinfo_file = get_beamtimeinfo_filename(instrument, runnumber)
    IF (beamtimeinfo_file EQ 'ERROR') THEN BEGIN
      proposal = '0'
    ENDIF ELSE BEGIN
      proposal = getProposalfromPreNeXus(beamtimeinfo_file)
    ENDELSE
  ENDELSE
  
  IF (proposal NE '0') THEN BEGIN
    mask_directory  = '/SNS/' + STRUPCASE(STRCOMPRESS(string(instrument),/REMOVE_ALL))
    mask_directory += '/' + STRCOMPRESS(string(proposal),/REMOVE_ALL)
    mask_directory += '/shared/mask'
  ENDIF ELSE BEGIN
    mask_directory  = '/SNS/users/' + get_ucams() + '/mask'
  ENDELSE
  
  return, mask_directory


end