;this function takes two arrays of 2 elements and replot the 
;Background and Peak selection on top of Norm 1D
PRO ReplotNormBackPeakSelection, Event, BackArray, PeakArray

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

RePlot1DNormFile, Event

;back
color = (*global).back_selection_color
y_array = (*(*global).Norm_back_selection)
plots, 0, y_array[0], /device, color=color
plots, (*global).xsize_1d_draw, y_array[0], /device, /continue, color=color
plots, 0, y_array[1], /device, color=color
plots, (*global).xsize_1d_draw, y_array[1], /device, /continue, color=color

;peak
color = (*global).peak_selection_color
y_array = (*(*global).Norm_peak_selection)
plots, 0, y_array[0], /device, color=color
plots, (*global).xsize_1d_draw, y_array[0], /device, /continue, color=color
plots, 0, y_array[1], /device, color=color
plots, (*global).xsize_1d_draw, y_array[1], /device, /continue, color=color
    
END





;This functions retrieves the value of ymin, ymax of Back and peak
;text boxes and stores them in their global pointers
PRO REFreduction_NormBackgroundPeakSelection, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if ((*global).NormNeXusFound) then begin ;only if there is a NeXus loaded

;get Background Ymin, Ymax
    BackYmin = getTextFieldValue(Event,'normalization_d_selection_background_ymin_cw_field')
    BackYmax = getTextFieldValue(Event,'normalization_d_selection_background_ymax_cw_field')
    BackSelection = [BackYmin,BackYmax]
    (*(*global).norm_back_selection) = BackSelection
    
;get Peak Ymin and Ymax
    PeakYmin = getTextFieldValue(Event,'normalization_d_selection_peak_ymin_cw_field')
    PeakYmax = getTextFieldValue(Event,'normalization_d_selection_peak_ymax_cw_field')
    PeakSelection = [PeakYmin,PeakYmax]
    (*(*global).norm_peak_selection) = PeakSelection
    
;replot Back and Peak selection
    ReplotNormBackPeakSelection, Event, BackSelection, PeakSelection

endif

END
