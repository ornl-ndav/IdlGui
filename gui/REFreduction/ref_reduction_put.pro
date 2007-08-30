;this function repopulates (updates) the Plots droplist
PRO putPlotsDropListContain, event, ContainTextArray
id = widget_info(Event.top,find_by_uname='plots_droplist')
widget_control, id, set_value=ContainTextArray
END


;set the value of the specified uname with text
PRO putTextFieldValue, event, uname, text, append
TextFieldId = widget_info(Event.top,find_by_uname=uname)
if (append) then begin
    widget_control, TextFieldId, set_value=text,/append
endif else begin
    widget_control, TextFieldId, set_value=text
endelse
END


;Put the contain of the string array in the specified text field
PRO putTextFieldArray, Event, uname, array, NbrToDisplay, iteration
if (iteration EQ 0) then begin  ;no append
    putTextFieldValue, Event, uname,array[0],0
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


;set the value of the widget_label
PRO putLabelValue, Event, uname, value
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_value= value
END


;display message in Main Log Book (default is to not append the new message)
PRO putLogBookMessage, Event, LogBookText, Append=Append
if (n_elements(Append) EQ 0) then begin
    Append = 0
endif else begin
    Append = 1
endelse
putTextFieldValue, Event, 'log_book_text_field', LogBookText, append
END


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


;display message in Normalization Log Book (default is to not append the new text)
PRO putNormalizationLogBookMessage, Event, NormalizationLogBookText, Append=Append
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


;Add the given message at the end of the last string array element and
;put it back in the LogBook text field given
;If the optional RemoveString is present, the given String will be
;removed before adding the new MessageToAdd
PRO putTextAtEndOfLogBookLastLine, Event, InitialStrarr, MessageToAdd, RemoveString

;get size of InitialStrarr
ArrSize = (size(InitialStrarr))(1)
if (n_elements(RemoveString) EQ 0) then begin ;do not remove anything from last line
    if (ArrSize GE 2) then begin
        NewLastLine = InitialStrarr[ArrSize-1] + MessageToAdd
        FinalStrarr = [InitialStrarr[0:ArrSize-2],NewLastLine]
    endif else begin
        FinalStrarr = InitialStrarr + MessageToAdd
    endelse
endif else begin ;remove given string from last line
    if (ArrSize GE 2) then begin
        NewLastLine = removeStringFromText(InitialStrarr[ArrSize-1],RemoveString)
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


;Add the given message at the end of the last string array element and
;put it back in the DataLogBook text field given
PRO putTextAtEndOfDataLogBookLastLine, Event, InitialStrarr, MessageToAdd, RemoveString

;get size of InitialStrarr
ArrSize = (size(InitialStrarr))(1)
if (n_elements(RemoveString) EQ 0) then begin ;do not remove anything from last line
    if (ArrSize GE 2) then begin
        NewLastLine = InitialStrarr[ArrSize-1] + MessageToAdd
        FinalStrarr = [InitialStrarr[0:ArrSize-2],NewLastLine]
    endif else begin
        FinalStrarr = InitialStrarr + MessageToAdd
    endelse
endif else begin ;remove given string from last line
    if (ArrSize GE 2) then begin
        NewLastLine = removeStringFromText(InitialStrarr[ArrSize-1],RemoveString)
        NewLastLine += MessageToAdd
        FinalStrarr = [InitialStrarr[0:ArrSizae-2],NewLastLine]
    endif else begin
        NewInitialStrarr = removeStringFromText(InitialStrarr,RemoveString)
        FinalStrarr = NewInitialStrarr + MessageToAdd
    endelse
endelse
;put it back in uname text field
putDataLogBookMessage, Event, FinalStrarr
END


;Add the given message at the end of the last string array element and
;put it back in the NormalizationLogBook text field given
PRO putTextAtEndOfNormalizationLogBookLastLine, $
                                                Event, $
                                                InitialStrarr, $
                                                MessageToAdd, $
                                                RemoveString

