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

pro configure_resolution_function_event, Event
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global_resolution
  global = (*global_resolution).global
  
  case Event.id of
  
    widget_info(event.top, $
      find_by_uname='auto_resolution_function_base_close_button'): begin
      
      ;save new dQ0 and dQ/Q values
      dq0 = getTextfieldvalue(Event,'dq0_uname')
      dq_over_q = getTextfieldvalue(Event,'dq_over_q_uname')
      
      (*global).dq0 = dq0
      (*global).dq_over_q = dq_over_q
      
      id = widget_info(Event.top, $
        find_by_uname='resolution_function_base_uname')
      widget_control, id, /destroy
    end
    
    else:
    
  endcase
  
end

;------------------------------------------------------------------------------
PRO configure_resolution_function_gui, wBase, main_base_geometry, global
  compile_opt idl2
  
  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  spin_state_xsize = 340
  spin_state_ysize = 100
  
  spin_state_xoffset = (main_base_xsize - spin_state_xsize) / 2
  spin_state_xoffset += main_base_xoffset + 110
  
  spin_state_yoffset = (main_base_ysize - spin_state_ysize) / 2
  spin_state_yoffset += main_base_yoffset + 100
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'Resolution Function Configuration',$
    UNAME        = 'resolution_function_base_uname',$
    XOFFSET      = spin_state_xoffset,$
    YOFFSET      = spin_state_yoffset,$
    ;    SCR_YSIZE    = spin_state_ysize,$
    SCR_XSIZE    = spin_state_xsize,$
    MAP          = 1,$
    /BASE_ALIGN_CENTER,$
    /align_center,$
    /column,$
    GROUP_LEADER = ourGroup)
    
  row = widget_base(wBase,$
    /row)
  value = cw_field(row,$
    /floating,$
    /row,$
    value=(*global).dq0,$
    xsize=6,$
    title='dQ0 =',$
    uname='dq0_uname')
  value = cw_field(row,$
    /floating,$
    /row,$
    value=(*global).dq_over_q,$
    xsize=4,$
    title='   dQ/Q =',$
    uname='dq_over_q_uname')
    
  close = widget_button(wBase,$
    value = 'CLOSE',$
    xsize = 150,$
    uname = 'auto_resolution_function_base_close_button')
    
END

;------------------------------------------------------------------------------
PRO configure_resolution_function, Event=event, global=global
  compile_opt idl2
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;build gui
  wBase1 = ''
  configure_resolution_function_gui, wBase1, $
    main_base_geometry, global
    
  WIDGET_CONTROL, wBase1, /REALIZE
  
  global_resolution = PTR_NEW({ wbase: wbase1,$
    global: global, $
    main_event: Event})
    
  WIDGET_CONTROL, wBase1, SET_UVALUE = global_resolution
  
  XMANAGER, "configure_resolution_function", wBase1, $
    GROUP_LEADER = ourGroup, $
    /NO_BLOCK
    
END

