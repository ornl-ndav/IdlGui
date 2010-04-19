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

pro configure_auto_cleanup_event, Event

  ;get global structure
  widget_control,event.top,get_uvalue=global_spin_state
  global = (*global_spin_state).global
  
  case Event.id of
  
    widget_info(event.top, $
      find_by_uname='auto_cleanup_config_base_close_button'): begin
      
      ;save new auto q percentage value
      value = getTextfieldvalue(Event,'perecentage_of_q_to_remove_uname')
      (*global).percentage_of_q_to_remove_value = value
      
      id = widget_info(Event.top, $
        find_by_uname='auto_cleanup_config_widget_base')
      widget_control, id, /destroy
      event = (*global_spin_state).main_event
    end
    
    else:
    
  endcase
  
end

;------------------------------------------------------------------------------
PRO configure_auto_cleanup_gui, wBase, main_base_geometry

  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  spin_state_xsize = 350
  spin_state_ysize = 75
  
  spin_state_xoffset = (main_base_xsize - spin_state_xsize) / 2
  spin_state_xoffset += main_base_xoffset
  
  spin_state_yoffset = (main_base_ysize - spin_state_ysize) / 2
  spin_state_yoffset += main_base_yoffset
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'Automatic Cleanup Configuration',$
    UNAME        = 'auto_cleanup_config_widget_base',$
    XOFFSET      = spin_state_xoffset,$
    YOFFSET      = spin_state_yoffset,$
    SCR_YSIZE    = spin_state_ysize,$
    SCR_XSIZE    = spin_state_xsize,$
    MAP          = 1,$
    /BASE_ALIGN_CENTER,$
    /align_center,$
    /column,$
    GROUP_LEADER = ourGroup)
    
    row = widget_base(wBase,$
    /row)
    field = cw_field(row,$
    /row,$
    title = 'Percentage of Q to remove on both sides (%) ',$
    value = 10,$
    xsize = 2,$
    /integer,$
    uname = 'perecentage_of_q_to_remove_uname')
    
  close = widget_button(wBase,$
    value = 'CLOSE',$
    xsize = 150,$
    uname = 'auto_cleanup_config_base_close_button')
    
END

;------------------------------------------------------------------------------
PRO configure_auto_cleanup, main_base=main_base, Event=event

  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    id = WIDGET_INFO(main_base, FIND_BY_UNAME='MAIN_BASE')
    WIDGET_CONTROL,main_base,GET_UVALUE=global
    event = 0
  ENDIF ELSE BEGIN
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ENDELSE
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;build gui
  wBase1 = ''
  configure_auto_cleanup_gui, wBase1, $
    main_base_geometry
    
  WIDGET_CONTROL, wBase1, /REALIZE
  
  global_spin_state = PTR_NEW({ wbase: wbase1,$
    global: global, $
    main_event: Event})
    
  WIDGET_CONTROL, wBase1, SET_UVALUE = global_spin_state
  
  XMANAGER, "configure_auto_cleanup", wBase1, GROUP_LEADER = ourGroup, /NO_BLOCK
  
END

