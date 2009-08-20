PRO plot_data_for_beam_center_base, $
    EVENT=event, $
    base=base, $
    MAIN_GLOBAL=main_global, $
    GLOBAL_BC = global_bc
    
  min_pixel = (*global_bc).min_pixel_plotted
  max_pixel = (*global_bc).max_pixel_plotted
  min_tube  = (*global_bc).min_tube_plotted
  max_tube  = (*global_bc).max_tube_plotted
  
  both_banks = (*(*main_global).both_banks)
  zoom_data = both_banks[*,min_pixel:max_pixel,min_tube:max_tube]
  t_zoom_data = TOTAL(zoom_data,1)
  tt_zoom_data = TRANSPOSE(t_zoom_data)
  (*(*global_bc).tt_zoom_data) = tt_zoom_data
  rtt_zoom_data = CONGRID(tt_zoom_data, 400,350)
  (*(*global_bc).rtt_zoom_data) = rtt_zoom_data
  
  id = WIDGET_INFO(base,FIND_BY_UNAME='beam_center_main_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  TVSCL, rtt_zoom_data
  
END
