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

PRO refresh_trans_manual_step2_plots_counts_vs_x_and_y, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH, /CANCEL
    RETURN
  ENDIF
  
  x0y0x1y1 = (*global).x0y0x1y1
  x0 = x0y0x1y1[0]
  y0 = x0y0x1y1[1]
  x1 = x0y0x1y1[2]
  y1 = x0y0x1y1[3]
  
  IF (x0 + y0 NE 0 AND $
    x1 + y1 NE 0) THEN BEGIN
    
    counts_vs_x = (*(*global).counts_vs_x)
    counts_vs_y = (*(*global).counts_vs_y)
    
    ;plot data
    ;Counts vs tube (integrated over y)
    x_axis = (*(*global).tube_x_axis)
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME='trans_manual_step2_counts_vs_x')
    WIDGET_CONTROL, id, GET_VALUE=id_value
    WSET, id_value
    plot, x_axis, counts_vs_x, XSTYLE=1, XTITLE='Tube #', YTITLE='Counts', $
      TITLE = 'Counts vs tube integrated over pixel'
      
    ;Counts vs tube (integrated over x)
    x_axis = (*(*global).pixel_x_axis)
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME='trans_manual_step2_counts_vs_y')
    WIDGET_CONTROL, id, GET_VALUE=id_value
    WSET, id_value
    plot, x_axis, counts_vs_y, XSTYLE=1, XTITLE='Pixel #', YTITLE='Counts', $
      TITLE = 'Counts vs pixel integrated over tube'
      
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO display_trans_step2_algorith_image, Event

  ;get global structure
  WIDGET_CONTROL,event.top,GET_UVALUE=global
  
  ;build gui
  wBase = ''
  transmission_manual_mode_step2_info_gui, Event, wBase
  
  XMANAGER, "display_trans_step2_algorith_image", wBase, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
END

;------------------------------------------------------------------------------
PRO transmission_manual_mode_step2_info_gui, Event, wBase

  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='transmission_manual_mode_base')
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  xsize = 500
  ysize= 375
  xoffset = main_base_xoffset + main_base_xsize/2-xsize/2
  yoffset = main_base_yoffset + main_base_ysize/2-ysize/2
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'Algorithm used to calculate Background',$
    MAP          = 1,$
    XOFFSET = xoffset,$
    YOFFSET = yoffset,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    GROUP_LEADER = ourGroup)
    
  draw = WIDGET_DRAW(wBase,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    UNAME = 'trans_manual_step2_image')
    
  WIDGET_CONTROL, wBase, /REALIZE
  
  image = READ_PNG('SANSreduction_images/algorithm_engine.png')
  mode_id = WIDGET_INFO(wBase, $
    FIND_BY_UNAME='trans_manual_step2_image')
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, image, 0, 0,/true
  
END

;------------------------------------------------------------------------------
PRO trans_manual_step2_calculate_background, Event

  ;get global structure
  WIDGET_CONTROL,event.top,GET_UVALUE=global
  
  counts_vs_xy = (*(*global).counts_vs_xy)
  ;counts_vs_x = (*(*global).counts_vs_x)
  ;counts_vs_y = (*(*global).counts_vs_y)
  
  nbr_pixels = N_ELEMENTS(counts_vs_xy)
  
  s_nbr_iterations = getTextFieldValue(Event,$
    'trans_manual_step2_nbr_iterations')
  nbr_iterations = FIX(s_nbr_iterations)
  average = FLTARR(nbr_iterations)
  
  array = counts_vs_xy
  index = 0
  WHILE (index LT nbr_iterations) DO BEGIN
    IF (index NE 0) THEN BEGIN
      array_list = WHERE(array LE average[index-1],counts)
      IF (counts GT 0) THEN BEGIN
        array[array_list] = 0
      ENDIF
    ENDIF
    total = TOTAL(array)
    average_value = FLOAT(total)/FLOAT(nbr_pixels)
    plot_average_value, Event, average_value, index
    average[index] = average_value
    index++
  ENDWHILE
  
  background = FIX(average_value)
  s_background = STRCOMPRESS(background,/REMOVE_ALL)
  putTextFieldValue, Event, 'trans_manual_step2_background_value', s_background
  
END

;------------------------------------------------------------------------------
PRO plot_average_value, Event, average_value

  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='trans_manual_step2_counts_vs_x')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  plot, x_axis, counts_vs_x, XSTYLE=1, XTITLE='Tube #', YTITLE='Counts', $
    TITLE = 'Counts vs tube integrated over pixel'
    
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='trans_manual_step2_counts_vs_y')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  plot, x_axis, counts_vs_y, XSTYLE=1, XTITLE='Pixel #', YTITLE='Counts', $
    TITLE = 'Counts vs pixel integrated over tube'
    
    
END
