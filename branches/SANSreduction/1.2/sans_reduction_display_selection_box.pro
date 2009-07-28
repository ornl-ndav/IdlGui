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

PRO display_selection, Event, x1=x1, y1=y1

  id = WIDGET_INFO(Event.top,find_by_uname='draw_uname')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  xmin = MIN([(*global).x0_device,x1],MAX=xmax)
  ymin = MIN([(*global).y0_device,y1],MAX=ymax)
  
  PLOTS, [xmin, xmin, xmax, xmax, xmin],$
    [ymin,ymax, ymax, ymin, ymin],$
    /DEVICE,$
    LINESTYLE = 3,$
    COLOR = 200
    
END

;------------------------------------------------------------------------------
PRO display_selection_manually, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;get manual x0, y0, width and height
  x0_data = getTextFieldValue(Event,'corner_pixel_x0')
  y0_data = getTextFieldValue(Event,'corner_pixel_y0')
  width_data = getTextFieldValue(Event,'corner_pixel_width')
  height_data = getTextFieldValue(Event,'corner_pixel_height')
  
  x1_data = x0_data + width_data - 1
  y1_data = y0_data + height_data - 1
  
  x0_device = convert_xdata_into_device(Event,x0_data)
  y0_device = convert_ydata_into_device(Event,y0_data)
  x1_device = convert_xdata_into_device(Event,x1_data)
  y1_device = convert_ydata_into_device(Event,y1_data)
  
  (*global).x0_device = x0_device
  (*global).y0_device = y0_device
  
  ;lin_or_log_plot, Event ;refresh of main plot
  display_selection, Event, x1=x1_device, y1=y1_device
  
END

;------------------------------------------------------------------------------
PRO display_excluded_pixels, Event, $
    temp_x_device=temp_x_device, $
    temp_y_device=temp_y_device
    
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  x0_device = (*global).x0_device
  x1_device = (*global).x1_device
  y0_device = (*global).y0_device
  y1_device = (*global).y1_device
  
  IF (x0_device EQ temp_x_device AND $
    y0_device EQ temp_y_device) THEN RETURN
    
  x_device_min = MIN([x0_device,x1_device],MAX=x_device_max)
  y_device_min = MIN([y0_device,y1_device],MAX=y_device_max)
  
  IF (x0_device EQ x1_device AND $
    y0_device EQ y1_device) THEN RETURN
    
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='show_both_banks_button')
  value = WIDGET_INFO(id, /BUTTON_SET)
  coeff = 2
  IF (value EQ 1) THEN coeff = 1
  x_step = coeff * (*global).congrid_x_coeff
  y_step = (*global).congrid_y_coeff
  
  print, x_step
  print, y_step
  
  FOR x=x_device_max, x_device_min, -x_step DO BEGIN
    FOR y=y_device_max, y_device_min, -y_step DO BEGIN
      PLOTS, x, y, COLOR=100, /DEVICE
      PLOTS, x-x_step, y, COLOR=100, /DEVICE, /CONTINUE
      PLOTS, x-x_step, y-y_step, COLOR=100, /DEVICE, /CONTINUE
      PLOTS, x, y-y_step, COLOR=100, /DEVICE, /CONTINUE
      PLOTS, x, y, COLOR=100, /DEVICE, /CONTINUE
    ENDFOR
  ENDFOR
  
END








