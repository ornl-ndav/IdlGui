;+
; :Description:
;    refresh the main plot and automatically scales it to TOF range
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro refresh_data_plot_tof_range, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  tvimg = (*(*global).tvimg_data_ptr)
  sz = size(tvimg)

  ;plot only the range of tof selected
  new_rescaled_tvimg, event, tvimg
  
  IF (getDropListSelectedIndex(Event,'data_rescale_z_droplist') EQ 1) $
    THEN BEGIN                ;log
    
    ;remove 0 values and replace with NAN
    ;and calculate log
    index = where(tvimg eq 0, nbr)
    if (nbr GT 0) then begin
      tvimg[index] = !VALUES.D_NAN
    endif
    tvimg = ALOG10(tvimg)
    tvimg = BYTSCL(tvimg,/NAN)
    
  ENDIF
  
  REFreduction_Rescale_PlotData, Event, tvimg
  
end