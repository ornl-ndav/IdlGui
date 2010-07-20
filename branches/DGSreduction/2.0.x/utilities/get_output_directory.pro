function get_output_directory, instrument, runnumber, HOME=HOME, $
    CREATE=CREATE, OVERRIDE=OVERRIDE, LABEL=LABEL, NO_USERDIR=NO_USERDIR
    
  ;  print, 'START@GET_OUTPUT_DIRECTORY()', systime()
    
  UNKNOWN = 0
  output_directory = ''
  
  IF KEYWORD_SET(OVERRIDE) THEN BEGIN
    ; only return the override if it contains something!
    IF STRLEN(OVERRIDE) GE 1 THEN BEGIN
      ; Let's check to see if the directory exists
      directoryThere = FILE_TEST(OVERRIDE, /DIRECTORY)
      ; Make it if it doesn't exists (and we have asked for it to be created)
      IF (directoryThere EQ 0) AND KEYWORD_SET(CREATE) THEN BEGIN
        print, 'Creating directory ',OVERRIDE
        spawn, 'mkdir -p ' + OVERRIDE
      ENDIF
      ;      print, 'END@GET_OUTPUT_DIRECTORY()', systime()
      return, OVERRIDE
    ENDIF
  ENDIF
  
  IF N_ELEMENTS(instrument) EQ 0 THEN UNKNOWN=1
  IF N_ELEMENTS(runnumber) EQ 0 THEN BEGIN
    UNKNOWN=1
    runnumber=''
  ENDIF
  
  ; Also check to for a single digit run number
  IF STRLEN(runnumber) LT 3 THEN UNKNOWN = 1
  
  ; If we don't know what the instrument or run number is then just write to
  ; the ~/results directory!
  IF (UNKNOWN EQ 1) THEN BEGIN
    output_directory  = '/SNS/users/' + get_ucams() + '/results/'
  ENDIF ELSE BEGIN
  
    IF KEYWORD_SET(HOME) THEN BEGIN
      ; If we want to force the results to go into the users home directory
      ; then the easist way is the just set the proposal=0
      proposal = '0'
    ENDIF ELSE BEGIN
      beamtimeinfo_file = get_beamtimeinfo_filename(instrument, runnumber)
      IF (beamtimeinfo_file EQ 'ERROR') THEN BEGIN
        proposal = '0'
      ENDIF ELSE BEGIN
        proposal = get_Proposal_fromPreNeXus(beamtimeinfo_file)
      ENDELSE
    ENDELSE
    
    IF (proposal NE '0') THEN BEGIN
      output_directory  = '/SNS/' + STRUPCASE(STRCOMPRESS(string(instrument),/REMOVE_ALL))
      output_directory += '/' + STRCOMPRESS(string(proposal),/REMOVE_ALL)
      output_directory += '/shared/'
      ; Do we want to have the 'username' subdirectory present ?
      IF NOT KEYWORD_SET(NO_USERDIR) THEN output_directory +=  get_ucams() + '/'
      ; Add on the run number
      output_directory += STRUPCASE(STRCOMPRESS(string(runnumber),/REMOVE_ALL))
    ENDIF ELSE BEGIN
      output_directory  = '/SNS/users/' + get_ucams() + '/results/'
      output_directory += STRUPCASE(STRCOMPRESS(string(instrument),/REMOVE_ALL)) + '/'
      output_directory += STRUPCASE(STRCOMPRESS(string(runnumber),/REMOVE_ALL))
    ENDELSE
    
  ENDELSE
  
  ; If a label is requested then append to the directory name.
  IF KEYWORD_SET(LABEL) THEN BEGIN
    output_directory += '-' + STRCOMPRESS(STRING(LABEL),/REMOVE_ALL)
  ENDIF
  
  ; Make it if it doesn't exists (and we have asked for it to be created)
  IF KEYWORD_SET(CREATE) THEN BEGIN
    ; Let's check to see if the directory exists
    directoryThere = FILE_TEST(output_directory, /DIRECTORY)
    IF (directoryThere EQ 0) THEN BEGIN
      print, 'Creating directory ',output_directory
      spawn, 'mkdir -p ' + output_directory
    ENDIF
  ENDIF
  
  ;  print, 'END@GET_OUTPUT_DIRECTORY()', systime()
  
  return, output_directory
end