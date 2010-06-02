;+
; :Copyright:
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
; Copyright (c) 2009, Spallation Neutron Source, Oak Ridge National Lab,
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
; :Description:
;    This routine returns the corner geometry filename
;    for a given instrument.
;
; :Params:
;    Instrument - The instrument short name
;
; :Keywords:
;    RUNNUMBER - Optional parameter to pass in a run number
;
; :Author: scu (campbellsi@ornl.gov)
;
function GetCornerGeometryFile, Instrument, RUNNUMBER=RUNNUMBER

  IF N_ELEMENTS(Instrument) EQ 0 THEN Instrument = ''
  
  IF KEYWORD_SET(RUNNUMBER) THEN BEGIN
    run = RUNNUMBER
  ENDIF ELSE BEGIN
    run = 0
  ENDELSE
  
  case (STRUPCASE(instrument)) of
    "ARCS": begin
      cornergeometry = $
        "/SNS/ARCS/2009_2_18_CAL/calibrations/ARCS_cgeom_20090128.txt"
    end
    "CNCS": begin
      IF (run LT 7848) THEN BEGIN
        cornergeometry = $
          "/SNS/CNCS/2009_2_5_CAL/calibrations/CNCS_cgeom_20090224.txt"
      ENDIF ELSE BEGIN
        cornergeometry = $
          "/SNS/CNCS/2010_2_5_CAL/calibrations/CNCS_cgeom_20100325.txt"
      ENDELSE
    end
    "SEQ": begin
      cornergeometry = $
        "/SNS/SEQ/2010_2_17_CAL/calibrations/SEQ_cgeom_20100419.txt"
    end
    ;    "SEQUOIA": begin
    ;      cornergeometry = $
    ;        "/SNS/SEQ/2009_2_17_CAL/calibrations/SEQ_cgeom_20090413.txt"
    ;    end
    else: begin
      cornergeometry = ""
    end
  endcase
  ;print,'Corner Geometry = ', cornergeometry
  return, cornergeometry
end
