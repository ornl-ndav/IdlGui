;this function takes two arrays of 2 elements and replot the 
;Background and Peak selection on top of Data 1D
PRO ReplotDataBackPeakSelection, Event, BackArray, PeakArray

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;clear full draw window
id_draw = widget_info(Event.top, find_by_uname='load_data_D_draw')
widget_control, id_draw, get_value=id_value
wset,id_value
erase

RePlot1DDataFile, Event

xsize_1d_draw = (*global).Ntof_DATA-1
;back
color = (*global).back_selection_color
y_array = (*(*global).data_back_selection)
plots, 0, y_array[0], /device, color=color
plots, xsize_1d_draw, y_array[0], /device, /continue, color=color
plots, 0, y_array[1], /device, color=color
plots, xsize_1d_draw, y_array[1], /device, /continue, color=color

;peak
color = (*global).peak_selection_color
y_array = (*(*global).data_peak_selection)
plots, 0, y_array[0], /device, color=color
plots, xsize_1d_draw, y_array[0], /device, /continue, color=color
plots, 0, y_array[1], /device, color=color
plots, xsize_1d_draw, y_array[1], /device, /continue, color=color

END





;This functions retrieves the value of ymin, ymax of Back and peak
;text boxes and stores them in their global pointers
PRO REFreduction_DataBackgroundPeakSelection, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if ((*global).DataNeXusFound) then begin ;only if there is a NeXus loaded
    
;get Background Ymin, Ymax
    BackYmin = getTextFieldValue(Event,'data_d_selection_background_ymin_cw_field')
    BackYmax = getTextFieldValue(Event,'data_d_selection_background_ymax_cw_field')
    BackSelection = [BackYmin,BackYmax]
    
;be sure they are in the right order
    Ymin=Min(BackSelection,max=Ymax)
    if (Ymin LT 0) then Ymin = 0
    if (Ymax GT 303) then Ymax = 303

;put them back in their fields
    putCWFieldValue, event, 'data_d_selection_background_ymin_cw_field', Ymin
    putCWFieldValue, event, 'data_d_selection_background_ymax_cw_field', Ymax

    BackSelection = [2*Ymin,2*Ymax]
    (*(*global).data_back_selection) = BackSelection
    
;get Peak Ymin and Ymax
    PeakYmin = getTextFieldValue(Event,'data_d_selection_peak_ymin_cw_field')
    PeakYmax = getTextFieldValue(Event,'data_d_selection_peak_ymax_cw_field')
    PeakSelection = [PeakYmin,PeakYmax]

;be sure they are in the right order
    Ymin=Min(PeakSelection,max=Ymax)
    if (Ymin LT 0) then Ymin = 0
    if (Ymax GT 303) then Ymax = 303

;put them back in their fields
    putCWFieldValue, event, 'data_d_selection_peak_ymin_cw_field', Ymin
    putCWFieldValue, event, 'data_d_selection_peak_ymax_cw_field', Ymax

    PeakSelection = [2*Ymin,2*Ymax]
    (*(*global).data_peak_selection) = PeakSelection    
;replot Back and Peak selection
    ReplotDataBackPeakSelection, Event, BackSelection, PeakSelection

endif

END
