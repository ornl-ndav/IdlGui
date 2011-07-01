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
;    This returns the global mean value between all the regions of the OB
;    and the data files. This coefficient will be used to rescale the
;    data array
;
;
;
; :Keywords:
;    ob_roi_mean
;    data_roi_mean
;
; :Author: j35
;-
function get_global_mean, ob_roi_mean=ob_roi_mean, $
    data_roi_mean=data_roi_mean
  compile_opt idl2
  
  sz = n_elements(ob_roi_mean)
  _index = 0
  _global_mean_array = fltarr(sz)
  while (_index lt sz) do begin
  
    _tmp = data_roi_mean[_index] / ob_roi_mean[_index]
    _global_mean_array[_index] = _tmp
    
    _index++
  endwhile
  
  return, mean(_global_mean_array)
end

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
pro run_normalization, event=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  widget_control, /hourglass
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    widget_control, hourglass=0
    message = ['Normalization failed !!!!']
    log_book_update, event, message=message
    
    save_log_book, event=event, file_name=file_name
    
    kill_normalized_plot, event=event
    progress_bar, event=event, /close
    
    title = 'Normalization FAILED!'
    message = ['Please check log book or send ' + file_name, $
      'to j35@ornl.gov']
    widget_id = widget_info(event.top, find_by_uname='MAIN_BASE')
    result = dialog_message(message, $
      /error, $
      title=title,$
      dialog_parent=widget_id,$
      /center)
      
    return
  endif
  
  message = ['----------------------------','Start normalization using:']
  
  ;collect list of data, open beam and dark field files
  data_file_table = getValue(event=event, uname='data_files_table')
  list_data = reform(data_file_table)
  message = [message,'-> list data files:']
  _message = '    ' + list_data
  message = [message, _message]
  
  open_beam_table = getValue(event=event, uname='open_beam_table')
  list_open_beam = reform(open_beam_table)
  message = [message,'-> list open beam:']
  _message = '    ' + list_open_beam
  message = [message, _message]
  
  dark_field_table = getValue(event=event, uname='dark_field_table')
  list_dark_field = reform(dark_field_table)
  message = [message,'-> list dark field:']
  _message = '    ' + list_dark_field
  message = [message, _message]
  
  ;collect table of ROIs
  roi_table =  retrieve_list_roi(event=event)
  table_sz = size(roi_table)
  if (table_sz[0] eq 1) then begin
    nbr_rois = 0
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
  ;for merging all the open beam + merging ROIs
  pb_number_of_steps +=  n_elements(open_beam_table)+1
  ;for merging all the dark field
  pb_number_of_steps += n_elements(dark_field_table)
  (*global).pb_number_of_steps = pb_number_of_steps
  
  progress_bar, event=event, /init
  
  log_book_update, event, message='Starting work on open beam(s)'
  ;take mean of all open beam provided
  nbr_open_beam = n_elements(open_beam_table)
  _index_ob = 0
  _open_beam_data = !null
  while (_index_ob lt nbr_open_beam) do begin
    _ob_file_name = list_open_beam[_index_ob]
    read_fits_file, event=event, $
      file_name=_ob_file_name, $
      data=_data
    if (_index_ob gt 0) then begin
      _open_beam_data += _data
    endif else begin
      _open_beam_data = _data
    endelse
    _index_ob++
    progress_bar, event=event, /step
  endwhile
  ;take the average
  
  ;no need to take average of only 1 open beam file
  if (nbr_open_beam gt 1) then begin
    _open_beam_data /= nbr_open_beam
    log_book_update, event, message='-> done with getting average open beam'
  endif
  
  ;Create array of average values of region selected
  ;this will be used to scale the data file according to the open beam file
  if (nbr_rois gt 0) then begin
  
    _open_beam_mean_of_regions = fltarr(nbr_rois)
    _index_ob_region = 0
    while (_index_ob_region lt nbr_rois) do begin
    
      x0 = roi_table[_index_ob_region,0]
      y0 = roi_table[_index_ob_region,1]
      x1 = roi_table[_index_ob_region,2]
      y1 = roi_table[_index_ob_region,3]
      
      xmin = min([x0,x1],max=xmax)
      ymin = min([y0,y1],max=ymax)
      
      _tmp_ob_data_region = _open_beam_data[xmin:xmax,ymin:ymax]
      _mean = mean(_tmp_ob_data_region)
      _open_beam_mean_of_regions[_index_ob_region] = _mean
      
      _index_ob_region++
    endwhile
    
  endif else begin
  
    _open_beam_mean_of_regions = fltarr(1)
    _open_beam_mean_of_regions[0] = 1
    
  endelse
  log_book_update, event, message='-> done with getting open beam ROIs'
  progress_bar, event=event, /step
  
  ;take average of all dark field
  log_book_update, event, message='Starting work on dark field'
  nbr_dark_field = n_elements(dark_field_table)
  _dark_field_data = !null
  _index_df = 0
  while (_index_df lt nbr_dark_field) do begin
    _df_file_name = list_dark_field[_index_df]
    read_fits_file, event=event, $
      file_name=_df_file_name, $
      data=_data
    if (_index_df gt 0) then begin
      _dark_field_data += _data
    endif else begin
      _dark_field_data = _data
    endelse
    _index_df++
    progress_bar, event=event, /step
  endwhile
  
  ;no need to take average if there is only 1 dark field
  if (nbr_dark_field gt 1) then begin
    ;take the average
    _dark_field_data /= nbr_dark_field
    log_book_update, event, message='-> done with getting average dark field'
  endif
  
  ;start jobs on data
  _index_data = 0
  list_output_file_name = !null
  while (_index_data lt nbr_data_file_to_treat) do begin
  
    message = 'Working with ' + list_data[_index_data]
    read_fits_file, event=event, $
      file_name=list_data[_index_data],$
      data=_data
      
    if (isButtonSelected(event=event,uname='with_gamma_filtering_uname')) $
      then begin
      message = [message, '-> Applying gamma filtering']
    endif
    apply_gamma_filtering, event=event, data=_data
    
    ;Create array of average values of region selected
    ;this will be used to scale the data file according to the open beam file
    if (nbr_rois gt 0) then begin
    
      _data_file_mean_of_regions = fltarr(nbr_rois)
      _index_data_region = 0
      while (_index_data_region lt nbr_rois) do begin
      
        x0 = roi_table[_index_data_region,0]
        y0 = roi_table[_index_data_region,1]
        x1 = roi_table[_index_data_region,2]
        y1 = roi_table[_index_data_region,3]
        
        xmin = min([x0,x1],max=xmax)
        ymin = min([y0,y1],max=ymax)
        
        _tmp_data_region = _data[xmin:xmax,ymin:ymax]
        _mean = mean(_tmp_data_region)
        _data_file_mean_of_regions[_index_data_region] = _mean
        
        _index_data_region++
      endwhile
      
    endif else begin
    
      _data_file_mean_of_regions = fltarr(1)
      _data_file_mean_of_regions[0] = 1
      
    endelse
    message = [message, '-> Created array of average values of ROIs']
    
    _global_mean = get_global_mean(ob_roi_mean=_open_beam_mean_of_regions,$
      data_roi_mean=_data_file_mean_of_regions)
    message = [message, '-> mean value: ' + $
      strcompress(_global_mean,/remove_all)]
      
    ;rescale data
    _data /= _global_mean
    
    ;calculate numerator and denominator
    ;num = data - DF
    ;den = OB - DF
    num = _data - _dark_field_data
    den = _open_beam_data - _dark_field_data
    
    _data_normalized = num / den
    
    ;cleanup data
    cleanup_data_normalized, event=event, $
      data=_data_normalized, $
      message=message
      
    launch_normalized_plot, event=event, $
      data=_data_normalized, $
      file_name=list_data[_index_data]
      
    create_output_tiff_file, event=event, $
      input_file_name = list_data[_index_data], $
      data = _data_normalized, $
      output_file_name = output_file_name
    if (output_file_name ne '') then $
      list_output_file_name = [list_output_file_name,output_file_name]
      
    create_output_fits_file, event=event, $
      input_file_name = list_data[_index_data], $
      data = _data_normalized, $
      output_file_name = output_file_name
    if (output_file_name ne '') then $
      list_output_file_name = [list_output_file_name,output_file_name]
      
    create_output_png_file, event=event, $
      input_file_name = list_data[_index_data], $
      data = _data_normalized, $
      output_file_name = output_file_name
    if (output_file_name ne '') then $
      list_output_file_name = [list_output_file_name,output_file_name]
      
    message = [message, '-> created output file(s)']
    log_book_update, event, message=message
    
    progress_bar, event=event, /step
    _index_data++
  endwhile
  
  message = ['Done with normalization','-> List of files produced:']
  _i=0
  nbr_output = n_elements(list_output_file_name)
  while (_i lt nbr_output) do begin
    new_line = '  -> ' + list_output_file_name[_i]
    message = [message,new_line]
    _i++
  endwhile
  log_book_update, event, message=message
  
  kill_normalized_plot, event=event
  progress_bar, event=event, /close
  
  widget_control, hourglass=0
  
  ;list all the files that have been created (in the log book and in a
  ;dialog_message)
  title = strcompress(nbr_output,/remove_all) + ' files have been created!'
  output_folder = getValue(event=event,uname='output_folder_button')
  message = ['Files have been created in: ' + output_folder + '            ']
  widget_id = widget_info(event.top, find_by_uname='MAIN_BASE')
  result = dialog_message(message, $
    /information, $
    title=title,$
    dialog_parent=widget_id,$
    /center)
    
