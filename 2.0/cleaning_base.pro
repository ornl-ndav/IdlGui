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
;   main base event
;
; :Params:
;   Event
;
; :Author: j35
;-
pro cleaning_base_event, Event
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global_plot
  main_event = (*global_plot).main_event
  
  case Event.id of
  
    widget_info(event.top, find_by_uname='cleaning_widget_base'): begin
    
      id = widget_info(event.top, find_by_uname='cleaning_widget_base')
      ;widget_control, id, /realize
      geometry = widget_info(id,/geometry)
      new_xsize = geometry.scr_xsize
      new_ysize = geometry.scr_ysize - 33
      
      (*global_plot).xsize = new_xsize
      (*global_plot).ysize = new_ysize
      
      widget_control, id, xsize = new_xsize
      widget_control, id, ysize = new_ysize
      
      id = widget_info(event.top, find_by_uname='cleaning_draw')
      widget_control, id, draw_xsize = new_xsize
      widget_control, id, draw_ysize = new_ysize
      
      refresh_plot, event=event
      
      return
    end
    
    widget_info(event.top, $
      find_by_uname='settings_base_close_button'): begin
      
      ;this will allow the settings tab to come back in the same state
      save_status_of_settings_button, event
      
      id = widget_info(Event.top, $
        find_by_uname='settings_widget_base')
      widget_control, id, /destroy
      
      return
    end
    
    else:
    
  endcase
  
end

;+
; :Description:
;    This routine is reached when the user click the With or without Y
;    error bar in the menu
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro error_bar_menu_eventcb, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_plot
  uname = widget_info(event.id,/uname)
  value = getValue(id=event.id)
  
  if (value eq '* Show Y error bars') then begin ;we need to hide the error bars
    (*global_plot).show_y_error_bar = 0b
    value = '  Show Y error bars'
  endif else begin
    (*global_plot).show_y_error_bar = 1b
    value = '* Show Y error bars'
  endelse
  putValue, event=event, uname=uname, value=value
  
  refresh_plot, event=event
  
end

;+
; :Description:
;    Switches from lin to log
;
; :Params:
;    event
;
; :Author: j35
;-
pro switch_yaxes_type, event
  compile_opt idl2
  
  uname = widget_info(event.id, /uname)
  widget_control, event.top, get_uvalue=global_plot
  
  if (uname eq 'local_scale_setting_linear') then begin
    set1_value = '*  ' + 'linear'
    set2_value = '   ' + 'logarithmic'
    (*global_plot).default_scale_settings = 0
  endif else begin
    set1_value = '   ' + 'linear'
    set2_value = '*  ' + 'logarithmic'
    (*global_plot).default_scale_settings = 1
  endelse
  
  putValue, event=event, uname='local_scale_setting_linear', value=set1_value
  putValue, event=event, uname='local_scale_setting_log', value=set2_value
  
  refresh_plot, event=event
  
end

;+
; :Description:
;    Refresh the plot when resizing for example
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro refresh_plot, event=event, base=base
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    widget_control, event.top, get_uvalue=global_plot
    id = WIDGET_INFO(event.top, FIND_BY_UNAME='cleaning_draw')
  endif else begin
    widget_control, base, get_uvalue=global_plot
    id = WIDGET_INFO(base, FIND_BY_UNAME='cleaning_draw')
  endelse
  
  global = (*global_plot).global
  index  = (*global_plot).current_index_plotted
  
  status_of_list_of_files_plotted = $
    (*(*global_plot).status_of_list_of_files_plotted)
  list_files = (*global_plot).list_files
  
  flt0_ptr = (*global).flt0_rescale_ptr
  flt1_ptr = (*global).flt1_rescale_ptr
  
  ;get index of the files to plot
  _index_to_plot = where(status_of_list_of_files_plotted eq 1, nbr)
  
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  if (nbr eq 0) then begin
    erase
    return
  endif
  
  ;determine the full xaxis by retrieving the min and max x value
  _index = 0
  min_value = 10
  max_value = 0
  while (_index lt nbr) do begin
    _min_value = min(*flt0_ptr[_index_to_plot[_index]],max=_max_value)
    
    min_value = (_min_value lt min_value) ? _min_value : min_value
    max_value = (_max_value gt max_value) ? _max_value : max_value
    
    _index++
  endwhile
  
  _index = 0
  while (_index lt nbr) do begin
  
    flt0 = *flt0_ptr[_index_to_plot[_index]]
    flt1 = *flt1_ptr[_index_to_plot[_index]]
    
    if ((*global_plot).default_scale_settings) then begin ;log
      plot, [min_value,max_value], flt1, $
        /ylog, $
        color=fsc_color('black'), $
        /nodata
      oplot, flt0, flt1, $
        color=fsc_color('red'), $
        psym=2
    endif else begin
      plot, [min_value, max_value], flt1, $
        color=fsc_color('black'), $
        /nodata
      oplot, flt0, flt1, psym=2, color=fsc_color('red')
    endelse
    
    if ((*global_plot).show_y_error_bar) then begin ;show error bars
    
      flt2_ptr = (*global).flt2_rescale_ptr
      flt2 = *flt2_ptr[_index_to_plot[_index]]
      
      errplot, flt0, $
        flt1+flt2,$
        flt1-flt2,$
        color=fsc_color('pink')
    endif
    
    _index++
  endwhile
  
