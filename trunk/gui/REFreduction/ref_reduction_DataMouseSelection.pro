;this function is reached when the user click on the plot
PRO REFreduction_DataSelectionPressLeft, event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;signal or peak selection
isPeakSelected = isDataPeakSelectionSelected(Event)
if (isPeakSelected) then begin  ;peak selection
    color = (*global).peak_selection_color
    y_array = (*(*global).data_peak_selection)
endif else begin                ;background selection
    color = (*global).back_selection_color
    y_array = (*(*global).data_back_selection)
endelse

;where to stop the plot of the lines
xsize_1d_draw = (*global).Ntof_DATA - 1

mouse_status = (*global).select_data_status
;print, 'PressLeft mouse_status: ' + strcompress(mouse_status)
CASE (mouse_status) OF
    0: Begin
;refresh plot
        RePlot1DDataFile, Event
        y=event.y
        plots, 0, y, /device, color=color
        plots, xsize_1d_draw, y, /device, /continue, color=color
        y2=y_array[1]
        plots, 0, y2, /device, color=color
        plots, xsize_1d_draw, y2, /device, /continue, color=color
        mouse_status_new = 1
    END
    1:  mouse_status_new = mouse_status
    2:  mouse_status_new = mouse_status
    3: Begin
        RePlot1DDataFile, Event
        y1 = y_array[0]
        plots, 0, y1, /device, color=color
        plots, xsize_1d_draw, y1, /device, /continue, color=color
        y=event.y
        plots, 0, y, /device, color=color
        plots, xsize_1d_draw, y, /device, /continue, color=color
        mouse_status_new = 4
    end
    4:mouse_status_new = mouse_status
    5:  Begin
        RePlot1DDataFile, Event
        y1 = y_array[0]
        plots, 0, y1, /device, color=color
        plots, xsize_1d_draw, y1, /device, /continue, color=color
        y=event.y
        plots, 0, y, /device, color=color
        plots, xsize_1d_draw, y, /device, /continue, color=color
        mouse_status_new = 4
    end
endcase

if (isPeakSelected) then begin  ;peak selection
    color = (*global).back_selection_color
    y_array = (*(*global).data_back_selection)
    plots, 0, y_array[0], /device, color=color
    plots, xsize_1d_draw, y_array[0], /device, /continue, color=color
    plots, 0, y_array[1], /device, color=color
    plots, xsize_1d_draw, y_array[1], /device, /continue, color=color
endif else begin                ;background selection
    color = (*global).peak_selection_color
    y_array = (*(*global).data_peak_selection)
    plots, 0, y_array[0], /device, color=color
    plots, xsize_1d_draw, y_array[0], /device, /continue, color=color
    plots, 0, y_array[1], /device, color=color
    plots, xsize_1d_draw, y_array[1], /device, /continue, color=color
endelse

(*global).select_data_status = mouse_status_new

;update Back and Peak Ymin and Ymax cw_fields of Data
putDataBackgroundPeakYMinMaxValueInTextFields, Event

END




PRO REFreduction_DataSelectionPressRight, event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

RePlot1DDataFile, Event

;where to stop the plot of the lines
xsize_1d_draw = (*global).Ntof_DATA-1

mouse_status = (*global).select_data_status
;print, 'PressRight mouse_status: ' + strcompress(mouse_status)
CASE (mouse_status) OF
    0: begin
        mouse_status_new = 3
        end
    1:  mouse_status_new = mouse_status
    2: mouse_status_new = mouse_status
    3: mouse_status_new = 0
    4: mouse_status_new = mouse_status
    5: mouse_status_new = 0
endcase

isPeakSelected = isDataPeakSelectionSelected(Event)

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

(*global).select_data_status = mouse_status_new

;update Back and Peak Ymin and Ymax cw_fields
putDataBackgroundPeakYMinMaxValueInTextFields, Event

END



;this function is reached when the mouse moved into the widget_draw
PRO REFreduction_DataSelectionMove, event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;where to stop the plot of the lines
xsize_1d_draw = (*global).Ntof_DATA-1

;signal or peak selection
isPeakSelected = isDataPeakSelectionSelected(Event)
if (isPeakSelected) then begin  ;peak selection
    color = (*global).peak_selection_color
    y_array = (*(*global).data_peak_selection)
endif else begin                ;background selection
    color = (*global).back_selection_color
    y_array = (*(*global).data_back_selection)
endelse

mouse_status = (*global).select_data_status
;print, 'Move mouse_status: ' + strcompress(mouse_status)
CASE (mouse_status) OF
    0:mouse_status_new = mouse_status
    1: Begin
        RePlot1DDataFile, Event
        mouse_status_new = mouse_status
        y2 = y_array[1]
        plots, 0, y2, /device, color=color
        plots, xsize_1d_draw, y2, /device, /continue, color=color