end

;+
; :Description:
;    This routine will do the following on the normalized data
;     - all values below 0 will be bring back to 0
;     - all values above 1 will be bring back to 1
;     - * by 65535
;     - float -> integer
;
; :Keyowrds:
;    event
;    data
;    message
;
;
; :Author: j35
;-
pro cleanup_data_normalized, event=event, data=data, message=message
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  method = (*global).normalization_method
  
  message = [message, '-> Cleanup data normalized using ' + method]
  
  case (method) of
    'method1': begin ;stretched data between [0,1] 32bits
    
      min_value = min(data,max=max_value)
      
      ;trying something here
      if (min_value lt 0) then begin
        data += abs(min_value)
      endif else begin
        data -= min_value
      endelse
      
      min_value = min(data,max=max_value)
      data = float(data) / (float(max_value))
      
      ;for 32bits output file
      ;full range of color
      data = float(data) * 65535.
      ;data -= 32768
      
      ;float->integer
      data = long(data)
      
    end
    
    'method2': begin ;32bits output file [0, 65535]
    
      index_neg = where(data lt 0.)
      data[index_neg] = 0.
      
      index_gt_1 = where(data gt 1.)
      data[index_gt_1] = 1.
      
      ;for 32bits output file
      ;full range of color
      data = float(data) * 65535.
      ;data -= 32768
      
      ;float->integer
      data = long(data)
      
    end
    
    'method3': begin ;16bits output file [-32767,32768]
    
      min_value = min(data,max=max_value)
      index = where(data GT 1, nbr)
      
      index_neg = where(data lt 0.)
      data[index_neg] = 0.
      
      index_gt_1 = where(data gt 1.)
      data[index_gt_1] = 1.
      
      ;full range of color
      data = float(data) * 65535.
      data -= 32768
      
      ;float->integer
      data = fix(data)
      
    end
    
  endcase
  
  
