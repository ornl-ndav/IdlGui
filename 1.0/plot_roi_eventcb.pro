PRO ListOfInstrument, Event

index = getDropListSelectedIndex(Event, 'list_of_instrument')
IF (index EQ 0) THEN BEGIN
    activateStatus = 0
ENDIF ELSE BEGIN
    activateStatus = 1
ENDELSE
MapBase, Event, 'nexus_run_number_base', activateStatus

END


;*******************************************************************************

PRO MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
END

PRO plot_roi_eventcb, event
END

