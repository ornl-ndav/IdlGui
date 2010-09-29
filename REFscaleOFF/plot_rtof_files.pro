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

;+
; :Description:
;   retrieve the various file selected and plot in a separete window the rtof
;   files
;   x axis is tof
;   y axis is pixel
;
; :Params:
;    event
;    from_line
;    to_line
;    spin_state: -1 = all spin states
;                 0 = first spin state (Off_Off) or when there is no spin states
;                 1 = second spin state (Off_On)
;                 2 = third spin state (On_Off)
;                 3 = fourth spin state (On_On)
;
; :Author: j35
;-
pro plot_rtof_files, event, from_line, to_line, spin_state=spin_state
  compile_opt idl2
  
  if (n_elements(spin_state) eq 0) then spin_state=0
  
  widget_control, event.top, get_uvalue=global
  
  files_SF_list = (*global).files_SF_list
  pData_x = (*global).pData_x
  pData_y = (*global).pData_y
  
  index = from_line
  delta_offset = 20
  index_offset = 0
  while (index le to_line) do begin
  
    file_name = files_SF_list[spin_state,0,index]
    if (file_test(file_name)) then begin
      
      px_vs_tof_plots_base, event = event, $
        file_name = file_name, $
        file_index = index, $
        offset = (delta_offset * index), $
        default_loadct = (*global).default_loadct, $
        default_scale_settings = (*global).scale_settings, $
        default_plot_size = (*global).default_plot_size, $
        current_plot_setting = (*global).plot_setting, $
        Data_x =  *pData_x[index,spin_state], $
        Data_y = *pData_y[index, spin_state], $ ;Data_y, $
        start_pixel = files_SF_list[spin_state, 2, index]

    endif
    
    index++
  endwhile
  
end