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

PRO load_temperature_file, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_temperature
  
  path = getButtonValue(Event,'load_temperature_path_button')
  file_name = getTextFieldValue(Event,'load_temperature_file_name')
  s_file_name = STRCOMPRESS(file_name,/REMOVE_ALL)
  full_file_name = path + s_file_name
  
  file_name = full_file_name[0]
  
  ;create array of temperature
  temp_array = STRARR(FILE_LINES(file_name))
  OPENR, u, file_name, /GET_LUN
  READF, u, temp_array
  CLOSE, u
  FREE_LUN, u
  
 ;get global structure
   main_event = (*global_temperature).main_event
  WIDGET_CONTROL,main_event.top,GET_UVALUE=global
  (*(*global).temperature_array) = temp_array

  table = (*global_temperature).table
  
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
  ENDIF ELSE BEGIN
    sz = N_ELEMENTS(temp_array)
    index = 0
    WHILE (index LT sz) DO BEGIN
      table[2,index] = temp_array[index]
      index++
    ENDWHILE
  ENDELSE
  putValue, main_event, 'tab2_table_uname', table
  
END

;------------------------------------------------------------------------------
PRO load_temperature_build_gui_event, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_temperature
  
  CASE Event.id OF
  
    ;browse button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='load_temperature_browse_button'): BEGIN
      load_temperature_browse, Event
    END
    
    ;path button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='load_temperature_path_button'): BEGIN
      load_temperature_path, Event
    END
    
    ;file name widget_text
    WIDGET_INFO(Event.top, FIND_BY_UNAME='load_temperature_file_name'): BEGIN
      ;validate_ok button
      check_load_temperature_ok_button, Event
    END
    
    ;preview button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='load_temperature_preview_button'): BEGIN
      path = getButtonValue(Event,'load_temperature_path_button')
      file_name = getTextFieldValue(Event,'load_temperature_file_name')
      s_file_name = STRCOMPRESS(file_name,/REMOVE_ALL)
      full_file_name = path + s_file_name
      XDISPLAYFILE, full_file_name[0]
    END
    
    ;cancel button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='load_temperature_cancel_button'): BEGIN
      id = WIDGET_INFO(Event.top,FIND_BY_UNAME='load_temperature_base_uname')
      WIDGET_CONTROL, id, /DESTROY
    END
    
    ;load button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='load_temperature_ok_button'): BEGIN
      load_temperature_file, Event
       main_event = (*global_temperature).main_event
      check_load_save_temperature_widgets, main_event
      id = WIDGET_INFO(Event.top,FIND_BY_UNAME='load_temperature_base_uname')
      WIDGET_CONTROL, id, /DESTROY
    END
    
    ELSE:
    
  ENDCASE
  
END

;------------------------------------------------------------------------------
PRO load_temperature_browse, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_temperature
  
  path = (*global_temperature).temperature_path
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='load_temperature_base_uname')
  file = DIALOG_PICKFILE(DIALOG_PARENT=id,$
    PATH = path, $
    TITLE = 'Pick a file to load',$
    GET_PATH = new_path)
    
  IF (file[0] NE '') THEN BEGIN
  
    IF (new_path NE path ) THEN $
      (*global_temperature).temperature_path = new_path
      
    ;file dir
    putButtonValue, Event, 'load_temperature_path_button', new_path
    
    ;file name
    file_name = FILE_BASENAME(file[0])
    putValue, Event, 'load_temperature_file_name', file_name
    
    ;validate_ok button
    check_load_temperature_ok_button, Event
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO check_load_temperature_ok_button, Event

  ;check that there is a file name
  path = getButtonValue(Event,'load_temperature_path_button')
  file_name = getTextFieldValue(Event,'load_temperature_file_name')
  full_file_name = path + STRCOMPRESS(file_name,/REMOVE_ALL)
  IF (STRCOMPRESS(file_name,/REMOVE_ALL) NE '') THEN BEGIN
    IF (FILE_TEST(full_file_name)) THEN BEGIN
      status = 1
    ENDIF ELSE BEGIN
      status = 0
    ENDELSE
  ENDIF ELSE BEGIN
    status = 0
  ENDELSE
  activate_widget, Event, 'load_temperature_ok_button', status
  activate_widget, Event, 'load_temperature_preview_button', status
  
