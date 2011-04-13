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
;    This function checks if the cursor is still inside the cleaning
;    application main widget_draw.
;
; :Params:
;    event
;
; :Author: j35
;-
function stillInsidePlot, event
  compile_opt idl2
  
  cursor, x, y, /nowait, /device
  if (x eq -1 or y eq -1) then return, 0
  return, 1
  
end

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
  
    ;draw
    widget_info(event.top, find_by_uname='cleaning_draw'): begin
    
      id = WIDGET_INFO(event.top, FIND_BY_UNAME='cleaning_draw')
      widget_control, id, GET_VALUE = plot_id
      wset, plot_id
      
      if (event.key eq 1 and event.press eq 1) then begin
        (*global_plot).shift_key_pressed = 1b
        return
      endif
      
      if (event.key eq 1 and event.release eq 1) then begin
        (*global_plot).shift_key_pressed = 0b
        return
      endif
      
      ;moving mouse with left click pressed
      if ((*global_plot).left_click_pressed) then begin
        x1y1x2y2 = (*global_plot).x1y1x2y2
        
        ;make sure we don't go outside the plot area
        if (stillInsidePlot(event)) then begin
        
          cursor, x,y, /nowait, /data
          
          x1y1x2y2[2] = x
          x1y1x2y2[3] = y
          (*global_plot).x1y1x2y2 = x1y1x2y2
          refresh_plot, event=event
          plot_data_point_to_remove, event=event
          
        endif ;still inside plot
      endif
      
      if (event.press eq 1) then begin ;left button pressed
        (*global_plot).left_click_pressed = 1b
        cursor, x,y, /nowait, /data
        x1y1x2y2 = [-1.,-1.,-1.,-1.]
        x1y1x2y2[0] = x
        x1y1x2y2[1] = y
        (*global_plot).x1y1x2y2 = x1y1x2y2
      endif
      
      if (event.release eq 1) then begin ;release button
        (*global_plot).left_click_pressed = 0b
        create_array_of_points_selected, event
        (*global_plot).x1y1x2y2 = [-1,-1,-1,-1] ;reset selection
        refresh_plot, event=event
        plot_data_point_to_remove, event=event
      endif
      
    end
    
    ;main base
    widget_info(event.top, find_by_uname='cleaning_widget_base'): begin
    
      id = widget_info(event.top, find_by_uname='cleaning_widget_base')
      ;widget_control, id, /realize
      geometry = widget_info(id,/geometry)
      new_xsize = geometry.scr_xsize
      new_ysize = geometry.scr_ysize - 33
      xoffset = geometry.xoffset
      yoffset = geometry.yoffset
      
      range_id = (*global_plot).xy_range_input_base_id
      if (widget_info(range_id,/valid_id)) then begin
        widget_control, range_id, xoffset=xoffset + new_xsize
        widget_control, range_id, yoffset=yoffset
      endif
      
      button_id = (*global_plot).cleaning_buttons_base_id
      if (widget_info(button_id,/valid_id)) then begin
        widget_control, button_id, xoffset=xoffset + new_xsize
        widget_control, button_id, yoffset=yoffset + 350
      endif
      
      (*global_plot).xsize = new_xsize
      (*global_plot).ysize = new_ysize
      
      widget_control, id, xsize = new_xsize
      widget_control, id, ysize = new_ysize
      
      id = widget_info(event.top, find_by_uname='cleaning_draw')
      widget_control, id, draw_xsize = new_xsize
      widget_control, id, draw_ysize = new_ysize
      
      refresh_plot, event=event
      plot_data_point_to_remove, event=event
      
      return
    end
    
    else:
    
  endcase
  
end

