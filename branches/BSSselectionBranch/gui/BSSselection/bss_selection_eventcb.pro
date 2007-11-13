PRO BSSselection_CountsVsTofTab, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

current_tab = getCurrentSelectedCountsVsTofTab(Event)
prev_tab = (*global).previous_counts_vs_tof_tab

IF ((*global).NeXusFound) THEN BEGIN
    IF (current_tab NE prev_tab) THEN BEGIN
        IF (current_tab EQ 0) THEN BEGIN
;plot counts vs tof            
            BSSselection_PlotCountsVsTofOfSelection, Event
        ENDIF 
        (*global).previous_counts_vs_tof_tab = current_tab
    ENDIF
ENDIF
END




PRO BSSselection_TabRefresh, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

current_tab = getCurrentSelectedMainTab(Event)
prev_tab = (*global).previous_tab

IF (current_tab NE prev_tab) THEN BEGIN
    CASE (current_tab) OF
        0: BEGIN          ;plot bank1, bank2, grid and unselected data
            IF ((*global).NeXusFound) THEN BEGIN
                PlotIncludedPixels, Event
            ENDIF
        END
        1: BEGIN                ;Reduce tab
            BSSselection_CommandLineGenerator, Event
        END
        ELSE:
    ENDCASE
    (*global).previous_tab = current_tab
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


