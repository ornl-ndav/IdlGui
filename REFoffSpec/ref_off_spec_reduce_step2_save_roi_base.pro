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

PRO save_roi_base_event, event

  COMPILE_OPT hidden
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_roi
  
  wWidget =  Event.top            ;widget id
  
  CASE Event.id OF
  
    ;path button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_step2_roi_path_button'): BEGIN
      change_path, Event
    END
    
    ;browse for file name
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='reduce_step2_roi_file_name_browse'): BEGIN
      change_file_name, Event
    END
    
    ;cancel
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='reduce_step2_roi_cancel_button'): BEGIN
      WIDGET_CONTROL, global_roi.ourGroup,/DESTROY
    END
    
    ;save roi
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='reduce_step2_roi_save_roi_ok_button'): BEGIN
      global = global_roi.global
      (*global).reduce_step2_roi_path = $
        getButtonValue(Event,'reduce_step2_roi_path_button')
      (*global).reduce_step2_roi_file_name = $
        getTextfieldValue(Event,'reduce_step2_roi_file_name_text')
      WIDGET_CONTROL, global_roi.ourGroup,/DESTROY
      event = global_roi.event
      quit_flag = global_roi.quit_flag
      reduce_step2_save_roi_step2, Event, quit_flag=quit_flag
    END
    
    ELSE:
    
  ENDCASE
  
END

;------------------------------------------------------------------------------
PRO save_roi_base, Event, path=path, $
    FILE_NAME=file_name, $
    quit_flag=quit_flag
    
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='MAIN_BASE')
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;our_group = widget_base(
  roi_base = WIDGET_BASE(GROUP_LEADER=id,$
    /MODAL,$
    /COLUMN,$
    SCR_XSIZE = 400,$
    frame = 5,$
    title = 'Select name of ROI file name to create')
    
  ;*****************************************
  ;
  ;path label
  label = WIDGET_LABEL(roi_base,$
    VALUE = 'PATH')
    
  ;path button ................. first row ........................
  path_button = WIDGET_BUTTON(roi_base,$
    VALUE = path,$
    UNAME = 'reduce_step2_roi_path_button')
    
  ;row_base .................second row ............................
  row2_base = WIDGET_BASE(roi_base,$
    /ROW)
    
  title = WIDGET_LABEL(row2_base,$
    VALUE = 'File Name:')
    
  ;file name text field
  name = WIDGET_TEXT(row2_base,$
    VALUE = file_name,$
    SCR_XSIZE = 300,$
    /EDITABLE,$
    /ALIGN_LEFT,$
    UNAME = 'reduce_step2_roi_file_name_text')
    
  ;vertical space ...........third row...........................
  space = WIDGET_LABEL(roi_base,$
    VALUE = ' ')
    
  ;label .................fourth row ............................
  label = WIDGET_LABEL(roi_base,$
    VALUE = ' or Browse for a file')
    
  ;browse file name button ............fifth row
  browse = WIDGET_BUTTON(roi_base,$
    VALUE = 'B R O W S E  . . . ',$
    SCR_XSIZE = 390,$
    UNAME = 'reduce_step2_roi_file_name_browse')
    
  ;vertical space ...........6th row...........................
  space = WIDGET_LABEL(roi_base,$
    VALUE = ' ')
    
  ;cancel and ok buttons .............. 7th row ................
  row3 = WIDGET_BASE(roi_base,$
    /ROW)
    
  cancel = WIDGET_BUTTON(row3,$
    VALUE = 'CANCEL',$
    SCR_XSIZE = 120,$
    UNAME = 'reduce_step2_roi_cancel_button')
    
  space = WIDGET_LABEL(row3,$
    VALUE = '                        ')
    
  ok = WIDGET_BUTTON(row3,$
    VALUE = 'SAVE ROI',$
    SCR_XSIZE = 120,$
    UNAME = 'reduce_step2_roi_save_roi_ok_button')
    
  WIDGET_CONTROL, roi_base, /realize
  
  global_roi = { global: global,$
    event: event,$
    quit_flag: quit_flag,$
    ourGroup: roi_base }
    
  WIDGET_CONTROL, roi_base, SET_UVALUE=global_roi
  XMANAGER, "save_roi_base", roi_base,$
    GROUP_LEADER = id
    
END

;-----------------------------------------------------------------------------
PRO change_path, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_roi
  
  ;get path
  path = getButtonValue(Event,'reduce_step2_roi_path_button')
  
  result = DIALOG_PICKFILE(/DIRECTORY,$
    TITLE = 'Select where to write the ROI file',$
    path = path,$
    get_path = new_path,$
    /must_exist)
    
  IF (result NE '') THEN BEGIN
    global = global_roi.global
    (*global).ROI_path = result
    putButtonValue, Event, 'reduce_step2_roi_path_button', result
  ENDIF
  
END

;-----------------------------------------------------------------------------
PRO change_file_name, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_roi
  
  ;get path
  path = getButtonValue(Event,'reduce_step2_roi_path_button')
  
  file = DIALOG_PICKFILE(TITLE = 'Select where to write the ROI file',$
    path = path,$
    get_path = new_path,$
    /must_exist)
    
  IF (file NE '') THEN BEGIN
  
    file_name = FILE_BASENAME(file)
    
    global = global_roi.global
    (*global).ROI_path = new_path
    putButtonValue, Event, 'reduce_step2_roi_path_button', new_path
    putButtonValue, Event, 'reduce_step2_roi_file_name_text', file_name
  ENDIF
  
END
















