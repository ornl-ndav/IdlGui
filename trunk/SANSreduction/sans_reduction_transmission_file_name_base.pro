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

PRO transmission_file_name_base_event, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  CASE Event.id OF
  
    ;CANCEL button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='trans_file_name_base_cancel'): BEGIN
      id = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='transmission_file_name_base')
      WIDGET_CONTROL, id, /DESTROY
    END
    
    ;Browse button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='trans_file_name_base_browse_button'): BEGIN
      trans_file_name_base_browse_file_name, Event
      check_validity_of_trans_file_name_go_button, Event
    END
    
    ;Browse path button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='trans_file_name_base_path_button'): BEGIN
      trans_file_name_base_path_file_name, Event
    END
    
    ;file name text fiedl
    WIDGET_INFO(Event.top, FIND_BY_UNAME='trans_file_name_base_file_name'): BEGIN
      check_validity_of_trans_file_name_go_button, Event
    END
    
    ELSE:
    
  ENDCASE
  
END

;------------------------------------------------------------------------------
PRO transmission_file_name_base_gui, wBase, main_base_geometry, output_path

  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xsize = 400
  ysize = 300
  
  xoffset = main_base_xoffset + main_base_xsize/2 - xsize/2
  yoffset = main_base_yoffset + main_base_ysize/2 - ysize/2
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'Transmission File Name:',$
    UNAME        = 'transmission_file_name_base',$
    XOFFSET      = xoffset, $
    YOFFSET      = yoffset, $
    MAP          = 1, $
    /COLUMN, $
    /BASE_ALIGN_CENTER, $
    GROUP_LEADER = ourGroup)
    
  browse = WIDGET_BUTTON(wBase,$
    VALUE = 'BROWSE ...',$
    SCR_XSIZE = 390,$
    UNAME = 'trans_file_name_base_browse_button',$
    TOOLTIP = 'Select a file to overwrite with the new transmission file')
    
  or_label = WIDGET_LABEL(wBase,$
    VALUE = 'OR')
    
  path = WIDGET_BUTTON(wBase,$
    VALUE = output_path,$
    SCR_XSIZE = 390,$
    UNAME = 'trans_file_name_base_path_button',$
    TOOLTIP = 'Select the destination of the transmission file')
    
  row = WIDGET_BASE(wBase,$
    /ROW)
    
  label = WIDGET_LABEL(row,$
    VALUE = 'File Name:')
    
  text = WIDGET_TEXT(row,$
    VALUE = 'N/A',$
    UNAME = 'trans_file_name_base_file_name',$
    /EDITABLE, $
    /ALL_EVENTS, $
    XSIZE = 50)
    
  row2 = WIDGET_BASE(wBase,$
    /ROW)
    
  xsize = 120
  cancel = WIDGET_BUTTON(row2,$
    SCR_XSIZE = xsize,$
    VALUE = 'CANCEL',$
    UNAME = 'trans_file_name_base_cancel')
    
  preview = WIDGET_BUTTON(row2,$
    SCR_XSIZE = xsize,$
    VALUE = 'PREVIEW...',$
    UNAME = 'trans_file_name_base_preview')
    
  OK = WIDGET_BUTTON(row2,$
    SCR_XSIZE = xsize,$
    VALUE = 'CREATE FILE',$
    UNAME = 'trans_file_name_base_ok_button',$
    SENSITIVE = 0)
    
END

;------------------------------------------------------------------------------
PRO trans_file_name_base_browse_file_name, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  main_global = (*global).main_global
  
  title     = 'Select a file to overwrite'
  path      = (*main_global).output_path
  file_name = DIALOG_PICKFILE(GET_PATH = new_path,$
    PATH = path,$
    TITLE = title,$
    /MUST_EXIST)
  IF (file_name[0] NE '') THEN BEGIN
  
    (*main_global).output_path = new_path
    
    file_name = file_name[0]
    file_basename = FILE_BASENAME(file_name)
    putTextFieldValue, Event, 'trans_file_name_base_file_name', file_basename
    putNewButtonValue, Event, 'trans_file_name_base_path_button', new_path
    
    (*global).main_global = main_global
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO trans_file_name_base_path_file_name, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  main_global = (*global).main_global
  
  title     = 'Select where you want to create the transmission file'
  path      = (*main_global).output_path
  path = DIALOG_PICKFILE(/DIRECTORY, $
    PATH = path,$
    TITLE = title,$
    /MUST_EXIST)
    
  IF (path[0] NE '') THEN BEGIN
  
    (*main_global).output_path = path[0]
    putNewButtonValue, Event, 'trans_file_name_base_path_button', path[0]
    (*global).main_global = main_global
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO check_validity_of_trans_file_name_go_button, Event

  file_name = getTextFieldValue(Event, 'trans_file_name_base_file_name')
  s_file_name = STRCOMPRESS(file_name,/REMOVE_ALL)
  
  IF (s_file_name EQ '' OR $
    s_file_name EQ 'N/A') THEN BEGIN
    status = 0
  ENDIF ELSE BEGIN
    status = 1
  ENDELSE
  activate_widget, Event, 'trans_file_name_base_ok_button', status
  
END

;------------------------------------------------------------------------------
PRO  transmission_file_name_base, Event, MAIN_GLOBAL=main_global

  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='transmission_manual_mode_base')
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;build gui
  wBase1 = ''
  output_path = (*main_global).output_path
  transmission_file_name_base_gui, wBase1, main_base_geometry, output_path
  
  WIDGET_CONTROL, wBase1, /REALIZE
  
  global = PTR_NEW({ wbase: wbase1,$
    main_global: main_global})
    
  WIDGET_CONTROL, wBase1, SET_UVALUE = global
  
  XMANAGER, "transmission_file_name_base", wBase1, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
END
