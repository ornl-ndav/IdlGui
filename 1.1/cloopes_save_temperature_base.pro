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

PRO save_temperature_build_gui_event, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_temperature
  
  CASE Event.id OF
  
    ;browse button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='save_temperature_browse_button'): BEGIN
      save_temperature_browse, Event
    END
    
    ;path button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='save_temperature_path_button'): BEGIN
      save_temperature_path, Event
    END
    
    ;cancel button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='save_temperature_cancel_button'): BEGIN
      id = WIDGET_INFO(Event.top,FIND_BY_UNAME='save_temperature_base_uname')
      WIDGET_CONTROL, id, /DESTROY
    END
    
    ELSE:
    
  ENDCASE
  
END

;------------------------------------------------------------------------------
PRO save_temperature_browse, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_temperature
  
  path = (*global_temperature).temperature_path
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='save_temperature_base_uname')
  file = DIALOG_PICKFILE(DIALOG_PARENT=id,$
    /WRITE,$
    PATH = path, $
    GET_PATH = new_path,$
    /OVERWRITE_PROMPT)
    
  IF (file[0] NE '') THEN BEGIN
  
    IF (new_path NE path ) THEN $
      (*global_temperature).temperature_path = new_path
      
    ;file dir
    putButtonValue, Event, 'save_temperature_path_button', new_path
    
    ;file name
    file_name = FILE_BASENAME(file[0])
    putValue, Event, 'save_temperature_file_name', file_name
    
    ;validate_ok button
    check_save_temperature_ok_button, Event
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO check_save_temperature_ok_button, Event

  ;check that there is a file name
  file_name = getTextFieldValue(Event,'save_temperature_file_name')
  file_name = STRCOMPRESS(file_name,/REMOVE_ALL)
  IF (file_name NE '') THEN BEGIN
    status = 1
  ENDIF ELSE BEGIN
    status = 0
  ENDELSE
  activate_widget, Event, 'save_temperature_ok_button', status
  
END

;------------------------------------------------------------------------------
PRO save_temperature_path, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_temperature
  
  path = (*global_temperature).temperature_path
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='save_temperature_base_uname')
  new_path = DIALOG_PICKFILE(DIALOG_PARENT=id,$
    PATH = path, $
    /DIRECTORY)
    
  IF (new_path NE '') THEN BEGIN
  
    main_event = (*global_temperature).main_event
    WIDGET_CONTROL,main_event.top,GET_UVALUE=global
    (*global).temperature_path = new_path
    (*global_temperature).temperature_path = new_path
    
    ;file dir
    putButtonValue, Event, 'save_temperature_path_button', new_path
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO save_temperature_build_gui, wBase, $
    main_base_geometry, $
    temperature_path, $
    output_file_name
    
  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  ; xsize = 500
  ; ysize = 300
  xoffset = main_base_xoffset + main_base_xsize/2
  yoffset = main_base_yoffset + main_base_ysize/2
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'Save Temperature Column',$
    UNAME        = 'save_temperature_base_uname',$
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    ;    SCR_XSIZE = 300,$
    ;    SCR_YSIZE = 200,$
    MAP          = 1,$
    /BASE_ALIGN_CENTER,$
    GROUP_LEADER = ourGroup,$
    /COLUMN)
    
  ;browse
  browse = WIDGET_BUTTON(wBase,$
    VALUE = 'Browse ...',$
    XSIZE = 400,$
    UNAME = 'save_temperature_browse_button')
    
  ;or
  or_label = WIDGET_LABEL(wBase,$
    VALUE = 'OR')
    
  ;path
  path = WIDGET_BUTTON(wBase,$
    VALUE = temperature_path,$
    XSIZE = 400,$
    UNAME = 'save_temperature_path_button')
    
  ;file name
  file_name = CW_FIELD(wBase,$
    VALUE = output_file_name,$
    UNAME = 'save_temperature_file_name',$
    XSIZE = 52,$
    TITLE = 'File Name:')
    
  ;space
  space = WIDGET_LABEL(wBase,$
    VALUE = '')
    
  ;cancel and ok buttons
  row2 = WIDGET_BASE(wBase,$
    /ROW)
    
  cancel = WIDGET_BUTTON(row2,$
    VALUE = 'CANCEL',$
    UNAME = 'save_temperature_cancel_button')
    
  space = WIDGET_LABEL(row2,$
    VALUE = '                            ')
    
  ok = WIDGET_BUTTON(row2,$
    VALUE = '  CREATE TEMPERATURE FILE  ',$
    UNAME = 'save_temperature_ok_button',$
    SENSITIVE = 0)
    
  WIDGET_CONTROL, wBase, /REALIZE
  
END

;------------------------------------------------------------------------------
PRO save_temperature_base, main_event

  id = WIDGET_INFO(main_event.top, FIND_BY_UNAME='MAIN_BASE')
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;get global structure
  WIDGET_CONTROL,main_event.top,GET_UVALUE=global
  temperature_path = (*global).temperature_path
  
  ;determine default output file name for file
  table = getTableValue(main_event,'tab2_table_uname')
  nbr_row = (SIZE(table))(2)
  Tmin = STRING(table[2,0],format='(f10.1)')
  Tmax = STRING(table[2,nbr_row-1],format='(f10.1)')
  sTmin = STRCOMPRESS(Tmin,/REMOVE_ALL)
  sTmax = STRCOMPRESS(Tmax,/REMOVE_ALL)
  output_file_name = 'cloopes_temp_from_' + sTmin + '_to_ + sTmax + '.txt'
  
  ;build gui
  wBase = ''
  save_temperature_build_gui, wBase, $
    main_base_geometry, $
    temperature_path, $
    output_file_name
    
  global_temperature = PTR_NEW({ wbase: wbase,$
    temperature_path: temperature_path,$
    main_event:       main_event})
    
  WIDGET_CONTROL, wBase, SET_UVALUE = global_temperature
  XMANAGER, "save_temperature_build_gui", wBase, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
  DEVICE, DECOMPOSED = 0
  loadct, 5, /SILENT
  
END