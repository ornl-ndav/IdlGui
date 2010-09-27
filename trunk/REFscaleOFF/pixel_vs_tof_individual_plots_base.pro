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
pro px_vs_tof_plots_base_event, Event
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global_plot
  global = (*global_plot).global
  main_event = (*global_plot).main_event
  
  case Event.id of
  
    widget_info(event.top, find_by_unam='plot_setting_untouched'): begin
      switch_local_settings_plot_values, event
      refresh_plot, event
    end
    widget_info(event.top, find_by_unam='plot_setting_interpolated'): begin
      switch_local_settings_plot_values, event
      refresh_plot, event
    end
    
    widget_info(event.top, find_by_uname='px_vs_tof_widget_base'): begin
    
      id = widget_info(event.top, find_by_uname='px_vs_tof_widget_base')
      ;widget_control, id, /realize
      geometry = widget_info(id,/geometry)
      new_xsize = geometry.scr_xsize
      new_ysize = geometry.scr_ysize
      
      (*global_plot).xsize = new_xsize
      (*global_plot).ysize = new_ysize
      
      widget_control, id, xsize = new_xsize
      widget_control, id, ysize = new_ysize
      
      id = widget_info(event.top, find_by_uname='draw')
      widget_control, id, draw_xsize = new_xsize
      widget_control, id, draw_ysize = new_ysize
      
      refresh_plot, event
      
    end
    
    widget_info(event.top, $
      find_by_uname='settings_base_close_button'): begin
      
      ;this will allow the settings tab to come back in the same state
      save_status_of_settings_button, event
      
      id = widget_info(Event.top, $
        find_by_uname='settings_widget_base')
      widget_control, id, /destroy
    end
    
    else:
    
  endcase
  
end

;+
; :Description:
;    refresh the 2d plot
;
; :Params:
;    event
;
; :Author: j35
;-
pro refresh_plot, event
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global_plot
  global = (*global_plot).global
  
  Data = (*(*global_plot).data)
  new_xsize = (*global_plot).xsize
  new_ysize = (*global_plot).ysize
  
  if ((*global_plot).plot_setting eq 'untouched') then begin
    cData = congrid(Data, new_ysize, new_xsize)
  endif else begin
    cData = congrid(Data, new_ysize, new_xsize,/interp)
  endelse
  
  id = widget_info(event.top, find_by_uname='draw')
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  erase
  
  tvscl, transpose(cData)
  
end

;+
; :Description:
;    Switch local label of plot settings button
;    validated.
;    add * at the beginning of string when button is validated
;
; :Params:
;    event
;
; :Author: j35
;-
pro switch_local_settings_plot_values, event
  compile_opt idl2
  
  widget_control,event.top,get_uvalue=global_plot
  global = (*global_plot).global
  
  plot_setting1 = (*global).plot_setting1
  plot_setting2 = (*global).plot_setting2
  
  set1_value = getValue(event, 'plot_setting_untouched')
  
  if (set1_value eq ('   ' + plot_setting1)) then begin ;setting1 needs to be checked
    set1_value = '*  ' + plot_setting1
    set2_value = '   ' + plot_setting2
    (*global_plot).plot_setting = 'untouched'
  endif else begin
    set1_value = '   ' + plot_setting1
    set2_value = '*  ' + plot_setting2
    (*global_plot).plot_setting = 'interpolated'
  endelse
  
  putValue, event, 'plot_setting_untouched', set1_value
  putValue, event, 'plot_setting_interpolated', set2_value
  
end

;+
; :Description:
;   Reached when the settings base is killed
;
; :Params:
;    event
;
; :Author: j35
;-
pro px_vs_tof_widget_killed, id
  compile_opt idl2
  
  ;get global structure
  widget_control,id,get_uvalue=global_settings
  global = (*global_settings).global
  main_event = (*global_settings).main_event
  
  id = widget_info(id, $
    find_by_uname='px_vs_tof_widget_base')
  widget_control, id, /destroy
;ActivateWidget, main_Event, 'open_settings_base', 1
  
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
PRO px_vs_tof_plots_base_gui, wBase, $
    main_base_geometry, $
    global, $
    file_name, $
    offset
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
  
  title = 'Pixel vs TOF of ' + file_name
  wBase = WIDGET_BASE(TITLE = title, $
    UNAME        = 'px_vs_tof_widget_base', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    SCR_YSIZE    = ysize,$
    SCR_XSIZE    = xsize,$
    MAP          = 1,$
    kill_notify  = 'px_vs_tof_widget_killed', $
    /BASE_ALIGN_CENTER,$
    /align_center,$
    /column,$
    /tlb_size_events,$
    mbar = bar1,$
    GROUP_LEADER = ourGroup)
    
  plot_setting1 = (*global).plot_setting1
  plot_setting2 = (*global).plot_setting2
  
  mPlot = widget_button(bar1, $
    value = 'Settings',$
    /menu)
    
  set2 = widget_button(mPlot, $
    value = ('*  ' + plot_setting1),$
    uname = 'plot_setting_untouched')
    
  set1 = widget_button(mPlot, $
    value = ('   ' + plot_setting2),$
    uname = 'plot_setting_interpolated')
    
  draw = widget_draw(wBase,$
    scr_xsize = xsize,$
    scr_ysize = ysize,$
    uname = 'draw')
    
END

;+
; :Description:
;     Creates the base and plot the pixel vs tof of the
;     given file index

; :Keywords:
;    main_base
;    event
;
; :Author: j35
;-
PRO px_vs_tof_plots_base, main_base=main_base, $
    event=event, $
    file_name = file_name, $
    file_index = file_index, $
    spin_state=spin_state,$
    offset = offset
  compile_opt idl2
  
  if (n_elements(spin_state) eq 0) then spin_state = 0
  
  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    id = WIDGET_INFO(main_base, FIND_BY_UNAME='main_base')
    WIDGET_CONTROL,main_base,GET_UVALUE=global
    event = 0
  ENDIF ELSE BEGIN
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME='main_base')
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ENDELSE
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;build gui
  wBase = ''
  px_vs_tof_plots_base_gui, wBase, $
    main_base_geometry, $
    global, $
    file_name, $
    offset
    
  WIDGET_CONTROL, wBase, /REALIZE
  
  default_plot_size = (*global).default_plot_size
  global_plot = PTR_NEW({ wbase: wbase,$
    global: global, $
    data: ptr_new(0L), $
    plot_setting: (*global).plot_setting,$
    xsize: default_plot_size[0],$
    ysize: default_plot_size[1],$
    main_event: event})
    
  WIDGET_CONTROL, wBase, SET_UVALUE = global_plot
  
  XMANAGER, "px_vs_tof_plots_base", wBase, GROUP_LEADER = ourGroup, /NO_BLOCK
  
  ;retrieve the data to plot
  pData_y = (*global).pData_y
  Data = *pData_y[file_index, spin_state]
  (*(*global_plot).data) = Data
  
  if ((*global_plot).plot_setting eq 'untouched') then begin
    cData = congrid(Data, default_plot_size[0], default_plot_size[1])
  endif else begin
    cData = congrid(Data, default_plot_size[0], default_plot_size[1],/interp)
  endelse
  
  DEVICE, DECOMPOSED = 0
  loadct, 5, /SILENT
  
  id = widget_info(wBase,find_by_uname='draw')
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  tvscl, transpose(cData)
  
END