;get size of InitialStrarr
ArrSize = (size(InitialStrarr))(1)
if (n_elements(RemoveString) EQ 0) then begin ;do not remove anything from last line
    if (ArrSize GE 2) then begin
        NewLastLine = InitialStrarr[ArrSize-1] + MessageToAdd
        FinalStrarr = [InitialStrarr[0:ArrSize-2],NewLastLine]
    endif else begin
        FinalStrarr = InitialStrarr + MessageToAdd
    endelse
endif else begin ;remove given string from last line
    if (ArrSize GE 2) then begin
        NewLastLine = removeStringFromText(InitialStrarr[ArrSize-1],RemoveString)
        NewLastLine += MessageToAdd
        FinalStrarr = [InitialStrarr[0:ArrSizae-2],NewLastLine]
    endif else begin
        NewInitialStrarr = removeStringFromText(InitialStrarr,RemoveString)
        FinalStrarr = NewInitialStrarr + MessageToAdd
    endelse
endelse
;put it back in uname text field
putNormalizationLogBookMessage, Event, FinalStrarr
END


;This function put an integer in his cw_fields
PRO putCWFieldValue, Event, Uname, value
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_value=value
END


;Put all the peak and background Ymin and Ymax values in their
;respective cw_fields for DATA
PRO putDataBackgroundPeakYMinMaxValueInTextFields, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get Background Ymin, Ymax
BackSelection = (*(*global).data_back_selection)
Ymin = Min(BackSelection,max=Ymax)
(*(*global).data_back_selection) = [Ymin,Ymax]
if (Ymin LT 0) then Ymin = 0
if (Ymax GT (*global).xsize_1d_draw) then Ymax = ((*global).xsize_1d_draw)-1
putCWFieldValue, event, 'data_d_selection_background_ymin_cw_field', Ymin/2
putCWFieldValue, event, 'data_d_selection_background_ymax_cw_field', Ymax/2

;get Peak Ymin and Ymax
PeakSelection = (*(*global).data_peak_selection)
Ymin = Min(PeakSelection,max=Ymax)
if (Ymin LT 0) then Ymin = 0
if (Ymax GT (*global).xsize_1d_draw) then Ymax = ((*global).xsize_1d_draw)-1
(*(*global).data_peak_selection) = [Ymin,Ymax]
putCWFieldValue, event, 'data_d_selection_peak_ymin_cw_field', Ymin/2
putCWFieldValue, event, 'data_d_selection_peak_ymax_cw_field', Ymax/2

END


;Put all the peak and background Ymin and Ymax values in their
;respective cw_fields for NORM
PRO putNormBackgroundPeakYMinMaxValueInTextFields, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get Background Ymin, Ymax
BackSelection = (*(*global).norm_back_selection)
Ymin = Min(BackSelection,max=Ymax)
(*(*global).norm_back_selection) = [Ymin,Ymax]
if (Ymin LT 0) then Ymin = 0
if (Ymax GT (*global).xsize_1d_draw) then Ymax = ((*global).xsize_1d_draw)-1
putCWFieldValue, event, 'normalization_d_selection_background_ymin_cw_field', Ymin/2
putCWFieldValue, event, 'normalization_d_selection_background_ymax_cw_field', Ymax/2

;get Peak Ymin and Ymax
PeakSelection = (*(*global).norm_peak_selection)
Ymin = Min(PeakSelection,max=Ymax)
if (Ymin LT 0) then Ymin = 0
if (Ymax GT (*global).xsize_1d_draw) then Ymax = ((*global).xsize_1d_draw)-1
(*(*global).data_peak_selection) = [Ymin,Ymax]
putCWFieldValue, event, 'normalization_d_selection_peak_ymin_cw_field', Ymin/2
putCWFieldValue, event, 'normalization_d_selection_peak_ymax_cw_field', Ymax/2
END


;Put the given string in the Reduction status text field
PRO putInfoInReductionStatus, Event, string, append
putTextFieldValue, $
  Event, $
  'reduction_status_text_field', $
  string, $
  append
END

