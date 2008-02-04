PRO BankPlotInteraction, Event
WIDGET_CONTROL, event.top, GET_UVALUE=global2
wbase   = (*global2).wBase
;retrieve bank number
BankX = getBankPlotX(Event)
BankY = getBankPlotY(Event)
;get pixelID
print, '(X,Y)=('+BankX+','+BankY+')'

;change title
;id = widget_info(wBase,find_by_uname='main_plot_base')
;widget_control, id, base_set_title= text
END
