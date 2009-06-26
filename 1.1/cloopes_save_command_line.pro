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

PRO save_command_line_event, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  wWidget =  Event.top            ;widget id
  
  CASE Event.id OF
  
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='save_command_line_cancel_button'): BEGIN
      id = WIDGET_INFO(Event.top,FIND_BY_UNAME='save_command_line_base_uname')
      WIDGET_CONTROL, id, /DESTROY
    END
    
    
    ELSE:
    
  ENDCASE
  
  
END

;------------------------------------------------------------------------------
PRO save_command_line_build_gui, wBase, $
    main_base_geometry, $
    output_path = output_path
    
  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  ; xsize = 500
  ; ysize = 300
  xoffset = main_base_xoffset + main_base_xsize/2
  yoffset = main_base_yoffset + main_base_ysize/2
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'Save Command Line ...',$
    UNAME        = 'save_command_line_base_uname',$
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    /BASE_ALIGN_CENTER,$
    GROUP_LEADER = ourGroup,$
    /COLUMN)
    
  ;browse
  browse = WIDGET_BUTTON(wBase,$
    VALUE = 'Browse ...',$
    XSIZE = 400,$
    UNAME = 'save_command_line_browse_button')
    
  ;or
  or_label = WIDGET_LABEL(wBase,$
    VALUE = 'OR')
    
  ;path
  path = WIDGET_BUTTON(wBase,$
    VALUE = output_path,$
    XSIZE = 400,$
    UNAME = 'save_command_line_path_button')
    
  ;file name row
  rowa = WIDGET_BASE(wBase,$
    /ROW)
    
  label = WIDGET_LABEL(rowa,$
    VALUE = 'File Name:')
    
  text = WIDGET_TEXT(rowa,$
    VALUE = output_file_name,$
    UNAME = 'save_command_line_file_name',$
    /EDITABLE,$
    /ALL_EVENTS,$
    XSIZE = 52)
    
  ;space
  space = WIDGET_LABEL(wBase,$
    VALUE = '')
    
  ;cancel and ok buttons
  row2 = WIDGET_BASE(wBase,$
    /ROW)
    
  cancel = WIDGET_BUTTON(row2,$
    VALUE = 'CANCEL',$
    UNAME = 'save_command_line_cancel_button')
    
  space = WIDGET_LABEL(row2,$
    VALUE = '      ')
    
  preview = WIDGET_BUTTON(row2,$
    VALUE = '   PREVIEW   ',$
    UNAME = 'save_command_line_preview_button',$
    SENSITIVE = 0)
    
  space = WIDGET_LABEL(row2,$
    VALUE = '      ')
    
  ok = WIDGET_BUTTON(row2,$
    VALUE = '  CREATE TEMPERATURE FILE  ',$
    UNAME = 'save_temperature_ok_button',$
    SENSITIVE = 1)
    
  WIDGET_CONTROL, wBase, /REALIZE
  
END

;------------------------------------------------------------------------------
PRO save_command_line, main_event, CMD=cmd

  id = WIDGET_INFO(main_event.top, FIND_BY_UNAME='MAIN_BASE')
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;get global structure
  WIDGET_CONTROL,main_event.top,GET_UVALUE=global
  
  ;build gui
  wBase = ''
  save_command_line_build_gui, wBase, $
    main_base_geometry, $
    output_path=(*global).path
    
  global_cl = PTR_NEW({ wbase: wbase,$
    cmd: cmd,$
    main_event: main_event})
    
  WIDGET_CONTROL, wBase, SET_UVALUE = global_cl
  XMANAGER, "save_command_line", wBase, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
END