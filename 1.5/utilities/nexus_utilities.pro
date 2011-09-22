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

function isButtonSelected, id=id, event=event, base=base, uname=uname
  compile_opt idl2
  
  if (n_elements(id) ne 0) then begin
    status = widget_info(id,/button_set)
    return, status
  endif
  
  if (n_elements(event) ne 0 && $
    n_elements(uname) ne 0) then begin
    
    id = widget_info(event.top, find_by_uname=uname)
    status = widget_info(id,/button_set)
    return, status
  endif
  
  if (keyword_set(base) && keyword_set(uname)) then begin
    id = widget_info(base, find_by_uname=uname)
    status = widget_info(id,/button_set)
    return, status
  endif
  
  return, 'N/A'
  
end



FUNCTION check_number_polarization_state, Event, $
    nexus_file_name, $
    list_pola_state
    
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;REMOVE_ME once nxdir works again
  text = '-> Number of polarization states: '
  IF ((*global).instrument EQ 'REF_L') THEN BEGIN
    list_pola_state = ['/entry/']
  ENDIF ELSE BEGIN
    list_pola_state = ['entry-Off_Off',$
      'entry-Off_On',$
      'entry-On_Off',$
      'entry-On_On']
  ENDELsE
  (*(*global).list_pola_state) = list_pola_state
  
  sz = N_ELEMENTS(list_pola_state)
  text += STRCOMPRESS(sz,/REMOVE_ALL)
  i=0
  text += ' ('
  WHILE (i LT sz) DO BEGIN
    text += list_pola_state[i]
    if (i LT (sz-1)) THEN text += ', '
    i++
  ENDWHILE
  text += ')'
  putLogBookMessage, Event, Text, Append=1
  RETURN, sz
  
  ;end of remove me once nxdir works again
  
  text = '-> Number of polarization states: '
  cmd = 'nxdir ' + nexus_file_name[0]
  
  no_error = 0
  CATCH, no_error
  IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    putLogBookMessage, Event, $
      'ERROR retrieving the number of polarization states!', $
      APPEND=1
    RETURN, -1
  ENDIF ELSE BEGIN
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

;;-----------------------------------------------------------------------------
;;return 1 if the button is enabled (pushed)
;FUNCTION isButtonSelected, Event, Uname
;  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
;  value = WIDGET_INFO(id, /BUTTON_SET)
;  RETURN, VALUE
;END

;------------------------------------------------------------------------------
;when we want only the archived one
FUNCTION find_full_nexus_name, Event,$
    run_number, $
    instrument, $
    isNexusExist, $
    SOURCE_FILE=source_file
    
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    my_package = (*(*global).my_package)
    IF (my_package[0].found EQ 0) THEN BEGIN
      debugging_structure = (*(*global).debugging_structure)
      isNexusExist = 1
      RETURN, debugging_structure.data_nexus_full_path
    ENDIF
  ENDIF
  
  CASE (source_file) OF
    'data': BEGIN
      button_uname='with_data_proposal_button'
      droplist_uname='data_proposal_folder_droplist'
    END
    'norm': BEGIN
      button_uname='with_norm_proposal_button'
      droplist_uname='norm_proposal_folder_droplist'
    END
    'empty_cell': BEGIN
      button_uname='with_empty_cell_proposal_button'
      droplist_uname='empty_cell_proposal_folder_droplist'
    END
  ENDCASE
  
  cmd = "findnexus -i" + instrument
  
  value = isButtonSelected(event=Event, uname=button_uname)
  
  IF (value EQ 1) THEN BEGIN ;get proposal selected
    proposal = getDropListSelectedValue(Event, droplist_uname)
    cmd += ' --proposal=' + STRCOMPRESS(proposal,/REMOVE_ALL)
  ENDIF
  
  cmd += " " + STRCOMPRESS(run_number,/remove_all)
  SPAWN, cmd, full_nexus_name, err_listening
  
  if (full_nexus_name[0] ne '') then begin ;make sure it's really a nexus file
    result = strmatch(strlowcase(full_nexus_name[0]), "failed to fill in *")
    if (result ge 1) then begin
      isNexusExist = 0
      return, ''
    endif
  endif
  
  ;check if nexus exists
  sz = (SIZE(full_nexus_name))(1)
  IF (sz EQ 1) THEN BEGIN
    result = STRMATCH(full_nexus_name,"ERROR*")
    IF (result GE 1) THEN BEGIN
      isNeXusExist = 0
    ENDIF ELSE BEGIN
      isNeXusExist = 1
    ENDELSE
    RETURN, full_nexus_name
  ENDIF ELSE BEGIN
    isNeXusExist = 1
    RETURN, full_nexus_name[0]
  ENDELSE
END

;-----------------------------------------------------------------------------
FUNCTION find_list_nexus_name, Event, run_number, instrument, isNexusExist

  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,get_uvalue=global
  
  cmd = "findnexus -i" + instrument
  cmd += " " + STRCOMPRESS(run_number,/remove_all)
  cmd += " --listall"
  
  ; spawn, 'hostname',listening
  ; CASE (listening) OF
  ;     'lrac':
  ;     'mrac':
  ;     else: BEGIN
  ;         if ((*global).instrument EQ (*global).REF_L) then begin
  ;             cmd = 'srun -p lracq ' + cmd
  ;         endif else begin
  ;             cmd = 'srun -p mracq ' + cmd
  ;         endelse
  ;     END
  ; ENDCASE
  
  SPAWN, cmd, full_nexus_name, err_listening
  
  ;get size of result
  sz = (SIZE(full_nexus_name))(1)
  
  ;check if nexus exists
  if (sz EQ 1) then begin
    result = STRMATCH(full_nexus_name,"ERROR*")
    
    if (result GE 1) then begin
      isNeXusExist = 0
    endif else begin
      isNeXusExist = 1
    endelse
  endif else begin
    isNeXusExist = 1
  endelse
  
  RETURN, full_nexus_name
end

