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

PRO plot_ascii_tools_base_event, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_tools
  global = (*global_tools).global
  main_event = (*global_tools).main_event
  
  CASE Event.id OF
  
    ;lin/log
    WIDGET_INFO(Event.top, FIND_BY_UNAME='y_axis_lin'): BEGIN
      plot_ascii_file, main_event=main_event
      (*global).lin_log_yaxis = 'lin'
    END
    WIDGET_INFO(Event.top, FIND_BY_UNAME='y_axis_log'): BEGIN
      plot_ascii_file, main_event=main_event
      (*global).lin_log_yaxis = 'log'
    END
    
    ;yaxis type
    WIDGET_INFO(Event.top, FIND_BY_UNAME='y_axis_type_y'): BEGIN
      plot_ascii_file, main_event=main_event
      (*global).yaxis_type = 'Y'
    END
    WIDGET_INFO(Event.top, FIND_BY_UNAME='y_axis_type_yx4'): BEGIN
      plot_ascii_file, main_event=main_event
      (*global).yaxis_type = 'YX4'
    END
    
    ;x1, x2, y1 and y2
    WIDGET_INFO(Event.top, FIND_BY_UNAME='plot_ascii_tools_x1'): BEGIN
      x1 = getTextFieldValue(event, 'plot_ascii_tools_x1')
      y1 = getTextFieldValue(event, 'plot_ascii_tools_y1')
      x2 = getTextFieldValue(event, 'plot_ascii_tools_x2')
      y2 = getTextFieldValue(event, 'plot_ascii_tools_y2')
      (*global).x0y0x1y1 = [x1,y1,x2,y2]
      sort_x0y0x1y1, main_Event
      repopulate_plot_ascii_tools_x0y0x1y1, Event
      plotAsciiData, main_event=main_event
    END
    WIDGET_INFO(Event.top, FIND_BY_UNAME='plot_ascii_tools_x2'): BEGIN
      x1 = getTextFieldValue(event, 'plot_ascii_tools_x1')
      y1 = getTextFieldValue(event, 'plot_ascii_tools_y1')
      x2 = getTextFieldValue(event, 'plot_ascii_tools_x2')
      y2 = getTextFieldValue(event, 'plot_ascii_tools_y2')
      (*global).x0y0x1y1 = [x1,y1,x2,y2]
      sort_x0y0x1y1, main_Event
      repopulate_plot_ascii_tools_x0y0x1y1, Event
      plotAsciiData, main_event=main_event
    END
    WIDGET_INFO(Event.top, FIND_BY_UNAME='plot_ascii_tools_y1'): BEGIN
      x1 = getTextFieldValue(event, 'plot_ascii_tools_x1')
      y1 = getTextFieldValue(event, 'plot_ascii_tools_y1')
      x2 = getTextFieldValue(event, 'plot_ascii_tools_x2')
      y2 = getTextFieldValue(event, 'plot_ascii_tools_y2')
      (*global).x0y0x1y1 = [x1,y1,x2,y2]
      sort_x0y0x1y1, main_Event
      repopulate_plot_ascii_tools_x0y0x1y1, Event
      plotAsciiData, main_event=main_event
    END
    WIDGET_INFO(Event.top, FIND_BY_UNAME='plot_ascii_tools_y2'): BEGIN
      x1 = getTextFieldValue(event, 'plot_ascii_tools_x1')
      y1 = getTextFieldValue(event, 'plot_ascii_tools_y1')
      x2 = getTextFieldValue(event, 'plot_ascii_tools_x2')
      y2 = getTextFieldValue(event, 'plot_ascii_tools_y2')
      (*global).x0y0x1y1 = [x1,y1,x2,y2]
      sort_x0y0x1y1, main_Event
      repopulate_plot_ascii_tools_x0y0x1y1, Event
      plotAsciiData, main_event=main_event
    END
    
    ;reset button
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='plot_ascii_tools_full_zoom_reset'): BEGIN
      get_initial_plot_range, main_event=main_event
      PlotAsciiData, main_event=main_event
    END
    
    ELSE:
    
  ENDCASE
  
END

