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
pro preview_display_base_event, Event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_preview
  global = (*global_preview).global
  
  case Event.id of
  
    ;loadct button
    widget_info(event.top, find_by_uname='show_xloadct'): begin
      launch_preview_xloadct, event=event
    end
    
    ;draw
    widget_info(event.top, find_by_uname='zoom_draw'): begin
    
      ;left click
      if (event.press eq 1) then begin
        (*global_preview).left_click = 1b
        x=event.x
        y=event.y
        roi_selection = [x,y,0,0]
        (*global_preview).roi_selection = roi_selection
        return
      endif
      
      ;release left click
      if (event.release eq 1b && $
        (*global_preview).left_click eq 1b) then begin
        (*global_preview).left_click = 0b
        ;add roi to the main_base roi box if the selection is valid
        selection = (*global_preview).roi_selection
        ;        plot_zoom_data, event=event
        if (is_selection_valid(selection=selection)) then begin
          keep_selection_inside_zoom_draw, event=event, selection=selection
          selection_data = convert_zoom_device_to_data(event=event, selection)
          add_new_selection_to_list_of_roi, event=event, new_roi=selection_data
        endif
        plot_zoom_roi, event=event
        display_preview_roi, base=(*global_preview).top_base
        plot_other_zoom_and_roi_data, event=event
        return
      endif
      
      ;moving mouse with left click
      if ((*global_preview).left_click) then begin
        x=event.x
        y=event.y
        roi_selection = (*global_preview).roi_selection
        roi_selection[2] = x
        roi_selection[3] = y
        (*global_preview).roi_selection = roi_selection
        
        x0 = roi_selection[0]
        y0 = roi_selection[1]
        x1 = x
        y1 = y
        
        plot_zoom_data, event=event
        plot_zoom_roi, event=event
        
        id = widget_info(event.top,find_by_uname='zoom_draw')
        widget_control, id, get_value=plot_id
        wset, plot_id
        
        plots, [x0, x0, x1, x1, x0], $
          [y0, y1, y1, y0, y0], /device, color=fsc_color('red')
          
        ;plot_other_zoom_and_roi_data, event=event, /live
          
        return
      endif
      
    end
    
    ;main base resized or moved
    widget_info(event.top, find_by_uname='zoom_base_uname'): begin
    
      if (path_sep() eq '\') then return ;no resizing for windows
      ;because right now it's a mess !!!!
    
      id = widget_info(event.top, find_by_uname='zoom_base_uname')
      geometry = widget_info(id,/geometry)
      new_xsize = geometry.scr_xsize
      new_ysize = geometry.scr_ysize
      xoffset = geometry.xoffset
      yoffset = geometry.yoffset
      
      if (path_sep() eq '/') then begin ;mac/unix
      
        if ((abs((*global_preview).ysize - new_ysize) eq 33.0) && $
          (abs((*global_preview).xsize - new_xsize) eq 70.0)) then return
          
        if ((abs((*global_preview).ysize - new_ysize) eq 33.0) && $
          (abs((*global_preview).xsize - new_xsize) eq 0.0)) then return
          
        new_ysize -= 33  ;due to the menu bar at the top
        
      endif else begin ;windows
      
        print, '(*global_preview).ysize: ' , (*global_preview).ysize
        print, 'new_ysize: ' , new_ysize
        print, '(*global_preview).xsize: ' , (*global_preview).xsize
        print, 'new_xsize: ' , new_xsize
        print

      if ((abs((*global_preview).xsize - new_xsize) eq 111.0) && $
      (abs((*global_preview).ysize - new_ysize) eq 56.0)) then return
      ;if (abs((*global_preview).ysize - new_ysize) eq 56.0) then return

        new_ysize -= 33  ;due to the menu bar at the top
        ; new_xsize -= 5
      endelse
      
      (*global_preview).xsize = new_xsize
      (*global_preview).ysize = new_ysize
            
      widget_control, id, scr_xsize = new_xsize
      widget_control, id, scr_ysize = new_ysize
      
      border = (*global_preview).border
      colorbar_xsize = (*global_preview).colorbar_xsize
      
      id = widget_info(event.top, find_by_uname='zoom_draw')
      widget_control, id, draw_xsize = new_xsize-2*border-colorbar_xsize
      widget_control, id, draw_ysize = new_ysize-2*border
      
      id = widget_info(event.top,find_by_Uname='zoom_scale')
      widget_control, id, draw_xsize = new_xsize-colorbar_xsize
      widget_control, id, draw_ysize = new_ysize
      
      id = widget_info(event.top, find_by_uname='zoom_colorbar')
      widget_control, id, xoffset=new_xsize-colorbar_xsize
      widget_control, id, draw_ysize = new_ysize
      widget_control, id, draw_xsize = colorbar_xsize
      
      ;plot colorbar
      plot_colorbar_zoom_data, event=event
      
      ;display the main data
      plot_zoom_data, event=event, /recalculate
      
      ;plot roi
      plot_zoom_roi, event=event
      
      ;plot scale around the plot
      plot_scale_zoom_data, event=event
      
      return
      
    end
    
    ;       ;cancel tof selected
    ;    widget_info(event.top, $
    ;      find_by_uname='cancel_discrete_selection_selected_uname'): begin
    ;      widget_control, event.top, get_uvalue=global_preview
    ;      top_base = (*global_preview).top_base
    ;      widget_control, top_base, /destroy
    ;    end
    
    else:
    
  endcase
  
end

;+
; :Description:
;    Launch the xloadct base
;
;
;
; :Keywords:
;    event
;
; :Author: j35
;-
pro launch_preview_xloadct, event=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_preview
  global = (*global_preview).global
  
  id = widget_info(event.top, find_by_uname='zoom_base_uname')
  xloadct, group=id, $
    updatecallback='zoom_live_preview_of_currently_selected_file',$
    updatecbdata=event, $
    /use_current, $
    global=global
    
end

;+
; :Description:
;    This procedure launch the preview of the currently selected file
;
;
;
; :Keywords:
;    data
;
; :Author: j35
;-
pro zoom_live_preview_of_currently_selected_file, data=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_preview
  
  ;display the main data
  plot_zoom_data, event=event, /recalculate
  
  ;plot colorbar
  plot_colorbar_zoom_data, event=event
  
end

;+
; :Description:
;    Builds the GUI of the preview display
;
; :Params:
;    wBase
;    parent_base_geometry
;    border
;    default_plot_size
;
;
; :Author: j35
;-
pro preview_display_base_gui, wBase, $
    parent_base_geometry, $
    scale_setting=scale_setting, $
    border=border, $
    default_plot_size=default_plot_size,$
    colorbar_xsize=colorbar_xsize
    
  compile_opt idl2
  
  border = 40
  
  if (path_sep() eq '\') then begin ;if windows
    xborder=border+7
    colorbar_xsize = 95
  endif else begin ;unix/mac
    xborder=border
    colorbar_xsize = 70
  endelse
  
  yborder=border
  
  default_plot_size = [1000,1000]
  
  xsize = default_plot_size[0]
  ysize = default_plot_size[1]
  
  main_base_xoffset = parent_base_geometry.xoffset
  main_base_yoffset = parent_base_geometry.yoffset
  main_base_xsize = parent_base_geometry.scr_xsize
  main_base_ysize = parent_base_geometry.scr_ysize
  
  xoffset = main_base_xsize
  xoffset += main_base_xoffset
  
  yoffset = main_base_yoffset
  
  ourGroup = WIDGET_BASE()
  
  title = 'Zoom'
  wBase = WIDGET_BASE(TITLE = title, $
    UNAME        = 'zoom_base_uname', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    ;    kill_notify  = 'zoom_killed', $
    /tlb_size_events,$
    /align_center, $
    /tlb_move_events, $
    mbar=bar1,$
    GROUP_LEADER = ourGroup)
    
  draw = widget_draw(wbase,$
    xoffset = xborder,$
    yoffset = yborder,$
    scr_xsize = xsize-2*xborder,$
    scr_ysize = ysize-2*yborder,$
    /button_events, $
    /motion_events, $
    ;    /tracking_events, $
    keyboard_events=2, $
    retain=2, $
    ;    event_pro = 'refpix_draw_eventcb',$
    uname = 'zoom_draw')
    
  scale = widget_draw(wBase,$
    uname = 'zoom_scale',$
    scr_xsize = xsize,$
    scr_ysize = ysize,$
    retain=2)
    
  colorbar =  widget_draw(wBase,$
    uname = 'zoom_colorbar',$
    xoffset = xsize,$
    scr_xsize = colorbar_xsize,$
    scr_ysize = ysize,$
    retain=2)
    
  ;  if (scale_setting eq 0) then begin
  ;    set1_value = '*  linear'
  ;    set2_value = '   logarithmic'
  ;  endif else begin
  ;    set1_value = '   linear'
  ;    set2_value = '*  logarithmic'
  ;  endelse
  ;
  ;  mPlot = widget_button(bar1, $
  ;    value = 'Axes',$
  ;    /menu)
  ;
  ;  set1 = widget_button(mPlot, $
  ;    value = set1_value, $
  ;    event_pro = 'tof_selection_local_switch_axes_type',$
  ;    uname = 'tof_selection_local_scale_setting_linear')
  ;
  ;  set2 = widget_button(mPlot, $
  ;    value = set2_value,$
  ;    event_pro = 'tof_selection_local_switch_axes_type',$
  ;    uname = 'tof_selection_local_scale_setting_log')
    
  loadct = widget_button(bar1,$
    value = 'Color/Contrast',$
    /menu)
    
  button1 = widget_button(loadct,$
    value = 'Launch tool...',$
    uname = 'show_xloadct')
    
;  pixel = widget_button(bar1,$
;    value = 'Extra',$
;    /menu)
;
;  show = widget_button(pixel,$
;    value = 'Show TOF selection window',$
;    uname = 'show_tof_selection_base')
;
;  _plot = widget_button(pixel,$
;    value = 'Show Counts vs TOF window',$
;    uname = 'show_counts_vs_tof_base')
    
end

;+
; :Description:
;    Killed routine
;
; :Params:
;    id
;
;
;
; :Author: j35
;-
pro preview_display_base_killed, id
  compile_opt idl2
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    return
  endif
  
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
pro preview_display_base_cleanup, tlb
  compile_opt idl2
  
  ;  add_zoom_base_id, preview_base=tlb
  
  widget_control, tlb, get_uvalue=global_preview, /no_copy
  
  if (n_elements(global_preview) eq 0) then return
  
  ptr_free, (*global_preview).cData
  ptr_free, (*global_preview).data
  ptr_free, (*global_preview).background
  
  ptr_free, global_preview
  
end

;+
; :Description:
;
; :Keywords:
;    main_base
;    event
;
; :Author: j35
;-
pro preview_display_base, event=event, $
    top_base=top_base, $
    parent_base_uname = parent_base_uname
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME=parent_base_uname)
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
    top_base = (*global).top_base
  endif else begin
    id = widget_info(top_base, find_by_uname=parent_base_uname)
    widget_control, top_base, get_uvalue=global
  endelse
  parent_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;default values
  default_scale_setting = 0b ;linear by default (1b for log)
  default_loadct = 5
  
  _base = 0L
  border=0
  default_plot_size=0
  preview_display_base_gui, _base, $
    parent_base_geometry, $
    scale_setting=default_scale_setting,$
    border=border,$
    default_plot_size=default_plot_size,$
    colorbar_xsize=colorbar_xsize
    
  add_zoom_base_id, event=event, new_base=_base
  
  WIDGET_CONTROL, _base, /REALIZE
  
  global_preview = PTR_NEW({ _base: _base,$
    top_base: top_base, $
    
    default_loadct: default_loadct, $
    default_scale_setting: default_scale_setting, $ ;0b:linear, 1b:log
    
    ;default plot size of main plot
    xsize: default_plot_size[0],$
    ysize: default_plot_size[1],$
    
    background: ptr_new(0L), $
    
    left_click: 0b, $
    roi_selection: intarr(4), $
    
    border: border, $
    colorbar_xsize: colorbar_xsize, $
    
    cData: ptr_new(0L), $ ;congrid(data, xsize, ysize)
    data: ptr_new(0L), $ ;untouched data
    xrange: intarr(2), $  ;ex: [0,2048]
    yrange:intarr(2), $   ;ex: [0,2048]
    
    global: global })
    
  WIDGET_CONTROL, _base, SET_UVALUE = global_preview
  
  data = (*(*global).preview_data)
  (*(*global_preview).data) = data
  sz = size(data,/dim)
  xrange = (*global_preview).xrange
  xrange[1] = sz[0]
  yrange = (*global_preview).yrange
  yrange[1] = sz[1]
  (*global_preview).xrange = xrange
  (*global_preview).yrange = yrange
  
  XMANAGER, "preview_display_base", $
    _base, $
    GROUP_LEADER=ourGroup, $
    /NO_BLOCK, $
    cleanup='preview_display_base_cleanup'
    
  ;display the main data
  plot_zoom_data, base=_base, /recalculate
  
  ;plot roi
  plot_zoom_roi, base=_base
  
  ;plot colorbar
  plot_colorbar_zoom_data, base=_base
  
  ;plot scale around the plot
  plot_scale_zoom_data, base=_base
  
end

;+
; :Description:
;    This routine launch the zoom display
;
;
;
; :Keywords:
;    event
;
; :Author: j35
;-
pro launch_zoom, event=event
  compile_opt idl2
  
  top_base = widget_info(event.top, find_by_uname='MAIN_BASE')
  
  preview_file_name = getValue(event=event,uname='preview_file_name_label')
  if (preview_file_name eq 'N/A') then return
  
  preview_display_base, event=event, $
    top_base=top_base, $
    parent_base_uname='MAIN_BASE'
    
end
