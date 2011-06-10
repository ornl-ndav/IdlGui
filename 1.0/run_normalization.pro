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
pro run_normalization, event=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  ;collect list of data, open beam and dark field files
  data_file_table = getValue(event=event, uname='data_files_table')
  list_data = reform(data_file_table)
  
  open_beam_table = getValue(event=event, uname='open_beam_table')
  list_open_beam = reform(open_beam_table)
  
  dark_field_table = getValue(event=event, uname='dark_field_table')
  list_dark_field = reform(dark_field_table)
  
  ;collect table of ROIs
  roi_table =  retrieve_list_roi(event=event)
  
  ;evaluate the number of jobs (for the progress bar)
  nbr_data_file_to_treat = n_elements(list_data)
  
  ;take average of all open beam provided
  nbr_open_beam = n_elements(open_beam_table)
  _open_beam_data = !null
  _index_ob = 0
  while (_index_ob lt nbr_open_beam) do begin
    _ob_file_name = list_open_beam[_index_ob]
    read_fits_file, event=event, $
      file_name=_ob_file_name, $
      data=_data
      if (_index_ob gt 0) then begin
      _open_beam_data += _data
    endif
    _index_ob++
  endwhile
  ;take the average
  _open_beam_data /= nbr_open_beam
  
  ;Create array of average values of region selected
  
  
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
    endif
    _index_df++
  endwhile
  ;take the average
  _dark_field_data /= nbr_dark_field
  
  ;start job
  _index_data = 0
  while (_index_data lt nbr_data_file_to_treat) do begin

  read_fits_file, event=event, $
  file_name=list_data[_index_data],$
  data=_data
  
  apply_gamma_filtering, event=event, data=_data
  
  
  
  
  
  
    _index_data++
  endwhile
  
  
  
  
  
end
