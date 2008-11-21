PRO PressMouseInTof, Event
;get global structure
WIDGET_CONTROL, event.top, GET_UVALUE=global3
;position inside plotting area (0=left, 1=right)
XRatio = (Event.x-60.)/(482.-60.)

;Nbr tof
NbTOF = (*global3).tof

IF (XRatio LT 0) THEN XRatio = 0
IF (XRatio GT 1) THEN XRatio = 1

xmin = (*global3).true_x_min
xmax = (*global3).true_x_max

;find out in which bin we clicked
IF (xmax GT 0.00001 AND $
    XRatio NE 0 AND $
    XRatio NE 1) THEN BEGIN
    left_click  = XRatio * (xmax-xmin) + xmin
ENDIF ELSE BEGIN
    left_click = XRatio * (NbTOF - 1)
ENDELSE
(*global3).true_x_min = left_click
END


PRO ReleaseMouseInTof, Event
;get global structure
WIDGET_CONTROL, event.top, GET_UVALUE=global3

;position inside plotting area (0=left, 1=right)
XRatio = (Event.x-60.)/(482.-60.)
NbTOF  = (*global3).tof

IF (XRatio LT 0) THEN XRAtio = 0
IF (XRatio GT 1) THEN XRatio = 1

;find out in which bin we clicked
xmin = (*global3).true_x_min
xmax = (*global3).true_x_max
IF (xmax GT 0.0001 AND $
    XRatio NE 0 AND $
    XRatio NE 1) THEN BEGIN
    left_click = XRatio * (xmax-xmin) + xmin
ENDIF ELSE BEGIN
    left_click = XRatio * (NBTOF-1)
ENDELSE

;plot new plot
;from xmin to xmax
x1 = (*global3).true_x_min
x2 = left_click
(*global3).true_x_max = x2

;get true xmin and xmax
xmin = min([x1,x2],max=xmax)

;plot data (counts vs tof)
view_info = widget_info(Event.top,FIND_BY_UNAME='tof_plot_draw')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id

data = (*(*global3).IvsTOF)
;get type desired
type = getTypeDesired(Event)

(*global3).xmin_for_refresh = xmin
(*global3).xmax_for_refresh = xmax

IF (type EQ 'log') THEN BEGIN ;log
    plot, data, xrange=[xmin,xmax], XSTYLE=1, /YLOG, MIN_VALUE=1
ENDIF ELSE BEGIN
    plot, data, xrange=[xmin,xmax], XSTYLE=1
ENDELSE

END





PRO RefreshPlotInTof, Event
;get global structure
WIDGET_CONTROL, event.top, GET_UVALUE=global3

;plot data (counts vs tof)
view_info = widget_info(Event.top,FIND_BY_UNAME='tof_plot_draw')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id

data = (*(*global3).IvsTOF)
;get type desired
type = getTypeDesired(Event)

xmin = (*global3).xmin_for_refresh
xmax = (*global3).xmax_for_refresh

IF (type EQ 'log') THEN BEGIN ;log
    plot, data, xrange=[xmin,xmax], XSTYLE=1, /YLOG, MIN_VALUE=1
ENDIF ELSE BEGIN
    plot, data, xrange=[xmin,xmax], XSTYLE=1
ENDELSE

END
