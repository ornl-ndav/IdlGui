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
pro refpix_cursor_info_base_event, Event
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
pro refpix_cursor_info_base_gui, wBase, $
    parent_base_geometry
  compile_opt idl2
  
  main_base_xoffset = parent_base_geometry.xoffset
  main_base_yoffset = parent_base_geometry.yoffset
  main_base_xsize = parent_base_geometry.xsize
  main_base_ysize = parent_base_geometry.ysize
  
  xoffset = main_base_xsize
  xoffset += main_base_xoffset
  
  yoffset = main_base_yoffset + 170
  
  ourGroup = WIDGET_BASE()
  
  title = 'Cursor position'
  wBase = WIDGET_BASE(TITLE = title, $
    UNAME        = 'refpix_cursor_position_base', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    /column,$
    /tlb_size_events,$
    GROUP_LEADER = ourGroup)
    
  ;cursor_info
  rowa = widget_base(wBase,$
    /frame,$
    /column)
    
  rowa_1 = widget_base(rowa,$
    /row)
  label = widget_label(rowa_1,$
    /align_right,$
    value = 'TOF (ms):')
  value = widget_label(rowa_1,$
    value = 'N/A',$
    scr_xsize = 140,$
    uname = 'refpix_cursor_tof_value',$
    /align_left)
    
  rowa_2 = widget_base(rowa,$
    /row)
  label = widget_label(rowa_2,$
    /align_right,$
    value = '   Pixel:')
  value = widget_label(rowa_2,$
    value = 'N/A',$
    scr_xsize = 140,$
    uname = 'refpix_cursor_pixel_value',$
    /align_left)
    
  rowa_3 = widget_base(rowa,$
    /row)
  label = widget_label(rowa_3,$
    /align_right,$
    value = '  Counts:')
  value = widget_label(rowa_3,$
    value = 'N/A',$
    scr_xsize = 140,$
    uname = 'refpix_cursor_counts_value',$
    /align_left)
    
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
pro refpix_cursor_info_base, event=event, $
    top_base=top_base, $
    parent_base_uname = parent_base_uname
  compile_opt idl2
  
  print, 'in refpix_cursor_info_base'
  
  if (keyword_set(event)) then begin
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME=parent_base_uname)
    WIDGET_CONTROL,Event.top,GET_UVALUE=global_refpix
    top_base = 0L
  endif else begin
    id = widget_info(top_base, find_by_uname=parent_base_uname)
    widget_control, top_base, get_uvalue=global_refpix
  endelse
  parent_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  _base = 0L
  refpix_cursor_info_base_gui, _base, $
    parent_base_geometry
    
  (*global_refpix).refpix_cursor_info_base = _base
  
  WIDGET_CONTROL, _base, /REALIZE
  
  XMANAGER, "refpix_cursor_info_base", _base, GROUP_LEADER = ourGroup, /NO_BLOCK
    
end