end

;+
; :Description:
;    This returns the base file name. The suffix will be added later
;
;
;
; :Keywords:
;    event
;    full_file_name
;    prefix   ex:'N_'
;    suffix   ex:'tiff'
;
; :Author: j35
;-
function get_base_output_file, event=event, $
    full_file_name=full_file_name, $
    prefix=prefix, $
    suffix=suffix
  compile_opt idl2
  
  ;determine the new output file name
  output_folder = getValue(event=event,uname='output_folder_button')
  
  ;base file name
  base_file_name = file_basename(full_file_name)
  
  ;remove extension, add '_normalized.fits'
  file_array = strsplit(base_file_name,'.',/extract)
  sz = n_elements(file_array)
  if (sz gt 1) then begin
    _file = strjoin(file_array[0:-2],'.')
  endif else begin
    _file = file_array[0]
  endelse
  
  ;new output file name
  output_file = output_folder + prefix + _file + '.' + suffix
  
  return, output_file
end

;+
; :Description:
;    Create the TIFF output file
;
;
;
; :Keywords:
;    event
;    input_file_name
;    data
;    output_file_name
;
; :Author: j35
;-
pro create_output_tiff_file, event=event, $
    input_file_name=input_file_name, $
    data=data, $
    output_file_name = output_file_name
  compile_opt idl2
  
  ;stop here is we did not select tiff format
  if (~isButtonSelected(event=event,uname='format_tiff_button')) then begin
    output_file_name = ''
    return
  endif
  
  ;get base_output_file
  output_file_name = get_base_output_file(event=event, $
    full_file_name = input_file_name, $
    prefix = 'N_', $
    suffix = 'tif')
    
  write_tiff, output_file_name, data
  
end

;+
; :Description:
;    Create the FITS output file
;
;
;
; :Keywords:
;    event
;    input_file_name
;    data
;    output_file_name
;
; :Author: j35
;-
pro create_output_fits_file, event=event, $
    input_file_name=input_file_name, $
    data=data, $
    output_file_name = output_file_name
  compile_opt idl2
  
  ;stop here is we did not select tiff format
  if (~isButtonSelected(event=event,uname='format_fits_button')) then begin
    output_file_name = ''
    return
  endif
  
  ;get base_output_file
  output_file_name = get_base_output_file(event=event, $
    full_file_name = input_file_name,$
    prefix = 'N_', $
    suffix = 'fits')
    
  fits_write, output_file_name, data
  
end

;+
; :Description:,
;    Create the png output file
;
;
;
; :Keywords:
;    event
;    input_file_name
;    data
;    output_file_name
;
; :Author: j35
;-
pro create_output_png_file, event=event, $
    input_file_name=input_file_name, $
    data=data, $
    output_file_name=output_file_name
  compile_opt idl2
  
  ;stop here is we did not select tiff format
  if (~isButtonSelected(event=event,uname='format_png_button')) then begin
    output_file_name = ''
    return
  endif
  
  ;get base_output_file
  output_file_name = get_base_output_file(event=event, $
    full_file_name = input_file_name, $
    prefix = 'N_', $
    suffix = 'png')
    
  widget_control, event.top, get_uvalue=global
  id =  (*global).normalized_plot_base_id
  id_draw = widget_info(id, find_by_uname='normalized_draw')
  widget_control, id_draw, get_value=id_value
  wset,id_value
  
  write_png, output_file_name, tvrd(/true)
  
end