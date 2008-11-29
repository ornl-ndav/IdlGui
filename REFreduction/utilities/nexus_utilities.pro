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

FUNCTION check_number_polarization_state, Event, $
                                          nexus_file_name, $
                                          list_pola_state
WIDGET_CONTROL,Event.top,GET_UVALUE=global
text = '-> Number of polarization states: '
IF ((*global).debugging_version) THEN BEGIN
   debugging_structure = (*(*global).debugging_structure)
   sz = debugging_structure.nbr_pola_state
   text += STRCOMPRESS(sz,/REMOVE_ALL)
   list_pola_state = debugging_structure.list_pola_state
   (*(*global).list_pola_state) = list_pola_state
   i=0
   text += ' ('
   WHILE (i LT sz) DO BEGIN
      text += list_pola_state[i]
      if (i LT (sz-1)) THEN text += ', '
      i++
   ENDWHILE
   text += ')'
   putLogBookMessage, Event, Text, Append=1
   RETURN, debugging_structure.nbr_pola_state
ENDIF ELSE BEGIN
   cmd = 'nxdir ' + nexus_file_name
   SPAWN, cmd, listening, err_listening
   list_pola_state = listening  ;keep record of name of pola states
   (*(*global).list_pola_state) = list_pola_state
   IF (err_listening[0] NE '') THEN RETURN, -1
   sz = N_ELEMENTS(listening)
   text += STRCOMPRESS(sz,/REMOVE_ALL)
   i=0
   text += ' ('
   WHILE (i LT sz) DO BEGIN
      text += listening[i]
      if (i LT (sz-1)) THEN text += ', '
      i++
   ENDWHILE
   text += ')'
   putLogBookMessage, Event, Text, Append=1
   RETURN, sz
ENDELSE
END

;------------------------------------------------------------------------------
;when we want only the archived one
FUNCTION find_full_nexus_name, Event, run_number, instrument, isNexusExist

cmd = "findnexus --archive -i" + instrument 
cmd += " " + strcompress(run_number,/remove_all)
spawn, cmd, full_nexus_name, err_listening
;check if nexus exists
sz = (size(full_nexus_name))(1)
if (sz EQ 1) then begin
    result = strmatch(full_nexus_name,"ERROR*")
    if (result GE 1) then begin
        isNeXusExist = 0
    endif else begin
        isNeXusExist = 1
    endelse
    return, full_nexus_name
endif else begin
    isNeXusExist = 1
    return, full_nexus_name[0]
endelse

end

;-----------------------------------------------------------------------------
FUNCTION find_list_nexus_name, Event, run_number, instrument, isNexusExist

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

cmd = "findnexus -i" + instrument 
cmd += " " + strcompress(run_number,/remove_all)
cmd += " --listall"

spawn, 'hostname',listening
CASE (listening) OF
    'lrac': 
    'mrac': 
    else: BEGIN
        if ((*global).instrument EQ (*global).REF_L) then begin
            cmd = 'srun -p lracq ' + cmd
        endif else begin
            cmd = 'srun -p mracq ' + cmd
        endelse
    END
ENDCASE

spawn, cmd, full_nexus_name, err_listening

;get size of result
sz = (size(full_nexus_name))(1)

;check if nexus exists
if (sz EQ 1) then begin
    result = strmatch(full_nexus_name,"ERROR*")

    if (result GE 1) then begin
        isNeXusExist = 0
    endif else begin
        isNeXusExist = 1
    endelse
endif else begin
    isNeXusExist = 1
endelse

return, full_nexus_name
end

