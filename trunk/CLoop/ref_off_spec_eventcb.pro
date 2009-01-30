PRO MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
WIDGET_CONTROL,/HOURGLASS
;turn off hourglass
WIDGET_CONTROL,HOURGLASS=0
END

PRO ref_off_spec_eventcb, event
END

