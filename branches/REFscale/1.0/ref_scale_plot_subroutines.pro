PRO populate_min_max_axis, Event, $
    flt0, $
    flt1
    
  WIDGET_CONTROL,Event.top, get_uvalue=global
  
  ;populate min/max x/y axis
  min_xaxis = MIN(flt0,max=max_xaxis,/nan)
  min_yaxis = MIN(flt1,max=max_yaxis,/nan)
  ;keep in global value of x and y min and max
  (*(*global).XYMinMax) = [min_xaxis,max_xaxis,$
    min_yaxis,max_yaxis]
    
  ;reduce the number of digit displayed
;  min_xaxis_display = NUMBER_FORMATTER(min_xaxis)
;  max_xaxis_display = NUMBER_FORMATTER(max_xaxis)
;  min_yaxis_display = NUMBER_FORMATTER(min_yaxis)
;  max_yaxis_display = NUMBER_FORMATTER(max_yaxis)

  min_xaxis_display = string(min_xaxis)
  max_xaxis_display = string(max_xaxis)
  min_yaxis_display = string(min_yaxis)
  max_yaxis_display = string(max_yaxis)
  
  PopulateXYScaleAxis, Event, $ ;_put
    min_xaxis_display, $
    max_xaxis_display, $
    min_yaxis_display, $
    max_yaxis_display
    
  CreateDefaultXYMinMax,Event,$ ;_gui
    min_xaxis,$
    max_xaxis,$
    min_yaxis,$
    max_yaxis
  
END