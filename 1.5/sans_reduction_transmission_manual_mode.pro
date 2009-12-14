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

PRO transmission_manual_mode_gui, wBase, main_base_geometry, sys_color_window_bk

  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xsize = 700 ;width of various steps of manual mode
  ysize = 840 ;height of various steps of manual mode
  
  xoffset = main_base_xoffset + main_base_xsize/2-xsize/2
  yoffset = main_base_yoffset + main_base_ysize/2-ysize/2
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'Transmission Calculation -> STEP 1/3: ' + $
    'Define Beam Stop Region',$
    UNAME        = 'transmission_manual_mode_base',$
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    /BASE_ALIGN_CENTER,$
    GROUP_LEADER = ourGroup)
    
  ;design step1
  step1_base = design_transmission_manual_mode_step1(wBase)
  
  ;design step2
  step2_base = design_transmission_manual_mode_step2(wBase)
  
  ;design step3
  step3_base = design_transmission_manual_mode_step3(wBase)
  
  WIDGET_CONTROL, wBase, /REALIZE
  
  plot_transmission_step1_scale, step1_base, sys_color_window_bk
  
END

;------------------------------------------------------------------------------
PRO plot_data_around_beam_stop, EVENT=event, MAIN_BASE=wBase, $
    global, $
    global_step1
    
  both_banks = (*(*global).both_banks)
  zoom_data = both_banks[*,112:151,80:111]
  
  t_zoom_data = TOTAL(zoom_data,1)
  tt_zoom_data = TRANSPOSE(t_zoom_data)
  (*(*global_step1).tt_zoom_data) = tt_zoom_data
  rtt_zoom_data = CONGRID(tt_zoom_data, 450, 400)
  (*(*global_step1).rtt_zoom_data) = rtt_zoom_data
  
  id = WIDGET_INFO(wBase,FIND_BY_UNAME='manual_transmission_step1_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  TVSCL, rtt_zoom_data
  
END

;------------------------------------------------------------------------------
PRO refresh_transmission_manual_step1_main_plot, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_step1
  
  data = (*(*global_step1).rtt_zoom_data)
  
  IF (~isTranManualStep1LinSelected(Event)) THEN BEGIN ;log mode
    index = WHERE(data EQ 0, nbr)
    IF (nbr GT 0) THEN BEGIN
      data[index] = !VALUES.D_NAN
    ENDIF
    Data_log = ALOG10(Data)
    Data_log_bytscl = BYTSCL(Data_log,/NAN)
    data = data_log_bytscl
  ENDIF
  
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='manual_transmission_step1_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  DEVICE, DECOMPOSED = 0
  LOADCT,5,/SILENT
  
  TVSCL, data, /DEVICE
  
  save_transmission_manual_step1_background,  EVENT=Event
  
END

;------------------------------------------------------------------------------
PRO plot_trans_manual_step1_background, Event

  ;get global structure
  WIDGET_CONTROL,event.top,GET_UVALUE=global
  
  id = WIDGET_INFO(event.top,FIND_BY_UNAME='manual_transmission_step1_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  TV, (*(*global).background), true=3
  
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
PRO transmission_manual_Cleanup, tlb

  WIDGET_CONTROL, tlb, GET_UVALUE=global, /NO_COPY
  IF N_ELEMENTS(global) EQ 0 THEN RETURN
  
  ; Free up the pointers
  PTR_FREE, (*global).background
  PTR_FREE, (*global).rtt_zoom_data
  PTR_FREE, (*global).tt_zoom_data
  PTR_FREE, (*global).counts_vs_x
  PTR_FREE, (*global).counts_vs_y
  PTR_FREE, (*global).pixel_x_axis
  PTR_FREE, (*global).tube_x_axis
  PTR_FREE, (*global).counts_vs_xy
  PTR_FREE, (*global).trans_manual_step2.user_counts_vs_xy
  PTR_FREE, (*global).trans_manual_step2.xaxis
  PTR_FREE, (*global).trans_manual_step2.yaxis
  PTR_FREE, (*global).trans_peak_tube
  PTR_FREE, (*global).trans_peak_pixel
  PTR_FREE, (*global).top_plot_background_with_right_tube
  PTR_FREE, (*global).top_plot_background_with_left_tube
  PTR_FREE, (*global).bottom_plot_background_with_right_pixel
  PTR_FREE, (*global).bottom_plot_background_with_left_pixel
  PTR_FREE, (*global).user_counts_vs_xy
  PTR_FREE, (*global).step3_3d_data
  PTR_FREE, (*global).step3_tt_zoom_data
  PTR_FREE, (*global).step3_rtt_zoom_data
  PTR_FREE, (*global).step3_counts_vs_x
  PTR_FREE, (*global).step3_counts_vs_y
  PTR_FREE, (*global).step3_background
  PTR_FREE, (*global).tof_array
  PTR_FREE, (*global).transmission_peak_value
  PTR_FREE, (*global).transmission_peak_error_value
  PTR_FREE, (*global).transmission_lambda_axis
  PTR_FREE, global
  
END

;------------------------------------------------------------------------------
PRO launch_transmission_manual_mode_base, main_event

  id = WIDGET_INFO(main_event.top, FIND_BY_UNAME='MAIN_BASE')
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;get global structure
  WIDGET_CONTROL,main_event.top,GET_UVALUE=global
  
  ;build gui
  wBase = ''
  sys_color_window_bk = 0
  transmission_manual_mode_gui, wBase, $
    main_base_geometry, sys_color_window_bk
    
  (*global).transmission_manual_mode_id = wBase
    
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
    
    trans_output_file_name: '', $
    
    main_event: main_event})
    
  WIDGET_CONTROL, wBase, SET_UVALUE = global_step1
  XMANAGER, "launch_transmission_manual_mode", wBase, $
    GROUP_LEADER = ourGroup, /NO_BLOCK, CLEANUP='transmission_manual_Cleanup'
    
  plot_data_around_beam_stop, main_base=wBase, global, global_step1
  
  ;save background
  save_transmission_manual_step1_background,  Event=event, MAIN_BASE=wBase
  
  ;get TOF array
  ;tof_array = getTOFarray(Event, (*global).data_nexus_file_name)
  (*(*global_step1).tof_array) = (*(*global).tof_array)
  
END
