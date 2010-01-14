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

PRO fits_tools_tab3_plot_base_event, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_plot
  global = (*global_plot).global
  main_event = (*global_plot).main_event
  
  CASE Event.id OF
  
    ;plot base
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='fits_tools_tab3_plot_base_uname'): BEGIN
      
      id1 = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='fits_tools_tab3_plot_base_uname')
      WIDGET_CONTROL, id1, /REALIZE
      geometry = WIDGET_INFO(id1, /GEOMETRY)
      new_xsize = geometry.scr_xsize
      new_ysize = geometry.scr_ysize
      
      IF (new_xsize LT 400) THEN BEGIN
        new_xsize = 400
        new_ysize = 590
      ENDIF
      IF (new_ysize LT 590) THEN BEGIN
        new_xsize = 400
        new_ysize = 590
      ENDIF
      IF (new_xsize GE 400) THEN BEGIN
        new_ysize = new_xsize+190
      ENDIF
      
      WIDGET_CONTROL, id1, XSIZE= new_xsize
      WIDGET_CONTROL, id1, YSIZE= new_ysize
      
      id = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='fits_tools_tab3_plot_draw_uname')
      WIDGET_CONTROL, id, DRAW_XSIZE= new_xsize-6
      WIDGET_CONTROL, id, DRAW_YSIZE= new_xsize-6
      
      replot_step3_after_resizing, Event
      
    END
    
    ;draw
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='fits_tools_tab3_plot_draw_uname'): BEGIN
      CURSOR, X_device, Y_device, /DEVICE, /nowait
      
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
        x = 'N/A'
        y = 'N/A'
        counts = 'N/A'
      ENDIF ELSE BEGIN
        x = getStep3X(Event, X_device)
        y = getStep3Y(Event, Y_device)
        counts = getStep3Counts(Event, x_device, y_device)
      ENDELSE
      putValue, Event, 'fits_tools_tab3_plot_x_value', x
      putValue, Event, 'fits_tools_tab3_plot_y_value', y
      putValue, Event, 'fits_tools_tab3_plot_counts_value', counts
      
    END
    
    ;bin size ruler
    WIDGET_INFO(Event.top, FIND_BY_UNAME='fits_tools_tab3_bin_slider'): BEGIN
      update_from_to_bin, Event
      IF (Event.drag EQ 0) THEN BEGIN ;when moving the cursor
        WIDGET_CONTROL, /HOURGLASS
        update_step3_plot, Event
        WIDGET_CONTROL, HOURGLASS=0
      ENDIF
    END
    
    ELSE:
    
  ENDCASE
  
END

;------------------------------------------------------------------------------
PRO replot_step3_after_resizing, Event

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
    
  DEVICE, DECOMPOSED=0
  LOADCT, 5, /SILENT
  TVSCL, congrid_current_bin_array
  DEVICE, DECOMPOSED=1
  
END

;------------------------------------------------------------------------------
PRO update_from_to_bin, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global_plot
  
  slider_value = LONG(getSliderValue(Event,'fits_tools_tab3_bin_slider'))
  bin_size = LONG((*global_plot).bin_size)
  
  from = FLOAT((bin_size*slider_value))
  to   = FLOAT((bin_size*(slider_value+1)))
  
  sfrom = STRCOMPRESS(from,/REMOVE_ALL)
  sto   = STRCOMPRESS(to,/REMOVE_ALL)
  
  putValue, Event, 'fits_tools_tab3_from_time', sfrom
  putValue, Event, 'fits_tools_tab3_to_time', sto
  
END

