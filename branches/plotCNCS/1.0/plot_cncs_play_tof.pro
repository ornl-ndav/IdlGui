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

FUNCTION checkPauseStop, Event
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;check pause status
  id_pause = WIDGET_INFO(event.top,find_by_uname='pause_button')
  pause_status = 0
  IF WIDGET_INFO(id_pause,/valid_id) then begin
    CATCH, error
    IF (error NE 0) THEN BEGIN
      CATCH,/CANCEL
    ENDIF ELSE BEGIN
      event_id = WIDGET_EVENT(id_pause,/nowait)
      IF (event_id.press EQ 1) THEN BEGIN
        (*global).pause_button_activated = 1
        play_buttons_activation, event, activate_button='pause'
        pause_status = 1
      ENDIF ELSE BEGIN
        (*global).pause_button_activated = 0
      ENDELSE
    ENDELSE
  ENDIF
  
  id_stop = WIDGET_INFO(event.top,find_by_uname='stop_button')
  stop_status = 0
  IF WIDGET_INFO(id_stop,/valid_id) then begin
    CATCH, error
    IF (error NE 0) THEN BEGIN
      CATCH,/CANCEL
    ENDIF ELSE BEGIN
      event_id = WIDGET_EVENT(id_stop,/nowait)
      IF (event_id.press EQ 1) THEN BEGIN
        play_buttons_activation, event, activate_button='stop'
        stop_status = 1
      ENDIF
    ENDELSE
  ENDIF
  
  RETURN, [pause_status,stop_status]
END

;==============================================================================
PRO preview_of_tof, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  wBase = (*global1).wBase
  
  nexus_file_name = (*global1).nexus_file_name
  tof_array = (*(*global1).tof_array)
  s_tof_array = STRCOMPRESS(tof_array,/REMOVE_ALL)
  
  title = 'TOF axis of ' + nexus_file_name
  done_button = 'DONE with TOF axis'
  
  sz = N_ELEMENTS(tof_array)
  new_tof_array = STRARR(1,sz+1)
  new_tof_array[0] = 'Bin #     TOF Range (microS)'
  index = 1
  WHILE (index LT sz) DO BEGIN
    new_tof_array[index] = STRCOMPRESS(index,/REMOVE_ALL) + $
      '          ' + s_tof_array[index-1] + ' -> ' + $
      s_tof_array[index]
    index++
  ENDWHILE
  XDISPLAYFILE, GROUP=wBase, $
    TITLE=title, $
    TEXT=new_tof_array, $
    DONE_BUTTON=done_button
    
END

