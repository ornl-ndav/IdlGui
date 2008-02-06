PRO BankPlotInteraction, Event
WIDGET_CONTROL, event.top, GET_UVALUE=global2
wbase   = (*global2).wBase
;retrieve bank number
BankX = getBankPlotX(Event)
putTextInTextField, Event, 'x_input', BankX
BankY = getBankPlotY(Event)
putTextInTextField, Event, 'y_input', BankY

;get pixelID
BankID = (*global2).bankName
PixelID = getPixelID(BankID, BankX, BankY)
putTextInTextField, Event, 'pixelid_input', PixelID

;get number of counts
tvimg = (*(*global2).tvimg)
putTextInTextField, Event, 'counts', tvimg[PixelID]
END
