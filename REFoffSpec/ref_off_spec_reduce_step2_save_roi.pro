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

;------------------------------------------------------------------------------
PRO reduce_step2_save_roi, Event, quit_flag=quit_flag

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  path    = (*global).ROI_path
  title   = 'ROI file name'
  file    = getDefaultReduceStep2RoiFileName(event)
  
  LogText = '> Save ROI (default file name: ' + file + ')'
  IDLsendToGeek_addLogBookText, Event, LogText
  LogText = '-> Bring to life ROI file name base.'
  IDLsendToGeek_addLogBookText, Event, LogText
  
  save_roi_base, Event, PATH=path, FILE_NAME=file, quit_flag=quit_flag
  
  nexus_spin_state_roi_table = (*(*global).nexus_spin_state_roi_table)
  data_spin_state = (*global).tmp_reduce_step2_data_spin_state
  row = (*global).tmp_reduce_step2_row
  column = getReduceStep2SpinStateColumn(Event, row=row,$
    data_spin_state=data_spin_state)
    
  ;get Norm file selected
  norm_table = (*global).reduce_step2_big_table_norm_index
  full_file_name = STRCOMPRESS(path,/REMOVE_ALL) + $
    STRCOMPRESS(file,/REMOVE_ALL)
    
  nexus_spin_state_roi_table[column,norm_table[row]] = full_file_name
  (*(*global).nexus_spin_state_roi_table) = nexus_spin_state_roi_table
  
END

;..............................................................................
PRO reduce_step2_save_roi_step2, Event, quit_flag=quit_flag

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  path = (*global).reduce_step2_roi_path
  file = (*global).reduce_step2_roi_file_name
  
  file_name = path + file
  
  create_roi_file, Event, file_name, quit_flag=quit_flag
  
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
  activate_widget, Event, 'reduce_step2_create_roi_save_roi_quit', status
  
END

;------------------------------------------------------------------------------
PRO create_roi_file, Event, roi_file_name, quit_flag=quit_flag

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  instrument = (*global).instrument
  
  ;ON_IOERROR, error
  
  ;get Y1 and Y2
  Y1 = getTextFieldValue(Event,'reduce_step2_create_roi_y1_value')
  Y2 = getTextFieldValue(Event,'reduce_step2_create_roi_y2_value')
  
  ;get integer values
  Y1 = FIX(Y1)
  Y2 = FIX(Y2)
  
  ;get min and max values
  Ymin = MIN([Y1,Y2],MAX=Ymax)
  nbr_y = (Ymax-Ymin+1)
  ;open output file
  no_error = 0
  CATCH, no_error
  IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    message = 'ERROR: The ROI file can not be saved at this location ('
    message += roi_file_name + ')'
    IDLsendToGeek_addLogBookText, Event, message
  ENDIF ELSE BEGIN
    OPENW, 1, roi_file_name
    i     = 0L
    NyMax = 256L
    OutputArray = STRARR((NyMax)*nbr_y)
    
    IF (instrument EQ 'REF_M') THEN BEGIN
    
      FOR y=(Ymin),(Ymax) DO BEGIN
        FOR x=0,(NyMax-1) DO BEGIN
          text  = 'bank1_' + STRCOMPRESS(y,/REMOVE_ALL)
          text += '_' + STRCOMPRESS(x,/REMOVE_ALL)
          PRINTF,1,text
          OutputArray[i] = text
          i++
        ENDFOR
      ENDFOR
      
    ENDIF ELSE BEGIN
    
      FOR x=0,(NyMax-1) DO BEGIN
        FOR y=(Ymin),(Ymax) DO BEGIN
          text  = 'bank1_' + STRCOMPRESS(x,/REMOVE_ALL)
          text += '_' + STRCOMPRESS(y,/REMOVE_ALL)
          PRINTF,1,text
          OutputArray[i] = text
          i++
        ENDFOR
      ENDFOR
    ENDELSE
    
    CLOSE, 1
    FREE_LUN, 1
  ENDELSE ;end of (Ynbr LE 1)
  
  putTextFieldValue, Event, $
    'reduce_step2_create_roi_file_name_label',$
    roi_file_name
    
  ERROR:
  
  IF (quit_flag EQ 'on') THEN BEGIN ;close
    refresh_roi_file_name, event
    reduce_step2_return_to_table, event
  ENDIF
  
END

