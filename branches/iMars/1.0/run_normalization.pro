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
  _global_mean_array = fltarr(ob_roi_mean)
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
  
  ;collect list of data, open beam and dark field files
  data_file_table = getValue(event=event, uname='data_files_table')
  list_data = reform(data_file_table)
  
  open_beam_table = getValue(event=event, uname='open_beam_table')
  list_open_beam = reform(open_beam_table)
  
  dark_field_table = getValue(event=event, uname='dark_field_table')
  list_dark_field = reform(dark_field_table)
  
  ;collect table of ROIs
  roi_table =  retrieve_list_roi(event=event)
  table_sz = size(roi_table)
  if (table_sz[0] eq 1) then begin
    nbr_rois = 0
  endif else begin
    nbr_rois = table_sz[1]
  endelse
  
  ;evaluate the number of jobs (for the progress bar)
  nbr_data_file_to_treat = n_elements(list_data)
  
  ;take average of all open beam provided
  nbr_open_beam = n_elements(open_beam_table)
  _index_ob = 0
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
  endwhile
  ;take the average
  _open_beam_data /= nbr_open_beam
  
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
      
      _tmp_ob_data_region = _open_beam_data[x0:x1,y0:y1]
      _mean = mean(_tmp_ob_data_region)
      _open_beam_mean_of_regions[_index_ob_region] = _mean
      
      _index_ob_region++
    endwhile
    
  endif else begin
  
    _open_beam_mean_of_regions = fltarr(1)
    _open_beam_mean_of_regions[0] = 1
    
  endelse
  
  ;take average of all dark field
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
  endwhile
  ;take the average
  _dark_field_data /= nbr_dark_field
  
  ;start jobs on data
  _index_data = 0
  while (_index_data lt nbr_data_file_to_treat) do begin
  
    read_fits_file, event=event, $
      file_name=list_data[_index_data],$
      data=_data
      
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
        
        _tmp_data_region = _data[x0:x1,y0:y1]
        _mean = mean(_tmp_data_region)
        _data_file_mean_of_regions[_index_data_region] = _mean
        
        _index_data_region++
      endwhile
      
    endif else begin
    
      _data_file_mean_of_regions = fltarr(1)
      _data_file_mean_of_regions[0] = 1
      
    endelse
    
    _global_mean = get_global_mean(ob_roi_mean=_open_beam_mean_of_regions,$
      data_roi_mean=_data_file_mean_of_regions)
      
    ;rescale data
    _data *= _global_mean
    
    ;calculate numerator and denominator
    ;num = data - DF
    ;den = OB - DF
    num = _data - _dark_field_data
    den = _open_beam_data - _dark_field_data
    
    _data_normalized = num / den
    
    
    
    
    _index_data++
  endwhile
  
  
  
  
  widget_control, hourglass=0
  
end
