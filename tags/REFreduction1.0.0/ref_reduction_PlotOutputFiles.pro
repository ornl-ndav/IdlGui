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

;get index of droplist plot selected
SelectedIndex = getDropListSelectedIndex(Event,'plots_droplist')


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

print, flt0
print, flt1
   

plot,flt0,flt1
errplot, flt0,flt1-flt2,flt1+flt2

END
