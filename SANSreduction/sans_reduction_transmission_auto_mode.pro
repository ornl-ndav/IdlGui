;==============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================

PRO launch_transmission_auto_mode_event, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  CASE Event.id OF
  
    WIDGET_INFO(Event.top, FIND_BY_UNAME='trans_auto_ok_button'): BEGIN
      id = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='transmission_auto_mode_base')
      WIDGET_CONTROL, id, /DESTROY
    END
    
    ELSE:
    
  ENDCASE
  
END

;------------------------------------------------------------------------------
PRO transmission_auto_mode_gui, wBase, main_base_geometry, sys_color_window_bk

  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xsize = 950 ;width of various steps of manual mode
  ysize = 900 ;height of various steps of manual mode
  
  xoffset = main_base_xoffset + main_base_xsize/2-xsize/2
  yoffset = main_base_yoffset + main_base_ysize/2-ysize/2
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'Automatic Transmission Calculation', $
    UNAME        = 'transmission_auto_mode_base',$
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    /BASE_ALIGN_CENTER,$
    GROUP_LEADER = ourGroup)
    
  base = design_transmission_auto_mode(wBase)
  
  WIDGET_CONTROL, wBase, /REALIZE
  
  plot_transmission_auto_scale, base, sys_color_window_bk
  
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
PRO launch_transmission_auto_mode_base, main_event

  id = WIDGET_INFO(main_event.top, FIND_BY_UNAME='MAIN_BASE')
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;get global structure
  WIDGET_CONTROL,main_event.top,GET_UVALUE=global
  
  ;build gui
  wBase = ''
  sys_color_window_bk = 0
  transmission_auto_mode_gui, wBase, $
    main_base_geometry, sys_color_window_bk
    
  global_step1 = PTR_NEW({ wbase: wbase,$
    global: global,$
    background: PTR_NEW(0L), $
    rtt_zoom_data: PTR_NEW(0L), $
    tt_zoom_data: PTR_NEW(0L), $
    counts_vs_x: PTR_NEW(0L), $
    counts_vs_y: PTR_NEW(0L), $
    pixel_x_axis: PTR_NEW(0L), $
    tube_x_axis: PTR_NEW(0L), $
    counts_vs_xy: PTR_NEW(0L), $
    trans_manual_step2_background: 0L, $
    trans_manual_step2_transmission_intensity: 0L, $
    left_button_clicked: 0, $
    sys_color_window_bk: sys_color_window_bk, $
    working_with_xy: 0, $ ;step1
    
    trans_manual_step2_ymin_device: 40,$
    trans_manual_step2_ymax_device: 390,$
    trans_manual_step2_xmin_device: 61, $
    trans_manual_step2_xmax_device: 523, $
    
    trans_manual_step2: { user_counts_vs_xy: PTR_NEW(0L), $
    xaxis: PTR_NEW(0L), $
    yaxis: PTR_NEW(0L), $
    average_value: 0. }, $
    trans_manual_3dview_status: 'disable', $
    
    selection_not_working_color: 'deep pink', $
    selection_working_color: 'red', $
    
    trans_manual_step2_top_plot_ymin_data: 0L,$
    trans_manual_step2_top_plot_ymax_data: 0L,$
    trans_manual_step2_top_plot_xmin_data: 0L,$
    trans_manual_step2_top_plot_xmax_data: 0L,$
    
    trans_manual_step2_bottom_plot_ymin_data: 0L,$
    trans_manual_step2_bottom_plot_ymax_data: 0L,$
    trans_manual_step2_bottom_plot_xmin_data: 0L,$
    trans_manual_step2_bottom_plot_xmax_data: 0L, $
    
    need_to_reset_trans_step2: 1, $ ;will go to 1 everytime the selection of step1 changes
    
    trans_peak_tube: PTR_NEW(0L), $
    trans_peak_pixel: PTR_NEW(0L), $
    
    top_plot_background_with_right_tube: PTR_NEW(0L),$
    top_plot_background_with_left_tube: PTR_NEW(0L),$
    bottom_plot_background_with_right_pixel: PTR_NEW(0L),$
    bottom_plot_background_with_left_pixel: PTR_NEW(0L),$
    ;    bottom_plot_background: PTR_NEW(0L),$
    step2_tube_right: 0., $
    step2_tube_left: 0., $
    step2_pixel_left: 0., $
    step2_pixel_right: 0., $
    user_counts_vs_xy: PTR_NEW(0L),$
    
    working_with_tube: 1 ,$ ;step2 left or right
    working_with_pixel: 1, $ ;step2 bottom (1) or top (2) pixel
    tube_pixel_min_max: INTARR(4),$
    xoffset_plot: 80L,$
    yoffset_plot: 112L, $
    
    ;step3
    both_banks: (*(*global).both_banks), $
    step3_3d_data: PTR_NEW(0L), $
    step3_tt_zoom_data: PTR_NEW(0L), $
    step3_rtt_zoom_data: PTR_NEW(0L), $
    step3_xoffset_plot: 84L,$
    step3_yoffset_plot: 116L, $
    step3_counts_vs_x: PTR_NEW(0L), $
    step3_counts_vs_y: PTR_NEW(0L), $
    step3_tube_min: 0, $
    step3_tube_max: 0, $
    step3_pixel_min: 0, $
    step3_pixel_max: 0, $
    step3_background: PTR_NEW(0L), $
    trans_manual_step3_refresh: 1, $
    x0y0x1y1: INTARR(4), $
    
    tof_array: PTR_NEW(0L), $
    transmission_peak_value: PTR_NEW(0L), $
    transmission_peak_error_value: PTR_NEW(0L), $
    transmission_lambda_axis: PTR_NEW(0L), $
    
    beam_center_bank_tube_pixel: INTARR(3), $
    
    main_event: main_event})
    
  WIDGET_CONTROL, wBase, SET_UVALUE = global_step1
  XMANAGER, "launch_transmission_auto_mode", wBase, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
  ; plot_data_around_beam_stop, main_base=wBase, global, global_step1
    
  ;get TOF array
  tof_array = getTOFarray(Event, (*global).data_nexus_file_name)
  (*(*global_step1).tof_array) = tof_array
  
END

