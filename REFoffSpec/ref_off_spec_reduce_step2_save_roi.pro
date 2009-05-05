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

PRO reduce_step2_save_roi, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  path    = (*global).ROI_path
  filters = ['*.dat','*.txt']
  title   = 'Select ROI file name'
  file    = getDefaultReduceStep2RoiFileName(event)
  
  LogText = '> Save ROI (default file name: ' + file
  IDLsendToGeek_addLogBookText, Event, LogText
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  
  file = DIALOG_PICKFILE(FILTER = filters,$
    DIALOG_PARENT = id,$
    GET_PATH = new_path,$
    PATH = path,$
    FILE = file,$
    /OVERWRITE_PROMPT,$
    TITLE = title)
    
  IF (file NE '') THEN BEGIN
    IF (new_path NE path) THEN BEGIN
      (*global).ROI_path = new_path
      LogText = '-> User changed ROI path: ' + new_path
      IDLsendToGeek_addLogBookText, Event, LogText
    ENDIF
    LogText = '-> ROI file name: ' + file
  ENDIF ELSE BEGIN
    LogText = '-> User canceled Save ROI.'
    IDLsendToGeek_addLogBookText, Event, LogText
  ENDELSE
  
END

;------------------------------------------------------------------------------
PRO check_reduce_step2_save_roi_validity, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  Y1 = getTextFieldValue(Event,'reduce_step2_create_roi_y1_value')
  Y2 = getTextFieldValue(Event,'reduce_step2_create_roi_y2_value')
  
  IF (STRCOMPRESS(Y1,/REMOVE_ALL) NE '' AND $
    STRCOMPRESS(Y2,/REMOVE_ALL) NE '') THEN BEGIN
    status = 1
  ENDIF ELSE BEGIN
    status = 0
  ENDELSE
  activate_widget, Event, 'reduce_step2_create_roi_save_roi', status
  
END