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

FUNCTION retrive_source_rate, info
  search_string = 'Source rep rate'
  sz = N_ELEMENTS(info)
  FOR i=0,(sz-1) DO BEGIN
    result = STREGEX(info[i],search_string,/BOOLEAN,/FOLD_CASE)
    IF (result NE 0b) THEN BEGIN
      source_rate_array = STRSPLIT(info[i],'=',/REGEX,/EXTRACT)
      RETURN, source_rate_array[1]
    ENDIF
  ENDFOR
  RETURN, ''
END

;------------------------------------------------------------------------------
FUNCTION retrieve_sample_detector_distance, info
  ON_IOERROR, error
  search_string = 'sample to detector'
  sz = N_ELEMENTS(info)
  FOR i=0,(sz-1) DO BEGIN
    result = STREGEX(info[i],search_string,/BOOLEAN,/FOLD_CASE)
    IF (result NE 0b) THEN BEGIN
      distance_array = STRSPLIT(info[i],'=',/REGEX,/EXTRACT)
      distance_array_2 = STRSPLIT(distance_array[1],'\[',/REGEX,/EXTRACT)
      distance_in_m = FLOAT(distance_array_2[0])/1000.
      RETURN, distance_in_m
    ENDIF
  ENDFOR
  error:
  RETURN, ''
END

;------------------------------------------------------------------------------
FUNCTION retrieve_sample_source_distance, info
  ON_IOERROR, error
  search_string = 'sample-to source'
  sz = N_ELEMENTS(info)
  FOR i=0,(sz-1) DO BEGIN
    result = STREGEX(info[i],search_string,/BOOLEAN,/FOLD_CASE)
    IF (result NE 0b) THEN BEGIN
      distance_array = STRSPLIT(info[i],'=',/REGEX,/EXTRACT)
      distance_array_2 = STRSPLIT(distance_array[1],'\[',/REGEX,/EXTRACT)
      distance_in_m = FLOAT(distance_array_2[0])/1000.
      RETURN, distance_in_m
    ENDIF
  ENDFOR
  error:
  RETURN, ''
END

;------------------------------------------------------------------------------
FUNCTION retrieve_monitor_source_distance, info
  ON_IOERROR, error
  search_string = 'monitor to source'
  sz = N_ELEMENTS(info)
  FOR i=0,(sz-1) DO BEGIN
    result = STREGEX(info[i],search_string,/BOOLEAN,/FOLD_CASE)
    IF (result NE 0b) THEN BEGIN
      distance_array = STRSPLIT(info[i],'=',/REGEX,/EXTRACT)
      distance_array_2 = STRSPLIT(distance_array[1],'\[',/REGEX,/EXTRACT)
      distance_in_m = FLOAT(distance_array_2[0])/1000.
      RETURN, distance_in_m
    ENDIF
  ENDFOR
  error:
  RETURN, ''
END

;------------------------------------------------------------------------------
FUNCTION retrieve_detector_source_distance, info
ON_IOERROR, error
  search_string = 'detector to source'
  sz = N_ELEMENTS(info)
  FOR i=0,(sz-1) DO BEGIN
    result = STREGEX(info[i],search_string,/BOOLEAN,/FOLD_CASE)
    IF (result NE 0b) THEN BEGIN
      distance_array = STRSPLIT(info[i],'=',/REGEX,/EXTRACT)
      distance_array_2 = STRSPLIT(distance_array[1],'\[',/REGEX,/EXTRACT)
      distance_in_m = FLOAT(distance_array_2[0])/1000.
      RETURN, distance_in_m
    ENDIF
  ENDFOR
  error:
  RETURN, ''
END

;------------------------------------------------------------------------------
FUNCTION retrieve_number_of_pixels, info
  search_string = 'detector dimension'
  sz = N_ELEMENTS(info)
  FOR i=0,(sz-1) DO BEGIN
    result = STREGEX(info[i],search_string,/BOOLEAN,/FOLD_CASE)
    IF (result NE 0b) THEN BEGIN
      number_array = STRSPLIT(info[i],'=',/REGEX,/EXTRACT)
      number_array_2 = STRSPLIT(number_array[1],' ',/REGEX,/EXTRACT)
      X = number_array_2[0]
      Y = number_array_2[2]
      RETURN, [X,Y]
    ENDIF
  ENDFOR
  RETURN, ['','']
END

;------------------------------------------------------------------------------
FUNCTION retrieve_pixels_size, info
  search_string = 'detector pixel sizes'
  sz = N_ELEMENTS(info)
  FOR i=0,(sz-1) DO BEGIN
    result = STREGEX(info[i],search_string,/BOOLEAN,/FOLD_CASE)
    IF (result NE 0b) THEN BEGIN
      number_array = STRSPLIT(info[i],'=',/REGEX,/EXTRACT)
      ;to get first number
      number_array_2 = STRSPLIT(number_array[1],',',/REGEX,/EXTRACT)
      X = number_array_2[0]
      ;to get second number
      number_array_3 = STRSPLIT(number_array_2[1],'\[',/REGEX,/EXTRACT)
      Y = number_array_3[0]
      RETURN, [X,Y]
    ENDIF
  ENDFOR
  RETURN, ['','']
END
