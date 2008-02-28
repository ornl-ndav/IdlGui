;###############################################################################
;*******************************************************************************

PRO putValueInTextField, Event, uname, value
uname_id = widget_info(Event.top,find_by_uname=uname)
widget_control, uname_id, set_value=strcompress(value)
END

;###############################################################################
;*******************************************************************************

PRO putArrayInTextField, Event, uname, ArrayValue
id = widget_info(Event.top,find_by_uname=uname)
sz = (size(ArrayValue))(1)
widget_control, id, set_value=ArrayValue[0]
IF (sz GT 1) THEN BEGIN
    FOR i=1,(nbr_line-1) DO BEGIN
        widget_control, id, set_value=ArrayValue[i],/append
    ENDFOR
ENDIF
END

;###############################################################################
;*******************************************************************************

;This function populates the x/y axis text boxes
PRO PopulateXYScaleAxis, Event, $
                         min_xaxis, $
                         max_xaxis, $
                         min_yaxis, $
                         max_yaxis

;min-xaxis
XminId = widget_info(Event.top,find_by_uname='XaxisMinTextField')
widget_control, XminId, set_value=strcompress(min_xaxis,/remove_all)

;max-xaxis
XmaxId = widget_info(Event.top,find_by_uname='XaxisMaxTextField')
widget_control, XmaxId, set_value=strcompress(max_xaxis,/remove_all)

;min-yaxis
YminId = widget_info(Event.top,find_by_uname='YaxisMinTextField')
widget_control, YminId, set_value=strcompress(min_yaxis,/remove_all)

;max-yaxis
YmaxId = widget_info(Event.top,find_by_uname='YaxisMaxTextField')
widget_control, YmaxId, set_value=strcompress(max_yaxis,/remove_all)

END

;###############################################################################
;*******************************************************************************


















PRO appendValueInTextField, Event, $
                            uname, $
                            value
uname_id = widget_info(Event.top,find_by_uname=uname)
widget_control, uname_id, set_value=strcompress(value),/append
END



;This function will put the values of Xmin/max and Ymin/max
;in their respectives boxes
PRO putXYMinMax, Event, XYMinMax
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

Xmin = XYMinMax[0]
Xmax = XYMinMax[1]
Ymin = XYMinMax[2]
Ymax = XYMinMax[3]

;min-xaxis
XminId = widget_info(Event.top,find_by_uname='XaxisMinTextField')
widget_control, XminId, set_value=strcompress(Xmin)

;max-xaxis
XmaxId = widget_info(Event.top,find_by_uname='XaxisMaxTextField')
widget_control, XmaxId, set_value=strcompress(Xmax)

;min-yaxis
YminId = widget_info(Event.top,find_by_uname='YaxisMinTextField')
widget_control, YminId, set_value=strcompress(Ymin)

;max-yaxis
YmaxId = widget_info(Event.top,find_by_uname='YaxisMaxTextField')
widget_control, YmaxId, set_value=strcompress(Ymax)
END


;this function changes the value displays inside a label
PRO putValueInLabel, Event, uname, value
uname_id = widget_info(Event.top,find_by_uname=uname)
widget_control, uname_id, set_value=strcompress(value)
END