;------------------------------------------------------------------------------
PRO play_tof, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  
  IF ((*global1).nexus_file_name NE '' ) THEN BEGIN
    tof_array = (*(*global1).tof_array)
  ENDIF
  
  ;get nbr bins per frame
  nbr_bins_per_frame = getNbrBinsPerFrame(Event)
  time_per_frame     = getTimePerFrame(Event)
  
  ;to check 3 times if pause has been hitted
  time_per_frame = FLOAT(time_per_frame) / 3.0
  ;during the same frame displayed
  
  img = (*(*global1).img)
  nbr_total_bins = (SIZE(img))(1)
  
  IF ((*global1).pause_button_activated) THEN BEGIN
    bin_min = (*global1).bin_min
    bin_max = (*global1).bin_max
  ENDIF ELSE BEGIN
    bin_min = getFromBin(Event)
    bin_max = bin_min + nbr_bins_per_frame
  ENDELSE
  
  ;select plot area
  id = WIDGET_INFO(Event.top,find_by_uname='main_plot')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  ERASE
  
  to_bin = getToBin(Event)
  WHILE (bin_min LT to_bin) DO BEGIN
  
    display_current_bin, Event, bin_min=bin_min, bin_max=bin_max
    
    ;extract range of data
    img_range = img[bin_min:bin_max-1,*,*]
    
    (*global1).bin_min = bin_min
    (*global1).bin_max = bin_max
    
    ;display min and max
    putTextFieldValue, Event, 'min_bin_value', STRCOMPRESS(bin_min,/REMOVE_ALL)
    putTextFieldValue, Event, 'max_bin_value', STRCOMPRESS(bin_max,/REMOVE_ALL)
    IF ((*global1).nexus_file_name NE '' ) THEN BEGIN
      putTextFieldValue, Event, 'min_tof_value', $
        STRCOMPRESS(tof_array[bin_min],/REMOVE_ALL)
      putTextFieldValue, Event, 'max_tof_value', $
        STRCOMPRESS(tof_array[bin_max],/REMOVE_ALL)
    ENDIF
    
    plot_from_play_tof, Event, img_range
    
    time_index = 0
    while (time_index LT 3) DO BEGIN
      ;check if user click pause or stop
      pause_stop_status = checkPauseStop(event)
      pause_status = pause_stop_status[0]
      stop_status  = pause_stop_status[1]
      IF (pause_status EQ 1) THEN BEGIN
        RETURN
      ENDIF
      
      IF (stop_status) EQ 1 THEN BEGIN
        stop_play, Event
        RETURN
      ENDIF
      
      WAIT, time_per_frame
      time_index++
      
    ENDWHILE
    
    bin_min = bin_max
    bin_max = bin_min + nbr_bins_per_frame
    
    IF (bin_max GT to_bin) THEN bin_max = to_bin
    
  ENDWHILE
  
  play_buttons_activation, event, activate_button='all'
  
END

;------------------------------------------------------------------------------
PRO plot_from_play_tof, Event, img

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  
  ;retrieve values from inside structure
  Xfactor = (*global1).Xfactor
  Yfactor = (*global1).Yfactor
  Xcoeff  = (*global1).Xcoeff
  Ycoeff  = (*global1).Ycoeff
  off     = (*global1).off
  xoff    = (*global1).xoff
  wbase   = (*global1).wBase
  
  ;main data array
  tvimg = TOTAL(img,1)
  tvimg = TRANSPOSE(tvimg)
  
  ;change title
  id = WIDGET_INFO(wBase,find_by_uname='main_plot_base')
  WIDGET_CONTROL, id, base_set_title= (*global1).main_plot_real_title
  
  ;select plot area
  id = WIDGET_INFO(wBase,find_by_uname='main_plot')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  ;Create big array (before rebining)
  xsize       = 8L
  xsize_space = 1L
  xsize_total = xsize * 52L + xsize_space * 51L
  ysize = 128L
  big_array = LONARR(xsize_total, ysize)
  ;put left part in big array
  FOR i=0L,(36L-1) DO BEGIN
    bank = tvimg[i*8:(i+1)*8L-1,*]
    big_array[i*7L+2*i:(i+1L)*7L+2*i,*] = bank
  ENDFOR
  ;put right part in big array
  FOR i=38L,(52L-2L) DO BEGIN
    bank = tvimg[(i-2L)*8L:(i-1L)*8L-1,*]
    big_array[i*7L+2*i:(i+1L)*7L+2*i,*] = bank
  ENDFOR
  
  ;min value and max value
  min = getCWFieldValue(Event,'main_base_min_value')
  max = getCWFieldValue(Event,'main_base_max_value')
  
  index_min = WHERE(big_array LT MIN, nbr)
  IF (nbr GT 0) THEN BEGIN
    big_array[index_min] = 0
  ENDIF
  
  index_max = WHERE(big_array GT MAX, nbr)
  IF (nbr GT 0) THEN BEGIN
    big_array[index_max] = 0
  ENDIF
  
  ;check if we want lin or log
  lin_status = isMainPlotLin(Event)
  IF (lin_status EQ 0) THEN BEGIN ;log
  
    ;remove 0 values and replace with NAN
    ;and calculate log
    index = WHERE(big_array EQ 0, nbr)
    IF (nbr GT 0) THEN BEGIN
      big_array[index] = !VALUES.D_NAN
      big_array = ALOG10(big_array)
      big_array = BYTSCL(big_array,/NAN)
    ENDIF
    
  ENDIF
  
  IF (min NE MAX) THEN BEGIN
  
    ;rebin big array
    big_array_rebin = REBIN(big_array, xsize_total*Xfactor, $
      ysize*Yfactor,/SAMPLE)
      
    yoff = 0
    TVSCL, big_array_rebin, /DEVICE, xoff, yoff
    (*(*global1).big_array_rebin) = big_array_rebin
    (*(*global1).big_array_rebin_rescale) = big_array_rebin
    
    ;plot scale
    plot_scale, global1, min, max
    
  ENDIF
  
  ;select plot area
  id = WIDGET_INFO(wBase,find_by_uname='main_plot')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  ;plot grid
  plotGridMainPlot, global1
  
