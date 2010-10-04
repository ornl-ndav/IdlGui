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
;    This pops up a window and display the big array rescaled
;
; :Params:
;    event
;
; :Author: j35
;-
pro show_big_array, event, spin_state=spin_state
compile_opt idl2

widget_control, event.top, get_uvalue=global

if (n_elements(spin_state) eq 0) then spin_state=0

xaxis = (*global).master_xaxis
data  = (*global).master_data  
files_SF_list = (*global).files_SF_list

delta_offset = 20

 px_vs_tof_plots_base, event = event, $
        main_base_uname = 'main_base', $
        file_name = 'Rescaled data', $
        offset = delta_offset, $
        default_loadct = (*global).default_loadct, $
        default_scale_settings = (*global).scale_settings, $
        default_plot_size = (*global).default_plot_size_global_plot, $
        current_plot_setting = (*global).plot_setting, $
        Data_x =  *xaxis[spin_state], $
        Data_y = *data[spin_state], $
        start_pixel = files_SF_list[spin_state, 2, 0]

end