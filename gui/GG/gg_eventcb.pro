PRO ggEventcb_InstrumentSelection, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get instrument selected
InstrumentSelectedIndex = getInstrumentSelectedIndex(Event)

;if instrument selected is not 0 then activate 'loading geometry' GUI
IF (InstrumentSelectedIndex EQ 0) THEN BEGIN
    sensitiveStatus = 0
ENDIF ELSE BEGIN
    sensitiveStatus = 1
ENDELSE
update_loading_geometry_gui_sensitivity, Event, sensitiveStatus

instrumentShortList = (*(*global).instrumentShortList)
END


PRO retrieve_cvinfo_file_name, Event
;get cvinfo file name
cvinfo_file_name = get_cvinfo_file_name(Event)
IF (cvinfo_file_name NE '') THEN BEGIN ;display file name found
    putFileNameInTextField, Event, 'cvinfo', cvinfo_file_name
ENDIF
END




pro MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
end

pro gg_eventcb, event
end