END

;------------------------------------------------------------------------------
PRO stop_play, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  plotDASviewFullInstrument, global1
  putTextFieldValue, Event, 'min_tof_value', 'N/A'
  (*global1).pause_button_activated = 0
  putTextFieldValue, Event, 'max_tof_value', 'N/A'
  putTextFieldValue, Event, 'min_bin_value', 'N/A'
  putTextFieldValue, Event, 'max_bin_value', 'N/A'
  
  ;get nbr bins per frame
  nbr_bins_per_frame = getNbrBinsPerFrame(Event)
  bin_min = getFromBin(Event)
  (*global1).bin_min = bin_min
  bin_max = getToBin(Event)
  (*global1).bin_max = bin_max
  
  id = WIDGET_INFO(Event.top,find_by_uname='play_counts_vs_tof_plot')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  background = (*(*global1).background)
  TV, background
  
;display_current_bin, Event, bin_min=bin_min, bin_max=bin_max
  
END

;------------------------------------------------------------------------------
PRO play_next, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  
  ;get nbr bins per frame
  nbr_bins_per_frame = getNbrBinsPerFrame(Event)
  time_per_frame     = getTimePerFrame(Event)
  
  ;to check 3 times if pause has been hitted
  time_per_frame = FLOAT(time_per_frame) / 3.0
  ;during the same frame displayed
  
  img = (*(*global1).img)
  nbr_total_bins = (SIZE(img))(1)
  
  bin_min = (*global1).bin_min
  bin_max = (*global1).bin_max
  to_bin = getToBin(Event)
  
  ;select plot area
  id = WIDGET_INFO(Event.top,find_by_uname='main_plot')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  IF (bin_max GE to_bin) THEN RETURN
  ERASE
  
  bin_min = bin_max
  bin_max = bin_min + nbr_bins_per_frame
  IF (bin_max GT to_bin) THEN bin_max = to_bin
  
  ;extract range of data
  img_range = img[bin_min:bin_max-1,*,*]
  
  (*global1).bin_min = bin_min
  (*global1).bin_max = bin_max
  
  ;display min and max
  putTextFieldValue, Event, 'min_bin_value', STRCOMPRESS(bin_min,/REMOVE_ALL)
  putTextFieldValue, Event, 'max_bin_value', STRCOMPRESS(bin_max,/REMOVE_ALL)
  IF ((*global1).nexus_file_name NE '') THEN BEGIN
    tof_array = (*(*global1).tof_array)
    putTextFieldValue, Event, 'min_tof_value', $
      STRCOMPRESS(tof_array[bin_min],/REMOVE_ALL)
    putTextFieldValue, Event, 'max_tof_value', $
      STRCOMPRESS(tof_array[bin_max],/REMOVE_ALL)
  ENDIF
  
  display_current_bin, Event, bin_min=bin_min, bin_max=bin_max
  plot_from_play_tof, Event, img_range
  
END

