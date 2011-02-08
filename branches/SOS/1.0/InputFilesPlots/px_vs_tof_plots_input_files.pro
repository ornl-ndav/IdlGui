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

pro show_pixel_vs_tof_2d_plot, event
  compile_opt idl2
  
  selection = get_table_lines_selected(event=event, base=base, $
    uname='tab1_table')
  from_row_selected = selection[1]
  from_column_selected = selection[0]
  to_row_selected = selection[3]
  to_column_selected = selection[2]
  
  widget_control, /hourglass
  
  nbr_file_selected = (to_row_selected - from_row_selected + 1) * $
    (to_column_selected - from_column_selected + 1)
  offset = 0
  _step_offset = 50
  index_row = from_row_selected
  while (index_row le to_row_selected) do begin
  
    index_column = from_column_selected
    while (index_column le to_column_selected) do begin
    
      table = getValue(event=event,uname='tab1_table')
      ;get file name of line selected
      full_file_name_spin = table[index_column,index_row]
      
      file_structure = get_file_structure(full_file_name_spin)
      _short_file_name = file_structure.short_file_name
      _spin = file_structure.spin
      _full_file_name = file_structure.full_file_name
      
      ;create nexus object to retrieve data
      message = ['> Displaying Pixel vs tof:' , $
      '-> file name: ' + full_file_name_spin, $
      '-> column index: ' + strcompress(index_column,/remove_all), $
      '-> row index: ' + strcompress(index_row,/remove_all)]
      log_book_update, event, message=message
      iNexus = obj_new('IDLnexusUtilities', _full_file_name, spin_state=_spin)
      
      ;retrieving data set
      message = '-> Retrieving full data [tof,x,y]'
      log_book_update, event, message=message
      _data = iNexus->get_full_data()  ;[tof, x, y]
      
      ;retrieving tof axis
      message = ['-> Retrieving tof axis data']
      log_book_update, event, message=message
      _tof_axis = iNexus->get_tof_data() ;tof axis in ms
      obj_destroy, iNexus
      
      sz = size(_data,/dim)
      _pixel_axis = indgen(sz[2])
      
      offset += _step_offset
      px_vs_tof_plots_input_files_base, main_base=base, $
        event=event, $
        file_name = full_file_name_spin, $
        offset = offset, $
        data = _data, $
        tof_axis = _tof_axis
        
      index_column++
    endwhile
    
    index_row++
  endwhile
  
  widget_control, hourglass=0
  
end