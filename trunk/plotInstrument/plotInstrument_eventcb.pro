;==============================================================================

PRO send_to_geek, Event
;  cmd_file = getTextFieldValue(Event,'cl_file_name_label')
;  IF (cmd_file NE 'N/A') THEN BEGIN
;    list_of_files = [cmd_file]
;    IDLsendLogBook_SendToGeek, Event, $
;      LIST_OF_FILES_TO_TAR=list_of_files
;  ENDIF ELSE BEGIN
;    IDLsendLogBook_SendToGeek, Event
;  ENDELSE
END

;------------------------------------------------------------------------------
PRO MAIN_REALIZE, wWidget
  ;indicate initialization with hourglass icon
  WIDGET_CONTROL,/HOURGLASS
  
  ;tlb = get_tlb(wWidget)
 
  ;turn off hourglass
  WIDGET_CONTROL,HOURGLASS=0
END

;------------------------------------------------------------------------------
PRO plotInstrument_eventcb, event
END

