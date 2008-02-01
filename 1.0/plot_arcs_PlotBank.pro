PRO MakeGuiBankPlot_Event, event

WIDGET_CONTROL, event.top, GET_UVALUE=global2

CASE event.id OF

ELSE:
ENDCASE

END






PRO PlotBank, img, i, bankName

Xfactor = 10
Yfactor = 5

;build gui
wBase = ''
MakeGuiBankPlot, wBase, Xfactor, Yfactor

global2 = ptr_new({ wbase   : wbase})

WIDGET_CONTROL, wBase, SET_UVALUE = global2
XMANAGER, "MakeGuiBankPlot", wBase, GROUP_LEADER = ourGroup, /NO_BLOCK

DEVICE, DECOMPOSED = 0
loadct, 5

;select plot area
id = widget_info(wBase,find_by_uname='bank_plot')
WIDGET_CONTROL, id, GET_VALUE=id_value
WSET, id_value

;main data array
tvimg = total(img,1)
tvimg = transpose(tvimg)

bank = tvimg[i*8:(i+1)*8-1,*]
bank_rebin = rebin(bank,8*Xfactor, 128L*Yfactor,/sample)
tvscl, bank_rebin, /device

;display bank number in title ba
id = widget_info(wBase,find_by_uname='bank_plot_base')
widget_control, id, base_set_title= strcompress(bankName)

END