;------------------------------------------------------------------------------
PRO play_previous, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  
  ;get nbr bins per frame
  nbr_bins_per_frame = getNbrBinsPerFrame(Event)
  time_per_frame     = getTimePerFrame(Event)
  
  ;to check 3 times if pause has been hitted
  time_per_frame = FLOAT(time_per_frame) / 3.0
  ;during the same frame displayed
  
  img = (*(*global1).img)
  nbr_total_bins = (SIZE(img))(1)
  
  bin_min = (*global1).bin_min
  bin_max = (*global1).bin_max
  from_bin = getFromBin(Event)
  
  ;select plot area
  id = WIDGET_INFO(Event.top,find_by_uname='main_plot')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  IF (bin_min LE from_bin) THEN RETURN
  ERASE
  
  bin_max = bin_min
  bin_min = bin_max - nbr_bins_per_frame
  IF (bin_min LE from_bin) THEN bin_min = from_bin
  
  ;extract range of data
  img_range = img[bin_min:bin_max-1,*,*]
  
  (*global1).bin_min = bin_min
  (*global1).bin_max = bin_max
  
  ;display min and max
  putTextFieldValue, Event, 'min_bin_value', STRCOMPRESS(bin_min,/REMOVE_ALL)
  putTextFieldValue, Event, 'max_bin_value', STRCOMPRESS(bin_max,/REMOVE_ALL)
  IF ((*global1).nexus_file_name NE '') THEN BEGIN
    tof_array = (*(*global1).tof_array)
    putTextFieldValue, Event, 'min_tof_value', $
      STRCOMPRESS(tof_array[bin_min],/REMOVE_ALL)
    putTextFieldValue, Event, 'max_tof_value', $
      STRCOMPRESS(tof_array[bin_max],/REMOVE_ALL)
  ENDIF
  
  display_current_bin, Event, bin_min=bin_min, bin_max=bin_max
  plot_from_play_tof, Event, img_range
  
END

;------------------------------------------------------------------------------
PRO change_from_and_to_bins, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  
  ;display counts vs tof for play buttons of central row
  counts_vs_tof = (*(*global1).counts_vs_tof_for_play)
  id = WIDGET_INFO(Event.top,find_by_uname='play_counts_vs_tof_plot')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  ;get from_bin and to_bin
  from_bin = getTextFieldValue(event,'from_bin')
  to_bin = getTextFieldValue(event,'to_bin')
  
  xrange = (*global1).xrange
  PLOT, counts_vs_tof, XTITLE='Bins #', YTITLE='Counts', $
    XRANGE=xrange, XSTYLE=1
  from_bin_min = xrange[0]
  to_bin_min = xrange[1]
  
  ;take snapshot
  background = TVREAD(TRUE=3)
  DEVICE, copy=[0,0,600,130,0,0,id_value]
  POLYFILL, [from_bin_min,from_bin,from_bin,from_bin_min, from_bin_min],$
    [0,0,2.5e4,2.5e4,0], color=FSC_COLOR('deep pink'), /data
  POLYFILL, [to_bin,to_bin_min,to_bin_min,to_bin,to_bin],[0,0,2.5e4,2.5e4,0], $
    color=FSC_COLOR('deep pink'), /data
  foreground = TVREAD(TRUE=3)
  alpha= 0.25
  TV, (foreground*alpha)+(1-alpha)*background, true=3
  
  background = TVREAD(TRUE=3)
  (*(*global1).background) = background
  
  plot_main_plot_with_new_bin_range, Event
  
END

;------------------------------------------------------------------------------
PRO display_current_bin, Event, bin_min=bin_min, bin_max=bin_max

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  
  ;display counts vs tof for play buttons of central row
  counts_vs_tof = (*(*global1).counts_vs_tof_for_play)
  id = WIDGET_INFO(Event.top,find_by_uname='play_counts_vs_tof_plot')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  background = (*(*global1).background)
  TV, background
  
  POLYFILL, [bin_min, bin_max, bin_max, bin_min, bin_min],$
    [0,0,2.5e4,2.5e4,0], color=FSC_COLOR('red'), /data
  foreground = TVREAD(true=3)
  alpha = 0.25
  background = (*(*global1).background)
  TV, (foreground*alpha)+(1-alpha)*background, true=3
  
END

