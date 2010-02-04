;+
; :Description:
;    This procedure determines the name of the mask file that will be used 
;    as the 'source' to split up into separate mask files depending on the 
;    number of jobs/banks the reduction job is split up into.
;
; :Params:
;    instrument - The instrument name
;    runnumber - The number of the file we are processing
;
; :Keywords:
;    OVERRIDE - If set the value will override the determined value
;    for the mask file with whatever is specified
;
; :Author: scu
;-
function get_maskfile, instrument, runnumber, OVERRIDE=OVERRIDE

  ; try to find the proposal number
  beamtimeinfo_file = get_beamtimeinfo_filename(instrument, runnumber)
  IF (beamtimeinfo_file EQ 'ERROR') THEN BEGIN
    proposal = '0'
  ENDIF ELSE BEGIN
    proposal = getProposalfromPreNeXus(beamtimeinfo_file)
  ENDELSE
  
  IF (proposal NE '0') THEN BEGIN
    source_maskfile  = '/SNS/' + STRUPCASE(STRCOMPRESS(string(instrument),/REMOVE_ALL))
    source_maskfile += '/' + STRCOMPRESS(string(proposal),/REMOVE_ALL)
    source_maskfile += '/shared/masks/CNCS.mask'
  ENDIF ELSE BEGIN
    source_maskfile  = '/SNS/users/' + get_ucams() + '/masks/'
    source_maskfile += STRUPCASE(STRCOMPRESS(string(instrument),/REMOVE_ALL)) + '.mask'
    ; if this option is being used, then make sure we have a ~/masks directory
    spawn, 'mkdir -p /SNS/users/' + get_ucams() + '/masks/'
  ENDELSE
  
  ; Check to see if we are forcing a value for the mask file.
  IF KEYWORD_SET(OVERRIDE) THEN BEGIN
    ; only return the override if it contains something!
    IF STRLEN(OVERRIDE) GE 1 THEN BEGIN
      ; Let's check to see if the file exists and is readable
      maskFileThere = FILE_TEST(OVERRIDE, /READ)
      IF (maskFileThere EQ 1) THEN BEGIN
        ; If the file exists, set this as the mask file to use.
        source_maskfile = OVERRIDE
      ENDIF
    ENDIF
  ENDIF
  
  ; Now let's check to see if the mask file we want to use actually exists!
  maskFileThere = FILE_TEST(source_maskfile, /READ)
  
  ; If the file doesn't exist, copy a 'central' mask file to use
  IF (maskFileThere EQ 0) THEN BEGIN
    default_maskfile = '/SNS/' + STRUPCASE(STRCOMPRESS(string(instrument),/REMOVE_ALL))
    default_maskfile += '/shared/masks/'
    
    ; Let's check to see if this directory exists.
    sharedMasksDir = FILE_TEST(default_maskfile, /DIRECTORY, /READ)
    IF (sharedMasksDir EQ 0) THEN BEGIN
      print, 'Creating masks directory in the shared proposal area.'
      spawn, 'mkdir -p ' + sharedMasksDir
    ENDIF
    
    ; Now that we've checked the directory is there, add on the filename.
    default_maskfile += STRUPCASE(STRCOMPRESS(string(instrument),/REMOVE_ALL)) + '_default.mask'
    
    ; Is the default mask there and readable ?
    defaultMaskThere = FILE_TEST(default_maskfile, /READ)
    
    IF (defaultMaskThere EQ 1) THEN BEGIN
      ; If it is there copy it to the source filename
      cmd = 'cp ' + default_maskfile + ' ' + source_maskfile
      print, cmd
      spawn, cmd
    ENDIF ELSE BEGIN
      ; If the file doesn't exist - create a blank file!
      cmd = 'touch ' + source_maskfile
      print,cmd
      spawn, cmd
    ENDELSE
    
  ENDIF
  
  return, source_maskfile
  
end