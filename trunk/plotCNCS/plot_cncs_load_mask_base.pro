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

FUNCTION getBankTubeRow_from_pixelid, pixelid

  tube_row = getXYfromPixelID(pixelid)
  global_tube = tube_row[0]
  tube = global_tube MOD 8L
  row = tube_row[1]
  bank = pixelid / 1024L
  return, [bank, tube, row]
END

;------------------------------------------------------------------------------
FUNCTION load_mask_file, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_mask
  
  ;get input path
  path = getButtonValue(Event,'load_mask_path_button')
  
  ;get input file name
  file_name = getTextFieldValue(Event,'load_mask_file_name')
  
  ;input file name
  input_file_name = path + file_name
  
  global = (*global_mask).global
  excluded_pixel_array = INTARR(128L * 400L)
  
  error = 0
  ;CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, 0
  ENDIF
  






  
  RETURN, 1
  
END

;------------------------------------------------------------------------------
FUNCTION preview_load_mask_file, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_mask
  
  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, 0
  ENDIF
  
  ;get input path
  path = getButtonValue(Event,'load_mask_path_button')
  
  ;get input file name
  file_name = getTextFieldValue(Event,'load_mask_file_name')
  
  ;input file name
  input_file_name = path + file_name
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='load_mask_base_uname')
  XDISPLAYFILE, input_file_name, $
    GROUP=id, $
    TITLE = 'Preview of ' + input_file_name[0]
    
  RETURN, 1
END

;==============================================================================
;------------------------------------------------------------------------------
PRO load_mask_build_gui_event, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_mask
  
  CASE Event.id OF
  
    ;browse button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='load_mask_browse_button'): BEGIN
      load_mask_browse_button, Event
    END
    
    ;path button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='load_mask_path_button'): BEGIN
      load_mask_path, Event
    END
    
    ;file name widget_text
    WIDGET_INFO(Event.top, FIND_BY_UNAME='load_mask_file_name'): BEGIN
      ;validate_ok button
      check_load_mask_ok_button, Event
    END
    
    ;cancel button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='load_mask_cancel_button'): BEGIN
      id = WIDGET_INFO(Event.top,FIND_BY_UNAME='load_mask_base_uname')
      WIDGET_CONTROL, id, /DESTROY
    END
    
    ;preview button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='preview_load_mask_button'): BEGIN
      result = preview_load_mask_file(Event)
    END
    
    ;load button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='load_mask_ok_button'): BEGIN
      result = load_mask_file(Event)
      IF (result EQ 1) THEN BEGIN
        text = 'File ' + output_file_name + ' has been loaded with success!'
        tmp = DIALOG_MESSAGE(text,$
          /INFORMATION)
      ENDIF ELSE BEGIN
        text = 'Loading of masking file failed!'
        tmp = DIALOG_MESSAGE(text,$
          /ERROR)
      ENDELSE
      id = WIDGET_INFO(Event.top,FIND_BY_UNAME='load_mask_base_uname')
      WIDGET_CONTROL, id, /DESTROY
    END
    
    ELSE:
    
  ENDCASE
  
END

;------------------------------------------------------------------------------
PRO load_mask_browse_button, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_mask
  
  global = (*global_mask).global
  path = (*global).file_path
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='load_mask_base_uname')
  file = DIALOG_PICKFILE(DIALOG_PARENT=id,$
    /READ,$
    PATH = path, $
    GET_PATH = new_path,$
    /OVERWRITE_PROMPT)
    
  IF (file[0] NE '') THEN BEGIN
  
    IF (new_path NE path ) THEN (*global).file_path = new_path
    
    ;file dir
    putButtonValue, Event, 'load_mask_path_button', new_path
    
    ;file name
    file_name = FILE_BASENAME(file[0])
    putTextFieldValue, Event, 'load_mask_file_name', file_name
    
    ;validate_ok button
    check_load_mask_ok_button, Event
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO check_load_mask_ok_button, Event

  ;check that there is a file name
  file_name = getTextFieldValue(Event,'load_mask_file_name')
  file_name = STRCOMPRESS(file_name,/REMOVE_ALL)
  IF (file_name NE '') THEN BEGIN
    status = 1
  ENDIF ELSE BEGIN
    status = 0
  ENDELSE
  activateWidget, Event, 'load_mask_ok_button', status
  activateWidget, Event, 'preview_load_mask_button', status
  
END

;------------------------------------------------------------------------------
PRO load_mask_path, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_mask
  
  global = (*global_mask).global
  path = (*global).file_path
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='load_mask_base_uname')
  new_path = DIALOG_PICKFILE(DIALOG_PARENT=id,$
    PATH = path, $
    /DIRECTORY)
    
  IF (new_path NE '') THEN BEGIN
  
    (*global).file_path = new_path
    
    ;file dir
    putButtonValue, Event, 'load_mask_path_button', new_path
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO load_mask_build_gui, wBase, main_base_geometry, path

  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xoffset = main_base_xoffset + main_base_xsize/2 + 350
  yoffset = main_base_yoffset + main_base_ysize/2 + 100
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'Load Mask',$
    UNAME        = 'load_mask_base_uname',$
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    /BASE_ALIGN_CENTER,$
    GROUP_LEADER = ourGroup,$
    /COLUMN)
    
  ;browse
  browse = WIDGET_BUTTON(wBase,$
    VALUE = 'BROWSE ...',$
    XSIZE = 400,$
    UNAME = 'load_mask_browse_button')
    
  ;or
  or_label = WIDGET_LABEL(wBase,$
    VALUE = 'OR')
    
  ;path
  path = WIDGET_BUTTON(wBase,$
    VALUE = path,$
    XSIZE = 400,$
    UNAME = 'load_mask_path_button')
    
  ;file name row
  rowa = WIDGET_BASE(wBase,$
    /ROW)
    
  label = WIDGET_LABEL(rowa,$
    VALUE = 'File Name:')
    
  text = WIDGET_TEXT(rowa,$
    VALUE = output_file_name,$
    UNAME = 'load_mask_file_name',$
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
    VALUE = ' CANCEL ',$
    UNAME = 'load_mask_cancel_button')
    
  space = WIDGET_LABEL(row2,$
    VALUE = '             ')
    
  preview = WIDGET_BUTTON(row2,$
    VALUE = ' PREVIEW ...  ',$
    UNAME = 'preview_load_mask_button',$
    SENSITIVE = 0)
    
  ok = WIDGET_BUTTON(row2,$
    VALUE = '  LOAD MASKING FILE  ',$
    UNAME = 'load_mask_ok_button',$
    SENSITIVE = 0)
    
  WIDGET_CONTROL, wBase, /REALIZE
  
END

;------------------------------------------------------------------------------
PRO load_mask_base, main_event

  id = WIDGET_INFO(main_event.top, FIND_BY_UNAME='main_plot_base')
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;get global structure
  WIDGET_CONTROL,main_event.top,GET_UVALUE=global
  
  mask_path = (*global).file_path
  
  ;build gui
  wBase = ''
  load_mask_build_gui, wBase, $
    main_base_geometry, $
    mask_path
    
  global_mask = PTR_NEW({ wbase: wbase,$
    global: global,$
    main_event: main_event})
    
  WIDGET_CONTROL, wBase, SET_UVALUE = global_mask
  XMANAGER, "load_mask_build_gui", wBase, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
END
