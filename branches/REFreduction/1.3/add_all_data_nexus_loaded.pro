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
;    return the full path of the nexus file
;
; :Params:
;    run_number
;
; :Keywords:
;    event
;
; :Returns:
;   full_nexus_name or empty string if nexus can not be found
;
; :Author: j35
;-
function _find_nexus, event=event, run_number
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  instrument = (*global).instrument
  
  cmd = 'findnexus -i' + instrument + ' ' + strcompress(run_number,/remove_all)
  spawn, cmd, full_nexus_name, err_listening
  
  if (full_nexus_name[0] ne '') then begin ;make sure it's really a nexus file
  
      result = strmatch(strlowcase(full_nexus_name[0]),'failed to fill in *')
    if (result ge 1) then begin
    isNexusExist = 0
    return, ''
    endif
    
  endif
  
  ;check if nexus exists
  sz = (SIZE(full_nexus_name))[1]
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
  
end

;+
; :Description:
;    This routine adds all the nexus defined in the data text field
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro add_all_data_nexus_loaded, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  if ((*global).instrument eq 'REF_L') then return
  
  widget_control, /hourglass
  
  runs_list = getValue(event=event, uname='reduce_data_runs_text_field')
  if ((strcompress(runs_list,/remove_all)) eq '') then return
  
  ;replace all spaces by ','
  _comma_list = strsplit(runs_list,' ',/regex,/extract)
  if (n_elements(_comma_list) gt 1) then begin
    _list = strjoin(_comma_list,',')
  endif else begin
    _list = runs_list
  endelse
  
  ;find full nexus path if entry is just a run number
  _tmp_list = strsplit(_list,',',/regex,/extract)
  sz = n_elements(_tmp_list)
  
;  ;there is only 1 file, we are done here
;  if (sz eq 1) then begin
;    widget_control, hourglass=0
;    return
;  endif
  
  _final_list = strarr(sz)
  _index = 0
  status = 1b ;by default, we expect to find all the files defined
  _undefined_nexus = ''
  while (_index lt sz) do begin
    _tmp = _tmp_list[_index]
    if (file_test(_tmp)) then begin
      _final_list[_index] = _tmp
    endif else begin
      _nexus = _find_nexus(event=event, _tmp)
      if (_nexus ne '') then begin
        _final_list[_index] = _nexus
      endif else begin
        status=0b
        _undefined_nexus = _tmp
        break
      endelse
    endelse
    _index++
  endwhile
  
  ;we can not plot all the files together as one or more of the nexus file
  ;can not be found
  if (status eq 0b) then begin
  
    id = widget_info(event.top, find_by_uname='MAIN_BASE')
    message = ['Following run can not be found!: ' + _undefined_nexus]
    title = 'Plot all FAILED!'
    
    result = dialog_message(message, $
      title=title,$
      dialog_parent=id,$
      /center,$
      /error)
    return
    
  endif
  
  ;all files have been found and we can now retrieve their data array
  data_path = (*global).data_path + '/bank1/data/'
  _index = 0
  sz = n_elements(_final_list)
  _data = !null
  while (_index lt sz) do begin
  
    fileID = h5f_open(_final_list[_index])
    fieldID = h5d_open(fileID, data_path)
    data = h5d_read(fieldID)
    if (_index eq 0) then begin
      _data=data
    endif else begin
      ;make sure they have the same size
      if (((size(_data))[0] ne (size(data))[0]) || $
        ((size(_data))[1] ne (size(data))[1]) || $
        ((size(_data))[2] ne (size(data))[2])) then begin
        
        id = widget_info(event.top, find_by_uname='MAIN_BASE')
        message = ['Only file with same TOF binning can be added!']
        title = 'Plot all FAILED!'
        
        result = dialog_message(message, $
          title=title,$
          dialog_parent=id,$
          /center,$
          /error)
        return
        
      endif else begin
      
        _data += data
        
      endelse
    endelse
    
    _index++
  endwhile
  
  (*(*global).bank1_data) = _data
 result = REFreduction_Plot1D2DDataFile(Event)
  
  ;refresh data plot
  
  
  widget_control, hourglass=0
  
end