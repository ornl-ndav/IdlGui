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
;    This routine will gather all the infos necessary to run the normalization
;    and run it
;
;
;
; :Keywords:
;    event
;
; :Author: j35
;-
pro run_intensity_vs_file, event=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  ;  error = 0
  ;  catch, error
  ;  if (error ne 0) then begin
  ;    catch,/cancel
  ;    widget_control, hourglass=0
  ;    message = ['Normalization failed !!!!']
  ;    log_book_update, event, message=message
  ;
  ;    save_log_book, event=event, file_name=file_name
  ;
  ;    kill_normalized_plot, event=event
  ;    progress_bar, event=event, /close
  ;
  ;    title = 'Normalization FAILED!'
  ;    message = ['Please check log book or send ' + file_name, $
  ;      'to j35@ornl.gov']
  ;    widget_id = widget_info(event.top, find_by_uname='MAIN_BASE')
  ;    result = dialog_message(message, $
  ;      /error, $
  ;      title=title,$
  ;      dialog_parent=widget_id,$
  ;      /center)
  ;
  ;    return
  ;  endif
  
  ;Select name of output file
  title='Select or define output file name'
  widget_id = widget_info(event.top, find_by_uname='MAIN_BASE')
  path = (*global).config_path
  
  output_file = dialog_pickfile(dialog_parent=widget_id,$
    path=path,$
    /write,$
    title=title)
    
  if (output_file ne '') then begin
  
    widget_control, /hourglass
    message = ['----------------------------','Start I(file) process using:']
    
    ;collect list of data, open beam and dark field files
    data_file_table = getValue(event=event, uname='sample_table')
    list_data = reform(data_file_table)
    message = [message,'-> list sample:']
    _message = '    ' + list_data
    message = [message, _message]
    
    ;collect table of ROIs
    roi_table =  retrieve_list_roi(event=event)
    table_sz = size(roi_table)
    if (table_sz[0] eq 1) then begin
      nbr_rois = 0
      widget_control, hourglass=0
      progress_bar, event=event, /close
      return
    endif else begin
      nbr_rois = table_sz[1]
    endelse
    message = [message, '-> Number of ROIs used: ' + $
      strcompress(nbr_rois,/remove_all)]
    if (table_sz[0] ne 1) then begin
      _i = 0
      while (_i lt nbr_rois) do begin
        _roi = strjoin(reform(roi_table[_i,*]),',')
        _message = '     ' + _roi
        message = [message, _message]
        _i++
      endwhile
    endif
    log_book_update, event, message=message
    
    ;evaluate the number of jobs (for the progress bar)
    nbr_data_file_to_treat = n_elements(list_data)
    pb_number_of_steps = nbr_data_file_to_treat
    (*global).pb_number_of_steps = pb_number_of_steps
    
    progress_bar, event=event, /init
    
    ;start jobs on data
    _index_data = 0
    list_output_file_name = !null
    
    total_intensity = fltarr(nbr_data_file_to_treat)
    number_of_pixels_of_selection = fltarr(nbr_data_file_to_treat)
    mean_intensity = fltarr(nbr_data_file_to_treat)
    
    while (_index_data lt nbr_data_file_to_treat) do begin
    
      message = 'Working with ' + list_data[_index_data]
      read_fits_file, event=event, $
        file_name=list_data[_index_data],$
        data=_data
        
      ;Create array of average values of region selected
      ;this will be used to scale the data file according to the open beam file
      if (nbr_rois gt 0) then begin
      
        _index_data_region = 0
        while (_index_data_region lt nbr_rois) do begin
        
          x0 = roi_table[_index_data_region,0]
          y0 = roi_table[_index_data_region,1]
          x1 = roi_table[_index_data_region,2]
          y1 = roi_table[_index_data_region,3]
          
          xmin = min([x0,x1],max=xmax)
          ymin = min([y0,y1],max=ymax)
          
          _tmp_data_region = _data[xmin:xmax,ymin:ymax]
          
          _nbr_pixels = n_elements(_tmp_data_region)
          number_of_pixels_of_selection[_index_data] += _nbr_pixels
          
          _total_intensity = total(_tmp_data_region)
          total_intensity[_index_data] += _total_intensity
          
          _mean = mean(_tmp_data_region)
          mean_intensity[_index_data] += _mean
          
          _index_data_region++
        endwhile
        
      endif
      
      progress_bar, event=event, /step
      _index_data++
    endwhile
    
    ;create I(file) ascii output file
    create_ascii_output_file, event=event,$
      total_intensity = total_intensity,$
      number_of_pixels_of_selection = number_of_pixels_of_selection, $
      mean_intensity = mean_intensity,$
      output_file=output_file, $
      list_data=list_data
      
    message = ['Done with I(file) process']
    log_book_update, event, message=message
    
    ;kill_normalized_plot, event=event
    progress_bar, event=event, /close
    
    widget_control, hourglass=0
    
    ;list all the files that have been created (in the log book and in a
    ;dialog_message)
    title = 'I(file) has been created!'
    message = ['Name of file create: ' + output_file ]
    widget_id = widget_info(event.top, find_by_uname='MAIN_BASE')
    result = dialog_message(message, $
      /information, $
      title=title,$
      dialog_parent=widget_id,$
      /center)
      
  endif
  
end

;+
; :Description:
;    This routine will create the output file
;
;
;
; :Keywords:
;    event
;    total_intensity
;    number_of_pixels_of_selection
;    mean_intensity
;    output_file
;    list_data
;
; :Author: j35
;-
pro  create_ascii_output_file, event=event,$
    total_intensity = total_intensity,$
    number_of_pixels_of_selection = number_of_pixels_of_selection, $
    mean_intensity = mean_intensity,$
    output_file=output_file, $
    list_data=list_data
  compile_opt idl2
  
  nbr_files = n_elements(list_data)
  text = 'File_Name Total_Intensity Number_of_pixels Mean_Intensity'
  openw, 1, output_file
  printf, 1, text
  for i=0,nbr_files-1 do begin
    _file_name = strcompress(list_data[i],/remove_all)
    _total_intensity = strcompress(total_intensity[i],/remove_all)
    _number_of_pixels = strcompress(number_of_pixels_of_selection[i],/remove_all)
    _mean_intensity = strcompress(mean_intensity[i],/remove_all)
    text = _file_name + ' ' + _total_intensity + ' ' + $
      _number_of_pixels + ' ' + _mean_intensity
    printf, 1, text
  endfor
  close, 1
  free_lun, 1
  return
  
end