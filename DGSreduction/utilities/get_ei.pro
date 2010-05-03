;+
; :Description:
;    This procedure will atempt to estimate the Ei for a given run
;    It first gets the requested value of Ei from either the NeXus file
;    or the CVINFO file.  It then uses this to determine the Ei from the
;    monitor spectra, except for CNCS where it is just returned directly.
;
; :Params:
;    instrument - instrument name
;    runnumber - The run number
;
; :Author: scu (campbellsi@ornl.gov)
;-
function get_Ei, instrument, runnumber

  ; initialise Ei
  Ei = 0.0
  
  fileThere = 0
  inNeXus = 0
  
  findnexus_exe = 'findnexus'
  cvlog_extract_exe = 'simple_cvlog_reader.py'
  
  ; Uppercase the instrument name
  instrument = STRUPCASE(instrument)
  
  ; Find the NeXus file
  findnexus_cmd = findnexus_exe + ' -i ' + instrument + ' ' + strcompress(string(runnumber), /REMOVE_ALL)
  spawn, findnexus_cmd, listening
  nexusfile = listening[0]
  
  ; Let's see if the first string returned by findnexus exists and is readable
  nexusThere = FILE_TEST(listening[0], /READ, /REGULAR)
  
  ; Check to see if the Ei is in the NeXus file
  ; TODO: Not needed at the moment as no nexus files have this field!
  IF (nexusThere EQ 1) THEN BEGIN
  ; If the energy is found in the nexus file then set 'inNeXus = 1'
  ENDIF
  
  IF (inNeXus NE 1) THEN BEGIN
  
    ; If not, then find the preNeXus files
    findnexus_cmd = findnexus_exe + ' -i ' + instrument + ' --prenexus ' + strcompress(string(runnumber), /REMOVE_ALL)
    spawn, findnexus_cmd, listening
    
    cvinfo_filename = listening[0] + '/' + instrument + '_' + strcompress(string(runnumber), /REMOVE_ALL) + '_cvinfo.xml'
    
    
    IF (FILE_TEST(cvinfo_filename, /READ, /REGULAR) EQ 1) THEN BEGIN
      cmd = cvlog_extract_exe + ' EnergyRequest ' + cvinfo_filename
      ;print, cmd
      spawn, cmd, listening
      requested_ei = float(listening[0])
    ENDIF ELSE BEGIN
      return, ''
    ENDELSE
    
  ENDIF
  
  ;print,'INSTRUMENT:',instrument
  
  ; Now are we going to determine the Ei from the monitors ?
  case (STRUPCASE(instrument)) of
    "ARCS": begin
      ; Calculate the Ei
      result = calcei_python(instrument, runnumber, requested_ei)
      ei = result.Ei
    ;      IF (nexusThere EQ 1) THEN BEGIN
    ;        Ei = calcei(instrument, runnumber, requested_ei, NEXUSFILE=nexusfile)
    ;      ENDIF ELSE BEGIN
    ;        Ei = calcei(instrument, runnumber, requested_ei)
    ;ENDELSE
    end
    "CNCS": begin
      Ei = requested_ei
    end
  "SEQ": begin
      ; Calculate the Ei
    result = calcei_python(instrument, runnumber, requested_ei)
    ei = result.ei
  ;      IF (nexusThere EQ 1) THEN BEGIN
  ;        Ei = calcei(instrument, runnumber, requested_ei, NEXUSFILE=nexusfile)
  ;      ENDIF ELSE BEGIN
  ;        Ei = calcei(instrument, runnumber, requested_ei)
  ;      ENDELSE
    end
    else: begin
      ; If we don't know the beamline then just assumed that the requested Ei is good enough!
      ei = requested_ei
    end
  endcase
  
  return, Ei
end