;+
; :Description:
;    Using the selection made, this procedures will go through all the data
;    loaded and displayed and retrieve the data points inside the selection.
;
; :Params:
;    event
;
; :Author: j35
;-
pro create_array_of_points_selected, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_plot
  global = (*global_plot).global
  
  ;selection
  x1y1x2y2 = (*global_plot).x1y1x2y2
  
  status_of_list_of_files_plotted = $
    (*(*global_plot).status_of_list_of_files_plotted)
    
  flt0_ptr = (*global).flt0_rescale_ptr
  flt1_ptr = (*global).flt1_rescale_ptr
  
  ;get index of the files to plot
  _index_to_plot = where(status_of_list_of_files_plotted eq 1, nbr)
  
  x1 = x1y1x2y2[0]
  y1 = x1y1x2y2[1]
  x2 = x1y1x2y2[2]
  y2 = x1y1x2y2[3]
  
  xmin = min([x1,x2],max=xmax)
  ymin = min([y1,y2],max=ymax)
  
  if ((*global_plot).shift_key_pressed) then begin
    flt0_intersection = (*(*global_plot).flt0_to_removed)
    flt1_intersection = (*(*global_plot).flt1_to_removed)
  endif else begin
    ;initialize array of points selected
    flt0_intersection = !null
    flt1_intersection = !null
  endelse
  
  _index=0
  while (_index lt nbr) do begin
  
    xaxis = *flt0_ptr[_index_to_plot[_index]]
    yaxis = *flt1_ptr[_index_to_plot[_index]]
    
    _xaxis_index_selected = where((xaxis ge xmin) and (xaxis le xmax),/null)
    _yaxis_index_selected = where((yaxis ge ymin) and (yaxis le ymax),/null)
    
    if (_xaxis_index_selected eq !null) then begin
      _index++
      continue
    endif
    if (_yaxis_index_selected eq !null) then begin
      _index++
      continue
    endif
    
    _xyaxis_index_intersection = $
      getIntersectionOfArrays(array1=_xaxis_index_selected, $
      array2=_yaxis_index_selected)
      
    flt0_intersection = [flt0_intersection, xaxis[_xyaxis_index_intersection]]
    flt1_intersection = [flt1_intersection, yaxis[_xyaxis_index_intersection]]
    
    _index++
  endwhile
  
  (*(*global_plot).flt0_to_removed) = flt0_intersection
  (*(*global_plot).flt1_to_removed) = flt1_intersection
  
end

;+
; :Description:
;    This routine reached by the 'X and Y axis button' will bring to life, if
;    not already mapped, the X_Y_range_base_selection
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro switch_xyaxes_range, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_plot
  range_id = (*global_plot).xy_range_input_base_id
  if (widget_info(range_id,/valid_id) eq 0) then begin
  
    top_base_id = widget_info(event.top, find_by_uname='cleaning_widget_base')
    parent_base_uname = 'cleaning_widget_base
    
    xy_range_input_base, event=event, $
      parent_base_uname = parent_base_uname
      
  endif
  
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
  plot_data_point_to_remove, event=event
  
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
  plot_data_point_to_remove, event=event
  
end

;+
; :Description:
;    Plot (highlight) the data points that have been selected and that
;    will be removed.
;
; :Keywords:
;    event
;    base
;
; :Author: j35
;-
pro plot_data_point_to_remove, event=event, base=base
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    widget_control, event.top, get_uvalue=global_plot
    id = WIDGET_INFO(event.top, FIND_BY_UNAME='cleaning_draw')
  endif else begin
    widget_control, base, get_uvalue=global_plot
    id = WIDGET_INFO(base, FIND_BY_UNAME='cleaning_draw')
  endelse
  
  catch,error
  if (error ne 0) then begin
    catch,/cancel
    return
  endif
  
  flt0_intersection = (*(*global_plot).flt0_to_removed)
  flt1_intersection = (*(*global_plot).flt1_to_removed)
  
  ;stop if there is no valid selection
  if (flt0_intersection eq !null) then return
  
  ;keep only the flt0_intersection and flt1_intersection of files displayed
  
  ;get index of the files to plot
  status_of_list_of_files_plotted = $
    (*(*global_plot).status_of_list_of_files_plotted)
  _index_to_plot = where(status_of_list_of_files_plotted eq 1, nbr)
  flt0_ptr = (*global_plot).local_flt0_rescale_ptr
  flt1_ptr = (*global_plot).local_flt1_rescale_ptr
  
  _final_list_x = !null
  _final_list_y = !null
  
  _index=0
  while (_index lt nbr) do begin
  
    xaxis = *flt0_ptr[_index_to_plot[_index]]
    yaxis = *flt1_ptr[_index_to_plot[_index]]
    
    _list_x = getIndexOfIntersectionOfArrays(array2=flt0_intersection, $
      array1=xaxis)
    _list_y = getIndexOfIntersectionOfArrays(array2=flt1_intersection, $
      array1=yaxis)
      
    _final_list_x = [_final_list_x, _list_x]
    _final_list_y = [_final_list_y, _list_y]
    
    _index++
  endwhile
  
  if (_final_list_x eq !null) then return
  if (_final_list_y eq !null) then return
  
  ;find the indexes that are in both lists (_final_list_x and _final_list_y)
  _final_list = getIntersectionOfArrays(array1=_final_list_x, $
    array2=_final_list_y)
    
  final_flt0_intersection = flt0_intersection[_final_list]
  final_flt1_intersection = flt1_intersection[_final_list]
  
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  
  if (final_flt0_intersection eq !null) then return
  
  oplot, final_flt0_intersection, final_flt1_intersection, $
    color=fsc_color('blue'), $
    symsize=2,$
    psym=6
    
