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
;    This routine will launch the tof_selection base
;
; :Params:
;    event
;
; :Author: j35
;-
pro data_background_selection_tool_button_eventcb, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  widget_control, /hourglass
  
  row_selected = getTableRowSelected(Event,'reduce_tab1_table_uname')
  reduce_tab1_table = (*(*global).reduce_tab1_table)
  run_number = reduce_tab1_table[0,row_selected[0]]
  full_nexus_name = reduce_tab1_table[1,row_selected[0]]
  
  retrieve_2dData_and_tof, event, full_nexus_name, data=data, tof_axis=tof_axis
  
  data_background_selection_base, main_base='MAIN_BASE',$
    event=event, $
    offset = 50,$
    x_axis = tof_axis,$
    y_axis = indgen(256),$
    data = data,$
    run_number= strcompress(run_number[0],/remove_all), $
    file_name = full_nexus_name
    
  widget_control, hourglass=0
  
end


;+
; :Description:
;    retrieves the tof_axis and data array
;
; :Params:
;    event
;    full_nexus_name
;
; :Keywords:
;    data
;    tof_axis
;
; :Author: j35
;-
pro retrieve_2dData_and_tof, event, full_nexus_name, data=data, tof_axis=tof_axis
compile_opt idl2

fileID = h5f_open(full_nexus_name)
data_path = '/entry/bank1/data'
tof_path = '/entry/bank1/time_of_flight'

;data
dataID = h5d_open(fileID, data_path)
data = h5d_read(dataID)
h5d_close, dataID

;tof
tofID = h5d_open(fileID, tof_path)
tof_axis = h5d_read(tofID)/1000.  ;to be in ms
h5d_close, tofID

h5f_close, fileID

end

