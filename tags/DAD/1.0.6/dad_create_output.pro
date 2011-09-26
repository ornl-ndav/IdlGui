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

FUNCTION create_output_ascii_file, Event, $
    output_ascii_file, $
    Erange, $
    Qrange, $
    divided_dave_data, $
    metadata
    
  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, 0
  ENDIF
  
  OPENW, 1, output_ascii_file
  
  ;Write axis E, Q
  line = "# Number of energy transfer values"
  PRINTF, 1, line
  nbr_E = N_ELEMENTS(Erange)
  PRINTF, 1, STRCOMPRESS(nbr_E,/REMOVE_ALL)
  line = "# Number of Q transfer values"
  PRINTF, 1, line
  nbr_Q = N_ELEMENTS(Qrange)
  PRINTF, 1, STRCOMPRESS(nbr_Q,/REMOVE_ALL)
  line = "# energy transfer (uev) Values:"
  PRINTF, 1, line
  FOR i=0L, (nbr_E - 1) DO BEGIN
    PRINTF, 1, STRCOMPRESS(Erange[i],/REMOVE_ALL)
  ENDFOR
  line = "# Q transfer (1/Angstroms) Values:"
  PRINTF, 1, line
  FOR i=0, (nbr_Q - 1) DO BEGIN
    PRINTF, 1, STRCOMPRESS(Qrange[i],/REMOVE_ALL)
  ENDFOR
  
  ;Write big axis
  i=0L
  while (i lt nbr_Q) do begin
  ;FOR i=0L, (nbr_Q - 1) DO BEGIN
    line = "# Group " + STRCOMPRESS(i,/REMOVE_ALL)
    PRINTF, 1, line
    j=0L
    while (j lt nbr_E) do begin
    ;FOR j=0L, (nbr_E - 1) DO BEGIN
      line = STRCOMPRESS(divided_dave_data[i,j,0],/REMOVE_ALL)
      line += '   ' + STRCOMPRESS(divided_dave_data[i,j,1],/REMOVE_ALL)
      PRINTF, 1, line
      j++
      endwhile
    ;ENDFOR
    i++
    endwhile
  ;ENDFOR
  
  ;Add comment
  nbr_metadata = N_ELEMENTS(metadata)
  FOR i=0L, (nbr_metadata-1) DO BEGIN
    line = metadata[i]
    PRINTF, 1, line
  ENDFOR
  
  CLOSE, 1
  FREE_LUN, 1
  
  RETURN, 1
  
END
