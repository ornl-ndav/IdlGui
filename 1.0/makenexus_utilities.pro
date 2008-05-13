;===============================================================================
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
;===============================================================================

function get_up_to_date_geo_tran_map_file, instrument

case instrument of
    'REF_L': beam_line = '4B'
    'REF_M': beam_line = '4A'
    'BSS'  : beam_line = '2'
    'ARCS' : beam_line = '18'
    'CNCS' : beam_line = '5'
    ELSE   : beam_line = '?'
endcase

path_to_files_base = "/SNS/" + instrument
path_array = [path_to_files_base + "/2006_1_" + beam_line + "_CAL/calibrations/",$
              path_to_files_base + "/2008_1_" + beam_line + "_CAL/calibrations/",$
              path_to_files_base + "/2008_2_" + beam_line + "_CAL/calibrations/"]
sz = (size(path_array))(1)

;generic file names
geometry_file    = instrument + '_geom_*.xml'
translation_file = instrument + '_*.nxt'
mapping_file     = instrument + '_TS_*.dat'

;get up-to-date geometry_file
FOR i=0,(sz-1) DO BEGIN
    ls_cmd = path_array[sz-1-i] + geometry_file
    spawn, 'ls ' + ls_cmd, geom, geom_error
    IF (geom[0] NE '') THEN BEGIN
        geom_file = reverse(geom[sort(geom)])
        BREAK
    ENDIF
ENDFOR

;get up-to-date translation_file
FOR i=0,(sz-1) DO BEGIN
    ls_cmd = path_array[sz-1-i] + translation_file
    spawn, 'ls ' + ls_cmd, trans, trans_error
    IF (trans[0] NE '') THEN BEGIN
        trans_file = reverse(trans[sort(trans)])
        BREAK
    ENDIF
ENDFOR

;get up-to-date mapping_file
FOR i=0,(sz-1) DO BEGIN
    ls_cmd = path_array[sz-1-i] + mapping_file
    spawn, 'ls ' + ls_cmd, map, map_error
    IF (map[0] NE '') THEN BEGIN
        map_file = reverse(map[sort(map)])
        BREAK
    ENDIF
ENDFOR

;combine results
array_result=[geom_file[0], trans_file[0], map_file[0]]
return, array_result

end
