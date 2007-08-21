PRO REFreduction_CreateDataBackgroundROIFile, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get Background Ymin and Ymax
SelectionBackArray = (*(*global).data_back_selection)
Ymin = SelectionBackArray[0]
Ymax = SelectionBackArray[1]
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
    
;display preview message
    Message = 'Preview of ' + file_name[0]
    putLabelValue, Event, 'left_data_interaction_help_message_help', Message

;get instrument
    instrument = (*global).instrument
    
;open output file
    openw, 1, file_name
    
    if (instrument EQ (*global).REF_L) then begin ;REF_L
        
        i=0
        NxMax = (*global).Nx_REF_L
        OutputArray = strarr(NxMax*YNbr)
        for y=(Ymin+1),(Ymax-1) do begin
            for x=0,(NxMax-1) do begin
                text = 'bank1_' + strcompress(x,/remove_all)
                text += '_' + strcompress(y,/remove_all)
                printf,1,text
                OutputArray[i] = text
                i++
            endfor
        endfor
        
    endif else begin            ;REF_M
        
        i=0
        NxMax = (*global).Nx_REF_M
        OutputArray = strarr(NxMax*YNbr)	
        for y=(Ymin+1),(Ymax-1) do begin
            for x=0,(NxMax-1) do begin
                text = 'bank1_' + strcompress(y,/remove_all)
                text += '_' + strcompress(x,/remove_all)
                printf,1,text
                OutputArray[i] = text
                i++
            endfor
        endfor

    endelse                     ;end of (instrument is REF_L)

    close, 1
    free_lun, 1
    
;display file_name in info box (display x first lines)
REFreduction_DisplayPreviewOfDataRoiFile, $
  Event, $
  OutputArray, $
  (*global).roi_file_preview_nbr_line

endelse ;end of (Ynbr LE 1)

END
