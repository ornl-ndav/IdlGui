;+
; :Description:
;    Plot the scale around the plot
;
; :Params:
;    base
;
; :Author: j35
;-
pro plot_reduce_tab2_scale, base=base, event=event, plot_range=plot_range
  compile_opt idl2
  
  if (n_elements(base) ne 0) then begin
    id = widget_info(base,find_by_Uname='reduce_step2_scale_uname')
    id_base = widget_info(base, find_by_uname='MAIN_BASE')
    sys_color = widget_info(base,/system_colors)
    widget_control, base, get_uvalue=global
  endif else begin
    id = widget_info(event.top, find_by_uname='reduce_step2_scale_uname')
    id_base = widget_info(event.top, find_by_uname='MAIN_BASE')
    sys_color = widget_info(event.top, /system_colors)
    widget_control, event.top, get_uvalue=global
  endelse
  
  widget_control, id, get_value=id_value
  wset, id_value
  
  ;change color of background
  device, decomposed=1
  sys_color_window_bk = sys_color.window_bk

  ;pixel axis
  y_range = [0, (*global).detector_pixels_y]
  max_y = y_range[1]
  
  ;tof axis
  tof = (*(*global).norm_tof)
  
   if (keyword_set(plot_range)) then begin
    
      tof1 = getTextFieldValue(event,'reduce_step2_tof1')
      tof2 = getTextFieldValue(event,'reduce_step2_tof2')
      
      _tof1 = float(tof1)
      _tof2 = float(tof2)
      
      tof = (*(*global).norm_tof)
      
      index_tof1 = getIndexOfValueInArray(array=tof, value=_tof1*1000, from=1)
      index_tof2 = getIndexOfValueInArray(array=tof, value=_tof2*1000, to=1)
      
      index_tof_min = min([index_tof1,index_tof2],max=index_tof_max)
      _tof_min = tof[index_tof_min]
      _tof_max = tof[index_tof_max]
      
      x_range = [_tof_min, _tof_max] /1000
      
    endif else begin

  x_range = [tof[0],tof[-1]]/1000.
  
  endelse
  
  ;determine the number of xaxis data to show
  geometry = widget_info(id_base,/geometry)
  xsize = geometry.scr_xsize
  
  xticks = 8
  yticks = max_y/8
  
  xmargin = 6.6
  ymargin = 4
  
  ticklen = -0.0015
  
  plot, randomn(s,80), $
    XRANGE     = x_range,$
    YRANGE     = y_range,$
    COLOR      = convert_rgb([0B,0B,255B]), $
    BACKGROUND = convert_rgb(sys_color_window_bk),$
    THICK      = 0.5, $
    TICKLEN    = ticklen, $
    XTICKLAYOUT = 0,$
    XSTYLE      = 1,$
    YSTYLE      = 1,$
    YTICKLAYOUT = 0,$
    XTICKS      = xticks,$
    XMINOR      = 2,$
    ;YMINOR      = 2,$
    YTICKS      = yticks,$
    XTITLE      = 'TOF (ms)',$
    YTITLE      = 'Pixels',$
    XMARGIN     = [xmargin, xmargin+0.2],$
    YMARGIN     = [ymargin, ymargin],$
    /NODATA
  axis, yaxis=1, YRANGE=y_range, YTICKS=yticks, YSTYLE=1, $
    COLOR=convert_rgb([0B,0B,255B]), TICKLEN = ticklen
  axis, xaxis=1, XRANGE=x_range, XTICKS=xticks, XSTYLE=1, $
    COLOR=convert_rgb([0B,0B,255B]), TICKLEN = ticklen
    
  device, decomposed=0
  
end