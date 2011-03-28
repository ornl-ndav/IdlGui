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
pro data_background_tof_range_selection_base_gui, wBase, $
    parent_base_geometry
  compile_opt idl2
  
  main_base_xoffset = parent_base_geometry.xoffset
  main_base_yoffset = parent_base_geometry.yoffset
  main_base_xsize = parent_base_geometry.xsize
  main_base_ysize = parent_base_geometry.ysize
  
  xoffset = main_base_xoffset  
  yoffset = main_base_yoffset + main_base_ysize + 35
  
  ourGroup = WIDGET_BASE()
  
  title = 'TOF range selection'
  wBase = WIDGET_BASE(TITLE = title, $
    UNAME        = 'tof_range_base', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    /column,$
    /tlb_size_events,$
    GROUP_LEADER = ourGroup)

  tof_row1 = widget_base(wBase,$
    /row)
  tof1 = widget_label(tof_row1,$
    value = 'Plot from TOF1 (ms):')
  tof1_value = widget_text(tof_row1,$
    value = 'N/A',$
    xsize=8,$
    /editable,$
    uname = 'reduce_step2_tof1')
  tof1 = widget_label(tof_row1,$
    value = ' to TOF2 (ms):')
  tof1_value = widget_text(tof_row1,$
    value = 'N/A',$
    /editable,$
    xsize = 8,$
    uname = 'reduce_step2_tof2')
  space = widget_label(tof_row1,$
    value = '   ')
  full_range = widget_button(tof_row1,$
    value = 'Plot range',$
    scr_xsize = 110,$
    uname = 'reduce_step2_tof_plot_only_range')
  space = widget_label(tof_row1,$
    value = '      ')
  full_range = widget_button(tof_row1,$
    value = 'Plot full',$
    scr_xsize = 110,$
    uname = 'reduce_step2_tof_plot_full_range')
  tof_row2 = widget_label(wBase,$
    value = 'Left click TOF range to select TOF1, right' + $
    ' click to switch to TOF2.')
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
pro cursor_info_base_killed, id
  compile_opt idl2

return
  
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
pro data_background_tof_range_selection_base_cleanup, tlb
  compile_opt idl2
  
  widget_control, tlb, get_uvalue=global_info, /no_copy
  
  if (n_elements(global_info) eq 0) then return
  
  ptr_free, global_info
  
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
pro data_background_tof_range_selection_base, event=event, $
    top_base=top_base, $
    parent_base_uname = parent_base_uname
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME=parent_base_uname)
    WIDGET_CONTROL,Event.top,GET_UVALUE=global_pixel_selection
  endif else begin
    id = widget_info(top_base, find_by_uname=parent_base_uname)
    widget_control, top_base, get_uvalue=global_pixel_selection
  endelse
  parent_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  _base = 0L
  data_background_tof_range_selection_base_gui, _base, $
    parent_base_geometry
    
  (*global_pixel_selection).tof_range_selection_base = _base
  
  WIDGET_CONTROL, _base, /REALIZE
  
  global_info = PTR_NEW({ _base: _base,$
    top_base: top_base, $
    global_pixel_selection: global_pixel_selection })
    
  WIDGET_CONTROL, _base, SET_UVALUE = global_info
  
  XMANAGER, "data_background_tof_range_selection_base", _base, $
  GROUP_LEADER = ourGroup, $
    /NO_BLOCK, $
    cleanup='data_background_tof_range_selection_base_cleanup'
    
end

