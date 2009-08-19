PRO beam_center_base_gui, wBase, main_base_geometry

  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xsize = 600
  ysize = 500
  
  xoffset = main_base_xoffset + main_base_xsize/2 - xsize/2
  yoffset = main_base_yoffset + main_base_ysize/2 - ysize/2
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'Transmission Calculation Mode',$
    UNAME        = 'transmission_mode_launcher_base',$
    SCR_XSIZE        = xsize, $
    SCR_YSIZE        = ysize, $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    GROUP_LEADER = ourGroup)
    
END