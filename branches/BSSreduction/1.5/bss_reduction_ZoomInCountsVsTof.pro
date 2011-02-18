PRO BSSreduction_ZoomInCountsVsTofPressed, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;position inside plotting area (0=left, 1=right)
XRatio = (Event.x-40.)/(340.)

;Nbr tof
NbTOF = (*global).NBTOF

IF (XRatio LT 0) THEN XRAtio = 0
IF (XRatio GT 1) THEN XRatio = 1

xmin = (*global).true_x_min
xmax = (*global).true_x_max

;find out in which bin we clicked
IF (xmax GT 0.00001 AND $
    XRatio NE 0 AND $
    XRatio NE 1) THEN BEGIN
    left_click = XRatio * (xmax-xmin) + xmin
ENDIF ELSE BEGIN
    left_click = XRatio * (NBTOF-1)
ENDELSE

(*global).true_x_min = left_click
END



PRO BSSreduction_ZoomInCountsVsTofReleased, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve bank, x and y infos
bank = (*global).counts_vs_tof_bank
X    = (*global).counts_vs_tof_x
Y    = (*global).counts_vs_tof_y

;position inside plotting area (0=left, 1=right)
XRatio = (Event.x-40.)/(340.)

IF (bank EQ 1) THEN BEGIN       ;bank1
    bank = (*(*global).bank1)
ENDIF ELSE BEGIN                ;bank2
    bank = (*(*global).bank2)
ENDELSE

NbTOF = (*global).NBTOF

IF (XRatio LT 0) THEN XRAtio = 0
IF (XRatio GT 1) THEN XRatio = 1

;find out in which bin we clicked
xmin = (*global).true_x_min
xmax = (*global).true_x_max
IF (xmax GT 0.0001 AND $
    XRatio NE 0 AND $
    XRatio NE 1) THEN BEGIN
    left_click = XRatio * (xmax-xmin) + xmin
ENDIF ELSE BEGIN
    left_click = XRatio * (NBTOF-1)
ENDELSE

;plot new plot
;from xmin to xmax
x1 = (*global).true_x_min
x2 = left_click
(*global).true_x_max = x2

;get true xmin and xmax
xmin = min([x1,x2],max=xmax)

;plot data (counts vs tof)
view_info = widget_info(Event.top,FIND_BY_UNAME='counts_vs_tof_draw')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id

data = bank(*,Y,X)
IF ((*global).PrevLinLogValue) THEN BEGIN ;log
    plot, data, xrange=[xmin,xmax],POSITION=[0.1,0.1,0.95,0.99], XSTYLE=1, $
      /YLOG, $
      MIN_VALUE=1
ENDIF ELSE BEGIN
    plot, data, xrange=[xmin,xmax],POSITION=[0.1,0.1,0.95,0.99], XSTYLE=1
ENDELSE

END



;reset of plot
PRO BSSreduction_ResetCountsVsTof, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve bank, x and y infos
bank = (*global).counts_vs_tof_bank
X    = (*global).counts_vs_tof_x
Y    = (*global).counts_vs_tof_y

IF (bank EQ 1) THEN BEGIN ;bank1
    bank = (*(*global).bank1)
ENDIF ELSE BEGIN ;bank2
    bank = (*(*global).bank2)
ENDELSE

data = bank(*,Y,X)

;plot data (counts vs tof)
view_info = widget_info(Event.top,FIND_BY_UNAME='counts_vs_tof_draw')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id

IF ((*global).PrevLinLogValue) THEN BEGIN ;log
    plot, data, POSITION=[0.1,0.1,0.95,0.99],/YLOG,MIN_VALUE=0.000001
ENDIF ELSE BEGIN
    plot, data, POSITION=[0.1,0.1,0.95,0.99]
ENDELSE


END







