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
;DATA SIDE OF LOAD TAB
PRO REFreduction_CreateDataBackgroundROIFile, Event, type

  WIDGET_CONTROL, event.top, GET_UVALUE=global
  
  if (((*global).reduction_mode) ne 'one_per_selection') then begin
    create_data_roi_for_broad_discrete_mode, event=event
    return
  endif
  
  ;get Ymin and Ymax
  IF (type EQ 'back') THEN BEGIN
    SelectionArray = (*(*global).data_back_selection)
  ENDIF ELSE BEGIN
    SelectionArray = (*(*global).data_roi_selection)
  ENDELSE
  
  IF ((*global).miniVersion) THEN BEGIN
    coeff = 1
  ENDIF ELSE BEGIN
    coeff = 2
  ENDELSE
  
  Ymin = SelectionArray[0]/coeff
  Ymax = SelectionArray[1]/coeff
  YNbr = (Ymax-Ymin)
  
  IF (YNbr LE 1) THEN BEGIN
  
    ;display error message saying that selection is invalid
    Message = '* E R R O R *'
    putLabelValue, Event, 'left_data_interaction_help_message_help', Message
    
    IF (type EQ 'back') THEN BEGIN
      Message = 'Data Background Selection is Invalid !'
    ENDIF ELSE BEGIN
      Message = 'Data ROI Selection is Invalid !'
    ENDELSE
    
    putTextFieldValue, $
      Event, $
      'DATA_left_interaction_help_text',$
      Message, $
      0
      
  ENDIF ELSE BEGIN ;enough Y between Ymax and Ymin to create outpur roi file
  
    ;get name of file to create
    IF (type EQ 'back') THEN BEGIN
      file_name = $
        getTextFieldValue(Event,$
        'data_back_d_selection_file_text_field')
        
    ENDIF ELSE BEGIN
      file_name = $
        getTextFieldValue(Event,$
        'data_roi_selection_file_text_field')
    ENDELSE
    file_name = file_name[0]
    
    IF (~isPathExist(file_name)) THEN BEGIN
      create_path, file_name
    ENDIF
    
    ;display preview message
    ;Message = 'Preview of ' + file_name
    Message = 'Preview of ROI file saved'
    putLabelValue, Event, 'left_data_interaction_help_message_help', Message
    
    ;get instrument
    instrument = (*global).instrument
    
    ;open output file
    no_error = 0
    CATCH, no_error
    IF (no_error NE 0) THEN BEGIN
      CATCH,/CANCEL
      message = 'ERROR: The ROI file can not be saved at this location ('
      message += file_name + ')'
      putLogbookMessage, Event, message, Append=1
      IF (type EQ 'back') THEN BEGIN
        data_message = 'ERROR saving the Data Background File ' + $
          '(check LogBook)'
      ENDIF ELSE BEGIN
        data_message = 'ERROR saving the Data ROI file (check LogBook)'
      ENDELSE
      putDataLogBookMessage, Event, data_message, Append=1
    ENDIF ELSE BEGIN
      OPENW, 1, file_name
      IF (instrument EQ (*global).REF_L) THEN BEGIN ;REF_L
        i     = 0L
        NxMax = (*global).Nx_REF_L
        YNbr  = YNbr+1
        OutputArray = STRARR((NxMax)*YNbr)
        FOR y=(Ymin),(Ymax) DO BEGIN
          FOR x=0,(NxMax-1) DO BEGIN
            text  = 'bank1_' + STRCOMPRESS(x,/REMOVE_ALL)
            text += '_' + STRCOMPRESS(y,/REMOVE_ALL)
            PRINTF,1,text
            OutputArray[i] = text
            i++
          ENDFOR
        ENDFOR
      ENDIF ELSE BEGIN        ;REF_M
        i     = 0L
        NyMax = (*global).Ny_REF_M
        YNbr  = YNbr+1
        OutputArray = STRARR((NyMax)*YNbr)
        (*global).broad_peak_pixel_range = [Ymin,Ymax]
        FOR y=(Ymin),(Ymax) DO BEGIN
          FOR x=0,(NyMax-1) DO BEGIN
            text  = 'bank1_' + STRCOMPRESS(y,/REMOVE_ALL)
            text += '_' + STRCOMPRESS(x,/REMOVE_ALL)
            PRINTF,1,text
            OutputArray[i] = text
            i++
          ENDFOR
        ENDFOR
      ENDELSE                 ;end of (instrument is REF_L)
      CLOSE, 1
      FREE_LUN, 1
      ;display file_name in info box (display x first lines)
      REFreduction_DisplayPreviewOfDataRoiFile, $
        Event, $
        OutputArray, $
        (*global).roi_file_preview_nbr_line
        
      IF (type EQ 'back') THEN BEGIN
        uname = 'data_back_selection_file_value'
      ENDIF ELSE BEGIN
        uname = 'reduce_data_region_of_interest_file_name'
      ENDELSE
      ;copy file name into reduce tab
      putTextFieldValue, Event, uname, file_name,0
      
    ENDELSE
  ENDELSE ;end of (Ynbr LE 1)
