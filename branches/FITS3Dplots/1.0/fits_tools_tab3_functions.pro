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

FUNCTION GetHowManyFileWillBeCreated, index_from_time, $
    index_to_time, $
    to_time_microS, $
    bin_size_microS
    
  nbr_file = 0
  WHILE (index_from_time LT to_time_microS) DO BEGIN
  
    nbr_file++
    index_from_time = index_to_time
    index_to_time   = index_from_time + bin_size_microS
    
  ENDWHILE
  
  RETURN, nbr_file
END

;------------------------------------------------------------------------------
FUNCTION increase_count, c, d, u

  u++
  IF (u EQ 10) THEN BEGIN
    u = 0
    d++
  ENDIF
  
  IF (d EQ 10) THEN BEGIN
    d = 0
    c++
  ENDIF
  
  string_u = STRCOMPRESS(u,/REMOVE_ALL)
  string_d = STRCOMPRESS(d,/REMOVE_ALL)
  string_c = STRCOMPRESS(c,/REMOVE_ALL)
  
  RETURN, string_c+string_d+string_u
END

;------------------------------------------------------------------------------
FUNCTION getStep3Counts, Event, x, y

  WIDGET_CONTROL, Event.top, GET_UVALUE=global_plot
  
  id = WIDGET_INFO(Event.top, $
    FIND_BY_UNAME='fits_tools_tab3_plot_draw_uname')
  WIDGET_CONTROL, id, GET_VALUE = id_value
  WSET, id_value
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  draw_xsize = main_base_geometry.xsize
  draw_ysize = main_base_geometry.ysize
  
  current_bin_array = (*(*global_plot).current_bin_array)
  congrid_current_bin_array = CONGRID(current_bin_array, $
    draw_xsize, draw_ysize)
    
  counts = congrid_current_bin_array[x,y]
  RETURN, STRCOMPRESS(counts,/REMOVE_ALL)
END

;------------------------------------------------------------------------------
FUNCTION getStep3X, Event, x

  WIDGET_CONTROL, Event.top, GET_UVALUE=global_plot
  
  detector_xsize = (*global_plot).detector_xsize
  
  id1 = WIDGET_INFO(Event.top, $
    FIND_BY_UNAME='fits_tools_tab3_plot_draw_uname')
  WIDGET_CONTROL, id1, /REALIZE
  geometry = WIDGET_INFO(id1, /GEOMETRY)
  xsize = geometry.scr_xsize
  
  data_x = (x * detector_xsize) / xsize
  s_data_x = data_x[0]
  
  RETURN, STRCOMPRESS(s_data_x,/REMOVE_ALL)
  
END

;------------------------------------------------------------------------------
FUNCTION getStep3Y, Event, y

  WIDGET_CONTROL, Event.top, GET_UVALUE=global_plot
  
  detector_ysize = (*global_plot).detector_ysize
  
  id1 = WIDGET_INFO(Event.top, $
    FIND_BY_UNAME='fits_tools_tab3_plot_draw_uname')
  WIDGET_CONTROL, id1, /REALIZE
  geometry = WIDGET_INFO(id1, /GEOMETRY)
  ysize = geometry.scr_ysize
  
  data_y = (y * detector_ysize) / ysize
  s_data_y = data_y[0]
  
  RETURN, STRCOMPRESS(s_data_y,/REMOVE_ALL)
  
END

;------------------------------------------------------------------------------
FUNCTION is_create_fits_button_enabled, Event, uname=uname

  ON_IOERROR, error
  
  ;if bin size is not 0 or empty
  bin_size = FIX(getTextFieldValue(Event, 'tab3_bin_size_value'))
  IF (bin_size EQ 0) THEN RETURN, 0
  
  ;if there is a file name defined
  file_name = getTextFieldValue(Event, 'tab3_file_name')
  IF (file_name EQ '') THEN RETURN, 0
  
  ;make sure there are at least 1 file name
  nbr_files_loaded = getFirstEmptyXarrayIndex(event=event)
  IF (nbr_files_loaded EQ 0) THEN RETURN, 0
  
  ;make sure the from and to time are not empty and values that make sense
  from_time = STRCOMPRESS(getTextFieldValue(Event,$
    'tab3_from_time_microS'),/REMOVE_ALL)
  IF (from_time EQ '') THEN RETURN, 0
  f_from_time = FLOAT(from_time)
  
  to_time   = STRCOMPRESS(getTextFieldValue(Event,$
    'tab3_to_time_microS'),/REMOVE_ALL)
  IF (to_time EQ '') THEN RETURN, 0
  f_to_time = FLOAT(to_time)
  
  IF (f_from_time GE f_to_time) THEN RETURN, 0
  
  RETURN, 1
  
  error:
  title = 'Input Error'
  message_text = 'The bin size you defined is not a valid number!'
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  result = DIALOG_MESSAGE(message_text,$
    title=title,$
    /CENTER,$
    DIALOG_PARENT=id,$
    /ERROR)
    
  IF (N_ELEMENTS(uname) NE 0) THEN BEGIN
    putValue, Event, uname, ''
  ENDIF
  
END

;------------------------------------------------------------------------------
FUNCTION is_tab3_plot_button_enabled, Event

  ON_IOERROR, error
  
  ;if bin size is not 0 or empty
  bin_size = FIX(getTextFieldValue(Event, 'tab3_bin_size_value'))
  IF (bin_size EQ 0) THEN RETURN, 0
  
  ;make sure there are at least 1 file name
  nbr_files_loaded = getFirstEmptyXarrayIndex(event=event)
  IF (nbr_files_loaded EQ 0) THEN RETURN, 0
  
  RETURN, 1
  
  error:
  RETURN, 0
  
END