;------------------------------------------------------------------------------
PRO  fits_tools_tab3_plot_base_gui, wBase=wBase, $
    main_base_geometry=main_base_geometry, $
    title=title, $
    max_bin=max_bin, $
    max_time=max_time
    
  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xoffset = main_base_xoffset + main_base_xsize
  yoffset = main_base_yoffset
  
  ourGroup = WIDGET_BASE()
  
  xBaseSize = 400
  yBaseSize = 590
  
  wBase = WIDGET_BASE(TITLE = title,$
    UNAME        = 'fits_tools_tab3_plot_base_uname', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    SCR_YSIZE    = yBaseSize,$
    SCR_XSIZE    = xBaseSize,$
    MAP          = 1,$
    /BASE_ALIGN_CENTER,$
    /TLB_MOVE_EVENTS, $
    /TLB_SIZE_EVENTS, $
    GROUP_LEADER = ourGroup)
    
  main_base = WIDGET_BASE(wBase,$
    /COLUMN)
    
  ;row1
  row1 = WIDGET_BASE(main_base,$
    /ALIGN_CENTER,$
    /ROW)
  x = WIDGET_LABEL(row1,$
    VALUE = 'X:')
  x_value = WIDGET_LABEL(row1,$
    VALUE = 'N/A',$
    SCR_XSIZE = 50,$
    /ALIGN_LEFT,$
    UNAME = 'fits_tools_tab3_plot_x_value')
  space = WIDGET_LABEL(row1,$
    VALUE = '    ')
  y = WIDGET_LABEL(row1,$
    VALUE = 'Y:')
  y_value = WIDGET_LABEL(row1,$
    VALUE = 'N/A',$
    /ALIGN_LEFT,$
    SCR_XSIZE = 50,$
    UNAME = 'fits_tools_tab3_plot_y_value')
  space = WIDGET_LABEL(row1,$
    VALUE = '    ')
  i = WIDGET_LABEL(row1,$
    VALUE = 'Count:')
  i_value = WIDGET_LABEL(row1,$
    VALUE = 'N/A',$
    /ALIGN_LEFT,$
    SCR_XSIZE = 50,$
    UNAME = 'fits_tools_tab3_plot_counts_value')
    
  draw = WIDGET_DRAW(main_base,$
    /ALIGN_CENTER,$
    SCR_XSIZE = xBaseSize-6,$
    SCR_YSIZE = xBaseSize-6,$
    /TRACKING_EVENTS,$
    /MOTION_EVENTS,$
    UNAME = 'fits_tools_tab3_plot_draw_uname')
    
  ;row3
  row3 = WIDGET_BASE(main_base,$
    /COLUMN)
    
  bin = WIDGET_SLIDER(row3,$
    TITLE = 'Bin #',$
    MINIMUM = 0,$
    MAXIMUM = STRCOMPRESS(max_bin,/REMOVE_ALL),$
    SCR_XSIZE = 380,$
    /DRAG,$
    ;    /TRACKING_EVENTS,$
    UNAME = 'fits_tools_tab3_bin_slider')
    
  ;row3b
  row3b = WIDGET_BASE(main_base,$
    /ROW,$
    FRAME=1)
  min = WIDGET_LABEL(row3b,$
    VALUE = 'From time (microS):',$
    /ALIGN_LEFT)
  value = WIDGET_LABEL(row3b,$
    VALUE = '0',$
    SCR_XSIZE = 60,$
    /ALIGN_LEFT,$
    UNAME = 'fits_tools_tab3_from_time')
  min = WIDGET_LABEL(row3b,$
    VALUE = '  to time (microS):',$
    /ALIGN_LEFT)
  value = WIDGET_LABEL(row3b,$
    VALUE = STRCOMPRESS(max_time,/REMOVE_ALL),$
    SCR_XSIZE = 60,$
    /ALIGN_LEFT,$
    UNAME = 'fits_tools_tab3_to_time')
    
  ;space
  space = WIDGET_LABEL(main_base,$
    VALUE = ' ')
    
  ;row4
  row4 = WIDGET_BASE(main_base,$
    /ROW)
  label = WIDGET_LABEL(row4,$
    VALUE = 'Preview of file -> ')
  value = WIDGET_LABEL(row4,$
    VALUE = 'N/A',$
    SCR_XSIZE = 240,$
    frame=1,$
    /ALIGN_LEFT,$
    UNAME = 'fits_tools_tab3_current_fits_file')
    
END

