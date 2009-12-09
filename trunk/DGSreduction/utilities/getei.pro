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
function getEi, instrument, runnumber

  ; initialise Ei
  Ei = 0.0
  
  fileThere = 0
  inNeXus = 0
  
  findnexus_exe = '/Library/Frameworks/Python.framework/Versions/Current/bin/findnexus'
  cvlog_extract_exe = '/Users/scu/sandpit/HLRedux/scripts/simple_cvlog_reader.py'
  
  ; Uppercase the instrument name
  instrument = STRUPCASE(instrument)
  
  ; Find the NeXus file
  findnexus_cmd = findnexus_exe + ' -i ' + instrument + ' ' + strcompress(string(runnumber), /REMOVE_ALL)
  spawn, findnexus_cmd, listening
  nexusfile = listening[0]
  
  ; Let's see if the first string returned by findnexus exists and is readable
  fileThere = FILE_TEST(listening[0], /READ, /REGULAR)
  
  ; Check to see if the Ei is in the NeXus file
  ; TODO: Not needed at the moment as no nexus files have this field!
  IF (fileThere EQ 1) THEN BEGIN
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
  
  ; Now are we going to determine the Ei from the monitors ?
  case (STRUPCASE(instrument)) of
    "ARCS": begin
      ; Calculate the Ei
      Ei = calcei(requested_ei, instrument, runnumber)
    end
    "CNCS": begin
      Ei = requested_ei
    end
    "SEQUOIA": begin
      ; Calculate the Ei
      Ei = calcei(requested_ei, instrument, runnumber)
    end
    else: begin
      ; If we don't know the beamline then just assumed that the requested Ei is good enough!
      ei = requested_ei
    end
  endcase
  
  return, Ei
end
