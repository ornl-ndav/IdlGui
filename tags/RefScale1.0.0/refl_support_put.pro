PRO putValueInTextField, Event, $
                         uname, $
                         value
uname_id = widget_info(Event.top,find_by_uname=uname)
widget_control, uname_id, set_value=strcompress(value)
END



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


