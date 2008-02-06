PRO RefreshBank, Event
WIDGET_CONTROL, event.top, GET_UVALUE=global2
;select plot area
id = widget_info((*global2).wBase,find_by_uname='bank_plot')
WIDGET_CONTROL, id, GET_VALUE=id_value
WSET, id_value

Xfactor = (*global2).Xfactor
Yfactor = (*global2).Yfactor
IF ((*global2).bDasView EQ 0) THEN BEGIN 
    tvscl, (*(*global2).bank_rebin), /device
ENDIF ELSE BEGIN
    tvscl, (*(*global2).bank_congrid), /device
ENDELSE
END



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




PRO PlotSelectionBox, x, y, x_coeff, y_coeff, color
plots, x*x_coeff, y*y_coeff, /device, color=color
plots, x*x_coeff, (y+1)*y_coeff, /device, /continue, color=color
plots, (x+1)*x_coeff, y*y_coeff, /device, color=color
plots, (x+1)*x_coeff, (y+1)*y_coeff, /device, /continue, color=color

plots, x*x_coeff,y*y_coeff, /device,color=color
plots, (x+1)*x_coeff, y*y_coeff, /device, /continue, color=color
plots, x*x_coeff,(y+1)*y_coeff, /device,color=color
plots, (x+1)*x_coeff, (y+1)*y_coeff, /device, /continue, color=color
END



;plot single pixel when user move nouse over bank plot
PRO plotPixel, Event  
WIDGET_CONTROL, event.top, GET_UVALUE=global2
x       = Event.X
y       = Event.y
xfactor = (*global2).Xfactor
yfactor = (*global2).Yfactor
id = widget_info((*global2).wbase,find_by_uname='bank_plot')
WIDGET_CONTROL, id, GET_VALUE=id_value
WSET, id_value

x = Fix(x/xfactor)
y = Fix(y/yfactor)

PlotSelectionBox, x, y, xfactor, yfactor, 100


END
