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

;+
; :Description:
;    Routine that creates the ROI
;
; :Params:
;    event
;
; :Keywords:
;   roi_file_name
;   pixel1
;   pixel2
;   instrument
;   result
;
; :Author: j35
;-
pro data_background_create_roi, roi_file_name=roi_file_name, $
  pixel1=pixel1, $
  pixel2=pixel2, $
  instrument = instrument, $
  result = result
  compile_opt idl2
  
  ON_IOERROR, error
  
  ;get integer values
  Y1 = FIX(pixel1)
  Y2 = FIX(pixel2)
  
  ;get min and max values
  Ymin = MIN([Y1,Y2],MAX=Ymax)
  nbr_y = (Ymax-Ymin+1)
  
  ;open output file
  no_error = 0
  CATCH, no_error
  IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    result = 0
    return
  ENDIF ELSE BEGIN
    OPENW, 1, roi_file_name

    i     = 0L
    IF (instrument EQ 'REF_M') THEN BEGIN

    NyMax = 256L
    OutputArray = STRARR((NyMax)*nbr_y)
      FOR y=(Ymin),(Ymax) DO BEGIN
        FOR x=0,(NyMax-1) DO BEGIN
          text  = 'bank1_' + STRCOMPRESS(y,/REMOVE_ALL)
          text += '_' + STRCOMPRESS(x,/REMOVE_ALL)
          PRINTF,1,text
          OutputArray[i] = text
          i++
        ENDFOR
      ENDFOR
      
    ENDIF ELSE BEGIN ;REF_L
    
    NyMax = 304L
    OutputArray = STRARR((NyMax)*nbr_y)
      FOR x=0,(NyMax-1) DO BEGIN
        FOR y=(Ymin),(Ymax) DO BEGIN
          text  = 'bank1_' + STRCOMPRESS(x,/REMOVE_ALL)
          text += '_' + STRCOMPRESS(y,/REMOVE_ALL)
          PRINTF,1,text
          OutputArray[i] = text
          i++
        ENDFOR
      ENDFOR
    ENDELSE
    
    CLOSE, 1
    FREE_LUN, 1
  ENDELSE ;end of (Ynbr LE 1)

  result = 1
  return
  
  ERROR:
  result = 0

END
