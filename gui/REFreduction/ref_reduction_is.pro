Function isDataPeakSelectionSelected, Event
id = widget_info(Event.top,find_by_uname='data_1d_selection')
widget_control, id, get_value=isPeakSelected
return, isPeakSelected
END


Function isDataBackPeakZoomSelected, Event
id = widget_info(Event.top,find_by_uname='data_1d_selection')
widget_control, id, get_value=SelectionStatus
return, selectionStatus
END


Function isNormBackPeakZoomSelected, Event
id = widget_info(Event.top,find_by_uname='normalization_1d_selection')
widget_control, id, get_value=SelectionStatus
return, selectionStatus
END



Function isDataWithBackground, Event
id = widget_info(Event.top,find_by_uname='data_background_cw_bgroup')
widget_control, id, get_value=isWithBackground
if (isWithBackground EQ 0) then begin
   return, 1
endif else begin
   return, 0
endelse
END


Function isNormPeakSelectionSelected, Event
id = widget_info(Event.top,find_by_uname='normalization_1d_selection')
widget_control, id, get_value=isPeakSelected
return, isPeakSelected
END


Function isNormWithBackground, Event
id = widget_info(Event.top,find_by_uname='normalization_background_cw_bgroup')
widget_control, id, get_value=isWithBackground
if (isWithBackground EQ 0) then begin
   return, 1
endif else begin
   return, 0
endelse
END


Function isReductionWithNormalization, Event
id = widget_info(Event.top,find_by_uname='yes_no_normalization_bgroup')
widget_control, id, get_value=isWithNormalization
if (isWithNormalization EQ 0) then begin
    return, 1
endif else begin
    return, 0
endelse
END


Function isWithFiltering, Event
id = widget_info(Event.top,find_by_uname='filtering_data_cwbgroup')
widget_control, id, get_value=isWithFiltering
if (isWithFiltering EQ 0) then begin
    return, 1
endif else begin
    return, 0
endelse
END


Function isWithDeltaToverT, Event
id = widget_info(Event.top,find_by_uname='delta_t_over_t_cwbgroup')
widget_control, id, get_value=isWithDeltaToverT
if (isWithDeltaToverT EQ 0) then begin
    return, 1
endif else begin
    return, 0
endelse
END


Function isWithInstrumentGeometryOverwrite, Event
id = widget_info(Event.top,find_by_uname='overwrite_instrument_geometry_cwbgroup')
widget_control, id, get_value=isWithIGOverwrite
if (isWithIGOverwrite EQ 0) then begin
    return, 1
endif else begin
    return, 0
endelse
END


Function isBaseMap, Event, uname
id = widget_info(Event.top,find_by_uname=uname)
isMap = widget_info(id, /map)
return, isMap
END


Function isDataZoomTabSelected, Event
tab_id = widget_info(Event.top,find_by_uname='data_nxsummary_zoom_tab')
CurrTabSelect = widget_info(tab_id,/tab_current)
return, CurrTabSelect
END


Function isNormZoomTabSelected, Event
tab_id = widget_info(Event.top,find_by_uname='normalization_nxsummary_zoom_tab')
CurrTabSelect = widget_info(tab_id,/tab_current)
return, CurrTabSelect
END


Function isWidgetSensitive, Event, uname
id = widget_info(Event.top,find_by_uname=uname)
sensitiveStatus = widget_info(id,/sensitive)
return, sensitiveStatus
END


Function isArchivedDataNexusDesired, Event
id = widget_info(Event.top,find_by_uname='data_archived_or_full_cwbgroup')
widget_control,id,get_value=status
if (status EQ 0) then begin
    return, 1
endif else begin
    return, 0
endelse
END


Function isArchivedNormNexusDesired, Event
id = widget_info(Event.top,find_by_uname='normalization_archived_or_full_cwbgroup')
widget_control,id,get_value=status
if (status EQ 0) then begin
    return, 1
endif else begin
    return, 0
endelse
END


;1D_3D booleans
FUNCTION isXaxisScaleLog, Event
id = widget_info(Event.top,find_by_uname='data1d_x_axis_scale')
index = widget_info(id, /droplist_select)
return, index
END

FUNCTION isYaxisScaleLog, Event
id = widget_info(Event.top,find_by_uname='data1d_y_axis_scale')
index = widget_info(id, /droplist_select)
return, index
END

FUNCTION isZaxisScaleLog, Event
id = widget_info(Event.top,find_by_uname='data1d_z_axis_scale')
index = widget_info(id, /droplist_select)
return, index
END

