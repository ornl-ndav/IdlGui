;this function takes two arrays of 2 elements and replot the 
;Background and Peak selection on top of Norm 1D
PRO ReplotNormBackPeakSelection, Event, BackArray, PeakArray

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;clear full window_draw
id_draw = widget_info(Event.top, find_by_uname='load_normalization_D_draw')
widget_control, id_draw, get_value=id_value
wset,id_value
erase

RePlot1DNormFile, Event

xsize_1d_draw = (*global).Ntof_NORM-1
;back
color = (*global).back_selection_color
y_array = (*(*global).Norm_back_selection)

if (y_array[0] NE -1) then begin
    plots, 0, y_array[0], /device, color=color
    plots, xsize_1d_draw, y_array[0], /device, /continue, color=color
endif

if (y_array[1] NE -1) then begin
    plots, 0, y_array[1], /device, color=color
    plots, xsize_1d_draw, y_array[1], /device, /continue, color=color
endif

;peak
color = (*global).peak_selection_color
y_array = (*(*global).Norm_peak_selection)

if (y_array[0] NE -1) then begin
    plots, 0, y_array[0], /device, color=color
    plots, xsize_1d_draw, y_array[0], /device, /continue, color=color
endif

if (y_array[1] NE -1) then begin
    plots, 0, y_array[1], /device, color=color
    plots, xsize_1d_draw, y_array[1], /device, /continue, color=color
endif
    
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

    if (BackYmin EQ '') then begin
        BackYmin = -1
    endif else begin
        BackYmin *= 2
    endelse

    if (BackYmax EQ '') then begin
        BackYmax = -1
    endif else begin
        BackYmax *= 2
    endelse

    BackSelection = [BackYmin,BackYmax]
    (*(*global).norm_back_selection) = BackSelection
    
;get Peak Ymin and Ymax
    PeakYmin = getTextFieldValue(Event,'normalization_d_selection_peak_ymin_cw_field')
    PeakYmax = getTextFieldValue(Event,'normalization_d_selection_peak_ymax_cw_field')

    if (PeakYmin EQ '') then begin
        PeakYmin = -1
    endif else begin
        PeakYmin *= 2
    endelse

    if (PeakYmax EQ '') then begin
        PeakYmax = -1
    endif else begin
        PeakYmax *= 2
    endelse

    PeakSelection = [PeakYmin,PeakYmax]
    (*(*global).norm_peak_selection) = PeakSelection
    
    putNormBackgroundPeakYMinMaxValueInTextFields, Event
    ReplotNormBackPeakSelection, Event, BackSelection, PeakSelection

endif

END
