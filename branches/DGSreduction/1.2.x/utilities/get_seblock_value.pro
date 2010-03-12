;+
; :Description:
;    This procedure will atempt to read the value for a given SE block
;    within a given run from either the NeXus file or the CVINFO file.
;
; :Params:
;    instrument - instrument name
;    runnumber - The run number
;    seblock - Sample Environment Block Name
;
; :Author: scu (campbellsi@ornl.gov)
;-
function get_seblock_value, instrument, runnumber, seblock

  IF N_ELEMENTS(seblock) EQ 0 THEN seblock = ''

  fileThere = 0
  inNeXus = 0
  
  findnexus_exe = 'findnexus'
  cvlog_extract_exe = 'simple_cvlog_reader.py'
  
  ; Uppercase the instrument name
  instrument = STRUPCASE(instrument)
  
  ; Find the NeXus file
  findnexus_cmd = findnexus_exe + ' -i ' + instrument + ' ' + strcompress(string(runnumber), /REMOVE_ALL)
  ; *** We can comment this out for the moment as we don't store them in the NeXus file...yet! ***
  ;spawn, findnexus_cmd, listening
  ;nexusfile = listening[0]
  ; Let's see if the first string returned by findnexus exists and is readable
  ;nexusThere = FILE_TEST(listening[0], /READ, /REGULAR)
  
  ; Check to see if the Ei is in the NeXus file
  ; TODO: Not needed at the moment as no nexus files have this field!
  ;IF (nexusThere EQ 1) THEN BEGIN
  ; If the block is found in the nexus file then set 'inNeXus = 1'
  ;ENDIF
  
  IF (inNeXus NE 1) AND (STRLEN(seblock) GT 0) THEN BEGIN
  
    ; If not, then find the preNeXus files
    findnexus_cmd = findnexus_exe + ' -i ' + instrument + ' --prenexus ' + strcompress(string(runnumber), /REMOVE_ALL)
    spawn, findnexus_cmd, listening
    
    cvinfo_filename = listening[0] + '/' + instrument + '_' + strcompress(string(runnumber), /REMOVE_ALL) + '_cvinfo.xml'
    
    
    IF (FILE_TEST(cvinfo_filename, /READ, /REGULAR) EQ 1) THEN BEGIN
      cmd = cvlog_extract_exe + ' ' + seblock + ' ' + cvinfo_filename
      ;print, cmd
      spawn, cmd, listening
      IF STRLEN(listening) GT 0 THEN BEGIN
        value = float(listening[0])
      ENDIF ELSE BEGIN
        value = ''
      ENDELSE
    ENDIF ELSE BEGIN
      value = ''
    ENDELSE
    
  ENDIF
  
  return, value
end
