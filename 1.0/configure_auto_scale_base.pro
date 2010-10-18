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

pro configure_auto_scale_base_event, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_config
  global = (*global_config).global
  
  case event.id of
  
    ;cancel button
    widget_info(event.top, find_by_uname='config_cancel_uname'): begin
    id = widget_info(event.top, find_by_uname = 'config_base')
    widget_control, id, /destroy
    end
    
    ;ok button
    widget_info(event.top, find_by_uname='config_ok_uname'): begin
    new_value = getValue(event=event, 'config_top_bottom_pixel')
    (*global).top_bottom_exclusion_percentage = new_value
    id = widget_info(event.top, find_by_uname = 'config_base')
    widget_control, id, /destroy
    end
    
    ;pixel top and bottom percentage
    widget_info(event.top, find_by_uname='config_top_bottom_pixel'): begin
    new_value = getValue(event=event, 'config_top_bottom_pixel')
    (*global).top_bottom_exclusion_percentage = new_value
    id = widget_info(event.top, find_by_uname = 'config_base')
    widget_control, id, /destroy
    end
    
    else:
    
  endcase
  
end

pro configure_auto_scale_base_gui, _base, $
    global, $
    main_base_geometry, $
    id_main_base = id_main_base
  compile_opt idl2
  
  _xoffset = main_base_geometry.xoffset
  _yoffset = main_base_geometry.yoffset
  _xsize = main_base_geometry.scr_xsize
  _ysize = main_base_geometry.scr_ysize
  
  xoffset = _xoffset + _xsize/2
  yoffset = _yoffset + _ysize/2
  
  ourGroup = widget_base()
  _base = widget_base(group_leader = ourGroup,$
    /modal,$
    xoffset = xoffset,$
    yoffset = yoffset,$
    /align_left,$
    uname = 'config_base',$
    title = 'Configuration',$
    /column)
    
  ;range of pixels to exclude from top and bottom
  value = cw_field(_base,$
    value = (*global).top_bottom_exclusion_percentage,$
    /return_events,$
    /integer,$
    uname = 'config_top_bottom_pixel',$
    xsize = 3,$
    /row,$
    title = 'Percentage of bottom and top pixels to remove from automatic calculation ' + $
    'of scaling factor:')
    
  ;row2
  row2 = widget_base(_base,$
    /row,$
    /align_center)
  cancel = widget_button(row2,$
    value = 'CANCEL',$
    scr_xsize = 150,$
    uname = 'config_cancel_uname')
  space = widget_label(row2,$
    value = '     ')
  ok = widget_button(row2,$
    value = 'OK',$
    scr_xsize = 150,$
    uname = 'config_ok_uname')
    
end


pro configure_auto_scale_base, event
  compile_opt idl2
  
  id = widget_info(event.top, find_by_uname='main_base')
  widget_control, event.top, get_uvalue=global
  main_base_geometry = widget_info(id,/geometry)
  
  configure_auto_scale_base_gui, _base, $
    global, $
    main_base_geometry, $
    id_main_base = id
    
  global_config = ptr_new({global:global})
  
  widget_control, _base, set_uvalue=global_config
  widget_control, _base, /realize
  xmanager, "configure_auto_scale_base", _base, /no_block
  
  
  
end