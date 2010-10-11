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
;    Enable or disable the various button of the first tab (LOAD and SCALE)
;     - auto scaling
;     - auto scaling and show plot
;     - show plot
;
; :Params:
;    event
;    spin_state
;
; :Author: j35
;-
pro check_status_of_tab1_buttons, event, spin_state = spin_state
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  if (n_elements(spin_state) eq 0) then spin_state = 0
  
  files_SF_list = (*global).files_SF_list
  sz = (size(files_SF_list))[3]
  
  ;for Automatic mode
  ;
  ;if no file loaded, disable everyting
  status_auto_scaling = 1
  if (files_SF_list[spin_state,0,0] eq '' || $
    files_SF_list[spin_state,0,1] eq '') then begin
    status_auto_scaling = 0
  endif
  
  ;we can activate plot button if scale has been performed and nothing changed
  status_show_plot = ~(*global).table_changed
  
  setSensitive, event=event, uname='automatic_scaling', sensitive=status_auto_scaling
  setSensitive, event=event, uname='automatic_scaling_and_plot', $
    sensitive=status_auto_scaling
  setSensitive, event=event, uname='show_plot', sensitive=status_show_plot
  
  ;For manual mode
  ;
  ;check that there is at least 1 file loaded
  status_auto_scaling = 1
  if (files_SF_list[spin_state,0,0] eq '') then begin
    status_auto_scaling = 0
  endif
  
  ;check that all the files loaded have a SF value defined
  index = 0
  while (index lt sz) do begin
    _file_name = files_SF_list[spin_state,0,index]
    if (_file_name eq '') then break
    _SF = files_SF_list[spin_state,1,index]
    if (_SF eq 'N/A' || _SF eq '0') then begin
      status_auto_scaling = 0
      break
    endif
    index++
  endwhile
  setSensitive, event=event, uname='manual_scaling', sensitive=status_auto_scaling
  setSensitive, event=event, uname='manual_scaling_and_plot', sensitive=status_auto_scaling
  
end

;+
; :Description:
;    Enable or not the CREATE OUTPUT button
;
; :Params:
;    event
;
; :Author: j35
;-
pro check_status_of_tab2_buttons, event
  compile_opt idl2
  
  ;by default, we can activate the button
  _activate_button = 1
  
  ;make sure we provided an output file name
  _base_file_name = getValue(event=event, 'output_base_file_name')
  if (strcompress(_base_file_name,/remove_all) eq '') then begin
    setSensitive, event=event, uname='create_output_button', sensitive=0
    return
  endif
  if (strcompress(_base_file_name,/remove_all) eq 'N/A') then begin
    setSensitive, event=event, uname='create_output_button', sensitive=0
    return
  endif
  
  ;make sure that we have at least 1 output format selected
  if (~isButtonSelected(event=event,uname='3_columns_ascii_button') && $
  ~isButtonSelected(event=event,uname='2d_table_ascii_button')) then begin
    setSensitive, event=event, uname='create_output_button', sensitive=0
    return
  endif

  ;make sure we have at least 2 files loaded in the various spin states
  widget_control, event.top, get_uvalue=global
  files_SF_list = (*global).files_SF_list
  at_least_2_files = 0b ;by default, we don't have 2 files in any of the spin states
  for i=0,3 do begin ;loop over spin states
    nbr_files = get_number_of_files_loaded(event, spin_state=i)
    if (nbr_files ge 2) then begin
      at_least_2_files = 1b
      break
    endif
  endfor
  
  ;auto or manual scaling has been performed
  show_scaled_data_button_status = isShowScaledDataButtonEnabled(event)
  if (show_scaled_data_button_status eq 0) then begin
    setSensitive, event=event, uname='create_output_button', sensitive=0
    return
  endif
    
  setSensitive, event=event, uname='create_output_button', sensitive=1
  
end