end

;+
; :Description:
;   Reached when the settings base is killed
;
; :Params:
;    global_plot
;
; :Author: j35
;-
pro cleaning_base_killed, global_plot
  compile_opt idl2
  
  main_event = (*global_plot).main_event
  
  info_base = (*global_plot).cursor_info_base
  ;if x,y and counts base is on, shows live values of x,y and counts
  if (widget_info(info_base, /valid_id) ne 0) then begin
    widget_control, info_base, /destroy
  endif
  
  ;close the xaxis info if openned
  xaxis_info_base = (*global_plot).counts_vs_xaxis_base
  if (widget_info(xaxis_info_base, /valid_id) ne 0) then begin
    widget_control, xaxis_info_base, /destroy
  endif
  
  ;close the yaxis info if openned
  yaxis_info_base = (*global_plot).counts_vs_yaxis_base
  if (widget_info(yaxis_info_base, /valid_id) ne 0) then begin
    widget_control, yaxis_info_base, /destroy
  endif
  
end

;+
; :Description:
;    This routine is reached by the list of files button and update the
;    name of the file display (at the top of the base) and the plot itself
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro cleaning_file_list, event
  compile_opt  idl2
  
  ;display new data set
  widget_control, event.top, get_uvalue=global_plot
  
  ;retrieve index and full file name of file
  button_value = getValue(id=event.id)
  split_array = strsplit(button_value,':',/extract)
  
  ;split for '*'
  index_array = strsplit(split_array[0],'*',/extract,count=nbr)
  if (nbr eq 0) then begin
    index = fix(strcompress(split_array[0],/remove_all))-1
  endif else begin
    index = fix(strcompress(index_array[-1],/remove_all))-1
  endelse
  (*global_plot).current_index_plotted = index
  
  status_of_list_of_files_plotted = $
    (*(*global_plot).status_of_list_of_files_plotted)
  _value = status_of_list_of_files_plotted[index]
  _value = (_value eq 0) ? 1 : 0
  status_of_list_of_files_plotted[index] = _value
  (*(*global_plot).status_of_list_of_files_plotted) = $
    status_of_list_of_files_plotted
    
  refresh_plot, event=event
  
end

;+
; :Description:
;    Cleanup routine
;
; :Params:
;    tlb
;
; :Author: j35
;-
pro cleaning_base_cleanup, tlb
  compile_opt idl2
  
  widget_control, tlb, get_uvalue=global_plot, /no_copy
  
  if (n_elements(global_plot) eq 0) then return
  
  ptr_free, (*global_plot).data
  ptr_free, (*global_plot).data_linear
  ptr_free, (*global_plot).status_of_list_of_files_plotted
  
  ptr_free, global_plot
  
end

