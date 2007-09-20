;This function plots the Main data reduction file for the first time
PRO RefReduction_PlotMainDataReductionFileFirstTime, Event

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

index = 0 ;main output file (.txt)
RefReduction_PlotOutputFiles, Event, index

END



;This function plots the plot selected
PRO RefReduction_PlotMainIntermediateFiles, Event

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if ((*global).DataNeXusFound) then begin

;get index of droplist plot selected
    SelectedIndex = getDropListSelectedIndex(Event,'plots_droplist')
    RefReduction_PlotOutputFiles, Event, SelectedIndex

endif
END





;Function that plots the Main data reduction plot
PRO RefReduction_PlotOutputFiles, Event, index

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

draw_id = widget_info(Event.top, find_by_uname='main_plot_draw')
WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
wset,view_plot_id

DEVICE, DECOMPOSED = 0
loadct,5

;retrieve flt0, flt1 and flt2
flt0_ptr = (*global).flt0_ptr
flt1_ptr = (*global).flt1_ptr
flt2_ptr = (*global).flt2_ptr

flt0 = *flt0_ptr[index]
flt1 = *flt1_ptr[index]
flt2 = *flt2_ptr[index]

;print, flt0 ;REMOVE_ME
;print, flt1 ;REMOVE_ME
   
err_plot = 0
CATCH, err_plot
if (err_plot NE 0) then begin

    CATCH,/cancel

;show error message base    
    MapStatus = 1

;informs user that current file does not have enough data to show
;something
    CurrentFilePlotted = getDropListSelectedValue(Event, 'plots_droplist')
    message = 'ERROR: ' + CurrentFilePlotted
    message += ': not enough data to plot !'
    putTextFieldValue, event, 'plots_error_message', message, 0

endif else begin

;display full name of file plotted
;#1 get index of droplist
    index = getDropListSelectedIndex(Event, 'plots_droplist')
    
;#2 get full name of file
    ListOfFiles = (*(*global).FilesToPlotList)
    FullFileName = ListOfFiles[index]
    
;#3 put name in text field
    message = 'File currently displayed: ' + FullFileName
    putTextFieldValue, event, 'plots_error_message', message, 0

;Hide error message base    
    MapStatus = 1

    plot,flt0,flt1
    errplot, flt0,flt1-flt2,flt1+flt2

endelse

MapBase, Event, 'plots_error_base', MapStatus

END