END

;------------------------------------------------------------------------------
PRO load_temperature_path, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_temperature
  
  path = (*global_temperature).temperature_path
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='load_temperature_base_uname')
  new_path = DIALOG_PICKFILE(DIALOG_PARENT=id,$
    PATH = path, $
    /DIRECTORY)
    
  IF (new_path NE '') THEN BEGIN
  
    main_event = (*global_temperature).main_event
    WIDGET_CONTROL,main_event.top,GET_UVALUE=global
    (*global).temperature_path = new_path
    (*global_temperature).temperature_path = new_path
    
    ;file dir
    putButtonValue, Event, 'load_temperature_path_button', new_path
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO load_temperature_build_gui, wBase, $
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
  
  wBase = WIDGET_BASE(TITLE = 'load Temperature Column',$
    UNAME        = 'load_temperature_base_uname',$
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
    UNAME = 'load_temperature_browse_button')
    
  ;or
  or_label = WIDGET_LABEL(wBase,$
    VALUE = 'OR')
    
  ;path
  path = WIDGET_BUTTON(wBase,$
    VALUE = temperature_path,$
    XSIZE = 400,$
    UNAME = 'load_temperature_path_button')
    
  ;file name row
  rowa = WIDGET_BASE(wBase,$
    /ROW)
    
  label = WIDGET_LABEL(rowa,$
    VALUE = 'File Name:')
    
  text = WIDGET_TEXT(rowa,$
    VALUE = output_file_name,$
    UNAME = 'load_temperature_file_name',$
    /EDITABLE,$
    /ALL_EVENTS,$
    XSIZE = 52)
    
  ;space
  space = WIDGET_LABEL(wBase,$
    VALUE = '')
    
  ;preview button
  preview = WIDGET_BUTTON(wBase,$
    VALUE = 'PREVIEW',$
    uname = 'load_temperature_preview_button',$
    SCR_XSIZE = 400,$
    SENSITIVE = 0)
    
  ;space
  space = WIDGET_LABEL(wBase,$
    VALUE = '')
    
  ;cancel and ok buttons
  row2 = WIDGET_BASE(wBase,$
    /ROW)
    
  cancel = WIDGET_BUTTON(row2,$
    VALUE = 'CANCEL',$
    UNAME = 'load_temperature_cancel_button')
    
  space = WIDGET_LABEL(row2,$
    VALUE = '                            ')
    
  ok = WIDGET_BUTTON(row2,$
    VALUE = '  LOAD TEMPERATURE FILE  ',$
    UNAME = 'load_temperature_ok_button',$
    SENSITIVE = 0)
    
  WIDGET_CONTROL, wBase, /REALIZE
  
END

;------------------------------------------------------------------------------
PRO load_temperature_base, main_event

  id = WIDGET_INFO(main_event.top, FIND_BY_UNAME='MAIN_BASE')
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;get global structure
  WIDGET_CONTROL,main_event.top,GET_UVALUE=global
  temperature_path = (*global).temperature_path
  
  table = getTableValue(main_event,'tab2_table_uname')
  nbr_row = (SIZE(table))(2)
  
  ;build gui
  wBase = ''
  load_temperature_build_gui, wBase, $
    main_base_geometry, $
    temperature_path
    
  global_temperature = PTR_NEW({ wbase: wbase,$
    temperature_path: temperature_path,$
    table: table,$
    main_event: main_event})
    
  WIDGET_CONTROL, wBase, SET_UVALUE = global_temperature
  XMANAGER, "load_temperature_build_gui", wBase, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
END
