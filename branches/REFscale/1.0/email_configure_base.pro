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

pro email_configure_base_event, Event

  ;get global structure
  widget_control,event.top,get_uvalue=global_settings
  global = (*global_settings).global
  main_event = (*global_settings).main_event
  
  case Event.id of
  
    widget_info(event.top, $
      find_by_uname='email_configure_base_close_button'): begin
      
      save_status_of_email_configure_button, event
      
      id = widget_info(Event.top, $
        find_by_uname='email_configure_widget_base')
      widget_control, id, /destroy
    end
    
    else:
    
  endcase
  
end

;+
; :Description:
;   This procedure save all the flags when leaving the settings base
;   by using the 'SAVE and CLOSE' button.
;
; :Params:
;    event
;
; :Author: j35
;-
pro save_status_of_email_configure_button, event
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global_settings
  global = (*global_settings).global
  
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
pro email_settings_killed, id
  compile_opt idl2
  
  ;get global structure
  widget_control,id,get_uvalue=global_settings
  global = (*global_settings).global
  main_event = (*global_settings).main_event
  
  id = widget_info(id, $
    find_by_uname='email_configure_widget_base')
  widget_control, id, /destroy
  ;ActivateWidget, main_Event, 'open_settings_base', 1
  
end

;------------------------------------------------------------------------------
PRO email_configure_base_gui, wBase, main_base_geometry, global

  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xsize = 350
  ysize = 130
  
  xoffset = (main_base_xsize - xsize) / 2
  xoffset += main_base_xoffset
  
  yoffset = (main_base_ysize - ysize) / 2
  yoffset += main_base_yoffset
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'EMAIL SETTINGS',$
    UNAME        = 'email_configure_widget_base',$
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    SCR_YSIZE    = ysize,$
    SCR_XSIZE    = xsize,$
    MAP          = 1,$
    kill_notify  = 'email_settings_killed', $
    /BASE_ALIGN_CENTER,$
    /align_center,$
    /column,$
    GROUP_LEADER = ourGroup)
    
  row1 = widget_base(wBase,$
  /row)
  label = widget_label(row1,$
  value = '        email:')
  value = widget_text(row1,$
  value = '',$
  xsize = 40,$
  uname = 'email1',$
  /editable,$
  /align_left)
  
  row2 = widget_base(wBase,$
  /row)
  label = widget_label(row2,$
  value = 'confirm email:')
  value = widget_text(row2,$
  xsize = 40,$
  value = '',$
  uname = 'email2',$
  /editable,$
  /align_left)
    
  ;empty row
  row3 = widget_label(wBase,$
  value = ' ')
    
  close = widget_button(wBase,$
    value = 'SAVE and CLOSE',$
    xsize = 150,$
    uname = 'email_configure_base_close_button')
    
END

;------------------------------------------------------------------------------
PRO email_configure_base, main_base=main_base, Event=event

  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    id = WIDGET_INFO(main_base, FIND_BY_UNAME='MAIN_BASE_ref_scale')
    WIDGET_CONTROL,main_base,GET_UVALUE=global
    event = 0
  ENDIF ELSE BEGIN
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ENDELSE
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;build gui
  wBase1 = ''
  email_configure_base_gui, wBase1, $
    main_base_geometry, global
    
  WIDGET_CONTROL, wBase1, /REALIZE
  
  global_settings = PTR_NEW({ wbase: wbase1,$
    global: global, $
    main_event: Event})
    
  WIDGET_CONTROL, wBase1, SET_UVALUE = global_settings
  
  XMANAGER, "email_configure_base", wBase1, GROUP_LEADER = ourGroup, /NO_BLOCK
  
END