;+
; :Description:
;   create the base
;
; :Params:
;    wBase
;    main_base_geometry
;    global
;
; :Author: j35
;-
pro cleaning_base_gui, wBase, $
    main_base_geometry, $
    global, $
    list_files, $
    offset, $
    border
    
  compile_opt idl2
  
  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xsize = 600
  ysize = 600
  
  xoffset = (main_base_xsize - xsize) / 2
  xoffset += main_base_xoffset
  xoffset += offset
  
  yoffset = (main_base_ysize - ysize) / 2
  yoffset += main_base_yoffset
  yoffset += offset
  
  ourGroup = WIDGET_BASE()
  
  title = 'Cleaning application'
  wBase = WIDGET_BASE(TITLE = title, $
    UNAME        = 'cleaning_widget_base', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    SCR_YSIZE    = ysize,$
    SCR_XSIZE    = xsize,$
    MAP          = 1,$
    /BASE_ALIGN_CENTER,$
    /align_center,$
    /tlb_size_events,$
    mbar = bar1,$
    GROUP_LEADER = ourGroup)
    
  ;list of files to plot
  nbr_files = n_elements(list_files)
  index=0
  uname_raw = 'file_index_'
  _file = widget_button(bar1,$
    value = 'Files',$
    /menu)
  while (index lt nbr_files) do begin
    value = strcompress(index+1,/remove_all) + ': ' + list_files[index]
    if (index eq 0) then begin
      value = '* ' + value
    endif else begin
      value = '  ' + value
    endelse
    __file = widget_button(_file,$
      value = value,$
      event_pro = 'cleaning_file_list')
    index++
  endwhile
  
  set1_value = '   linear'
  set2_value = '*  logarithmic'
  
  mPlot = widget_button(bar1, $
    value = 'Y axes',$
    /menu)
    
  set1 = widget_button(mPlot, $
    value = set1_value, $
    event_pro = 'switch_yaxes_type',$
    uname = 'local_scale_setting_linear')
    
  set2 = widget_button(mPlot, $
    value = set2_value,$
    event_pro = 'switch_yaxes_type',$
    uname = 'local_scale_setting_log')
    
  ;error bars
  error = widget_button(bar1,$
    value = 'Error Bars',$
    /menu)
  _Error = widget_button(error,$
    value = '* Show Y error bars',$
    uname = 'show_or_not_error_bars',$
    event_pro = 'error_bar_menu_eventcb')
    
  ;main plot
  draw = widget_draw(wbase,$
    scr_xsize = xsize,$
    scr_ysize = ysize,$
    ;    /button_events,$
    ;    /motion_events,$
    ;    /tracking_events,$
    retain=2, $
    event_pro = 'cleaning_draw_eventcb',$
    uname = 'cleaning_draw')
    
end

;+
; :Description:
;    Main procedure of the cleaning base
;
; :Keywords:
;    event
;    list_files
;    offset
;    main_base_uname
;
; :Author: j35
;-
pro cleaning_base, event=event, $
    list_files = list_files, $
    offset = offset, $
    main_base_uname = main_base_uname
    
  compile_opt idl2
  
  ;  if (n_elements(spin_state) eq 0) then spin_state = 0
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME=main_base_uname)
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;SETUP
  border = 40
  !P.BACKGROUND=255
  
  ;build gui
  wBase = ''
  cleaning_base_gui, wBase, $
    main_base_geometry, $
    global, $
    list_files, $
    offset, $
    border
    
  (*global).cleaning_base_id = wBase
  
  default_plot_size = [600,600]
  
  WIDGET_CONTROL, wBase, /REALIZE
  
  global_plot = PTR_NEW({ wbase: wbase,$
    global: global, $
    
    ;used to plot selection zoom
    list_files: list_files, $
    default_plot_size: 600, $
    default_scale_settings: 1, $ ;1 for log, 0 for linear
    
    show_y_error_bar: 1b, $ ;show or not the Y error bars (yes by default)
    
    scale_setting: 1, $  ;1 for log, 0 for linear
    current_index_plotted: 0, $
    
    status_of_list_of_files_plotted: ptr_new(0L), $
    
    data: ptr_new(0L), $
    data_linear: ptr_new(0L), $
    
    xsize: default_plot_size[0],$
    ysize: default_plot_size[1],$
    
    border: border, $ ;border of main plot (space reserved for scale)
    
    xrange: fltarr(2),$ ;[tof_min, tof_max]
    zrange: fltarr(2),$
    yrange: intarr(2),$ ;[min_pixel,max_pixel]
    
    left_click: 0b,$ ;by default, left button is not clicked
    
    main_event: event})
    
  ;[1,1,0,1] for example means the first 2 and the last file loaded are plotted.
  sz = n_elements(list_files)
  status_of_list_of_files_plotted = intarr(sz)
  (*(*global_plot).status_of_list_of_files_plotted) = $
    status_of_list_of_files_plotted
    
  WIDGET_CONTROL, wBase, SET_UVALUE = global_plot
  
  XMANAGER, "cleaning_base", wBase, GROUP_LEADER = ourGroup, /NO_BLOCK, $
    cleanup = 'cleaning_base_cleanup'
    
  refresh_plot, base=wBase
  
end

