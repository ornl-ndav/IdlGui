PRO MakeGuiBankPlot_Event, event

WIDGET_CONTROL, event.top, GET_UVALUE=global2

CASE event.id OF

ELSE:
ENDCASE

END






PRO PlotBank

;build gui
wBase = ''
MakeGuiBankPlot, wBase

global2 = ptr_new({ wbase   : wbase})

WIDGET_CONTROL, wBase, SET_UVALUE = global2
XMANAGER, "MakeGuiBankPlot", wBase, GROUP_LEADER = ourGroup, /NO_BLOCK

DEVICE, DECOMPOSED = 0
loadct, 5


END
