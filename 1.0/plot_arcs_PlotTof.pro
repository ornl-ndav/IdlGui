PRO MakeGuiTofBase_Event, event

WIDGET_CONTROL, event.top, GET_UVALUE=global3

CASE event.id OF
    widget_info(event.top, FIND_BY_UNAME='tof_plot_draw'): begin
        IF (Event.press EQ 1) THEN BEGIN ;left mouse pressed
            PressMouseInTOF, Event
        ENDIF
        IF (Event.release EQ 1) THEN BEGIN ;left mouse released
            ReleaseMouseInTof, Event
        ENDIF
    END
    
    widget_info(event.top, FIND_BY_UNAME='linear_scale'): begin
        id = widget_info(Event.top,find_by_uname='plot_scale_type')
        widget_control, id, set_value='Linear Y-axis      '
        RefreshPlotInTof, Event
    END
    
    widget_info(event.top, FIND_BY_UNAME='log_scale'): begin
        id = widget_info(Event.top,find_by_uname='plot_scale_type')
        widget_control, id, set_value='Logarithmic Y-axis'
        RefreshPlotInTof, Event
    END
    
ELSE:
ENDCASE

END








PRO PlotTof, img, bank, xLeft, yLeft, xRight, yRight, pixelID
;build gui
wBase = ''
MakeGuiTofBase, wBase

global3 = ptr_new({ wbase    : wbase,$
                    IvsTOF   : ptr_new(0L),$
                    true_x_min : 0.00000001,$
                    true_x_max : 0.000000001,$
                    xmin_for_refresh : 0,$
                    xmax_for_refresh : 0,$
                    tof      : 0L,$
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

;display bank number in title bar
id = widget_info(wBase,find_by_uname='tof_plot_base')
title = 'Counts vs TOF - '
title += '(Bank:' + strcompress(bank,/remove_all)
IF ((size(pixelID))(1) EQ 1) THEN BEGIN
    title += ' ,X:' + strcompress(xRight,/remove_all)
    title += ' ,Y:' + strcompress(yRight,/remove_all)
    title += ' ,PixelID:' + strcompress(pixelID[0],/remove_all)
ENDIF ELSE BEGIN
    nbr = (size(pixelID))(1)
    title += ' ,Xrange:'+strcompress(xLeft,/remove_all)
    title += '->'+strcompress(xRight,/remove_all)
    title += ' ,Yrange:'+strcompress(yLeft,/remove_all)
    title += '->'+strcompress(yRight,/remove_all)
    title += ' , Number of Pixel selected:'+strcompress(nbr,/remove_all)
ENDELSE
title += ')'
widget_control, id, base_set_title= title

;plot data
tof = (size(img))(1)
(*global3).tof = tof
tof_array = REFORM(img,tof,117760)
IvsTOF = tof_array(*,pixelID)
sz = (size(IvsTOF))(0)
IF (sz EQ 2) THEN BEGIN
    IvsTOF = total(IvsTOF,2)
ENDIF
(*(*global3).IvsTOF) = IvsTOF
plot, IvsTOF
END
