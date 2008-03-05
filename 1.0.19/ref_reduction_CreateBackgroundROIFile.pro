;DATA SIDE OF LOAD TAB
PRO REFreduction_CreateDataBackgroundROIFile, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get Background Ymin and Ymax
SelectionBackArray = (*(*global).data_back_selection)

if ((*global).miniVersion) then begin
    coeff = 1
endif else begin
    coeff = 2
endelse

Ymin = SelectionBackArray[0]/coeff
Ymax = SelectionBackArray[1]/coeff
YNbr = (Ymax-Ymin)

if (YNbr LE 1) then begin
    
;display error message saying that selection is invalid
Message = '* E R R O R *'
putLabelValue, Event, 'left_data_interaction_help_message_help', Message

Message = 'Data Background Selection is invalid !'
putTextFieldValue, $
  Event, $
  'DATA_left_interaction_help_text',$
  Message, $
  0

endif else begin ;enough Y between Ymax and Ymin to create outpur roi file

;get name of roi file to create
    file_name = $
      getTextFieldValue(Event,$
                        'data_background_selection_file_text_field')
    file_name = file_name[0]

;update REDUCE gui with name of data background roi file
    putTextFieldValue,$
      Event,$
      'reduce_data_region_of_interest_file_name',$
      file_name,$
      0 ;do not append

;display preview message
    Message = 'Preview of ' + file_name
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
        data_message = 'ERROR saving the Data ROI file (check LogBook)'
        putDataLogBookMessage, Event, data_message, Append=1
    ENDIF ELSE BEGIN

        openw, 1, file_name
        
        if (instrument EQ (*global).REF_L) then begin ;REF_L
            
            i=0L
            NxMax = (*global).Nx_REF_L
            YNbr = YNbr+1
            OutputArray = strarr((NxMax)*YNbr)
            for y=(Ymin),(Ymax) do begin
                for x=0,(NxMax-1) do begin
                    text = 'bank1_' + strcompress(x,/remove_all)
                    text += '_' + strcompress(y,/remove_all)
                    printf,1,text
                    OutputArray[i] = text
                    i++
                endfor
            endfor
            
        endif else begin        ;REF_M
            
            i=0L
            NyMax = (*global).Ny_REF_M
            YNbr = YNbr+1
            OutputArray = strarr((NyMax)*YNbr)	
            for y=(Ymin),(Ymax) do begin
                for x=0,(NyMax-1) do begin
                    text = 'bank1_' + strcompress(y,/remove_all)
                    text += '_' + strcompress(x,/remove_all)
                    printf,1,text
                    OutputArray[i] = text
                    i++
                endfor
            endfor
            
        endelse                 ;end of (instrument is REF_L)
        
        close, 1
        free_lun, 1
    
;display file_name in info box (display x first lines)
        REFreduction_DisplayPreviewOfDataRoiFile, $
          Event, $
          OutputArray, $
          (*global).roi_file_preview_nbr_line
        
    ENDELSE

endelse ;end of (Ynbr LE 1)

END




;NORMALIZATION SIDE OF LOAD TAB
PRO REFreduction_CreateNormBackgroundROIFile, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if ((*global).miniVersion) then begin
    coeff = 1
endif else begin
    coeff = 2
endelse

;get Background Ymin and Ymax
SelectionBackArray = (*(*global).norm_back_selection)
Ymin = SelectionBackArray[0]/coeff
Ymax = SelectionBackArray[1]/coeff
YNbr = (Ymax-Ymin)

if (YNbr LE 1) then begin
    
;display error message saying that selection is invalid
Message = '* E R R O R *'
putLabelValue, Event, 'left_normalization_interaction_help_message_help', Message

Message = 'Normalization Background Selection is invalid !'
putTextFieldValue, $
  Event, $
  'NORM_left_interaction_help_text',$
  Message, $
  0

endif else begin ;enough Y between Ymax and Ymin to create outpur roi file

;get name of roi file to create
    file_name = $
      getTextFieldValue(Event,$
                        'normalization_background_selection_file_text_field')
    file_name = file_name[0]

;update REDUCE gui with name of data background roi file
    putTextFieldValue,$
      Event,$
      'reduce_normalization_region_of_interest_file_name',$
      file_name,$
      0 ;do not append

;display preview message
    Message = 'Preview of ' + file_name
    putLabelValue, Event, 'left_normalization_interaction_help_message_help', Message

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
        norm_message = 'ERROR saving the Normalization ROI file (check LogBook)'
        putNormalizationLogBookMessage, Event, norm_message, Append=1
    ENDIF ELSE BEGIN
        
        openw, 1, file_name
    
        if (instrument EQ (*global).REF_L) then begin ;REF_L
            
            i=0L
            NxMax = (*global).Nx_REF_L
            YNbr = YNbr+1
            OutputArray = strarr(NxMax*YNbr)
            for y=(Ymin),(Ymax) do begin
                for x=0,(NxMax-1) do begin
                    text = 'bank1_' + strcompress(x,/remove_all)
                    text += '_' + strcompress(y,/remove_all)
                    printf,1,text
                    OutputArray[i] = text
                    i++
                endfor
            endfor
            
        endif else begin        ;REF_M
            
            i=0L
            NyMax = (*global).Ny_REF_M
            YNbr = YNbr+1
            OutputArray = strarr((NyMax)*YNbr)	
            for y=(Ymin),(Ymax) do begin
                for x=0,(NyMax-1) do begin
                    text = 'bank1_' + strcompress(y,/remove_all)
                    text += '_' + strcompress(x,/remove_all)
                    printf,1,text
                    OutputArray[i] = text
                    i++
                endfor
            endfor
            
        endelse                 ;end of (instrument is REF_L)
        
        close, 1
        free_lun, 1
        
;display file_name in info box (display x first lines)
        REFreduction_DisplayPreviewOfNormRoiFile, $
          Event, $
          OutputArray, $
          (*global).roi_file_preview_nbr_line

    ENDELSE

endelse                         ;end of (Ynbr LE 1)

END
