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

;this function repopulates (updates) the Plots droplist
PRO putPlotsDropListContain, event, ContainTextArray
  id = widget_info(Event.top,find_by_uname='plots_droplist')
  widget_control, id, set_value=ContainTextArray
END

;------------------------------------------------------------------------------
;set the value of the specified uname with text
PRO putTextFieldValue, event, uname, text, append
  TextFieldId = widget_info(Event.top,find_by_uname=uname)
  if (N_ELEMENTS(append) NE 0) then begin
    IF (append) THEN BEGIN
      widget_control, TextFieldId, set_value=text,/append
    endif else begin
      widget_control, TextFieldId, set_value=text
    endelse
  ENDIF ELSE BEGIN
    widget_control, TextFieldId, set_value=text
  ENDELSE
END

pro putValue, event=event, uname, value
putTextFieldValue, event, uname, value
end

;------------------------------------------------------------------------------
;Put the contain of the string array in the specified text field
PRO putTextFieldArray, Event, uname, array, NbrToDisplay, iteration
  if (iteration EQ 0) then begin  ;no append
    putTextFieldValue, Event, uname, array[0],0
    if (NbrToDisplay LE (size(array))(1)) then begin
      NbrLines = NbrToDisplay
    endif else begin
      NbrLines = (size(array))(1)
    endelse
    if (NbrLines GT 1) then begin
      for k=1,(NbrLines-1) do begin
        putTextFieldValue, Event, uname,array[k],1
      endfor
    endif
  endif else begin
    if (NbrToDisplay LE (size(array))(1)) then begin
      NbrLines = NbrToDisplay
    endif else begin
      NbrLines = (size(array))(1)
    endelse
    if (NbrLines GT 1) then begin
      for k=0,(NbrLines-1) do begin
        putTextFieldValue, Event, uname,array[k],1
      endfor
    endif
  endelse
END

;------------------------------------------------------------------------------
;set the value of the widget_label
PRO putLabelValue, Event, uname, value
  id = widget_info(Event.top,find_by_uname=uname)
  widget_control, id, set_value= value
END

;------------------------------------------------------------------------------
;display message in Main Log Book (default is to not append the new message)
PRO putLogBookMessage, Event, LogBookText, Append=Append
  if (n_elements(Append) EQ 0) then begin
    Append = 0
  endif else begin
    Append = 1
  endelse
  putTextFieldValue, Event, 'log_book_text_field', LogBookText, append
END

;------------------------------------------------------------------------------
;display message in Data Log Book (default is to not append the new text)
PRO putDataLogBookMessage, Event, DataLogBookText, Append=Append
  if (n_elements(append) EQ 0) then begin
    Append = 0
  endif else begin
    Append = 1
  endelse
  putTextFieldValue, Event, $
    'data_log_book_text_field', $
    DataLogBookText, $
    append
END