;------------------------------------------------------------------------------
PRO plot_main_plot_with_new_bin_range, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  
  ;retrieve values from inside structure
  img     = (*(*global1).img)
  Xfactor = (*global1).Xfactor
  Yfactor = (*global1).Yfactor
  Xcoeff  = (*global1).Xcoeff
  Ycoeff  = (*global1).Ycoeff
  off     = (*global1).off
  xoff    = (*global1).xoff
  
  from_bin = getFromBin(Event)
  to_bin   = getToBin(Event)
  
  ;main data array
  tvimg = img[from_bin-1:to_bin-1,*,*]
  tvimg = TOTAL(tvimg,1)
  tvimg = TRANSPOSE(tvimg)
  
  ;select plot area
  id = WIDGET_INFO(Event.top,find_by_uname='main_plot')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  ERASE
  
  ;Create big array (before rebining)
  xsize       = 8L
  xsize_space = 1L
  xsize_total = xsize * 52L + xsize_space * 51L
  ysize = 128L
  big_array = LONARR(xsize_total, ysize)
  ;put left part in big array
  FOR i=0L,(36L-1) DO BEGIN
    bank = tvimg[i*8:(i+1)*8L-1,*]
    big_array[i*7L+2*i:(i+1L)*7L+2*i,*] = bank
  ENDFOR
  ;put right part in big array
  FOR i=38L,(52L-2L) DO BEGIN
    bank = tvimg[(i-2L)*8L:(i-1L)*8L-1,*]
    big_array[i*7L+2*i:(i+1L)*7L+2*i,*] = bank
  ENDFOR
  
  min = MIN(big_array,MAX=max)
  id = WIDGET_INFO(event.top, FIND_BY_UNAME='main_base_min_value')
  WIDGET_CONTROL, id, SET_VALUE=STRCOMPRESS(min,/REMOVE_ALL)
  id = WIDGET_INFO(event.top, FIND_BY_UNAME='main_base_max_value')
  WIDGET_CONTROL, id, SET_VALUE=STRCOMPRESS(max,/REMOVE_ALL)
  
  ;check if we want lin or log
  lin_status = isMainPlotLin(Event)
  
  IF (lin_status EQ 0) THEN BEGIN ;log
  
    ;remove 0 values and replace with NAN
    ;and calculate log
    index = WHERE(big_array EQ 0, nbr)
    IF (nbr GT 0) THEN BEGIN
      big_array[index] = !VALUES.D_NAN
      big_array = ALOG10(big_array)
      big_array = BYTSCL(big_array,/NAN)
    ENDIF
    
  ENDIF
  
  ;rebin big array
  big_array_rebin = REBIN(big_array, xsize_total*Xfactor, ysize*Yfactor,/SAMPLE)
  
  yoff = 0
  TVSCL, big_array_rebin, /DEVICE, xoff, yoff
  ;(*(*global1).big_array_rebin) = big_array_rebin
  (*(*global1).big_array_rebin_rescale) = big_array_rebin
  
  ;plot grid
  plotGridMainPlot, global1
  
  ;plot scale
  plot_scale, global1, min, max
  
END

;------------------------------------------------------------------------------
PRO check_from_to_bin_input, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  
  from_bin = getFromBin(Event)
  to_bin = getToBin(Event)
  
  min_bin = MIN([from_bin,to_bin],MAX=max_bin)
  
  from_bin = min_bin
  to_bin   = max_bin
  
  IF (from_bin EQ to_bin) THEN BEGIN
    from_bin = (*global1).from_bin
    to_bin = (*global1).to_bin
  ENDIF ELSE BEGIN
    IF (from_bin LT 1) THEN from_bin = (*global1).from_bin
    IF (to_bin GT (*global1).bin_max_untouched) THEN to_bin = (*global1).to_bin
  ENDELSE
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='from_bin')
  WIDGET_CONTROL, id, SET_VALUE=from_bin
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='to_bin')
  WIDGET_CONTROL, id, SET_VALUE=to_bin
  
END