;refresh plot
        y=event.y
        plots, 0, y, /device, color=color
        plots, xsize_1d_draw, y, /device, /continue, color=color
        END
    2:mouse_status_new = mouse_status
    3: Begin
;refresh plot
        RePlot1DDataFile, Event
        mouse_status_new = mouse_status
        y1 = y_array[0]
        plots, 0, y1, /device, color=color
        plots, xsize_1d_draw, y1, /device, /continue, color=color
    END
    4: Begin
        RePlot1DDataFile, Event
        y1 = y_array[0]
        plots, 0, y1, /device, color=color
        plots, xsize_1d_draw, y1, /device, /continue, color=color
        y=event.y
        plots, 0, y, /device, color=color
        plots, xsize_1d_draw, y, /device, /continue, color=color
        mouse_status_new = mouse_status
    END
    5:mouse_status_new = mouse_status
endcase

if (isPeakSelected) then begin  ;peak selection
    color = (*global).back_selection_color
    y_array = (*(*global).data_back_selection)
    plots, 0, y_array[0], /device, color=color
    plots, xsize_1d_draw, y_array[0], /device, /continue, color=color
    plots, 0, y_array[1], /device, color=color
    plots, xsize_1d_draw, y_array[1], /device, /continue, color=color
endif else begin                ;background selection
    color = (*global).peak_selection_color
    y_array = (*(*global).data_peak_selection)
    plots, 0, y_array[0], /device, color=color
    plots, xsize_1d_draw, y_array[0], /device, /continue, color=color
    plots, 0, y_array[1], /device, color=color
    plots, xsize_1d_draw, y_array[1], /device, /continue, color=color
endelse

;update Back and Peak Ymin and Ymax cw_fields
putDataBackgroundPeakYMinMaxValueInTextFields, Event

END




PRO REFreduction_DataSelectionRelease, event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;where to stop the plot of the lines
xsize_1d_draw = (*global).Ntof_DATA-1

;signal or peak selection
isPeakSelected = isDataPeakSelectionSelected(Event)
if (isPeakSelected) then begin  ;peak selection
    color = (*global).peak_selection_color
    y_array = (*(*global).data_peak_selection)
endif else begin                ;background selection
    color = (*global).back_selection_color
    y_array = (*(*global).data_back_selection)
endelse

mouse_status = (*global).select_data_status
;print, 'Release mouse_status: ' + strcompress(mouse_status)
CASE (mouse_status) OF
    0:mouse_status_new = mouse_status
    1: Begin
;refresh plot
        RePlot1DDataFile, Event
        mouse_status_new = 0
;get y mouse
        y=event.y
        plots, 0, y, /device, color=color
        plots, xsize_1d_draw, y, /device, /continue, color=color
        y2 = y_array[1]
        plots, 0, y2, /device, color=color
        plots, xsize_1d_draw, y2, /device, /continue, color=color
        y_array = [y,y2]
    END
    2:mouse_status_new = mouse_status
    3: mouse_status_new = mouse_status
    4: Begin
        RePlot1DDataFile, Event
        y1 = y_array[0]
        plots, 0, y1, /device, color=color
        plots, xsize_1d_draw, y1, /device, /continue, color=color
        y=event.y
        plots, 0, y, /device, color=color
        plots, xsize_1d_draw, y, /device, /continue, color=color
        y_array = [y1,y]
        mouse_status_new = 5
        END
    5:mouse_status_new = mouse_status
endcase

;signal or peak selection
if (isPeakSelected) then begin  ;peak selection
    (*(*global).data_peak_selection) = y_array
    color = (*global).back_selection_color
    y_array = (*(*global).data_back_selection)
    plots, 0, y_array[0], /device, color=color
    plots, xsize_1d_draw, y_array[0], /device, /continue, color=color
    plots, 0, y_array[1], /device, color=color
    plots, xsize_1d_draw, y_array[1], /device, /continue, color=color
endif else begin                ;background selection
    (*(*global).data_back_selection) = y_array
    color = (*global).peak_selection_color
    y_array = (*(*global).data_peak_selection)
    plots, 0, y_array[0], /device, color=color
    plots, xsize_1d_draw, y_array[0], /device, /continue, color=color
    plots, 0, y_array[1], /device, color=color
    plots, xsize_1d_draw, y_array[1], /device, /continue, color=color
endelse

(*global).select_data_status = mouse_status_new

;update Back and Peak Ymin and Ymax cw_fields
putDataBackgroundPeakYMinMaxValueInTextFields, Event

END

