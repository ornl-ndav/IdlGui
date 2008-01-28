PRO MainPlotInteraction, Event
WIDGET_CONTROL, event.top, GET_UVALUE=global1
wbase   = (*global1).wBase
;retrieve bank number
bank_number = getBank(Event)
;display bank numbe in title
IF ((*global1).real_or_tof EQ 0) THEN BEGIN ;real das view
    text = (*global1).main_plot_real_title
ENDIF ELSE BEGIN ;tof view
    text = (*global1).main_plot_tof_title
ENDELSE
IF (bank_number NE '') THEN BEGIN
    text += ' - bank: ' + bank_number
ENDIF
;change title
id = widget_info(wBase,find_by_uname='main_plot_base')
widget_control, id, base_set_title= text
IF (Event.press EQ 1) THEN BEGIN ;mouse pressed
ENDIF
END
