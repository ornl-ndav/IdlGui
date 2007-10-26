PRO BSSselection_ZoomInCountsVsTofPressed, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve bank, x and y infos
bank = (*global).counts_vs_tof_bank
X    = (*global).counts_vs_tof_x
Y    = (*global).counts_vs_tof_y

;position inside plotting area (0=left, 1=right)
XRatio = (Event.x-40.)/(340.)

IF (bank EQ 1) THEN BEGIN ;bank1
    bank = (*(*global).bank1)
ENDIF ELSE BEGIN ;bank2
    bank = (*(*global).bank2)
ENDELSE

data = bank(*,Y,X)

;Nbr tof
NbTOF = (size(data))(1)
(*global).NBTOF = NbTOF

IF (XRatio LT 0) THEN XRAtio = 0
IF (XRatio GT 1) THEN XRatio = 1

;find out in which bin we clicked
left_click = XRatio * (NBTOF-1)

(*global).counts_vs_tof_click_pressed = left_click

END



PRO BSSselection_ZoomInCountsVsTofReleased, Event

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

data = bank(*,Y,X)

NbTOF = (*global).NBTOF

IF (XRatio LT 0) THEN XRAtio = 0
IF (XRatio GT 1) THEN XRatio = 1

;find out in which bin we clicked
left_click = XRatio * (NBTOF-1)

;plot new plot
;from xmin to xmax
x1 = (*global).counts_vs_tof_click_pressed
x2 = left_click

;get true xmin and xmax
xmin = min([x1,x2],max=xmax)

;plot data (counts vs tof)
view_info = widget_info(Event.top,FIND_BY_UNAME='counts_vs_tof_draw')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id

plot, data, xrange=[xmin,xmax],POSITION=[0.1,0.1,0.95,0.99]

END



;reset of plot
PRO BSSselection_ResetCountsVsTof, Event

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

plot, data, POSITION=[0.1,0.1,0.95,0.99]

END