;------------------------------------------------------------------------------
PRO plot_first_bin_for_tab3, base=base, global_plot=global_plot

  global = (*global_plot).global
  main_event = (*global_plot).main_event
  
  bin_size = getTextFieldValue(main_event, 'tab3_bin_size_value')
  bin_size = bin_size[0] ;units is microS
  
  xarray = (*(*global_plot).xarray)
  yarray = (*(*global_plot).yarray)
  timearray = (*(*global_plot).timearray)
  
  time_resolution_microS = (*global).time_resolution_microS
  
  xsize = FIX(getTextFieldValue(main_event,'tab1_x_pixels'))
  ysize = FIX(getTextFieldValue(main_event,'tab1_y_pixels'))
  
  current_bin_array = LONARR(xsize,ysize)
  
  nbr_files_loaded = getFirstEmptyXarrayIndex(event=main_event)
  index_nbr_files = 0
  
  WHILE (index_nbr_files LT nbr_files_loaded) DO BEGIN
  
    first_timearray = *timearray[index_nbr_files] * time_resolution_microS
    first_xarray = *xarray[index_nbr_files]
    first_yarray = *yarray[index_nbr_files]
    
    where_timearray = WHERE(first_timearray LT bin_size)
    xarray_bin0 = first_xarray[where_timearray]
    yarray_bin0 = first_yarray[where_timearray]
    
    sz = N_ELEMENTS(xarray_bin0)
    index = 0L
    WHILE (index LT sz) DO BEGIN
      x = xarray_bin0[index]
      y = yarray_bin0[index]
      ;make sure they are within the range specified in tab1
      IF (x LT xsize AND y LT ysize) THEN BEGIN
        current_bin_array[x,y]++
      ENDIF
      index++
    ENDWHILE
    
    index_nbr_files++
  ENDWHILE
  
  id = WIDGET_INFO(base, $
    FIND_BY_UNAME='fits_tools_tab3_plot_draw_uname')
  WIDGET_CONTROL, id, GET_VALUE = id_value
  WSET, id_value
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  draw_xsize = main_base_geometry.xsize
  draw_ysize = main_base_geometry.ysize
  
  congrid_current_bin_array = CONGRID(current_bin_array, $
    draw_xsize, draw_ysize)
    
  DEVICE, DECOMPOSED=0
  LOADCT, 5, /SILENT
  TVSCL, congrid_current_bin_array
  (*(*global_plot).current_bin_array) = current_bin_array
  DEVICE, DECOMPOSED=1
  
END

;------------------------------------------------------------------------------
PRO update_step3_plot, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global_plot
  
  slider_value = LONG(getSliderValue(Event,'fits_tools_tab3_bin_slider'))
  old_slider_value = (*global_plot).bin_size_selected
  
  IF (slider_value EQ old_slider_value) THEN RETURN
  (*global_plot).bin_size_selected = slider_value
  
  no_data_found_in_range_selected = 1b
  
  id = WIDGET_INFO(Event.top, $
    FIND_BY_UNAME='fits_tools_tab3_plot_draw_uname')
  WIDGET_CONTROL, id, GET_VALUE = id_value
  WSET, id_value
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  draw_xsize = main_base_geometry.xsize
  draw_ysize = main_base_geometry.ysize
  
  global     = (*global_plot).global
  main_event = (*global_plot).main_event
  
  bin_size  = (*global_plot).bin_size
  xarray    = (*(*global_plot).xarray)
  yarray    = (*(*global_plot).yarray)
  timearray = (*(*global_plot).timearray)
  
  xsize = (*global_plot).detector_xsize
  ysize = (*global_plot).detector_ysize
  
  current_bin_array = LONARR(xsize,ysize)
  
  s_from_time_micros = getTextFieldValue(Event,'fits_tools_tab3_from_time')
  s_to_time_microS   = getTextFieldValue(Event,'fits_tools_tab3_to_time')
  
  time_resolution_microS = (*global_plot).time_resolution_microS
  
  f_from_time_micros = FLOAT(s_from_time_micros[0])
  f_to_time_micros   = FLOAT(s_to_time_micros[0])
  
  l_from_time_microS = LONG(f_from_time_microS)
  l_to_time_microS   = LONG(f_to_time_microS)
  
  nbr_files_loaded = (*global_plot).nbr_files_loaded
  index_nbr_files = 0
  WHILE (index_nbr_files LT nbr_files_loaded) DO BEGIN
  
    first_timearray = *timearray[index_nbr_files] * time_resolution_microS
    first_xarray = *xarray[index_nbr_files]
    first_yarray = *yarray[index_nbr_files]
    
    where_timearray = WHERE(first_timearray GE l_from_time_microS AND $
      first_timearray LT l_to_time_microS, sz)
      
    IF (sz NE 0) THEN BEGIN ;array not empty
    
      no_data_found_in_range_selected = 0b
      
      xarray_bin0 = first_xarray[where_timearray]
      yarray_bin0 = first_yarray[where_timearray]
      
      sz = N_ELEMENTS(xarray_bin0)
      index = 0L
      WHILE (index LT sz) DO BEGIN
        x = xarray_bin0[index]
        y = yarray_bin0[index]
        ;make sure they are within the range specified in tab1
        IF (x LT xsize AND y LT ysize) THEN BEGIN
          current_bin_array[x,y]++
        ENDIF
        index++
      ENDWHILE
      
    ENDIF ;if where_timearray is not empty
    
    index_nbr_files++
  ENDWHILE
  
  congrid_current_bin_array = CONGRID(current_bin_array, $
    draw_xsize, draw_ysize)
    
  DEVICE, DECOMPOSED=0
  LOADCT, 5, /SILENT
  TVSCL, congrid_current_bin_array
  (*(*global_plot).current_bin_array) = current_bin_array
  DEVICE, DECOMPOSED=1
  
