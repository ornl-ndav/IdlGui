;+
; :Description:
;    This routine will display the zoomed data
;
;
;
; :Keywords:
;    event
;    base
;    recalculate
;
; :Author: j35
;-
pro plot_normalized_data, event=event, base=base, recalculate=recalculate
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    widget_control, event.top, get_uvalue=global_preview
    base = (*global_preview)._base
  endif else begin
    widget_control, base, get_uvalue=global_preview
  endelse
  
  ;set where we want to display the plot
  id = widget_info(base,find_by_uname='normalized_draw')
  widget_control, id, get_value=plot_id
  wset, plot_id
  
  ;get the size of the plot
  draw_geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = draw_geometry.xsize
  ysize = draw_geometry.ysize
  
  if (keyword_set(recalculate)) then begin
  
;    global = (*global_preview).global
    data = (*(*global_preview).data)
    cData = congrid(data, xsize, ysize)
    (*(*global_preview).cData) = cData
    tvscl, cData
    
;    save_zoom_data_background, event=event, base=base
;    return
    
  endif else begin
  
;    tv, (*(*global_preview).background), true=3
    
  endelse
  
end

;+
; :Description:
;    This will display the scale that surrounds the plot
;    ex: [2048,2048]
;
;
;
; :Keywords:
;    base
;    event
;
; :Author: j35
;-
pro plot_scale_normalized_data, base=base, event=event
  compile_opt idl2
  
  if (n_elements(base) ne 0) then begin
    id = widget_info(base,find_by_Uname='normalized_scale')
    sys_color = widget_info(base,/system_colors)
    widget_control, base, get_uvalue=global_preview
  endif else begin
    id = widget_info(event.top, find_by_uname='normalized_scale')
    sys_color = widget_info(event.top, /system_colors)
    widget_control, event.top, get_uvalue=global_preview
  endelse
  
  widget_control, id, get_value=id_value
  wset, id_value
  
  ;change color of background
  device, decomposed=1
  sys_color_window_bk = sys_color.window_bk
  
  x_range = (*global_preview).xrange
  min_x = x_range[0]
  max_x = x_range[-1]
  
  y_range = (*global_preview).yrange
  min_y = y_range[0]
  max_y = y_range[-1]
  
  ;  ;determine the number of xaxis data to show
  ;  geometry = widget_info(id_base,/geometry)
  ;  xsize = geometry.scr_xsize
  
  xticks = 16
  yticks = 32
  
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
    ;    XTITLE      = 'Pixels',$
    ;    YTITLE      = 'Pixels',$
    XMARGIN     = [xmargin, xmargin+0.2],$
    YMARGIN     = [ymargin, ymargin],$
    /NODATA
  axis, yaxis=1, YRANGE=y_range, YTICKS=yticks, YSTYLE=1, $
    COLOR=convert_rgb([0B,0B,255B]), TICKLEN = ticklen
  axis, xaxis=1, XRANGE=x_range, XTICKS=xticks, XSTYLE=1, $
    COLOR=convert_rgb([0B,0B,255B]), TICKLEN = ticklen
    
  device, decomposed=0
  
end

;+
; :Description:
;    Display the colorbar on the right size of the plot
;
;
;
; :Keywords:
;    base
;    event
;
; :Author: j35
;-
pro plot_colorbar_normalized_data, base=base, event=event
  compile_opt idl2
  
  if (n_elements(event) ne 0) then begin
    id_draw = widget_info(event.top,find_by_uname='normalized_colorbar')
    widget_control, event.top, get_uvalue=global_preview
  endif else begin
    id_draw = widget_info(base, find_by_uname='normalized_colorbar')
    widget_control, base, get_uvalue=global_preview
  endelse
  widget_control, id_draw, get_value=id_value
  wset,id_value
  erase
  
  data = (*(*global_preview).data)
  zmin = min(data, max=zmax)
  
  default_scale_setting = (*global_preview).default_scale_setting
  if (default_scale_setting eq 0) then begin ;linear
  
    divisions = 20
    perso_format = '(e8.1)'
    range = [zmin,zmax]
    colorbar, $
      NCOLORS      = 255, $
      POSITION     = [0.75,0.01,0.95,0.99], $
      RANGE        = range,$
      DIVISIONS    = divisions,$
      PERSO_FORMAT = perso_format,$
      /VERTICAL
      
  endif else begin
  
    divisions = 10
    perso_format = '(e8.1)'
    range = float([zmin,zmax])
    
    if (default_loadct eq 6) then begin
      colorbar, $
        AnnotateColor = 'white',$
        NCOLORS      = 255, $
        POSITION     = [0.75,0.01,0.95,0.99], $
        RANGE        = range,$
        DIVISIONS    = divisions,$
        PERSO_FORMAT = perso_format,$
        /VERTICAL,$
        ylog = 1
        
    endif else begin
    
      colorbar, $
        NCOLORS      = 255, $
        POSITION     = [0.75,0.01,0.95,0.99], $
        RANGE        = range,$
        DIVISIONS    = divisions,$
        PERSO_FORMAT = perso_format,$
        /VERTICAL,$
        ylog = 1
        
    endelse
    
  endelse
  
end