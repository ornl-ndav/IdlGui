;==============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================

PRO populate_data_geometry_info, Event

  WIDGET_CONTROL,Event.top,get_uvalue=global
  
  cmd = (*global).findcalib
  run_number = (*global).data_run_number
  instrument = (*global).instrument
  cmd += ' -g -i ' + instrument + ' ' + STRCOMPRESS(run_number,/REMOVE_ALL)
  
  ;retrieve name of geometry file
  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    geometry_file = ''
  ENDIF ELSE BEGIN
    SPAWN, cmd, listening
    geometry_file = listening[0]
  ENDELSE
  
  (*global).dirpix_geometry = geometry_file
  
  ;retrieve full path to cv info file
  cvinfo = get_cvinfo(Event, $
    INSTRUMENT=instrument,$
    RUN_NUMBER = run_number)
    
  (*global).cvinfo = cvinfo
  
  IF (geometry_file NE '' AND $
    cvinfo NE '') THEN BEGIN
    
    tmp_file = '~/.tmp_geo_file.xml'
    cmd = (*global).ts_geom
    cmd += ' ' + geometry_file
    cmd += ' -m ' + cvinfo
    cmd += ' -l ' + tmp_file
    
    error = 0
    CATCH, error
    IF (error NE 0) THEN BEGIN
      CATCH,/CANCEL
      DANGLE0 = 'N/A'
      DANGLE0_units = 'N/A'
      DIRPIX = 'N/A'
      DIRPIX_units = 'N/A'
      REFPIX = 'N/A'
      REFPIX_units = 'N/A'
    ENDIF ELSE BEGIN
      SPAWN, cmd, listening, err_listening
      
      xmlFile = OBJ_NEW('xmlParser')
      xmlFile->ParseFile, tmp_file
      motors = xmlFile->GetArray()
      
      for i=0,N_ELEMENTS(motors)-1 do begin
        CASE (motors[i].name) OF
          'DANGLE': BEGIN
            DANGLE = motors[i].value
            units = STRCOMPRESS(motors[i].valueUnits,/REMOVE_ALL)
            IF (units NE '') THEN BEGIN
              DANGLE_units = units
            ENDIF ElSE BEGIN
              DANGLE_units = 'N/A'
            ENDELSE
          END
          'DIRPIX': BEGIN
            DIRPIX = motors[i].value
            units = STRCOMPRESS(motors[i].valueUnits,/REMOVE_ALL)
            IF (units NE '') THEN BEGIN
              DIRPIX_units = units
            ENDIF ELSE BEGIN
              DIRPIX_units = 'N/A'
            ENDELSE
          END
          'REFPIX': BEGIN
            REFPIX = motors[i].value
            units = STRCOMPRESS(motors[i].valueUnits,/REMOVE_ALL)
            IF (units NE '') THEN BEGIN
              REFPIX_units = units
            ENDIF ELSE BEGIN
              REFPIX_units = 'N/A'
            ENDELSE
          END
          ELSE:
        ENDCASE
      ENDFOR
      
    ENDELSE
    
  ENDIF ELSE BEGIN
  
    DANGLE0 = 'N/A'
    DANGLE0_units = 'N/A'
    DIRPIX = 'N/A'
    DIRPIX_units = 'N/A'
    REFPIX = 'N/A'
    REFPIX_units = 'N/A'
    
  ENDELSE
  
  putTextFieldValue, Event, 'data_geometry_dangle_value', $
    STRCOMPRESS(DANGLE,/REMOVE_ALL), 0
  putTextFieldValue, Event, 'data_geometry_dangle_units', $
    STRCOMPRESS(DANGLE_units,/REMOVE_ALL), 0
  putTextFieldValue, Event, 'data_geometry_refpix_value',$
    STRCOMPRESS(REFPIX,/REMOVE_ALL), 0
    
  coefficient = getUDCoefficient(Event) ;1 for low, 2 for high
  IF (coefficient EQ 1) THEN BEGIN
    value_user = '(' + STRCOMPRESS(DIRPIX,/REMOVE_ALL) + '):'
  ENDIF ELSE BEGIN
    value_user = STRCOMPRESS(DIRPIX,/REMOVE_ALL)
  ENDELSE
  putTextFieldValue, Event, 'data_geometry_dirpix_value', $
    value_user, 0
    
  ;remove tmp file
  CATCH, error
  IF ( error NE 0) THEN BEGIN
    CATCH,/cancel
  ENDIF ELSE BEGIN
    SPAWN, 'rm ' + tmp_file
  ENDELSE
  
END

;------------------------------------------------------------------------------
PRO calculate_data_dirpix, Event

  WIDGET_CONTROL,Event.top,get_uvalue=global
  
 CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    dirpix = 'N/A'
        putTextFieldValue, event, 'data_center_pixel_uname', $
      STRCOMPRESS(dirpix,/REMOVE_ALL), 0
    return
  ENDIF ELSE BEGIN
  
;    ON_IOERROR, done_calculation
    
    ymin = strcompress(getTextFieldValue(Event,$
    'data_d_selection_peak_ymin_cw_field'),/remove_all)
    ymax = strcompress(getTextFieldValue(Event,$
    'data_d_selection_peak_ymax_cw_field'),/remove_all)
    
    ymin = ymin[0]
    ymax = ymax[0]
    
    if (ymin eq '') then begin
    dirpix = 'N/A'
    putTextFieldValue, event, 'data_center_pixel_uname', $
      STRCOMPRESS(dirpix,/REMOVE_ALL), 0
      return
    endif
    
    if (ymax eq '') then begin
    dirpix = 'N/A'
    putTextFieldValue, event, 'data_center_pixel_uname', $
      STRCOMPRESS(dirpix,/REMOVE_ALL), 0
      return
      endif    
    
    IF (ymin NE '' AND ymax NE '') THEN BEGIN
    
      ymin = FLOAT(ymin)
      ymax = FLOAT(ymax)

      dirpix = (ymin + ymax) / 2.
      
      (*global).dirpix = dirpix
      
    ENDIF ELSE BEGIN
    
      dirpix = 'N/A'
      
    ENDELSE
    
    putTextFieldValue, event, 'data_center_pixel_uname', $
      STRCOMPRESS(dirpix,/REMOVE_ALL)
      
    RETURN
    
  ENDELSE
  
END
