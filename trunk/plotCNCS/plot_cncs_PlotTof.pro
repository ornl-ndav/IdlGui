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

PRO MakeGuiTofBase_Event, event

  WIDGET_CONTROL, event.top, GET_UVALUE=global3
  
  CASE event.id OF
    widget_info(event.top, FIND_BY_UNAME='tof_plot_draw'): begin
    
      IF (Event.press EQ 1) THEN BEGIN ;left mouse pressed
        (*global3).left_mouse_pressed = 1
        PressMouseInTOF, Event
        CURSOR, X, Y, /data, /nowait
        (*global3).x0_data = X
        (*global3).y0_data = Y
        (*global3).x0_device = Event.x
        (*global3).y0_device = Event.y
      ENDIF
      
      IF (Event.type EQ 2) THEN BEGIN ;moving mouse with left button clicked
        IF ((*global3).left_mouse_pressed) THEN BEGIN
          (*global3).x1_device = Event.x
          (*global3).y1_device = Event.y
          RefreshPlotInTof, Event
          plotSelection_inTofPlot, Event
        ENDIF
      ENDIF
      
      IF (Event.release EQ 1) THEN BEGIN ;left mouse released
        ;ReleaseMouseInTof, Event
        CURSOR, X, Y, /data, /nowait
        (*global3).x1_data = X
        (*global3).y1_data = Y
        (*global3).left_mouse_pressed = 0
      ENDIF
    END
    
    widget_info(event.top, FIND_BY_UNAME='linear_scale'): begin
      id = widget_info(Event.top,find_by_uname='plot_scale_type')
      widget_control, id, set_value='Linear Y-axis      '
      RefreshPlotInTof, Event
    END
    
    widget_info(event.top, FIND_BY_UNAME='log_scale'): begin
      id = widget_info(Event.top,find_by_uname='plot_scale_type')
      widget_control, id, set_value='Logarithmic Y-axis'
      RefreshPlotInTof, Event
    END
    
    ELSE:
  ENDCASE
  
END

;------------------------------------------------------------------------------
PRO plotSelection_inTofPlot, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global3
  
  x0 = (*global3).x0_device
  x1 = (*global3).x1_device
  y0 = (*global3).y0_device
  y1 = (*global3).y1_device
  
  IF (x0 EQ 0. AND x1 EQ 0.) THEN RETURN
  
  xmin = MIN([x0,x1], MAX=xmax)
  ymin = MIN([y0,y1], MAX=ymax)
  
  DEVICE, DECOMPOSED=0
  LOADCT, 5, /SILENT
  
  color = 150
  
  id = WIDGET_INFO(Event.top,find_by_uname='tof_plot_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  PLOTS, [xmin, xmin, xmax, xmax, xmin],$
    [ymin,ymax, ymax, ymin, ymin],$
    /DEVICE,$
    LINESTYLE = 3,$
    COLOR =color
    
END

;------------------------------------------------------------------------------
PRO PlotTof, img, bank, xLeft, yLeft, xRight, yRight, pixelID, tmpImg
  ;build gui
  wBase = ''
  MakeGuiTofBase, wBase
  
  global3 = ptr_new({ wbase: wbase,$
    IvsTOF: ptr_new(0L),$
    true_x_min: 0.00000001,$
    true_x_max: 0.000000001,$
    xmin_for_refresh: 0,$
    xmax_for_refresh: 0,$
    left_mouse_pressed: 0,$
    tof: 0L,$
    x0_data: 0.,$
    y0_data: 0.,$
    x1_data: 0.,$
    y1_data: 0.,$
    x0_device: 0.,$
    y0_device: 0.,$
    x1_device: 0.,$
    y1_device: 0.,$
    tvimg: ptr_new(0L),$
    img: img})
    
  WIDGET_CONTROL, wBase, SET_UVALUE = global3
  XMANAGER, "MakeGuiTofBase", wBase, GROUP_LEADER = ourGroup,/NO_BLOCK
  
  DEVICE, DECOMPOSED = 0
  loadct, 5, /SILENT
  
  ;select plot area
  id = widget_info(wBase,find_by_uname='tof_plot_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  ;display bank number in title bar
  id = widget_info(wBase,find_by_uname='tof_plot_base')
  title = 'Counts vs TOF - '
  title += '(Bank:' + strcompress(bank,/remove_all)
  real_pixelID = pixelID + 1024L * (FIX(bank)-1)
  IF ((size(pixelID))(1) EQ 1) THEN BEGIN
    title += ' ,X:' + strcompress(xRight,/remove_all)
    title += ' ,Y:' + strcompress(yRight,/remove_all)
    title += ' ,PixelID:' + strcompress(real_pixelID[0],/remove_all)
  ENDIF ELSE BEGIN
    nbr = (size(pixelID))(1)
    title += ' ,Tube:'+strcompress(xLeft,/remove_all)
    title += '->'+strcompress(xRight,/remove_all)
    title += ' ,Row:'+strcompress(yLeft,/remove_all)
    title += '->'+strcompress(yRight,/remove_all)
    title += ' , Number of Pixel selected:'+strcompress(nbr,/remove_all)
  ENDELSE
  title += ')'
  widget_control, id, base_set_title= title
  
  ;plot data
  tof = (size(img))(1)
  (*global3).tof = tof
  
  tof_array = REFORM(img,tof,400L*128L)
  IvsTOF = tof_array(*,real_pixelID)
  sz = (size(IvsTOF))(0)
  IF (sz EQ 2) THEN BEGIN
    IvsTOF = total(IvsTOF,2)
  ENDIF
  (*(*global3).IvsTOF) = IvsTOF
  plot, IvsTOF, FONT='8x13'
  
  id = widget_info(wBase,find_by_uname='preview_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  tv, tmpImg
  
END