end

;+
; :Description:
;    This routine bring to life all the points previously removed
;
; :Keywords:
;    base
;
; :Author: j35
;-
pro full_reset_removed_points, base=base
  compile_opt idl2
  
  widget_control, base, get_uvalue=global_plot
  global = (*global_plot).global
  
  local_flt0_rescale_ptr = (*global_plot).local_flt0_rescale_ptr
  local_flt1_rescale_ptr = (*global_plot).local_flt1_rescale_ptr
  local_flt2_rescale_ptr = (*global_plot).local_flt2_rescale_ptr
  
  flt0_rescale_ptr = (*global).flt0_rescale_ptr
  flt1_rescale_ptr = (*global).flt1_rescale_ptr
  flt2_rescale_ptr = (*global).flt2_rescale_ptr
  
  _spin = (*global_plot).spin
  for i=0,49 do begin
  
    *local_flt0_rescale_ptr[i] = ptr_new(0L)
    *local_flt1_rescale_ptr[i] = ptr_new(0L)
    *local_flt2_rescale_ptr[i] = ptr_new(0L)
    
    *local_flt0_rescale_ptr[i] = *flt0_rescale_ptr[i,_spin]
    *local_flt1_rescale_ptr[i] = *flt1_rescale_ptr[i,_spin]
    *local_flt2_rescale_ptr[i] = *flt2_rescale_ptr[i,_spin]
    
  endfor
  
  (*global_plot).local_flt0_rescale_ptr = local_flt0_rescale_ptr
  (*global_plot).local_flt1_rescale_ptr = local_flt1_rescale_ptr
  (*global_plot).local_flt2_rescale_ptr = local_flt2_rescale_ptr
  
  (*(*global_plot).flt0_to_removed) = ptr_new(0L)
  (*(*global_plot).flt1_to_removed) = ptr_new(0L)
  
  ;refresh the plot
  refresh_plot, base=base
  
end

;+
; :Description:
;    This copy the new flt0, flt1 to the one used by the main application

; :Keywords:
;    base
;    ok
;
; :Author: j35
;-
pro validate_cleaning, base=base, ok=ok
  compile_opt idl2
  
  ok=1b
  
  widget_control, base, get_uvalue=global_plot
  global = (*global_plot).global
  
  local_flt0_rescale_ptr = (*global_plot).local_flt0_rescale_ptr
  local_flt1_rescale_ptr = (*global_plot).local_flt1_rescale_ptr
  local_flt2_rescale_ptr = (*global_plot).local_flt2_rescale_ptr
  
  flt0_rescale_ptr = (*global).flt0_rescale_ptr
  flt1_rescale_ptr = (*global).flt1_rescale_ptr
  flt2_rescale_ptr = (*global).flt2_rescale_ptr
  
  list_files = (*global_plot).list_files
  sz = n_elements(list_files)

  ;check first that we don't have an empty data file
  _spin = (*global_plot).spin
  for i=0,(sz-1) do begin
  
    if (*local_flt0_rescale_ptr[i] eq !null) then begin
      ok=0b
      return
    endif
    
  endfor

  _spin = (*global_plot).spin
  for i=0,(sz-1) do begin
  
    *flt0_rescale_ptr[i] = ptr_new(0L)
    *flt1_rescale_ptr[i] = ptr_new(0L)
    *flt2_rescale_ptr[i] = ptr_new(0L)
    
    if (*local_flt0_rescale_ptr[i] eq !null) then begin
      ok=0b
      return
    endif
    
    *flt0_rescale_ptr[i,_spin] = *local_flt0_rescale_ptr[i]
    *flt1_rescale_ptr[i,_spin] = *local_flt1_rescale_ptr[i]
    *flt2_rescale_ptr[i,_spin] = *local_flt2_rescale_ptr[i]
    
  endfor
  
  (*global).flt0_rescale_ptr = flt0_rescale_ptr
  (*global).flt1_rescale_ptr = flt1_rescale_ptr
  (*global).flt2_rescale_ptr = flt2_rescale_ptr
  
