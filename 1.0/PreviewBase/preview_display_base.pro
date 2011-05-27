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
  global = (*global_info).global
  
  case Event.id of
  
    ;cancel tof selected
    widget_info(event.top, $
      find_by_uname='cancel_discrete_selection_selected_uname'): begin
      widget_control, event.top, get_uvalue=global_preview
      top_base = (*global_preview).top_base
      widget_control, top_base, /destroy
    end
    
    else:
    
  endcase
  
end

;+
; :Description:
;    Builds the GUI of the preview display
;
; :Params:
;    wBase
;    parent_base_geometry
;
;
;
; :Author: j35
;-
pro preview_display_base_gui, wBase, $
    parent_base_geometry
  compile_opt idl2
  
  main_base_xoffset = parent_base_geometry.xoffset
  main_base_yoffset = parent_base_geometry.yoffset
  main_base_xsize = parent_base_geometry.xsize
  main_base_ysize = parent_base_geometry.ysize
  
  xoffset = main_base_xsize
  xoffset += main_base_xoffset
  
  yoffset = main_base_yoffset
  
  ourGroup = WIDGET_BASE()
  
  title = 'Discrete peaks selection'
  wBase = WIDGET_BASE(TITLE = title, $
    UNAME        = 'discrete_peak_selection_base', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    kill_notify  = 'discrete_peak_selection_base_killed', $
    /column,$
    /tlb_size_events,$
    GROUP_LEADER = ourGroup)
    
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
  
  widget_control, tlb, get_uvalue=global_preview, /no_copy
  
  if (n_elements(global_preview) eq 0) then return
  
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
  
  _base = 0L
  preview_display_base_gui, _base, $
    parent_base_geometry
    
  (*global).preview_display_base_id = _base
  
  WIDGET_CONTROL, _base, /REALIZE
  
  global_preview = PTR_NEW({ _base: _base,$
    top_base: top_base, $
    global: global })
    
  WIDGET_CONTROL, _base, SET_UVALUE = global_preview
  
  XMANAGER, "preview_display_base", $
    _base, GROUP_LEADER = ourGroup, $
    /NO_BLOCK, $
    cleanup='preview_display_base_cleanup'
    
end

