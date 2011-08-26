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
  distance = float(abs(h5d_read(fieldID)))   ;m
  h5d_close, fieldID
  
  ;retrieve tof scale
  fieldID = h5d_open(fileID, '/entry-diff/instrument/bank5/time_of_flight')
  tof_array = h5d_read(fieldID)
  h5d_close, fieldID
  
  h5f_close, fileID ;close file handler
  
  ;retrieve constants
  mn = (*global).mn
  h = (*global).h
  h_over_mn = float(h) / float(mn)
  four_pi = 4. * !PI
  
  ;retrieve raw data
  banks_9_10 = (*(*global).diff_raw_data)    ; Array[128*9, nbr TOF]
  
  sz = size(banks_9_10,/dim)
  nbr_pixel = sz[0]
  nbr_tof = sz[1]
  
  ;Determine the true range of TOF to use
  banks_9_10_integrated_over_pixels = total(banks_9_10, 1)
  
  index_non_zero = where(banks_9_10_integrated_over_pixels ne 0)
  tof_min = tof_array[index_non_zero[0]]*1.e-6 ;s
  tof_max = tof_array[index_non_zero[-1]]*1.e-6  ;s
  
  ;  print, 'tof_min: ' , tof_min
  ;  print, 'tof_max: ' , tof_max
  
  ;calculate the min and max Q and then bring to life a widget_base that
  ;ask the user for a Q width or number of bins (linear and log)
  Qmin = 10
  ;    print, 'Calculation of Qmin'
  _tof = tof_max
  ;    print, '-> _tof_max[s]: ' , _tof
  for px_index=0,1151 do begin
  
    _pixel_distance = float(diff_bank_distance[px_index])
    _d = distance + _pixel_distance
    _polar_angle = float(diff_polar_angle[px_index])
    ;print, '--> _polar_angle[rad]: ' , _polar_angle
    
    _d_over_tof = _d / _tof
    _lambda = (h_over_mn / _d_over_tof) * 1e10
    
    ;print, '--> _d_over_tof: ' , _d_over_tof
    ;print, '--> _lambda: ' , _lambda
    ;print, '--> sin(_polar_angle/2.): ', sin(_polar_angle/2.)
    
    Q = (four_pi / _lambda) * sin(_polar_angle/2.)
    
    ;print, '---> Q: ' , Q
    
    Qmin = (Q lt Qmin) ? Q : Qmin
    
  endfor
  ;  print, '***************'
  ;  print, 'Qmin: ' , Qmin
  ;  print, '***************'
  
  Qmax = 0
  _tof = tof_min
  for px_index=0,1151 do begin
  
    _pixel_distance = float(diff_bank_distance[px_index])
    _polar_angle = float(diff_polar_angle[px_index])
    
    _d = distance + _pixel_distance
    _d_over_tof = _d / _tof
    _lambda = (h_over_mn / _d_over_tof) * 1e10
    
    Q = (four_pi / _lambda) * sin(_polar_angle/2.)
    
    Qmax = (Q gt Qmax) ? Q : Qmax
    
  endfor
  ;  print, '***************'
  ;  print, 'Qmax: ' , Qmax
  ;  print, '***************'
  
  q_range_base, Event=event, $
    tof_min=tof_min, $
    tof_max=tof_max, $
    q_min=Qmin, $
    q_max=Qmax
    
  return
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  diff_Q = fltarr(long(nbr_pixel) * long(nbr_tof))   ;Array[nbr_pixel * nbr_tof]
  diff_counts = fltarr(long(nbr_pixel) * long(nbr_tof))
  
  for tof_index=0,(nbr_tof-1) do begin
    _tof = float(tof_array[tof_index])
    for px_index=0,(nbr_pixel-1) do begin
    
      _pixel_distance = float(diff_bank_distance[px_index])
      _polar_angle = float(diff_polar_angle[px_index])
      
      _d = distance + _pixel_distance
      _d_over_tof = _d / _tof
      _lambda = h_over_mn / _d_over_tof
      
      Q = (four_pi / _lambda) * sin(_polar_angle/2.)
      
      diff_Q[long(tof_index) * long(nbr_tof + px_index)] = Q
      diff_counts[tof_index * nbr_tof + px_index] = banks_9_10[px_index, tof_index]
      
    endfor
  endfor
  
  help, diff_Q
  help, diff_counts
  
  
end