;------------------------------------------------------------------------------
;display message in Normalization Log Book (default is to not append
;the new text
PRO putNormalizationLogBookMessage, Event, $
    NormalizationLogBookText, $
    Append=Append
  if (n_elements(append) EQ 0) then begin
    Append = 0
  endif else begin
    Append = 1
  endelse
  putTextFieldValue, $
    Event, $
    'normalization_log_book_text_field', $
    NormalizationLogBookText, $
    append
END

;------------------------------------------------------------------------------
;Add the given message at the end of the last string array element and
;put it back in the LogBook text field given
;If the optional RemoveString is present, the given String will be
;removed before adding the new MessageToAdd
PRO putTextAtEndOfLogBookLastLine, Event, $
    InitialStrarr, $
    MessageToAdd, $
    RemoveString
    
  ;get size of InitialStrarr
  ArrSize = (size(InitialStrarr))(1)
  if (n_elements(RemoveString) EQ 0) then begin
    ;do not remove anything from last line
    if (ArrSize GE 2) then begin
      NewLastLine = InitialStrarr[ArrSize-1] + MessageToAdd
      FinalStrarr = [InitialStrarr[0:ArrSize-2],NewLastLine]
    endif else begin
      FinalStrarr = InitialStrarr + MessageToAdd
    endelse
  endif else begin ;remove given string from last line
    if (ArrSize GE 2) then begin
      NewLastLine = removeStringFromText(InitialStrarr[ArrSize-1], $
        RemoveString)
      NewLastLine += MessageToAdd
      FinalStrarr = [InitialStrarr[0:ArrSize-2],NewLastLine]
    endif else begin
      NewInitialStrarr = removeStringFromText(InitialStrarr,RemoveString)
      FinalStrarr = NewInitialStrarr + MessageToAdd
    endelse
  endelse
  
  ;put it back in uname text field
  putLogBookMessage, Event, FinalStrarr
END

;------------------------------------------------------------------------------
PRO AppendReplaceLogBookMessage, Event, MessageToAdd, RemoveString
  InitialStrarr = getLogBookText(Event)
  ;get size of InitialStrarr
  ArrSize = (size(InitialStrarr))(1)
  if (n_elements(RemoveString) EQ 0) then begin
    ;do not remove anything from last line
    if (ArrSize GE 2) then begin
      NewLastLine = InitialStrarr[ArrSize-1] + MessageToAdd
      FinalStrarr = [InitialStrarr[0:ArrSize-2],NewLastLine]
    endif else begin
      FinalStrarr = InitialStrarr + MessageToAdd
    endelse
  endif else begin ;remove given string from last line
    if (ArrSize GE 2) then begin
      NewLastLine = removeStringFromText(InitialStrarr[ArrSize-1], $
        RemoveString)
      NewLastLine += MessageToAdd
      FinalStrarr = [InitialStrarr[0:ArrSize-2],NewLastLine]
    endif else begin
      NewInitialStrarr = removeStringFromText(InitialStrarr,RemoveString)
      FinalStrarr = NewInitialStrarr + MessageToAdd
    endelse
  endelse
  ;put it back in uname text field
  putLogBookMessage, Event, FinalStrarr
END

;------------------------------------------------------------------------------
;Add the given message at the end of the last string array element and
;put it back in the DataLogBook text field given
PRO putTextAtEndOfDataLogBookLastLine, Event, $
    InitialStrarr, $
    MessageToAdd, $
    RemoveString
  ;get size of InitialStrarr
  ArrSize = (size(InitialStrarr))(1)
  if (n_elements(RemoveString) EQ 0) then begin
    ;do not remove anything from last line
    if (ArrSize GE 2) then begin
      NewLastLine = InitialStrarr[ArrSize-1] + MessageToAdd
      FinalStrarr = [InitialStrarr[0:ArrSize-2],NewLastLine]
    endif else begin
      FinalStrarr = InitialStrarr + MessageToAdd
    endelse
  endif else begin ;remove given string from last line
    if (ArrSize GE 2) then begin
      NewLastLine = removeStringFromText(InitialStrarr[ArrSize-1], $
        RemoveString)
      NewLastLine += MessageToAdd
      FinalStrarr = [InitialStrarr[0:ArrSize-2],NewLastLine]
    endif else begin
      NewInitialStrarr = removeStringFromText(InitialStrarr,RemoveString)
      FinalStrarr = NewInitialStrarr + MessageToAdd
    endelse
  endelse
  ;put it back in uname text field
  putDataLogBookMessage, Event, FinalStrarr
END

;------------------------------------------------------------------------------
;Add the given message at the end of the last string array element and
;put it back in the NormalizationLogBook text field given
PRO putTextAtEndOfNormalizationLogBookLastLine, $
    Event, $
    InitialStrarr, $
    MessageToAdd, $
    RemoveString
  ;get size of InitialStrarr
  ArrSize = (size(InitialStrarr))(1)
  if (n_elements(RemoveString) EQ 0) then begin
    ;do not remove anything from last line
    if (ArrSize GE 2) then begin
      NewLastLine = InitialStrarr[ArrSize-1] + MessageToAdd
      FinalStrarr = [InitialStrarr[0:ArrSize-2],NewLastLine]
    endif else begin
      FinalStrarr = InitialStrarr + MessageToAdd
    endelse
  endif else begin ;remove given string from last line
    if (ArrSize GE 2) then begin
      NewLastLine = removeStringFromText(InitialStrarr[ArrSize-1], $
        RemoveString)
      NewLastLine += MessageToAdd
      FinalStrarr = [InitialStrarr[0:ArrSize-2],NewLastLine]
    endif else begin
      NewInitialStrarr = removeStringFromText(InitialStrarr,RemoveString)
      FinalStrarr = NewInitialStrarr + MessageToAdd
    endelse
  endelse
  ;put it back in uname text field
  putNormalizationLogBookMessage, Event, FinalStrarr
END

;------------------------------------------------------------------------------
;This function put an integer in his cw_fields
PRO putCWFieldValue, Event, Uname, value
  id = widget_info(Event.top,find_by_uname=uname)
  widget_control, id, set_value=value
END

;------------------------------------------------------------------------------
;Put all the peak and background Ymin and Ymax values in their
;respective cw_fields for DATA
PRO putDataBackgroundPeakYMinMaxValueInTextFields, Event
  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,GET_UVALUE=global
  
  xsize_1d_draw = (*global).xsize_1d_draw
  
  IF ((*global).miniVersion) THEN BEGIN
    coeff = 1
  ENDIF ELSE BEGIN
    coeff = 2
  ENDELSE
  
  ;get ROI Ymin, Ymax ===========================================================
  ROISelection = (*(*global).data_roi_selection)
  ValidateSaveButton = 0
  ;check all cases (-1,-1) (-1,value) (value,-1) and (value,value)
  CASE (ROISelection[0]) OF
    -1:begin
    case (ROISelection[1]) OF
      -1:                 ;do nothing
      else: begin
        Ymax = ROISelection[1]
        if (Ymax LT 1) then Ymax = 0
        if (Ymax GT xsize_1d_draw) then Ymax = (xsize_1d_draw)-1
        putCWFieldValue, event, $
          'data_d_selection_roi_ymax_cw_field', Ymax/coeff
      end
    endcase
  end
  else: begin
    case (ROISelection[1]) OF
      -1: begin
        Ymin = ROISelection[0]
        if (Ymin LT 1) then Ymin = 0
        if (Ymin GT xsize_1d_draw) then Ymin = (xsize_1d_draw)-1
        putCWFieldValue, event, $
          'data_d_selection_roi_ymin_cw_field', Ymin/coeff
      end
      else: begin
        Ymin = Min(ROISelection,max=Ymax)
        (*(*global).data_roi_selection) = [Ymin,Ymax]
        if (Ymin LT 1) then Ymin = 0
        if (Ymin GT xsize_1d_draw) then Ymin = (xsize_1d_draw)-1
        putCWFieldValue, $
          event, $
          'data_d_selection_roi_ymin_cw_field', $
          Ymin/coeff
        if (Ymax LT 1) then Ymax = 0
        if (Ymax GT xsize_1d_draw) then Ymax = (xsize_1d_draw)-1
        putCWFieldValue, $
          event, $
          'data_d_selection_roi_ymax_cw_field', $
          Ymax/coeff
        ValidateSaveButton = 1 ;enable SAVE button
      end
    endcase
  end
endcase

ActivateWidget, Event, 'data_roi_save_button', ValidateSaveButton
ActivateWidget, Event, 'data_roi_selection_file_text_field', $
  ValidateSaveButton
  
;;get Background Ymin, Ymax ====================================================
;BackSelection = (*(*global).data_back_selection)
;ValidateSaveButton = 0
;;check all cases (-1,-1) (-1,value) (value,-1) and (value,value)
;CASE (BackSelection[0]) OF
;  -1: begin
;    case (BackSelection[1]) OF
;      -1: ;do nothing
;      else: begin
;        Ymax = BackSelection[1]
;        if (Ymax LT 1) then Ymax = 0
;        if (Ymax GT xsize_1d_draw) then Ymax = (xsize_1d_draw)-1
;        putCWFieldValue, event, $
;          'data_d_selection_background_ymax_cw_field', Ymax/coeff
;      end
;    endcase
;  end
;  else: begin
;    case (BackSelection[1]) OF
;      -1: begin
;        Ymin = BackSelection[0]
;        if (Ymin LT 1) then Ymin = 0
;        if (Ymin GT xsize_1d_draw) then Ymin = (xsize_1d_draw)-1
;        putCWFieldValue, event, $
;          'data_d_selection_background_ymin_cw_field', Ymin/coeff
;      end
;      else: begin
;        Ymin = Min(BackSelection,max=Ymax)
;        (*(*global).data_back_selection) = [Ymin,Ymax]
;        if (Ymin LT 1) then Ymin = 0
;        if (Ymin GT xsize_1d_draw) then Ymin = (xsize_1d_draw)-1
;        putCWFieldValue, $
;          event, $
;          'data_d_selection_background_ymin_cw_field', $
;          Ymin/coeff
;        if (Ymax LT 1) then Ymax = 0
;        if (Ymax GT xsize_1d_draw) then Ymax = (xsize_1d_draw)-1
;        putCWFieldValue, $
;          event, $
;          'data_d_selection_background_ymax_cw_field', $
;          Ymax/coeff
;        ValidateSaveButton = 1 ;enable SAVE button
;      end
;    endcase
;  end
;endcase
;
;ActivateWidget, Event, 'data_back_save_button', ValidateSaveButton
;ActivateWidget, Event, 'data_back_d_selection_file_text_field', $
;  ValidateSaveButton
  
;get Peak Ymin and Ymax =======================================================
PeakSelection = (*(*global).data_peak_selection)
;check all cases -1,-1 and -1,value value,-1 and value,value
CASE (PeakSelection[0]) OF
  -1:begin
  case (PeakSelection[1]) OF
    -1: ;do nothing
    else: begin
      Ymax = PeakSelection[1]
      if (Ymax LT 1) then Ymax = 0
      if (Ymax GT xsize_1d_draw) then Ymax = (xsize_1d_draw)-1
      putCWFieldValue, event, $
        'data_d_selection_peak_ymax_cw_field', $
        Ymax/coeff
    end
  endcase
end
else: begin
  case (PeakSelection[1]) OF
    -1: begin
      Ymin = PeakSelection[0]
      if (Ymin LT 1) then Ymin = 0
      if (Ymin GT xsize_1d_draw) then Ymin = (xsize_1d_draw)-1
      putCWFieldValue, event, $
        'data_d_selection_peak_ymin_cw_field', $
        Ymin/coeff
        
    end
    else: begin
      Ymin = Min(PeakSelection,max=Ymax)
      (*(*global).data_peak_selection) = [Ymin,Ymax]
      if (Ymin LT 1) then Ymin = 0
      if (Ymin GT xsize_1d_draw) then Ymin = (xsize_1d_draw)-1
      putCWFieldValue, event, $
        'data_d_selection_peak_ymin_cw_field', $
        Ymin/coeff
      if (Ymax LT 1) then Ymax = 0
      if (Ymax GT xsize_1d_draw) then Ymax = (xsize_1d_draw)-1
      putCWFieldValue, event, $
        'data_d_selection_peak_ymax_cw_field', $
        Ymax/coeff
    end
  endcase
end
endcase

END

;------------------------------------------------------------------------------
;Put all the peak and background Ymin and Ymax values in their
;respective cw_fields for NORM
PRO putNormBackgroundPeakYMinMaxValueInTextFields, Event

  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,GET_UVALUE=global
  
  xsize_1d_draw = (*global).xsize_1d_draw
  
  IF ((*global).miniVersion) THEN BEGIN
    coeff = 1
  ENDIF ELSE BEGIN
    coeff = 2
  ENDELSE
  
  ;get ROI Ymin, Ymax ===========================================================
  ROISelection = (*(*global).norm_roi_selection)
  ValidateSaveButton = 0
  ;check all cases (-1,-1) (-1,value) (value,-1) and (value,value)
  CASE (ROISelection[0]) OF
    -1: begin
      case (ROISelection[1]) OF
        -1:                 ;do nothing
        else: begin
          Ymax = ROISelection[1]
          if (Ymax LT 1) then Ymax = 0
          if (Ymax GT xsize_1d_draw) then Ymax = (xsize_1d_draw)-1
          putCWFieldValue, event, $
            'norm_d_selection_roi_ymax_cw_field', Ymax/coeff
        end
      endcase
    end
    else: begin
      case (ROISelection[1]) OF
        -1: begin
          Ymin = ROISelection[0]
          if (Ymin LT 1) then Ymin = 0
          if (Ymin GT xsize_1d_draw) then Ymin = (xsize_1d_draw)-1
          putCWFieldValue, event, $
            'norm_d_selection_roi_ymin_cw_field', Ymin/coeff
        end
        else: begin
          Ymin = Min(ROISelection,max=Ymax)
          (*(*global).norm_roi_selection) = [Ymin,Ymax]
          if (Ymin LT 1) then Ymin = 0
          if (Ymin GT xsize_1d_draw) then Ymin = (xsize_1d_draw)-1
          putCWFieldValue, $
            event, $
            'norm_d_selection_roi_ymin_cw_field', $
            Ymin/coeff
          if (Ymax LT 1) then Ymax = 0
          if (Ymax GT xsize_1d_draw) then Ymax = (xsize_1d_draw)-1
          putCWFieldValue, $
            event, $
            'norm_d_selection_roi_ymax_cw_field', $
            Ymax/coeff
          ValidateSaveButton = 1 ;enable SAVE button
        end
      endcase
    end
  endcase
  
  ActivateWidget, Event, 'norm_roi_save_button', ValidateSaveButton
  ActivateWidget, Event, 'norm_roi_selection_file_text_field', $
    ValidateSaveButton
    
  ;  ;get Background Ymin, Ymax ====================================================
  ;  BackSelection = (*(*global).norm_back_selection)
  ;  ValidateSaveButton = 0
  ;  ;check all cases (-1,-1) (-1,value) (value,-1) and (value,value)
  ;  CASE (BackSelection[0]) OF
  ;    -1:begin
  ;    case (BackSelection[1]) OF
  ;      -1: ;do nothing
  ;      else:begin
  ;      Ymax = BackSelection[1]
  ;      if (Ymax LT 1) then Ymax = 0
  ;      if (Ymax GT xsize_1d_draw) then Ymax = (xsize_1d_draw)-1
  ;      putCWFieldValue, $
  ;        event, $
  ;        'norm_d_selection_background_ymax_cw_field', $
  ;        Ymax/coeff
  ;    end
  ;  endcase
  ;end
  ;else:begin
  ;case (BackSelection[1]) OF
  ;  -1: begin
  ;    Ymin = BackSelection[0]
  ;    if (Ymin LT 1) then Ymin = 0
  ;    if (Ymin GT xsize_1d_draw) then Ymin = (xsize_1d_draw)-1
  ;    putCWFieldValue, event, $
  ;      'norm_d_selection_background_ymin_cw_field', $
  ;      Ymin/coeff
  ;  end
  ;  else:begin
  ;  Ymin = Min(BackSelection,max=Ymax)
  ;  (*(*global).norm_back_selection) = [Ymin,Ymax]
  ;  if (Ymin LT 1) then Ymin = 0
  ;  if (Ymin GT xsize_1d_draw) then Ymin = (xsize_1d_draw)-1
  ;  putCWFieldValue, event, $
  ;    'norm_d_selection_background_ymin_cw_field', $
  ;    Ymin/coeff
  ;  if (Ymax LT 1) then Ymax = 0
  ;  if (Ymax GT xsize_1d_draw) then Ymax = (xsize_1d_draw)-1
  ;  putCWFieldValue, event, $
  ;    'norm_d_selection_background_ymax_cw_field', $
  ;    Ymax/coeff
  ;  ValidateSaveButton = 1 ;enable SAVE button
  ;end
  ;endcase
  ;end
  ;endcase
    
  ;ActivateWidget, Event, 'norm_back_save_button', ValidateSaveButton
  ;ActivateWidget, Event, $
  ;  'norm_back_d_selection_file_text_field', $
  ;  ValidateSaveButton
    
  ;get Peak Ymin and Ymax =======================================================
  PeakSelection = (*(*global).norm_peak_selection)
  ;check all cases -1,-1 and -1,value value,-1 and value,value
  CASE (PeakSelection[0]) OF
    -1: begin
      case (PeakSelection[1]) OF
        -1: ;do nothing
        else: begin
          Ymax = PeakSelection[1]
          if (Ymax LT 1) then Ymax = 0
          if (Ymax GT xsize_1d_draw) then Ymax = (xsize_1d_draw)-1
          putCWFieldValue, $
            event, $
            'norm_d_selection_peak_ymax_cw_field', $
            Ymax/coeff
        end
      endcase
    end
    else: begin
      case (PeakSelection[1]) OF
        -1: begin
          Ymin = PeakSelection[0]
          if (Ymin LT 1) then Ymin = 0
          if (Ymin GT xsize_1d_draw) then Ymin = (xsize_1d_draw)-1
          putCWFieldValue, $
            event, $
            'norm_d_selection_peak_ymin_cw_field', $
            Ymin/coeff
        end
        else: begin
          Ymin = Min(PeakSelection,max=Ymax)
          (*(*global).norm_peak_selection) = [Ymin,Ymax]
          if (Ymin LT 1) then Ymin = 0
          if (Ymin GT xsize_1d_draw) then Ymin = (xsize_1d_draw)-1
          putCWFieldValue, $
            event, $
            'norm_d_selection_peak_ymin_cw_field', $
            Ymin/coeff
          if (Ymax LT 1) then Ymax = 0
          if (Ymax GT xsize_1d_draw) then Ymax = (xsize_1d_draw)-1
          putCWFieldValue, $
            event, $
            'norm_d_selection_peak_ymax_cw_field', $
            Ymax/coeff
        END
      ENDCASE
    END
  ENDCASE
END

;------------------------------------------------------------------------------
;Put the given string in the Reduction status text field
PRO putInfoInReductionStatus, Event, string, append
  putTextFieldValue, $
    Event, $
    'reduction_status_text_field', $
    string, $
    append
END

;------------------------------------------------------------------------------
;Put array in droplist specified
PRO putArrayInDropList, Event, arrayString, uname
  id = widget_info(Event.top,find_by_uname=uname)
  widget_control, id, set_value=arrayString
END

;------------------------------------------------------------------------------
;Put name of file in widget_text 'save_as_file_name'
PRO putBatchFileName, Event, FileName
  putTextFieldValue, Event, 'save_as_file_name', FileName, 0
END
