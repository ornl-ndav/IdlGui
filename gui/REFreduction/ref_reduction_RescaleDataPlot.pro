PRO REFReduction_RescaleDataPlot,Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

tvimg = (*(*global).tvimg_data_ptr)
sz=size(tvimg)
new_tvimg = fltarr(sz[1],sz[2])

;Z-axis
zmin = getTextFieldValue(Event,'data_rescale_zmin_cwfield')
zmax = getTextFieldValue(Event,'data_rescale_zmax_cwfield')
index = where(tvimg GE zmin AND tvimg LE zmax,Nbr)
if (Nbr GT 0) then begin
    new_tvimg(index) = tvimg(index)
    tvimg = new_tvimg
endif

;if z-axis is linear
if (getDropListSelectedIndex(Event,'data_rescale_z_droplist') EQ 1) then begin ;log
    tvimg = alog(tvimg)
endif



REFreduction_Rescale_PlotData, Event, tvimg
END





PRO REFreduction_ResetXDataPlot, Event
print, 'in x reset'
END




PRO REFreduction_ResetYDataPlot, Event
print, 'in y reset'
END




PRO REFreduction_ResetZDataPlot, Event
print, 'in z reset'
END




PRO REFreduction_ResetFullDataPlot, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
tvimg = (*(*global).tvimg_data_ptr)
REFreduction_Rescale_PlotData, Event, tvimg

;reset Data Rescale Gui
REFreduction_Rescale_resetgui,Event,x=1,y=1,z=1
END




PRO REFreduction_Rescale_resetgui, Event, x=x, y=y, z=z
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

DataXYZminmaxArray = (*(*global).DataXYZminmaxArray)

if (x EQ 1) then begin ;reset x-axis
    REFreduction_Rescale_resetXaxis, Event, DataXYZminmaxARray
endif

if (y EQ 1) then begin ;reset y-axis
    REFreduction_Rescale_resetYaxis, Event, DataXYZminmaxARray
endif

if (z EQ 1) then begin ;reset z-axis
    REFreduction_Rescale_resetZaxis, Event, DataXYZminmaxARray
endif
END



PRO REFreduction_Rescale_resetZaxis, Event, DataXYZminmaxARray
;reset z-droplist
SetDropListValue, Event, 'data_rescale_z_droplist',0
putTextfieldValue,Event, 'data_rescale_zmin_cwfield',DataXYZminmaxArray[4],0
putTextfieldValue,Event, 'data_rescale_zmax_cwfield',DataXYZminmaxArray[5],0
END












PRO REFreduction_Rescale_PlotData, Event, tvimg
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

Device, decomposed=0

id_draw = widget_info(Event.top, find_by_uname='load_data_D_draw')
widget_control, id_draw, get_value=id_value
wset,id_value
erase
tvscl, tvimg, /device
END