;------------------------------------------------------------------------------
PRO plot_ascii_tools_base_gui, wBase, main_base_geometry, $
    lin_log_yaxis, $
    yaxis_type
    
  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xoffset = main_base_xoffset + main_base_xsize
  yoffset = main_base_yoffset
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'T O O L S',$
    UNAME        = 'plot_ascii_tools_base_uname',$
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
;    SCR_YSIZE = 350,$
;    SCR_XSIZE = 325,$
    MAP          = 1,$
    /BASE_ALIGN_CENTER,$
    GROUP_LEADER = ourGroup)
    
  main_base = WIDGET_BASE(wBase,$
    /COLUMN)
    
  ;lin and log buttons
  row1 = WIDGET_BASE(main_base,$
    /ROW)
  label = WIDGET_LABEL(row1,$
    VALUE = '   Y axis:')
  base = WIDGET_BASE(row1,$
    XOFFSET=0,$
    YOFFSET=0,$
    /ROW,$
    /EXCLUSIVE)
  button1 = WIDGET_BUTTON(base,$
    VALUE='Lin',$
    /NO_RELEASE,$
    UNAME = 'y_axis_lin')
  button2 = WIDGET_BUTTON(base,$
    VALUE='Log',$
    /NO_RELEASE,$
    UNAME = 'y_axis_log')
    
  IF (lin_log_yaxis EQ 'lin') THEN BEGIN
    WIDGET_CONTROL, button1, /SET_BUTTON
  ENDIF ELSE BEGIN
    WIDGET_CONTROL, button2, /SET_BUTTON
  ENDELSE
  
  ;y axis type
  row2 = widget_base(main_base,$
    /row)
  label = widget_label(row2,$
    value = 'Y axis type:')
  base = WIDGET_BASE(row2,$
    XOFFSET=0,$
    YOFFSET=0,$
    /ROW,$
    /EXCLUSIVE)
  button3 = WIDGET_BUTTON(base,$
    VALUE='Y',$
    /NO_RELEASE,$
    UNAME = 'y_axis_type_y')
  button4 = WIDGET_BUTTON(base,$
    VALUE='Y*X^4',$
    /NO_RELEASE,$
    UNAME = 'y_axis_type_yx4')
    
  IF (yaxis_type EQ 'Y') THEN BEGIN
    WIDGET_CONTROL, button3, /SET_BUTTON
  ENDIF ELSE BEGIN
    WIDGET_CONTROL, button4, /SET_BUTTON
  ENDELSE
  
  ;zoom_base
  zoom_row = WIDGET_BASE(main_base,$
    /ROW)
    
  zoom_base = WIDGET_BASE(zoom_row,$
    /COLUMN,$
    FRAME=1)
    
  row1 = WIDGET_BASE(zoom_base,$
    /ROW)
  x1 = CW_FIELD(row1,$
    VALUE = '',$
    XSIZE = 8,$
    /FLOAT,$
    /RETURN_EVENTS, $
    TITLE = 'Xmin:',$
    UNAME = 'plot_ascii_tools_x1',$
    /ROW)
  x2 = CW_FIELD(row1,$
    VALUE = '',$
    XSIZE = 8,$
    /FLOAT,$
    /RETURN_EVENTS, $
    UNAME = 'plot_ascii_tools_x2',$
    TITLE = '    Xmax:',$
    /ROW)
    
  row2 = WIDGET_BASE(zoom_base,$
    /ROW)
  y1 = CW_FIELD(row2,$
    VALUE = '',$
    XSIZE = 8,$
    /FLOAT,$
    /RETURN_EVENTS, $
    TITLE = 'Ymin:',$
    UNAME = 'plot_ascii_tools_y1',$
    /ROW)
  y2 = CW_FIELD(row2,$
    VALUE = '',$
    XSIZE = 8,$
    /FLOAT,$
    /RETURN_EVENTS, $
    UNAME = 'plot_ascii_tools_y2',$
    TITLE = '    Ymax:',$
    /ROW)
    
  ;reset button
  reset_button = WIDGET_BUTTON(zoom_row,$
    VALUE = 'RESET',$
    SCR_XSIZE = 50,$
    UNAME = 'plot_ascii_tools_full_zoom_reset')
    
  ;line style
  style_row = widget_base(main_base,$
  /row)
  label = widget_label(style_row,$
  value = 'Line style:')
  style_base = widget_base(style_row,$
  /row,$
  /exclusive)
  button1= widget_button(style_base,$
  uname = 'style_solid',$
  value = 'Solid')
  button2= widget_button(style_base,$
  uname = 'style_dotted',$
  value = 'Dotted')
  button3= widget_button(style_base,$
  uname = 'style_dashed',$
  value = 'Dashed')
  button4= widget_button(style_base,$
  uname = 'style_Dash Dot',$
  value = 'Dash Dot')
  button5= widget_button(style_base,$
  uname = 'style_dash_dot_dot',$
  value = 'Dash Dot Dot')
button6= widget_button(style_base,$
  uname = 'style_long_dashes',$
  value = 'Long Dashes')
  widget_control, button1, /set_button

  ;symbol style    
  style_row = widget_base(main_base,$
  /row)
  label = widget_label(style_row,$
  value = 'Symbol style:')
  style_base = widget_base(style_row,$
  /row,$
  /exclusive)
  button1= widget_button(style_base,$
  uname = 'symbol_plus',$
  value = '+')
  button2= widget_button(style_base,$
  uname = 'symbol_asterix',$
  value = '*')
  button3= widget_button(style_base,$
  uname = 'symbol_period',$
  value = '.')
  button4= widget_button(style_base,$
  uname = 'symbol_diamond',$
  value = 'diamond')
  button5= widget_button(style_base,$
  uname = 'symbol_triangle',$
  value = 'triangle')
  button6= widget_button(style_base,$
  uname = 'symbol_square',$
  value = 'square')
  widget_control, button1, /set_button


END

;------------------------------------------------------------------------------
PRO plot_ascii_tools_base, main_base=main_base, Event

  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    id = WIDGET_INFO(main_base, FIND_BY_UNAME='MAIN_BASE')
    WIDGET_CONTROL,main_base,GET_UVALUE=global
    event = 0
  ENDIF ELSE BEGIN
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ENDELSE
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  lin_log_yaxis = (*global).lin_log_yaxis ;'lin' or 'log'
  yaxis_type = (*global).yaxis_type ;Y or YX4
  
  ;build gui
  wBase1 = ''
  plot_ascii_tools_base_gui, wBase1, $
    main_base_geometry, $
    lin_log_yaxis, $
    yaxis_type
  (*global).tools_base = wBase1
  
  WIDGET_CONTROL, wBase1, /REALIZE
  
  global_tools = PTR_NEW({ wbase: wbase1,$
    global: global, $
    main_event: Event})
    
  WIDGET_CONTROL, wBase1, SET_UVALUE = global_tools
  
  XMANAGER, "plot_ascii_tools_base", wBase1, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
  xyminmax = (*global).xyminmax
  putValue_from_base, wBase1, 'plot_ascii_tools_x1' , xyminmax[0]
  putValue_from_base, wBase1, 'plot_ascii_tools_y1' , xyminmax[1]
  putValue_from_base, wBase1, 'plot_ascii_tools_x2' , xyminmax[2]
  putValue_from_base, wBase1, 'plot_ascii_tools_y2' , xyminmax[3]
  
END

