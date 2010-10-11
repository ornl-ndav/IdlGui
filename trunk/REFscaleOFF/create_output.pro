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
;    Produces the ascii output file
;
; :Params:
;    event
;
; :Keywords:
;    path_output_file_name
;
; :Author: j35
;-
pro create_rtof_output_file, event, path_output_file_name = path_output_file_name
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  rtof_ext = (*global).rtof_ext
  
  master_data = (*global).master_data
  master_data_error = (*global).master_data_error
  master_xaxis = (*global).master_xaxis
  files_SF_list = (*global).files_SF_list
  
  spin_state_name = (*global).spin_state_name
  
  _L = "#L time_of_flight(microsecond) data() Sigma()"
  _N = "#N 3"
  
  ;loop over all spin states
  for _spin=0,3 do begin
  
    _nbr_files = get_number_of_files_loaded(event, spin_state=_spin)
    if (_nbr_files ge 2) then begin ;create file
    
      full_output_file_name = path_output_file_name + '_' + spin_state_name[_spin]
      full_output_file_name += rtof_ext
      
      _xaxis = *master_xaxis[_spin]
      _delta_x = _xaxis[1] - _xaxis[0]
      _max_x = strcompress(_xaxis[-1] + _delta_x,/remove_all)
      _yaxis = *master_data[_spin]
      _yaxis_error = *master_data_error[_spin]
      
      xaxis_sz = n_elements(_xaxis)
      pixel_sz = (size(_yaxis))[1]
      
      openw, 1, full_output_file_name
      
      _index_file = 0
      while (_index_file lt _nbr_files) do begin
        printf, 1, "#F " + files_SF_list[_spin,0,_index_file] + $
          " with SF: " + files_SF_list[_spin,1,_index_file]
        _index_file++
      endwhile
      
      _S_1 = "#S 1 Spectrum ID ('bank1', (151, "
      _S_2 = "))"
      
      _pixel_offset = files_SF_list[_spin, 2,0]
      for _pixel=0, (pixel_sz-1) do begin ;loop over all pixels
      
        _current_pixel = strcompress(_pixel + _pixel_offset,/remove_all)
        _S = string(_S_1) + string(_current_pixel) + string(_S_2)
        printf, 1, " "
        printf, 1, _S
        printf, 1, _N
        printf, 1, _L
        for j=0,(xaxis_sz-1) do begin ;loop over all the xaxis values
        
          _x = strcompress(_xaxis[j],/remove_all)
          _y = strcompress(_yaxis[_pixel, j],/remove_all)
          _y_error = strcompress(_yaxis_error[_pixel, j],/remove_all)
          
          printf, 1, _x + '   ' + _y + '   ' + _y_error
          
        endfor
        printf, 1, _max_x
        
      endfor
      
      close, 1
      free_lun, 1
      
    endif ;end of enough file to get something to work with
    
  endfor
  
end

;+
; :Description:
;    Produces the excel output file
;
; :Params:
;    event
;
; :Keywords:
;    path_output_file_name
;
; :Author: j35
;-
pro create_excel_output_file, event, path_output_file_name = path_output_file_name
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  _ext = (*global).excel_ext
  
  master_data = (*global).master_data
  master_data_error = (*global).master_data_error
  master_xaxis = (*global).master_xaxis
  files_SF_list = (*global).files_SF_list
  
  spin_state_name = (*global).spin_state_name
  
  _L = "#L time_of_flight(microsecond) data() Sigma()"
  _N = "#N 3"
  
  ;loop over all spin states
  for _spin=0,3 do begin
  
    _nbr_files = get_number_of_files_loaded(event, spin_state=_spin)
    if (_nbr_files ge 2) then begin ;create file
    
      full_output_file_name = path_output_file_name + '_' + spin_state_name[_spin]
      full_output_file_name += _ext
      
      _xaxis = *master_xaxis[_spin]
      _delta_x = _xaxis[1] - _xaxis[0]
      _max_x = strcompress(_xaxis[-1] + _delta_x,/remove_all)
      _yaxis = *master_data[_spin]
      ;   _yaxis_error = *master_data_error[_spin]
      
      xaxis_sz = n_elements(_xaxis)
      pixel_sz = (size(_yaxis))[1]
      
      openw, 1, full_output_file_name
      
      _index_file = 0
      while (_index_file lt _nbr_files) do begin
        printf, 1, "#F " + files_SF_list[_spin,0,_index_file] + $
          " with SF: " + files_SF_list[_spin,1,_index_file]
        _index_file++
      endwhile
      printf, 1, ""
      
      _horizontal_size = pixel_sz + 2 ;+2 for x and y axis declaration
      _vertical_size = xaxis_sz
      big_table = strarr(_vertical_size, _horizontal_size)
      
      ;first column
      big_table[*,0] = strcompress(_xaxis,/remove_all)
      big_table[*,1] = 'N/A'
      pixel_array = indgen(pixel_sz) + files_SF_list[_spin, 2,0]
      big_table[0:(pixel_sz-1),1] = strcompress(pixel_array,/remove_all)
      
      ;help, _yaxis ;[pixel, tof]
      _pixel_sz = (size(_yaxis))[1]
      for i=0,(_pixel_sz-1) do begin
        big_table[*,i+2] = _yaxis[i,*]
      endfor
      
      ;create string array
      _big_string_array = strarr(_vertical_size)
      for j=0, (_vertical_size-1) do begin
        _row = big_table[j,*]
        _row = reform(_row)
        _big_string_array[j] = strjoin(_row, ' ')
      endfor
      
      ;write file
      for k=0, (_vertical_size-1) do begin
      printf, 1, _big_string_array[k]
      endfor
      
      close, 1
      free_lun, 1
      
    endif ;end of enough file to get something to work with
    
  endfor
  
end

;+
; :Description:
;    send by email the ascii and/or excel files
;
; :Params:
;    event
;
; :Keywords:
;    rtof_status   1=send this file, 0=do not send this file
;    excel_status   1=send this file, 0=do not send this file
;
; :Author: j35
;-
pro send_by_email, event, rtof_status=rtof_status, excel_status=excel_status
  compile_opt idl2
  
  
  
  
  
  
  
end

;+
; :Description:
;    Produces the output file(s) selected
;
; :Params:
;    event
;
; :Author: j35
;-
pro create_output, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  ;where are we going to create this output file
  output_path = (*global).output_path
  ;base file name
  base_file_name = getValue(event=event, 'output_base_file_name')
  
  ;is 3 columns rtof ASCII output file selected
  rtof_status = isButtonSelected(event=event, uname='3_columns_ascii_button')
  if (rtof_status) then begin
    create_rtof_output_file, event, path_output_file_name=output_path + base_file_name
  endif
  
  ;is excel ASCII output file selected
  excel_status= isButtonSelected(event=event, uname='2d_table_ascii_button')
  if (excel_status) then begin
    create_excel_output_file, event, path_output_file_name=output_path + base_file_name
  endif
  
  ;send by email or not
  email_status = isButtonSelected(event=event, uname='send_by_email_button_uname')
  if (email_status) then begin
    send_by_email, event, rtof_status=rtof_status, excel_status=excel_status
  endif
  
end