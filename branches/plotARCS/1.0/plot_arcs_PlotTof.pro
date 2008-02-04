PRO MakeGuiTofBase_Event, event

WIDGET_CONTROL, event.top, GET_UVALUE=global2

CASE event.id OF
    widget_info(event.top, FIND_BY_UNAME='tof_plot_draw'): begin
    END
ELSE:
ENDCASE

END








PRO PlotTof, img, bank, x, y, pixelID

;build gui
wBase = ''
MakeGuiTofBase, wBase

global3 = ptr_new({ wbase    : wbase,$
                    tvimg    : ptr_new(0L),$
                    img      : img})     

WIDGET_CONTROL, wBase, SET_UVALUE = global3
XMANAGER, "MakeGuiTofBase", wBase, GROUP_LEADER = ourGroup,/NO_BLOCK

DEVICE, DECOMPOSED = 0
loadct, 5

;select plot area
id = widget_info(wBase,find_by_uname='tof_plot_draw')
WIDGET_CONTROL, id, GET_VALUE=id_value
WSET, id_value

;display bank number in title ba
id = widget_info(wBase,find_by_uname='tof_plot_base')
title = 'Bank:' + strcompress(bank,/remove_all)
title += ' ,X:' + strcompress(x,/remove_all)
title += ' ,Y:' + strcompress(y,/remove_all)
title += ' ,PixelID:' + strcompress(pixelID,/remove_all)
widget_control, id, base_set_title= title

;plot data
tof = (size(img))(1)
tof_array = REFORM(img,tof,117760)
plot, tof_array(*,pixelID)

END
