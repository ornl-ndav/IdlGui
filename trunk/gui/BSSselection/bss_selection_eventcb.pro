PRO BSSselection_TabRefresh, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

current_tab = getCurrentSelectedMainTab(Event)
prev_tab = (*global).previous_tab

IF (current_tab NE prev_tab) THEN BEGIN

    (*global).previous_tab = current_tab

;plot bank1, bank2, grid and unselected data
    PlotIncludedPixels, Event

ENDIF

END



pro bss_selection_eventcb
end


pro MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
end