END

;------------------------------------------------------------------------------
;NORMALIZATION SIDE OF LOAD TAB
PRO REFreduction_CreateNormBackgroundROIFile, Event, type

  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,GET_UVALUE=global
  
  ;get Ymin and Ymax
  IF (type EQ 'back') THEN BEGIN
    SelectionArray = (*(*global).norm_back_selection)
  ENDIF ELSE BEGIN
    SelectionArray = (*(*global).norm_roi_selection)
  ENDELSE
  
  IF ((*global).miniVersion) THEN BEGIN
    coeff = 1
  ENDIF ELSE BEGIN
    coeff = 2
  ENDELSE
  
  Ymin = SelectionArray[0]/coeff
  Ymax = SelectionArray[1]/coeff
  YNbr = (Ymax-Ymin)
  
  IF (YNbr LE 1) THEN BEGIN
  
    ;display error message saying that selection is invalid
    Message = '* E R R O R *'
    putLabelValue, Event, 'left_normalization_interaction_help_message_help', $
      Message
      
    IF (type EQ 'back') THEN BEGIN
      Message = 'Normalization Background Selection is Invalid !'
    ENDIF ELSE BEGIN
      Message = 'Normalization ROI Selection is Invalid !'
    ENDELSE
    
    putTextFieldValue, $
      Event, $
      'NORM_left_interaction_help_text',$
      Message, $
      0
      
  ENDIF ELSE BEGIN ;enough Y between Ymax and Ymin to create outpur roi file
  
    ;get name of file to create
    IF (type EQ 'back') THEN BEGIN
      file_name = $
        getTextFieldValue(Event,$
        'norm_back_d_selection_file_text_field')
        
    ENDIF ELSE BEGIN
      file_name = $
        getTextFieldValue(Event,$
        'norm_roi_selection_file_text_field')
    ENDELSE
    file_name = file_name[0]
    
    IF (~isPathExist(file_name)) THEN BEGIN
      create_path, file_name
    ENDIF
    
    ;display preview message
    Message = 'Preview of ' + file_name
    putLabelValue, Event, 'left_normalization_interaction_help_message_help', $
      Message
      
    ;get instrument
    instrument = (*global).instrument
    
    ;open output file
    no_error = 0
    CATCH, no_error
    IF (no_error NE 0) THEN BEGIN
      CATCH,/CANCEL
      message = 'ERROR: The ROI file can not be saved at this location ('
      message += file_name + ')'
      putLogbookMessage, Event, message, Append=1
      IF (type EQ 'back') THEN BEGIN
        norm_message = 'ERROR saving the Normalization Background File ' + $
          '(check LogBook)'
      ENDIF ELSE BEGIN
        norm_message = 'ERROR saving the Normalization ROI file (check ' + $
          'LogBook)'
      ENDELSE
      putNormalizationLogBookMessage, Event, norm_message, Append=1
    ENDIF ELSE BEGIN
      OPENW, 1, file_name
      IF (instrument EQ (*global).REF_L) THEN BEGIN ;REF_L
        i     =0L
        NxMax = (*global).Nx_REF_L
        YNbr  = YNbr+1
        OutputArray = STRARR(NxMax*YNbr)
        FOR y=(Ymin),(Ymax) DO BEGIN
          FOR x=0,(NxMax-1) DO BEGIN
            text  = 'bank1_' + STRCOMPRESS(x,/REMOVE_ALL)
            text += '_' + STRCOMPRESS(y,/REMOVE_ALL)
            PRINTF,1,text
            OutputArray[i] = text
            i++
          ENDFOR
        ENDFOR
      ENDIF ELSE BEGIN        ;REF_M
        i     =0L
        NyMax = (*global).Ny_REF_M
        YNbr  = YNbr+1
        OutputArray = STRARR((NyMax)*YNbr)
        FOR y=(Ymin),(Ymax) DO BEGIN
          FOR x=0,(NyMax-1) DO BEGIN
            text  = 'bank1_' + STRCOMPRESS(y,/REMOVE_ALL)
            text += '_' + STRCOMPRESS(x,/REMOVE_ALL)
            PRINTF,1,text
            OutputArray[i] = text
            i++
          ENDFOR
        ENDFOR
      ENDELSE                 ;end of (instrument is REF_L)
      CLOSE, 1
      FREE_LUN, 1
      ;display file_name in info box (display x first lines)
      REFreduction_DisplayPreviewOfNormRoiFile, $
        Event, $
        OutputArray, $
        (*global).roi_file_preview_nbr_line
        
      IF (type EQ 'back') THEN BEGIN
        uname = 'norm_back_selection_file_value'
      ENDIF ELSE BEGIN
        uname = 'reduce_normalization_region_of_interest_file_name'
      ENDELSE
      ;copy file name into reduce tab
      putTextFieldValue, Event, uname, file_name,0
      
    ENDELSE
  ENDELSE                         ;end of (Ynbr LE 1)
END