end

;+
; :Description:
;    This procedure will remove from the local ptr0, ptr1 and ptr2 arrays
;    the data points selected
;
; :Keywords:
;    base
;
; :Author: j35
;-
pro remove_selected_points, base=base
  compile_opt idl2
  
  widget_control, base, get_uvalue=global_plot
  
  flt0_ptr = (*global_plot).local_flt0_rescale_ptr
  flt1_ptr = (*global_plot).local_flt1_rescale_ptr
  flt2_ptr = (*global_plot).local_flt2_rescale_ptr
  
  new_flt0_ptr = ptrarr(50,/allocate_heap)
  new_flt1_ptr = ptrarr(50,/allocate_heap)
  new_flt2_ptr = ptrarr(50,/allocate_heap)
  
  flt0_intersection = (*(*global_plot).flt0_to_removed)
  flt1_intersection = (*(*global_plot).flt1_to_removed)
  
  list_files = (*global_plot).list_files
  nbr_files = n_elements(list_files)
  
  ;find the list of points to remove
  _index=0
  _index_new=0
  while (_index lt nbr_files) do begin ;loop through all the files
  
    _new_flt0 = !null
    _new_flt1 = !null
    _new_flt2 = !null
    
    _flt0 = *flt0_ptr[_index]
    _flt1 = *flt1_ptr[_index]
    _flt2 = *flt2_ptr[_index]
    
    ;method
    ;for each, check if they are in the _index_intersection and with the
    ;same index for both x and y -> that will mean that's a point we need
    ;to remove and not copy into the final _new_flt0_ptr, _new_flt1_ptr...
    
    _index_val = 0
    ;loop through all the x and y values of the various files
    while (_index_val lt n_elements(_flt0)) do begin
    
      ;retrieve current x and y value to test (is this (x,y) points is in the
      ;list of points to remove
      _x_val_tested = _flt0[_index_val]
      _y_val_tested = _flt1[_index_val]
      
      ;is _x_val_tested in list of x to remove ?
      _result_x = where(_x_val_tested eq flt0_intersection, nbr)
      if (nbr eq 0) then begin
        _new_flt0 = [_new_flt0, _x_val_tested]
        _new_flt1 = [_new_flt1, _y_val_tested]
        _new_flt2 = [_new_flt2, _flt2[_index_val]]
        _index_val++
        continue
      endif
      
      ;is _y_val_tested
      _result_y = where(_y_val_tested eq flt1_intersection, nbr)
      if (nbr eq 0) then begin
        _new_flt0 = [_new_flt0, _x_val_tested]
        _new_flt1 = [_new_flt1, _y_val_tested]
        _new_flt2 = [_new_flt2, _flt2[_index_val]]
        _index_val++
        continue
      endif
      
      ;we found _x_val_tested and _y_val_tested in the list of x and y points
      ;to remove. Now we need to check that they have been found at the
      ;same index in the flt0_intersection and flt1_intersection
      _same_index = getIntersectionOfArrays(array1=_result_x, $
        array2=_result_y)
      if (_same_index eq !null) then begin
        _new_flt0 = [_new_flt0, _x_val_tested]
        _new_flt1 = [_new_flt1, _y_val_tested]
        _new_flt2 = [_new_flt2, _flt2[_index_val]]
      endif
      
      _index_val++
    endwhile
    
    *new_flt0_ptr[_index] = _new_flt0
    *new_flt1_ptr[_index] = _new_flt1
    *new_flt2_ptr[_index] = _new_flt2
    
    _index++
  endwhile
  
  (*global_plot).local_flt0_rescale_ptr = new_flt0_ptr
  (*global_plot).local_flt1_rescale_ptr = new_flt1_ptr
  (*global_plot).local_flt2_rescale_ptr = new_flt2_ptr
  
end

;+
; :Description:
;    Refresh the plot when resizing for example
;
; :keywords:
;    event
;    base
;    init   ;when we want to reset the x and y axis (min and max values)
;
; :Author: j35
;-
pro refresh_plot, event=event, base=base, init=init
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    widget_control, event.top, get_uvalue=global_plot
    id = WIDGET_INFO(event.top, FIND_BY_UNAME='cleaning_draw')
  endif else begin
    widget_control, base, get_uvalue=global_plot
    id = WIDGET_INFO(base, FIND_BY_UNAME='cleaning_draw')
  endelse
  
  index  = (*global_plot).current_index_plotted
  
  status_of_list_of_files_plotted = $
    (*(*global_plot).status_of_list_of_files_plotted)
  list_files = (*global_plot).list_files
  
  flt0_ptr = (*global_plot).local_flt0_rescale_ptr
  flt1_ptr = (*global_plot).local_flt1_rescale_ptr
  
  ;get index of the files to plot
  _index_to_plot = where(status_of_list_of_files_plotted eq 1, nbr)
  
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  if (nbr eq 0) then begin
    erase
    return
  endif
  
  if (keyword_set(init)) then begin
  
    ;determine the full xaxis by retrieving the min and max x value
    _index = 0
    min_x_value = 10
    max_x_value = 0
    min_y_value = 10
    max_y_value = 0
    while (_index lt nbr) do begin
    
      _min_x_value = min(*flt0_ptr[_index_to_plot[_index]],max=_max_x_value)
      min_x_value = (_min_x_value lt min_x_value) ? _min_x_value : min_x_value
      max_x_value = (_max_x_value gt max_x_value) ? _max_x_value : max_x_value
      
      _min_y_value = min(*flt1_ptr[_index_to_plot[_index]],max=_max_y_value)
      min_y_value = (_min_y_value lt min_y_value) ? _min_y_value : min_y_value
      max_y_value = (_max_y_value gt max_y_value) ? _max_y_value : max_y_value
      
      _index++
    endwhile
    
    xrange = [min_x_value, max_x_value]
    yrange = [min_y_value, max_y_value]
    (*global_plot).xrange = xrange
    (*global_plot).yrange = yrange
    
  endif else begin
  
    xrange = (*global_plot).xrange
    yrange = (*global_plot).yrange
    
    min_x_value = xrange[0]
    max_x_value = xrange[1]
    
    min_y_value = yrange[0]
    max_y_value = yrange[1]
    
  endelse
  
  ;1:exact range
  xstyle=0
  ystyle=0
  
  list_color = (*global_plot).list_color
  
  _index = 0
  while (_index lt nbr) do begin
  
    flt0 = *flt0_ptr[_index_to_plot[_index]]
    flt1 = *flt1_ptr[_index_to_plot[_index]]
    
    if ((*global_plot).default_scale_settings) then begin ;log
    
      if (_index eq 0) then begin
        plot, [min_x_value,max_x_value], $
          [min_y_value,max_y_value], $
          /ylog, $
          xtitle = 'Q (' + string("305B) + '!E-1!N)', $
          xstyle=xstyle,$
          ytitle = 'Intensity',$
          ystyle=ystyle,$
          color=fsc_color('black'), $
          /nodata
      endif
      if (flt0 ne !null) then begin
        oplot, flt0, flt1, $
          color=fsc_color(list_color[_index]), $
          psym=2
      endif
    endif else begin
      if (_index eq 0) then begin
        plot, [min_x_value, max_x_value], $
          [min_y_value,max_y_value], $
          xtitle = 'Q (' + string("305B) + '!E-1!N)', $
          xstyle=xstyle,$
          ytitle = 'Intensity',$
          ystyle=ystyle,$
          color=fsc_color('black'), $
          /nodata
      endif
      if (flt0 ne !null) then begin
        oplot, flt0, flt1, psym=2, color=fsc_color(list_color[_index])
      endif
    endelse
    
    if ((*global_plot).show_y_error_bar) then begin ;show error bars
    
      flt2_ptr = (*global_plot).local_flt2_rescale_ptr
      flt2 = *flt2_ptr[_index_to_plot[_index]]
      
      if (flt0 ne !null) then begin
        errplot, flt0, $
          flt1-flt2,$
          flt1+flt2,$
          color=fsc_color(list_color[_index])
      endif
      
    endif
    
    _index++
  endwhile
  
  x1y1x2y2 = (*global_plot).x1y1x2y2
  x1 = x1y1x2y2[0]
  y1 = x1y1x2y2[1]
  x2 = x1y1x2y2[2]
  y2 = x1y1x2y2[3]
  if (x1 eq -1) then return
  if (x1 eq x2) then return
  if (y1 eq y2) then return
  
  oplot, [x1,x2,x2,x1,x1],[y1,y1,y2,y2,y1],color=fsc_color('black')
  
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
  
  ;x and y range input base
  base_id = (*global_plot).xy_range_input_base_id
  if (widget_info(base_id, /valid_id) ne 0) then begin
    widget_control, base_id, /destroy
  endif
  
  ;buttons base
  buttons_id = (*global_plot).cleaning_buttons_base_id
  if (widget_info(buttons_id, /valid_id) ne 0) then begin
    widget_control, buttons_id, /destroy
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
    
  ;refresh label of button
  list_files = (*global_plot).list_files
  _file_name = list_files[index_array]
  if (_value eq 1) then begin
    _new_label = '* '
  endif else begin
    _new_label = '  '
  endelse
  _new_label += strcompress(index+1,/remove_all) + ': ' + _file_name
  putValue, id=event.id, value=_new_label[0]
  
  refresh_plot, event=event
  plot_data_point_to_remove, event=event
  
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
  
  cleaning_base_killed, global_plot
  
  ptr_free, (*global_plot).data
  ptr_free, (*global_plot).data_linear
  ptr_free, (*global_plot).status_of_list_of_files_plotted
  ptr_free, (*global_plot).flt0_to_removed
  ptr_free, (*global_plot).flt1_to_removed
  ptr_free, (*global_plot).local_flt0_rescale_ptr
  ptr_free, (*global_plot).local_flt1_rescale_ptr
  ptr_free, (*global_plot).local_flt2_rescale_ptr
  
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
    kill_notify  = 'cleaning_base_killed', $
    /BASE_ALIGN_CENTER,$
    /align_center,$
    /tlb_move_events, $
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
    value = '* ' + value
    __file = widget_button(_file,$
      value = value,$
      event_pro = 'cleaning_file_list')
    index++
  endwhile
  
  set1_value = '   Y: linear'
  set2_value = '*  Y: logarithmic'
  
  mPlot = widget_button(bar1, $
    value = 'Axes',$
    /menu)
    
  set1 = widget_button(mPlot, $
    value = set1_value, $
    event_pro = 'switch_yaxes_type',$
    uname = 'local_scale_setting_linear')
    
  set2 = widget_button(mPlot, $
    value = set2_value,$
    event_pro = 'switch_yaxes_type',$
    uname = 'local_scale_setting_log')
    
  xyaxes = widget_button(mPlot, $
    /separator, $
    value = 'Select X and Y ranges ...',$
    event_pro = 'switch_xyaxes_range')
    
  ;error bars
  error = widget_button(bar1,$
    value = 'Error',$
    /menu)
  _Error = widget_button(error,$
    value = '* Show Y error bars',$
    uname = 'show_or_not_error_bars',$
    event_pro = 'error_bar_menu_eventcb')
    
  ;main plot
  draw = widget_draw(wbase,$
    scr_xsize = xsize,$
    scr_ysize = ysize,$
    /button_events,$
    /motion_events,$
    retain=2, $
    keyboard_events=2,$
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
;    spin
;
;    main_base_uname
;
; :Author: j35
;-
pro cleaning_base, event=event, $
    list_files = list_files, $
    offset = offset, $
    spin=spin, $
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
    left_click_pressed: 0b, $
    shift_key_pressed: 0b, $
    
    xy_range_input_base_id: 0, $ ;id of x & y range input base
    cleaning_buttons_base_id: 0, $ ;id of cleaning buttons base
    
    spin: spin, $ ;spin selected
    
    scale_setting: 1, $  ;1 for log, 0 for linear
    current_index_plotted: 0, $
    
    list_color: ['red','pink','orange','green','blue','black', $
    'red','pink','orange','green','blue','black', $
    'red','pink','orange','green','blue','black'],$
    
    status_of_list_of_files_plotted: ptr_new(0L), $
    
    data: ptr_new(0L), $
    data_linear: ptr_new(0L), $
    
    local_flt0_rescale_ptr: ptrarr(50,/allocate_heap), $
    local_flt1_rescale_ptr: ptrarr(50,/allocate_heap), $
    local_flt2_rescale_ptr: ptrarr(50,/allocate_heap), $
    
    flt0_to_removed: ptr_new(0L), $
    flt1_to_removed: ptr_new(0L), $
    
    xsize: default_plot_size[0],$
    ysize: default_plot_size[1],$
    x1y1x2y2: [-1.,-1.,-1.,-1.], $
    
    border: border, $ ;border of main plot (space reserved for scale)
    
    xrange: fltarr(2),$ ;[Qmin, Qmax]
    yrange: fltarr(2),$ ;[IntensityMin, IntensityMax]
    
    left_click: 0b,$ ;by default, left button is not clicked
    
    main_event: event})
    
  local_flt0_rescale_ptr = (*global_plot).local_flt0_rescale_ptr
  local_flt1_rescale_ptr = (*global_plot).local_flt1_rescale_ptr
  local_flt2_rescale_ptr = (*global_plot).local_flt2_rescale_ptr
  
  flt0_rescale_ptr = (*global).flt0_rescale_ptr
  flt1_rescale_ptr = (*global).flt1_rescale_ptr
  flt2_rescale_ptr = (*global).flt2_rescale_ptr
  
  _spin = spin
  for i=0,49 do begin
  
    *local_flt0_rescale_ptr[i] = ptr_new(0L)
    *local_flt1_rescale_ptr[i] = ptr_new(0L)
    *local_flt2_rescale_ptr[i] = ptr_new(0L)
    
    *local_flt0_rescale_ptr[i] = *flt0_rescale_ptr[i,_spin]
    *local_flt1_rescale_ptr[i] = *flt1_rescale_ptr[i,_spin]
    *local_flt2_rescale_ptr[i] = *flt2_rescale_ptr[i,_spin]
    
  endfor
  
  (*global_plot).local_flt0_rescale_ptr = local_flt0_rescale_ptr
  (*global_plot).local_flt1_rescale_ptr = local_flt1_rescale_ptr
  (*global_plot).local_flt2_rescale_ptr = local_flt2_rescale_ptr
  
  ;[1,1,0,1] for example means the first 2 and the last file loaded are plotted.
  sz = n_elements(list_files)
  status_of_list_of_files_plotted = intarr(sz) + 1 ;plot all the files by default
  (*(*global_plot).status_of_list_of_files_plotted) = $
    status_of_list_of_files_plotted
    
  WIDGET_CONTROL, wBase, SET_UVALUE = global_plot
  
  XMANAGER, "cleaning_base", wBase, GROUP_LEADER = ourGroup, /NO_BLOCK, $
    cleanup = 'cleaning_base_cleanup'
    
  refresh_plot, base=wBase, /init
  
  xy_range_input_base, main_base_id=wBase, $
    parent_base_uname='cleaning_widget_base'
    
  cleaning_buttons_base, main_base_id=wBase, $
    parent_base_uname='cleaning_widget_base'
    
end

