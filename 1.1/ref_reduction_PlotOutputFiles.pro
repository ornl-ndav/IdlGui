;This function plots the Main data reduction file for the first time
PRO RefReduction_PlotMainDataReductionFileFirstTime, Event

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

index = 0 ;main output file (.txt)
RefReduction_PlotOutputFiles, Event, index

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

file_path    = getOutputPathFromButton(Event)
file_name    = getOutputFileName(Event)
FullFileName = STRING(file_path + file_name)

;retrieve flt0, flt1 and flt2
flt0_ptr = (*global).flt0_ptr
flt1_ptr = (*global).flt1_ptr
flt2_ptr = (*global).flt2_ptr

flt0 = *flt0_ptr[index]
flt1 = *flt1_ptr[index]
flt2 = *flt2_ptr[index]
   
err_plot = 0
CATCH, err_plot
IF (err_plot NE 0) THEN BEGIN

    CATCH,/CANCEL

;show error message base    
    MapStatus = 1

;informs user that current file does not have enough data to show
;something
    message = 'ERROR: ' + FullFileName[0]
    message += ': not enough data to plot !'
    putTextFieldValue, event, 'plots_error_message', message, 0

ENDIF ELSE BEGIN

    message = 'File currently displayed: ' + FullFileName[0]
    putTextFieldValue, event, 'plots_error_message', message[0], 0

;Show error message base    
    MapStatus = 1

    plot,flt0,flt1
    errplot, flt0,flt1-flt2,flt1+flt2

ENDELSE

MapBase, Event, 'plots_error_base', MapStatus

END