END

;------------------------------------------------------------------------------
PRO fits_tools_tab3_plot_base, main_base=main_base, $
    Event=Event, $
    title=title, $
    xtitle=xtitle, $
    ytitle=ytitle, $
    xarray=xarray, $
    yarray=yarray, $
    timearray=timearray
    
  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    id = WIDGET_INFO(main_base, FIND_BY_UNAME='MAIN_BASE')
    WIDGET_CONTROL,main_base,GET_UVALUE=global
    event = 0
  ENDIF ELSE BEGIN
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ENDELSE
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;determine the max bin size to define the slider min and max values
  bin_size = getTextFieldValue(Event, 'tab3_bin_size_value')
  bin_size = bin_size[0]
  max_time = bin_size
  user_max_time = getTextFieldValue(event,'tab1_max_time')
  user_max_time = FIX(user_max_time[0])
  max_bin = (user_max_time * 1000L) / bin_size ;max time
  ;*1000L to go from ms to microS
  time_resolution_microS = (*global).time_resolution_microS
  
  xsize = FIX(getTextFieldValue(event,'tab1_x_pixels'))
  ysize = FIX(getTextFieldValue(event,'tab1_y_pixels'))
  
  nbr_files_loaded = getFirstEmptyXarrayIndex(event=event)
  
  ;build gui
  wBase3 = ''
  fits_tools_tab3_plot_base_gui, wBase=wBase3, $
    main_base_geometry=main_base_geometry, $
    title=title, $
    max_bin=max_bin, $
    max_time=max_time
    
  (*global).tab3_base = wBase3
  
  WIDGET_CONTROL, wBase3, /REALIZE
  
  global_plot = PTR_NEW({ wbase: wbase3,$
    global: global, $
    
    current_bin_array: PTR_NEW(0L), $ ;current bin displayed
    
    detector_xsize: xsize, $
    detector_ysize: ysize, $
    nbr_files_loaded: nbr_files_loaded,$
    
    time_resolution_microS: time_resolution_microS, $
    
    bin_size_selected: 0L, $
    bin_size: bin_size, $
    max_bin: max_bin, $
    xtitle: xtitle, $
    ytitle: ytitle, $
    xarray: PTR_NEW(0L), $
    yarray: PTR_NEW(0L), $
    timearray: PTR_NEW(0L), $
    main_event: Event})
    
  (*(*global_plot).xarray) = xarray
  (*(*global_plot).yarray) = yarray
  (*(*global_plot).timearray) = timearray
  
  WIDGET_CONTROL, wBase3, SET_UVALUE = global_plot
  
  XMANAGER, "fits_tools_tab3_plot_base", wBase3, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
  plot_first_bin_for_tab3, base=wBase3, global_plot=global_plot
  
END
