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
pro px_vs_tof_cursor_info_base_event, Event
  compile_opt idl2
  
  case Event.id of
  
    else:
    
  endcase
  
end

;+
; :Description:
;    Builds the GUI of the info base
;
; :Params:
;    wBase
;    parent_base_geometry
;
;
;
; :Author: j35
;-
pro px_vs_tof_cursor_info_base_gui, wBase, $
    parent_base_geometry, $
    global_px_vs_tof
  compile_opt idl2
  
  main_base_xoffset = parent_base_geometry.xoffset
  main_base_yoffset = parent_base_geometry.yoffset
  main_base_xsize = parent_base_geometry.xsize
  main_base_ysize = parent_base_geometry.ysize
  
  ;  xsize = 300
  ;  ysize = 100
  
  xoffset = main_base_xsize
  xoffset += main_base_xoffset
  
  yoffset = main_base_yoffset - 20
  
  ourGroup = WIDGET_BASE()
  
  title = 'Cursor and selection infos'
  wBase = WIDGET_BASE(TITLE = title, $
    UNAME        = 'cursor_info_base', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    map          = 1,$
    kill_notify  = 'cursor_info_base_killed', $
    /column,$
    /tlb_size_events,$
    GROUP_LEADER = ourGroup)
    
  MainRow1=widget_base(wBase,$
    /row)
    
  cursor_selection_label = widget_label(MainRow1,$
    value = ' CURSOR LIVE                    SELECTION')
    
  MainRow2 = widget_base(wBase,$
    /row)
    
  ;live TOF, pixel and counts infos
  leftBase = widget_base(MainRow2,$
    frame=1,$
    /column)
    
  row1 = widget_base(leftBase,$
    /row)
  lab = widget_label(row1,$
    value = 'TOF (ms): ', $
    /align_right)
  val = widget_label(row1,$
    value = 'N/A',$
    uname = 'px_vs_tof_cursor_info_x_value_uname',$
    scr_xsize = 100,$
    /align_left)
    
  row2 = widget_base(leftBase,$
    /row)
  lab = widget_label(row2,$
    value = '   Pixel: ', $
    ;    scr_xsize= 60,$
    /align_right)
  val = widget_label(row2,$
    value = 'N/A',$
    uname = 'px_vs_tof_cursor_info_y_value_uname',$
    scr_xsize = 100,$
    /align_left)
    
  row3 = widget_base(leftBase,$
    /row)
  lab = widget_label(row3,$
    value = '  Counts: ',$
    ;    scr_xsize= 60,$
    /align_right)
  val = widget_label(row3,$
    uname = 'px_vs_tof_cursor_info_z_value_uname',$
    value = 'N/A',$
    scr_xsize = 100,$
    /align_left)
    
  ;right part with selection information
    
  rightBase = widget_base(MainRow2,$
    frame = 1,$
    /column)
    
  draw_zoom_data_selection = (*global_px_vs_tof).draw_zoom_data_selection
  tof0 = draw_zoom_data_selection[0]
  tof1 = draw_zoom_data_selection[2]
  if (tof0 ne -1 && tof1 ne -1) then begin
    tof0 = min([tof0,tof1],max=tof1)
    _tof0 = strcompress(tof0,/remove_all)
    _tof1 = strcompress(tof1,/remove_all)
  endif
  if (tof0 eq -1 && tof1 eq -1) then begin
    _tof0 = 'N/A'
    _tof1 = 'N/A'
  endif
  if (tof1 ne -1 && tof0 eq -1) then begin
    _tof0 = 'N/A'
    _tof1 = strcompress(tof1,/remove_all)
  endif
  if (tof1 eq -1 && tof0 ne -1) then begin
    _tof1 = 'N/A'
    _tof0 = strcompress(tof0,/remove_all)
  endif
  tof_label = _tof0 + ' -> ' + _tof1
  
  row1 = widget_base(rightBase,$
    /row)
  lab = widget_label(row1,$
    value = 'TOF (ms): ', $
    /align_right)
  val = widget_label(row1,$
    value = tof_label,$
    uname = 'px_vs_tof_cursor_info_x0x1_value_uname',$
    scr_xsize = 200,$
    /align_left)
    
  pixel0 = draw_zoom_data_selection[1]
  pixel1 = draw_zoom_data_selection[3]
  if (pixel0 ne -1 && pixel1 ne -1) then begin
    pixel0 = min([pixel0,pixel1],max=pixel1)
    _pixel0 = strcompress(fix(pixel0),/remove_all)
    _pixel1 = strcompress(fix(pixel1),/remove_all)
  endif
  if (pixel0 eq -1 && pixel1 eq -1) then begin
    _pixel0 = 'N/A'
    _pixel1 = 'N/A'
  endif
  if (pixel0 eq -1 && pixel1 ne -1) then begin
    _pixel0 = 'N/A'
    _pixel1 = strcompress(fix(tof1),/remove_all)
  endif
  if (pixel1 eq -1 && pixel0 ne -1) then begin
    _pixel1 = 'N/A'
    _pixel0 = strcompress(fix(tof0),/remove_all)
  endif
  pixel_label = _pixel0 + ' -> ' + _pixel1
  
  row2 = widget_base(rightBase,$
    /row)
  lab = widget_label(row2,$
    value = '   Pixel: ', $
    /align_right)
  val = widget_label(row2,$
    value = pixel_label,$
    uname = 'px_vs_tof_cursor_info_y0y1_value_uname',$
    scr_xsize = 200,$
    /align_left)
    
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
pro px_vs_tof_cursor_info_base_killed, id
  compile_opt idl2
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    return
  endif
  
  ;get global structure
  widget_control,id,get_uvalue=global_info
  event = (*global_info).parent_event
  refresh_plot, event
  
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
pro px_vs_tof_counts_info_base_cleanup, tlb
  compile_opt idl2
  
  widget_control, tlb, get_uvalue=global_info, /no_copy
  
  if (n_elements(global_info) eq 0) then return
  
  ptr_free, global_info
  
end

;+
; :Description:
;   base that will show the x, y, counts values
;   as well as the counts vs tof and counts vs pixel of cursor
;   position
;
; :Keywords:
;    main_base
;    event
;
; :Author: j35
;-
pro px_vs_tof_cursor_info_base, event=event, $
    parent_base_uname = parent_base_uname
  compile_opt idl2
  
  if (n_elements(spin_state) eq 0) then spin_state = 0
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME=parent_base_uname)
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_px_vs_tof
  parent_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  _base = ''
  px_vs_tof_cursor_info_base_gui, _base, $
    parent_base_geometry, $
    global_px_vs_tof
    
  (*global_px_vs_tof).cursor_info_base = _base
  
  WIDGET_CONTROL, _base, /REALIZE
  
  global_info = PTR_NEW({ _base: _base,$
    parent_event: event, $
    global: global_px_vs_tof })
    
  WIDGET_CONTROL, _base, SET_UVALUE = global_info
  
  XMANAGER, "px_vs_tof_cursor_info_base", _base, GROUP_LEADER = ourGroup, /NO_BLOCK, $
    cleanup='px_vs_tof_counts_info_base_cleanup'
    
end

