;This function plots the Main data reduction file for the first time
PRO RefReduction_PlotMainDataReductionFileFirstTime, Event


END



;Function that plots the Main data reduction plot
PRO RefReduction_PlotOutputFiles, Event

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;draw_id = widget_info(Event.top, find_by_uname=uname)
;WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
;wset,view_plot_id

DEVICE, DECOMPOSED = 0
loadct,5

;;retrieve flt0, flt1 and flt2
;   flt0_ptr = (*global).flt0_rescale_ptr
;   flt1_ptr = (*global).flt1_rescale_ptr
;   flt2_ptr = (*global).flt2_rescale_ptr
   
;      flt0 = *flt0_ptr[index_to_plot[i]]
;      flt1 = *flt1_ptr[index_to_plot[i]]
;      flt2 = *flt2_ptr[index_to_plot[i]]
      
END
