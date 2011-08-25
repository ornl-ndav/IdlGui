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
;    This routine display the counts vs pixel of the diffraction banks
;    integrated over TOF
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro plot_diffraction_counts_vs_pixel, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  banks_9_10 = (*(*global).diff_raw_data)    ; Array[128*9, nbr TOF]
  sz = size(banks_9_10,/dim)
  nbr_pixels = sz[0]
  pixel_range = indgen(nbr_pixels) + 8192*2
  
  _data = total(banks_9_10, 2)
  
  mp_plot = plot(pixel_range, _data, $
    title = 'Counts vs pixels of Diffranction banks integrated over all TOF', $
    xtitle = 'Pixels ID',$
    ytitle = 'Counts',$
    "r4D-")
    
end

;+
; :Description:
;    Display counts vs Q of the diffraction banks
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro plot_diffraction_counts_vs_q, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  full_nexus = (*global).NexusFullName
  fileID  = h5f_open(full_nexus)
  
  nbr_diff_banks = 9
  list_banks = strcompress(indgen(nbr_diff_banks) + 5, /remove_all)
  path1 = '/entry-diff/instrument/bank'
  path_distance = path1 + list_banks + '/distance/'
  path_polar = path1 + list_banks + '/polar_angle/'
  
  diff_bank_distance = !null
  diff_polar_angle = !null
  for i=0, (nbr_diff_banks-1) do begin
  
    fieldID = h5d_open(fileID, path_distance[i])
    _bank = reform(h5d_read(fieldID))
    diff_bank_distance = [diff_bank_distance, _bank]
    h5d_close, fieldID
    
    fieldID = h5d_open(fileID, path_polar[i])
    _polar = reform(h5d_read(fieldID))
    diff_polar_angle = [diff_polar_angle, _polar]
    h5d_close, fieldID
    
  endfor
  
  ;  ;display distance vs pixelid
  ;  pixel_range = indgen(128*9) + 8192*2
  ;  md_plot = plot(pixel_range, $
  ;    diff_bank_distance, $
  ;    title = 'Distance Sample/Detector',$
  ;    xtitle = 'Pixels ID',$
  ;    ytitle = 'Distance (m)',$
  ;    "r4D-")
  
  ;  ;display distance vs pixelid
  ;  pixel_range = indgen(128*9) + 8192*2
  ;  md_plot = plot(pixel_range, $
  ;    diff_polar_angle, $
  ;    title = 'Polar angle vs pixels ID',$
  ;    xtitle = 'Pixels ID',$
  ;    ytitle = 'Polar angle (rad)',$
  ;    "r4D-")
  
  ;retrieve distance sample/moderator
  fieldID = h5d_open(fileID, '/entry-diff/instrument/moderator/distance')
  distance = abs(h5d_read(fieldID))   ;m
  h5d_close, fieldID
  
  ;retrieve tof scale
  fieldID = h5d_open(fileID, '/entry-diff/instrument/bank5/time_of_flight')
  tof_array = h5d_read(fieldID)
  h5d_close, fieldID
  
  h5f_close, fileID ;close file handler
  
  ;retrieve constants
  mn = (*global).mn
  h = (*global).h
  
  ;retrieve raw data
  banks_9_10 = (*(*global).diff_raw_data)    ; Array[128*9, nbr TOF]
  
  sz = size(banks_9_10,/dim)
  nbr_pixel = sz[0]
  nbr_tof = sz[1]
  
  diff_Q = fltarr(nbr_pixel, nbr_tof)
  
  
  
  
  
end