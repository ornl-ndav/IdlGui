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
;    where to create the ascii tof slices files
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro tof_slices_where_button, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  path = (*global).dr_output_path
  id = widget_info(event.top, find_by_uname='MAIN_BASE')
  
  new_path = dialog_pickfile(/directory,$
    path=path,$
    dialog_parent=id,$
    /must_exist,$
    /read,$
    title='Output folder for ASCII files of TOF slices')
    
  if (new_path ne '') then begin
    (*global).dr_output_path = new_path
    putValue, event=event, 'where_tof_slices_path_uname', new_path
  endif
  
end

;+
; :Description:
;    This routine create the slices
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro create_ascii_tof_slices, event
  compile_opt idl2
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    id = widget_info(event.top, find_by_uname='MAIN_BASE')
    result = dialog_message([" E R R O R !",$
      '  Please report error to j35@ornl.gov  '],$
      /error,$
      dialog_parent=id,$
      /center,$
      title='Error while creating the ascii files')
    return
  endif
  
  widget_control, event.top, get_uvalue=global
  
  ;retrieve path and prefix file_name
  path = (*global).dr_output_path
  prefix_file_name = getValue(event=event,uname='file_name_tof_slices_uname')
  suffix = '.txt'
  
  ;number of slices requested
  number_of_slices = $
    getValue(event=event, uname='data_tof_nbr_tof_slices_uname')
  if (number_of_slices eq 0) then return
  
  ;retrieve data and tof range
  data = (*(*global).bank1_data) ;[tof, 256, 304]
  tof_axis = (*(*global).tof_axis_ms)
  
  ;  if ((*global).instrument eq 'REF_M') then begin
  ;    index=2
  ;  endif else begin
  ;    index=3
  ;  endelse
  ;  _data = total(data,index)
  
  index_of_tof_range = (*global).index_of_tof_range
  index_tof_min = index_of_tof_range[0]
  index_tof_max = index_of_tof_range[1]
  
  if (index_tof_min eq -1) then index_tof_min = 0
  if (index_tof_max eq -1) then begin
  sz = size(data,/dim)
  index_tof_max = sz[0]-1
  endif

  data = data[index_tof_min:index_tof_max,*,*]
  
  sz = size(data,/dim)
  nbr_tof = sz[0]
  ;make sure we don't want more slices that we have TOF bins
  if (number_of_slices gt nbr_tof) then number_of_slices=nbr_tof
  
  ;calculate tof step
  step = (index_tof_max - index_tof_min) / number_of_slices
  _start_index = 0
  if (number_of_slices eq 1) then begin
    _end_index= -1
  endif else begin
    _end_index = step
  endelse
  _slice_nbr=0
  
  list_of_files_created = !null
  
  while (_start_index lt nbr_tof) do begin
  
    _data = data[_start_index:_end_index,*,*]
    _sum_data = total(_data,1)
    
    file_name = path + prefix_file_name + '_slice' + $
      strcompress(_slice_nbr,/remove_all) + '.txt'
      
    from_tof = tof_axis[_start_index] ;ms
    to_tof = tof_axis[_end_index] ;ms
    
    output_tof_slices_ascii_file, event=event, $
      data=_sum_data, $
      file_name=file_name, $
      from_tof=from_tof, $
      to_tof=to_tof
      
    list_of_files_created = [list_of_files_created, $
      file_name]
      
    if (_end_index eq -1) then break

    _start_index += step
    _end_index += step
    
    if (_start_index ge nbr_tof) then break
    if (_end_index ge nbr_tof) then _end_index=-1
    
    _slice_nbr++
    
  endwhile
  
  message = ['Here is the list of files produced:']
  tmp = ' --> ' + list_of_files_created
  message = [message, tmp]
  
  id = widget_info(event.top, find_by_uname='MAIN_BASE')
  result = dialog_message(message, $
    /center,$
    dialog_parent=id,$
    /information,$
    title='List of files produced')
    
end

;+
; :Description:
;    This routine is going to create the huge ascii file
;
;
;
; :Keywords:
;    event
;    data
;    file_name
;    from_tof
;    to_tof
;
; :Author: j35
;-
pro output_tof_slices_ascii_file, event=event, data=data, $
    file_name=file_name, $
    from_tof=from_tof, $
    to_tof=to_tof
    
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  sz = size(data,/dim)
  nbr_row = sz[0]  ;256 for REf_M
  nbr_column = sz[1] ;304 for REF_M
  
  openw, 1, file_name
  data_nexus_file_name = (*global).data_nexus_full_path
  printf, 1, '#Data nexus: ' + data_nexus_file_name
  printf, 1, '#Rows: ' + strcompress(nbr_row,/remove_all)
  printf, 1, '#Columns: ' + strcompress(nbr_column,/remove_all)
  printf, 1, '#TOF range (ms): ' + strcompress(from_tof,/remove_all) + $
    ' - ' + strcompress(to_tof,/remove_all)
  printf, 1, ''
  
  _index_row = 0
  while (_index_row lt nbr_row) do begin
  
    _data = reform(data[_index_row,0:-1])
    _row = strcompress(_data,/remove_all)
    line = strjoin(_data,' ')
    
    printf, 1, line
    
    _index_row++
  endwhile
  
  close,1
  free_lun, 1
  
end
